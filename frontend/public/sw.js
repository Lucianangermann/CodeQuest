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
