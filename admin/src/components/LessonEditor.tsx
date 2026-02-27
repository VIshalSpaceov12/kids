import { useState, useEffect } from 'react';
import type { Lesson } from '../types';

interface LessonEditorProps {
  lesson?: Lesson | null;
  moduleId: string;
  onSave: (data: Partial<Lesson>) => void;
  onCancel: () => void;
}

const classOptions = ['Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3'];
const difficultyOptions = [1, 2, 3, 4, 5];

export default function LessonEditor({ lesson, moduleId, onSave, onCancel }: LessonEditorProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [difficulty, setDifficulty] = useState(1);
  const [classMin, setClassMin] = useState('Nursery');
  const [classMax, setClassMax] = useState('LKG');
  const [isActive, setIsActive] = useState(true);

  useEffect(() => {
    if (lesson) {
      setTitle(lesson.title);
      setDescription(lesson.description);
      setDifficulty(lesson.difficultyLevel);
      setClassMin(lesson.classRangeMin);
      setClassMax(lesson.classRangeMax);
      setIsActive(lesson.isActive);
    } else {
      setTitle('');
      setDescription('');
      setDifficulty(1);
      setClassMin('Nursery');
      setClassMax('LKG');
      setIsActive(true);
    }
  }, [lesson]);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    onSave({
      moduleId,
      title,
      description,
      difficultyLevel: difficulty,
      classRangeMin: classMin,
      classRangeMax: classMax,
      isActive,
    });
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <h3 className="text-lg font-semibold text-gray-900">
        {lesson ? 'Edit Lesson' : 'New Lesson'}
      </h3>

      <div>
        <label className="mb-1 block text-sm font-medium text-gray-700">Title</label>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
          placeholder="Lesson title"
        />
      </div>

      <div>
        <label className="mb-1 block text-sm font-medium text-gray-700">Description</label>
        <textarea
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          rows={3}
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
          placeholder="Brief description of the lesson"
        />
      </div>

      <div>
        <label className="mb-1 block text-sm font-medium text-gray-700">Difficulty</label>
        <select
          value={difficulty}
          onChange={(e) => setDifficulty(Number(e.target.value))}
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
        >
          {difficultyOptions.map((d) => (
            <option key={d} value={d}>
              Level {d}
            </option>
          ))}
        </select>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">Class Min</label>
          <select
            value={classMin}
            onChange={(e) => setClassMin(e.target.value)}
            className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
          >
            {classOptions.map((c) => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">Class Max</label>
          <select
            value={classMax}
            onChange={(e) => setClassMax(e.target.value)}
            className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
          >
            {classOptions.map((c) => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>
        </div>
      </div>

      <div className="flex items-center gap-2">
        <input
          type="checkbox"
          id="isActive"
          checked={isActive}
          onChange={(e) => setIsActive(e.target.checked)}
          className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
        />
        <label htmlFor="isActive" className="text-sm font-medium text-gray-700">
          Active
        </label>
      </div>

      <div className="flex gap-2 pt-2">
        <button
          type="submit"
          className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-blue-700"
        >
          {lesson ? 'Update' : 'Create'} Lesson
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50"
        >
          Cancel
        </button>
      </div>
    </form>
  );
}
