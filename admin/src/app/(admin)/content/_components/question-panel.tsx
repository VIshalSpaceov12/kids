'use client';

import { useState } from 'react';
import { useQuestions, useDeleteQuestion } from '@/hooks/use-content';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Plus, Pencil, Trash2, Loader2 } from 'lucide-react';
import { QuestionForm } from './question-form';
import type { Lesson, Question } from '@/types';

interface QuestionPanelProps {
  lesson: Lesson | null;
}

const TYPE_LABELS: Record<string, string> = {
  multiple_choice: 'MCQ',
  fill_blank: 'Fill Blank',
  ordering: 'Ordering',
  tracing: 'Tracing',
};

export function QuestionPanel({ lesson }: QuestionPanelProps) {
  const { data: questions, isLoading } = useQuestions(lesson?.id ?? null);
  const deleteQuestion = useDeleteQuestion();
  const [formOpen, setFormOpen] = useState(false);
  const [editingQuestion, setEditingQuestion] = useState<Question | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);

  if (!lesson) {
    return (
      <Card className="flex w-80 shrink-0 items-center justify-center">
        <p className="text-sm text-muted-foreground">Select a lesson to view questions</p>
      </Card>
    );
  }

  async function handleDelete() {
    if (!deleteId) return;
    await deleteQuestion.mutateAsync(deleteId);
    setDeleteId(null);
  }

  return (
    <>
      <Card className="flex w-80 shrink-0 flex-col overflow-hidden">
        <CardHeader className="flex flex-row items-center justify-between pb-3">
          <CardTitle className="text-sm">Questions</CardTitle>
          <Button
            size="sm"
            onClick={() => {
              setEditingQuestion(null);
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
          ) : questions && questions.length > 0 ? (
            <div className="space-y-2">
              {questions.map((question, index) => (
                <div
                  key={question.id}
                  className="rounded-md border p-3"
                >
                  <div className="flex items-start justify-between gap-2">
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-medium text-muted-foreground">
                          Q{index + 1}
                        </span>
                        <Badge variant="outline" className="text-xs">
                          {TYPE_LABELS[question.type] || question.type}
                        </Badge>
                        {!question.is_active && (
                          <Badge variant="secondary" className="text-xs">
                            Inactive
                          </Badge>
                        )}
                      </div>
                      <p className="mt-1 text-sm truncate">
                        {typeof question.question_data === 'object' && question.question_data !== null
                          ? (question.question_data as Record<string, unknown>).question as string ||
                            (question.question_data as Record<string, unknown>).text as string ||
                            (question.question_data as Record<string, unknown>).prompt as string ||
                            JSON.stringify(question.question_data).slice(0, 50)
                          : String(question.question_data).slice(0, 50)}
                      </p>
                    </div>
                    <div className="flex shrink-0 gap-1">
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-7 w-7"
                        onClick={() => {
                          setEditingQuestion(question);
                          setFormOpen(true);
                        }}
                      >
                        <Pencil className="h-3 w-3" />
                      </Button>
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-7 w-7 text-destructive hover:text-destructive"
                        onClick={() => setDeleteId(question.id)}
                      >
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="py-8 text-center text-sm text-muted-foreground">
              No questions yet
            </p>
          )}
        </CardContent>
      </Card>

      <QuestionForm
        open={formOpen}
        onClose={() => {
          setFormOpen(false);
          setEditingQuestion(null);
        }}
        lessonId={lesson.id}
        question={editingQuestion}
      />

      {/* Delete confirmation dialog */}
      <Dialog open={!!deleteId} onOpenChange={(open) => !open && setDeleteId(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Question</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this question? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteId(null)}>
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={deleteQuestion.isPending}
            >
              {deleteQuestion.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Delete
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
