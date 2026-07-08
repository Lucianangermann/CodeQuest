const STATIC_CACHE = 'cq-static-v1'
const API_CACHE = 'cq-api-v1'

// ── Install: pre-cache app shell ──────────────────────────────────────────────
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE).then(c => c.addAll(['/', '/index.html']))
  )
  self.skipWaiting()
})

// ── Activate: remove stale caches ────────────────────────────────────────────
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys
          .filter(k => k !== STATIC_CACHE && k !== API_CACHE)
          .map(k => caches.delete(k))
      )
    )
  )
  self.clients.claim()
})

// ── Fetch: offline caching strategy ──────────────────────────────────────────
self.addEventListener('fetch', (event) => {
  const { request } = event
  if (request.method !== 'GET') return

  const url = new URL(request.url)

  // Lesson detail API: network-first, cache fallback (offline reading)
  if (url.origin === location.origin && url.pathname.match(/^\/lessons\/\d+$/)) {
    event.respondWith(
      fetch(request)
        .then(response => {
          const clone = response.clone()
          caches.open(API_CACHE).then(c => c.put(request, clone))
          return response
        })
        .catch(() => caches.match(request))
    )
    return
  }

  // Skip other cross-origin requests (except Google Fonts)
  if (url.origin !== location.origin && !url.hostname.includes('fonts.g')) return

  // Static assets (JS, CSS, fonts, images): cache-first, update in background
  event.respondWith(
    caches.match(request).then(cached => {
      const networkFetch = fetch(request).then(response => {
        if (response.ok) {
          const clone = response.clone()
          caches.open(STATIC_CACHE).then(c => c.put(request, clone))
        }
        return response
      }).catch(() => cached)
      return cached || networkFetch
    })
  )
})

// ── Push notifications ────────────────────────────────────────────────────────
self.addEventListener('push', (event) => {
  if (!event.data) return
  let data = {}
  try { data = event.data.json() } catch { data = { title: 'CodeQuest', body: event.data.text() } }

  event.waitUntil(
    self.registration.showNotification(data.title || 'CodeQuest', {
      body: data.body || 'Time to practice!',
      icon: '/icon-192.png',
      badge: '/icon-192.png',
      data: { url: data.url || '/dashboard' },
      vibrate: [100, 50, 100],
    })
  )
})

self.addEventListener('notificationclick', (event) => {
  event.notification.close()
  const url = event.notification.data?.url || '/dashboard'
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      const existingClient = clientList.find(c => c.url.includes(self.location.origin))
      if (existingClient) {
        existingClient.focus()
        existingClient.navigate(url)
      } else {
        clients.openWindow(url)
      }
    })
  )
})
