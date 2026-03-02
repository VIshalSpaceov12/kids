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
import { useCreateLesson, useUpdateLesson } from '@/hooks/use-content';
import { slugify } from '@/lib/utils';
import { DIFFICULTY_LEVELS, CLASS_LEVELS } from '@/lib/constants';
import { Loader2 } from 'lucide-react';
import type { Lesson } from '@/types';

interface LessonFormProps {
  open: boolean;
  onClose: () => void;
  moduleId: string;
  lesson: Lesson | null;
}

export function LessonForm({ open, onClose, moduleId, lesson }: LessonFormProps) {
  const createLesson = useCreateLesson();
  const updateLesson = useUpdateLesson();

  const [title, setTitle] = useState('');
  const [slug, setSlug] = useState('');
  const [description, setDescription] = useState('');
  const [difficultyLevel, setDifficultyLevel] = useState(1);
  const [classRangeMin, setClassRangeMin] = useState('');
  const [classRangeMax, setClassRangeMax] = useState('');
  const [displayOrder, setDisplayOrder] = useState(0);
  const [isActive, setIsActive] = useState(true);
  const [autoSlug, setAutoSlug] = useState(true);

  useEffect(() => {
    if (lesson) {
      setTitle(lesson.title);
      setSlug(lesson.slug);
      setDescription(lesson.description || '');
      setDifficultyLevel(lesson.difficulty_level);
      setClassRangeMin(lesson.class_range_min || '');
      setClassRangeMax(lesson.class_range_max || '');
      setDisplayOrder(lesson.display_order);
      setIsActive(lesson.is_active);
      setAutoSlug(false);
    } else {
      setTitle('');
      setSlug('');
      setDescription('');
      setDifficultyLevel(1);
      setClassRangeMin('');
      setClassRangeMax('');
      setDisplayOrder(0);
      setIsActive(true);
      setAutoSlug(true);
    }
  }, [lesson, open]);

  useEffect(() => {
    if (autoSlug && !lesson) {
      setSlug(slugify(title));
    }
  }, [title, autoSlug, lesson]);

  const isPending = createLesson.isPending || updateLesson.isPending;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim() || !slug.trim()) return;

    const data = {
      title: title.trim(),
      slug: slug.trim(),
      description: description.trim() || undefined,
      difficultyLevel,
      classRangeMin: classRangeMin || undefined,
      classRangeMax: classRangeMax || undefined,
      displayOrder,
      isActive,
    };

    if (lesson) {
      await updateLesson.mutateAsync({ id: lesson.id, ...data });
    } else {
      await createLesson.mutateAsync({ ...data, moduleId });
    }
    onClose();
  }

  return (
    <Dialog open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-md">
        <DialogHeader>
          <DialogTitle>{lesson ? 'Edit Lesson' : 'New Lesson'}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="title">Title</Label>
            <Input
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="slug">Slug</Label>
            <Input
              id="slug"
              value={slug}
              onChange={(e) => {
                setSlug(e.target.value);
                setAutoSlug(false);
              }}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Difficulty</Label>
              <Select
                value={String(difficultyLevel)}
                onValueChange={(v) => setDifficultyLevel(Number(v))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {DIFFICULTY_LEVELS.map((d) => (
                    <SelectItem key={d.value} value={String(d.value)}>
                      {d.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="displayOrder">Display Order</Label>
              <Input
                id="displayOrder"
                type="number"
                value={displayOrder}
                onChange={(e) => setDisplayOrder(Number(e.target.value))}
              />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Class Min</Label>
              <Select value={classRangeMin} onValueChange={setClassRangeMin}>
                <SelectTrigger>
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent>
                  {CLASS_LEVELS.map((c) => (
                    <SelectItem key={c.value} value={c.value}>
                      {c.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Class Max</Label>
              <Select value={classRangeMax} onValueChange={setClassRangeMax}>
                <SelectTrigger>
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent>
                  {CLASS_LEVELS.map((c) => (
                    <SelectItem key={c.value} value={c.value}>
                      {c.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox
              id="isActive"
              checked={isActive}
              onCheckedChange={(checked) => setIsActive(checked === true)}
            />
            <Label htmlFor="isActive">Active</Label>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {lesson ? 'Update' : 'Create'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
