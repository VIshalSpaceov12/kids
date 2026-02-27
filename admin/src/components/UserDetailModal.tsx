import { X } from 'lucide-react';
import type { Parent, Child, Progress } from '../types';
import clsx from 'clsx';

interface UserDetailModalProps {
  parent: Parent;
  children: Child[];
  progress: Record<string, Progress[]>;
  onClose: () => void;
}

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  });
}

export default function UserDetailModal({
  parent,
  children: childList,
  progress,
  onClose,
}: UserDetailModalProps) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div className="fixed inset-0 bg-black/50" onClick={onClose} />
      <div className="relative z-10 mx-4 max-h-[90vh] w-full max-w-2xl overflow-y-auto rounded-2xl bg-white shadow-xl">
        <div className="sticky top-0 flex items-center justify-between border-b border-gray-200 bg-white px-6 py-4">
          <h2 className="text-xl font-bold text-gray-900">{parent.name}</h2>
          <button
            onClick={onClose}
            className="rounded-lg p-1 text-gray-400 transition-colors hover:bg-gray-100 hover:text-gray-600"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="p-6">
          <div className="mb-6 grid grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-gray-500">Email</p>
              <p className="font-medium text-gray-900">{parent.email || 'Not provided'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-500">Phone</p>
              <p className="font-medium text-gray-900">{parent.phone || 'Not provided'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-500">Registered</p>
              <p className="font-medium text-gray-900">{formatDate(parent.createdAt)}</p>
            </div>
            <div>
              <p className="text-sm text-gray-500">Last Active</p>
              <p className="font-medium text-gray-900">{formatDate(parent.lastActive)}</p>
            </div>
          </div>

          <h3 className="mb-4 text-lg font-semibold text-gray-900">
            Children ({childList.length})
          </h3>

          <div className="space-y-4">
            {childList.map((child) => {
              const childProgress = progress[child.id] || [];
              return (
                <div
                  key={child.id}
                  className="rounded-xl border border-gray-200 bg-gray-50 p-4"
                >
                  <div className="mb-3 flex items-center gap-3">
                    <span className="text-3xl">{child.avatar}</span>
                    <div>
                      <p className="font-semibold text-gray-900">{child.name}</p>
                      <p className="text-sm text-gray-500">
                        Age {child.age} &middot; {child.classLevel} &middot; {child.language}
                      </p>
                    </div>
                  </div>

                  {childProgress.length > 0 ? (
                    <div className="space-y-2">
                      {childProgress.map((p) => (
                        <div key={p.lessonId}>
                          <div className="mb-1 flex items-center justify-between text-sm">
                            <span className="text-gray-700">{p.lessonTitle}</span>
                            <span className="font-medium text-gray-900">
                              {p.score}%
                              <span className="ml-1 text-yellow-500">
                                {'★'.repeat(p.stars)}{'☆'.repeat(3 - p.stars)}
                              </span>
                            </span>
                          </div>
                          <div className="h-2 overflow-hidden rounded-full bg-gray-200">
                            <div
                              className={clsx(
                                'h-full rounded-full transition-all',
                                p.score >= 80
                                  ? 'bg-green-500'
                                  : p.score >= 50
                                    ? 'bg-yellow-500'
                                    : 'bg-red-500'
                              )}
                              style={{ width: `${p.score}%` }}
                            />
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-sm text-gray-400">No progress data yet</p>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
