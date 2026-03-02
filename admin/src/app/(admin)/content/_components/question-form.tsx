'use client';

import { useEffect, useState } from 'react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Checkbox } from '@/components/ui/checkbox';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { useCreateQuestion, useUpdateQuestion } from '@/hooks/use-content';
import { QUESTION_TYPES } from '@/lib/constants';
import { Loader2 } from 'lucide-react';
import type { Question } from '@/types';

interface QuestionFormProps {
  open: boolean;
  onClose: () => void;
  lessonId: string;
  question: Question | null;
}

export function QuestionForm({ open, onClose, lessonId, question }: QuestionFormProps) {
  const createQuestion = useCreateQuestion();
  const updateQuestion = useUpdateQuestion();

  const [type, setType] = useState<Question['type']>('multiple_choice');
  const [questionData, setQuestionData] = useState('{}');
  const [correctAnswer, setCorrectAnswer] = useState('{}');
  const [displayOrder, setDisplayOrder] = useState(0);
  const [isActive, setIsActive] = useState(true);
  const [jsonError, setJsonError] = useState('');

  useEffect(() => {
    if (question) {
      setType(question.type);
      setQuestionData(JSON.stringify(question.question_data, null, 2));
      setCorrectAnswer(JSON.stringify(question.correct_answer, null, 2));
      setDisplayOrder(question.display_order);
      setIsActive(question.is_active);
    } else {
      setType('multiple_choice');
      setQuestionData('{\n  "question": "",\n  "options": ["", "", "", ""]\n}');
      setCorrectAnswer('{\n  "answer": 0\n}');
      setDisplayOrder(0);
      setIsActive(true);
    }
    setJsonError('');
  }, [question, open]);

  const isPending = createQuestion.isPending || updateQuestion.isPending;

  function getPlaceholder(selectedType: string) {
    switch (selectedType) {
      case 'multiple_choice':
        return '{\n  "question": "What is 2+2?",\n  "options": ["3", "4", "5", "6"]\n}';
      case 'fill_blank':
        return '{\n  "question": "The capital of India is ___",\n  "hint": "Starts with N"\n}';
      case 'ordering':
        return '{\n  "question": "Arrange in order",\n  "items": ["First", "Second", "Third"]\n}';
      case 'tracing':
        return '{\n  "letter": "A",\n  "prompt": "Trace the letter A"\n}';
      default:
        return '{}';
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setJsonError('');

    let parsedData: Record<string, unknown>;
    let parsedAnswer: Record<string, unknown>;

    try {
      parsedData = JSON.parse(questionData);
    } catch {
      setJsonError('Invalid JSON in Question Data');
      return;
    }

    try {
      parsedAnswer = JSON.parse(correctAnswer);
    } catch {
      setJsonError('Invalid JSON in Correct Answer');
      return;
    }

    const payload = {
      type,
      questionData: parsedData,
      correctAnswer: parsedAnswer,
      displayOrder,
      isActive,
    };

    if (question) {
      await updateQuestion.mutateAsync({ id: question.id, ...payload });
    } else {
      await createQuestion.mutateAsync({ ...payload, lessonId });
    }
    onClose();
  }

  return (
    <Dialog open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{question ? 'Edit Question' : 'New Question'}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          {jsonError && (
            <div className="rounded-md bg-destructive/10 px-3 py-2 text-sm text-destructive">
              {jsonError}
            </div>
          )}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Type</Label>
              <Select value={type} onValueChange={(v) => setType(v as Question['type'])}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {QUESTION_TYPES.map((t) => (
                    <SelectItem key={t.value} value={t.value}>
                      {t.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="qDisplayOrder">Display Order</Label>
              <Input
                id="qDisplayOrder"
                type="number"
                value={displayOrder}
                onChange={(e) => setDisplayOrder(Number(e.target.value))}
              />
            </div>
          </div>
          <div className="space-y-2">
            <Label>Question Data (JSON)</Label>
            <Textarea
              value={questionData}
              onChange={(e) => setQuestionData(e.target.value)}
              rows={6}
              className="font-mono text-xs"
              placeholder={getPlaceholder(type)}
            />
          </div>
          <div className="space-y-2">
            <Label>Correct Answer (JSON)</Label>
            <Textarea
              value={correctAnswer}
              onChange={(e) => setCorrectAnswer(e.target.value)}
              rows={3}
              className="font-mono text-xs"
              placeholder='{"answer": 0}'
            />
          </div>
          <div className="flex items-center gap-2">
            <Checkbox
              id="qIsActive"
              checked={isActive}
              onCheckedChange={(checked) => setIsActive(checked === true)}
            />
            <Label htmlFor="qIsActive">Active</Label>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {question ? 'Update' : 'Create'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
