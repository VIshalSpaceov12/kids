'use client';

import { useState } from 'react';
import { useLessons } from '@/hooks/use-content';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import { LessonForm } from './lesson-form';
import type { Module, Lesson } from '@/types';

interface LessonPanelProps {
  module: Module | null;
  selectedLessonId: string | null;
  onSelectLesson: (lesson: Lesson) => void;
}

export function LessonPanel({ module, selectedLessonId, onSelectLesson }: LessonPanelProps) {
  const { data: lessons, isLoading } = useLessons(module?.slug ?? null);
  const [formOpen, setFormOpen] = useState(false);
  const [editingLesson, setEditingLesson] = useState<Lesson | null>(null);

  if (!module) {
    return (
      <Card className="flex flex-1 items-center justify-center">
        <p className="text-sm text-muted-foreground">Select a module to view lessons</p>
      </Card>
    );
  }

  return (
    <>
      <Card className="flex flex-1 flex-col overflow-hidden">
        <CardHeader className="flex flex-row items-center justify-between pb-3">
          <CardTitle className="text-sm">Lessons — {module.name}</CardTitle>
          <Button
            size="sm"
            onClick={() => {
              setEditingLesson(null);
              setFormOpen(true);
            }}
          >
            <Plus className="mr-1 h-4 w-4" />
            Add
          </Button>
        </CardHeader>
        <CardContent className="flex-1 overflow-y-auto p-2">
          {isLoading ? (
            <div className="space-y-2">
              {Array.from({ length: 3 }).map((_, i) => (
                <Skeleton key={i} className="h-16 w-full" />
              ))}
            </div>
          ) : lessons && lessons.length > 0 ? (
            <div className="space-y-1">
              {lessons.map((lesson) => (
                <div
                  key={lesson.id}
                  className={cn(
                    'flex items-center justify-between rounded-md border p-3 cursor-pointer transition-colors',
                    selectedLessonId === lesson.id
                      ? 'border-primary bg-primary/5'
                      : 'hover:bg-accent'
                  )}
                  onClick={() => onSelectLesson(lesson)}
                >
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-medium">{lesson.title}</p>
                    <div className="mt-1 flex items-center gap-2">
                      <Badge variant="outline" className="text-xs">
                        Lvl {lesson.difficulty_level}
                      </Badge>
                      {!lesson.is_active && (
                        <Badge variant="secondary" className="text-xs">
                          Inactive
                        </Badge>
                      )}
                    </div>
                  </div>
                  <Button
                    size="sm"
                    variant="ghost"
                    onClick={(e) => {
                      e.stopPropagation();
                      setEditingLesson(lesson);
                      setFormOpen(true);
                    }}
                  >
                    Edit
                  </Button>
                </div>
              ))}
            </div>
          ) : (
            <p className="py-8 text-center text-sm text-muted-foreground">
              No lessons in this module yet
            </p>
          )}
        </CardContent>
      </Card>

      <LessonForm
        open={formOpen}
        onClose={() => {
          setFormOpen(false);
          setEditingLesson(null);
        }}
        moduleId={module.id}
        lesson={editingLesson}
      />
    </>
  );
}
