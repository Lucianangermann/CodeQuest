import { useState, useRef, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { MessageSquare, X, Send, Loader2, Bot } from 'lucide-react'
import { sendChatMessage } from '../lib/api'
import { useLessonStore } from '../store/useLessonStore'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'

export default function AIChat() {
  const t = useT()
  const { chatMessages, isChatOpen, toggleChat, addChatMessage, currentTopicName } = useLessonStore()
  const { user } = useUserStore()

  const [input, setInput] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const bottomRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [chatMessages])

  if (!user) return null

  async function handleSend() {
    const text = input.trim()
    if (!text || isLoading) return

    const userMsg = { role: 'user' as const, content: text }
    addChatMessage(userMsg)
    setInput('')
    setIsLoading(true)

    try {
      const allMessages = [...chatMessages, userMsg]
      const reply = await sendChatMessage(
        allMessages,
        currentTopicName,
        user?.language_preference || 'python'
      )
      addChatMessage({ role: 'assistant', content: reply })
    } catch {
      addChatMessage({ role: 'assistant', content: t('chat.error') })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <>
      {/* Floating button */}
      <motion.button
        onClick={toggleChat}
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        className="fixed bottom-20 md:bottom-6 right-6 z-50 w-14 h-14 bg-quest-purple rounded-full shadow-lg shadow-quest-purple/30 flex items-center justify-center text-white hover:bg-quest-purple-light transition-colors"
        aria-label="Open AI tutor"
      >
        <AnimatePresence mode="wait">
          {isChatOpen ? (
            <motion.div key="close" initial={{ rotate: -90, opacity: 0 }} animate={{ rotate: 0, opacity: 1 }} exit={{ rotate: 90, opacity: 0 }}>
              <X className="w-6 h-6" />
            </motion.div>
          ) : (
            <motion.div key="open" initial={{ rotate: 90, opacity: 0 }} animate={{ rotate: 0, opacity: 1 }} exit={{ rotate: -90, opacity: 0 }}>
              <MessageSquare className="w-6 h-6" />
            </motion.div>
          )}
        </AnimatePresence>
        {chatMessages.length > 0 && !isChatOpen && (
          <span className="absolute -top-1 -right-1 w-5 h-5 bg-quest-green rounded-full text-xs font-bold flex items-center justify-center">
            {chatMessages.filter((m) => m.role === 'assistant').length}
          </span>
        )}
      </motion.button>

      {/* Chat panel */}
      <AnimatePresence>
        {isChatOpen && (
          <motion.div
            initial={{ opacity: 0, x: 24, scale: 0.95 }}
            animate={{ opacity: 1, x: 0, scale: 1 }}
            exit={{ opacity: 0, x: 24, scale: 0.95 }}
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            className="fixed bottom-40 md:bottom-24 right-6 z-50 w-80 sm:w-96 flex flex-col bg-quest-card border border-quest-border rounded-2xl shadow-2xl overflow-hidden"
            style={{ maxHeight: 'min(480px, calc(100vh - 160px))' }}
          >
            {/* Header */}
            <div className="flex items-center gap-3 px-4 py-3 border-b border-quest-border bg-quest-purple/10">
              <div className="w-8 h-8 bg-quest-purple rounded-xl flex items-center justify-center">
                <Bot className="w-5 h-5 text-white" />
              </div>
              <div>
                <p className="font-semibold text-sm text-white">{t('chat.tutor')}</p>
                <p className="text-xs text-quest-muted">
                  {currentTopicName ? `${t('chat.helpingWith')} ${currentTopicName}` : t('chat.askAnything')}
                </p>
              </div>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3 min-h-0">
              {chatMessages.length === 0 && (
                <div className="text-center py-8">
                  <Bot className="w-10 h-10 text-quest-purple mx-auto mb-2" />
                  <p className="text-quest-muted text-sm">
                    {t('chat.greeting')}
                  </p>
                </div>
              )}

              {chatMessages.map((msg, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 8 }}
                  animate={{ opacity: 1, y: 0 }}
                  className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}
                >
                  <div
                    className={`max-w-[85%] rounded-2xl px-3 py-2 text-sm leading-relaxed whitespace-pre-wrap ${
                      msg.role === 'user'
                        ? 'bg-quest-purple text-white rounded-br-sm'
                        : 'bg-quest-border text-quest-text rounded-bl-sm'
                    }`}
                  >
                    {msg.content}
                  </div>
                </motion.div>
              ))}

              {isLoading && (
                <div className="flex justify-start">
                  <div className="bg-quest-border rounded-2xl rounded-bl-sm px-3 py-2">
                    <Loader2 className="w-4 h-4 animate-spin text-quest-muted" />
                  </div>
                </div>
              )}
              <div ref={bottomRef} />
            </div>

            {/* Input */}
            <div className="p-3 border-t border-quest-border">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && !e.shiftKey && handleSend()}
                  placeholder={t('chat.placeholder')}
                  className="flex-1 bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-quest-text placeholder-quest-muted focus:outline-none focus:border-quest-purple transition-colors"
                />
                <button
                  onClick={handleSend}
                  disabled={!input.trim() || isLoading}
                  className="p-2 bg-quest-purple rounded-xl text-white hover:bg-quest-purple-light disabled:opacity-50 transition-colors"
                >
                  <Send className="w-4 h-4" />
                </button>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  )
}
