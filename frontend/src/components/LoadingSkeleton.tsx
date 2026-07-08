interface Props {
  className?: string
  count?: number
}

function Skeleton({ className = '' }: { className?: string }) {
  return (
    <div className={`animate-pulse bg-quest-border rounded-lg ${className}`} />
  )
}

export function CardSkeleton() {
  return (
    <div className="card space-y-4">
      <Skeleton className="h-5 w-2/3" />
      <Skeleton className="h-3 w-full" />
      <Skeleton className="h-3 w-4/5" />
      <Skeleton className="h-8 w-1/3" />
    </div>
  )
}

export function TopicNodeSkeleton() {
  return (
    <div className="flex flex-col items-center gap-2">
      <Skeleton className="w-16 h-16 rounded-full" />
      <Skeleton className="h-3 w-20" />
    </div>
  )
}

export function ListSkeleton({ count = 3 }: Props) {
  return (
    <div className="space-y-3">
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className="card flex items-center gap-4">
          <Skeleton className="w-10 h-10 rounded-xl flex-shrink-0" />
          <div className="flex-1 space-y-2">
            <Skeleton className="h-4 w-3/4" />
            <Skeleton className="h-3 w-1/2" />
          </div>
          <Skeleton className="h-8 w-20 flex-shrink-0" />
        </div>
      ))}
    </div>
  )
}

export function LessonSkeleton() {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-8 space-y-6">
      <div className="flex items-center gap-3">
        <Skeleton className="w-8 h-8 rounded-lg flex-shrink-0" />
        <div className="space-y-2 flex-1">
          <Skeleton className="h-5 w-1/2" />
          <Skeleton className="h-3 w-1/4" />
        </div>
      </div>
      <div className="card space-y-4">
        <Skeleton className="h-4 w-2/3" />
        <Skeleton className="h-3 w-full" />
        <Skeleton className="h-3 w-4/5" />
        <Skeleton className="h-3 w-3/5" />
        <Skeleton className="h-44 w-full rounded-xl mt-2" />
        <Skeleton className="h-9 w-32" />
      </div>
    </div>
  )
}

export default Skeleton
