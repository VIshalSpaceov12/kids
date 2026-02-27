import type { Module } from '../types';
import clsx from 'clsx';

interface ModuleListProps {
  modules: Module[];
  selectedId: string | null;
  onSelect: (module: Module) => void;
}

export default function ModuleList({ modules, selectedId, onSelect }: ModuleListProps) {
  return (
    <div className="space-y-2">
      <h3 className="mb-3 text-sm font-semibold uppercase tracking-wider text-gray-500">
        Modules
      </h3>
      {modules.map((mod) => (
        <button
          key={mod.id}
          onClick={() => onSelect(mod)}
          className={clsx(
            'flex w-full items-center gap-3 rounded-lg px-3 py-3 text-left transition-colors',
            selectedId === mod.id
              ? 'bg-blue-50 ring-1 ring-blue-200'
              : 'hover:bg-gray-100'
          )}
        >
          <span className="text-2xl">{mod.icon}</span>
          <div className="min-w-0 flex-1">
            <p
              className={clsx(
                'truncate text-sm font-medium',
                selectedId === mod.id ? 'text-blue-900' : 'text-gray-900'
              )}
            >
              {mod.name}
            </p>
            <p className="text-xs text-gray-500">
              {mod.lessonCount} lessons &middot; {mod.questionCount} questions
            </p>
          </div>
          <div
            className="h-3 w-3 rounded-full"
            style={{ backgroundColor: mod.color }}
          />
        </button>
      ))}
    </div>
  );
}
