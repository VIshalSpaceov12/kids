'use client';

import { useModules } from '@/hooks/use-content';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';
import { BookOpen } from 'lucide-react';
import type { Module } from '@/types';

interface ModuleListProps {
  selectedModuleId: string | null;
  onSelect: (module: Module) => void;
}

export function ModuleList({ selectedModuleId, onSelect }: ModuleListProps) {
  const { data: modules, isLoading } = useModules();

  return (
    <Card className="w-64 shrink-0 flex flex-col overflow-hidden">
      <CardHeader className="pb-3">
        <CardTitle className="text-sm">Modules</CardTitle>
      </CardHeader>
      <CardContent className="flex-1 overflow-y-auto p-2">
        {isLoading ? (
          <div className="space-y-2">
            {Array.from({ length: 4 }).map((_, i) => (
              <Skeleton key={i} className="h-16 w-full" />
            ))}
          </div>
        ) : modules && modules.length > 0 ? (
          <div className="space-y-1">
            {modules.map((module) => (
              <button
                key={module.id}
                onClick={() => onSelect(module)}
                className={cn(
                  'w-full rounded-md p-3 text-left transition-colors',
                  selectedModuleId === module.id
                    ? 'bg-primary text-primary-foreground'
                    : 'hover:bg-accent'
                )}
              >
                <div className="flex items-center gap-2">
                  <span className="text-lg">{module.icon || '📚'}</span>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-medium">{module.name}</p>
                    <p
                      className={cn(
                        'text-xs',
                        selectedModuleId === module.id
                          ? 'text-primary-foreground/70'
                          : 'text-muted-foreground'
                      )}
                    >
                      {module.lessonCount} lessons · {module.questionCount} questions
                    </p>
                  </div>
                </div>
              </button>
            ))}
          </div>
        ) : (
          <p className="py-4 text-center text-sm text-muted-foreground">
            No modules found
          </p>
        )}
      </CardContent>
    </Card>
  );
}
