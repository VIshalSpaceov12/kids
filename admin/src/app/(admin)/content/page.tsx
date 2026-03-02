'use client';

import { useState } from 'react';
import { ModuleList } from './_components/module-list';
import { LessonPanel } from './_components/lesson-panel';
import { QuestionPanel } from './_components/question-panel';
import type { Module, Lesson } from '@/types';

export default function ContentPage() {
  const [selectedModule, setSelectedModule] = useState<Module | null>(null);
  const [selectedLesson, setSelectedLesson] = useState<Lesson | null>(null);

  function handleSelectModule(module: Module) {
    setSelectedModule(module);
    setSelectedLesson(null);
  }

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Content Management</h1>
      <div className="flex gap-4 h-[calc(100vh-10rem)] overflow-hidden">
        <ModuleList
          selectedModuleId={selectedModule?.id ?? null}
          onSelect={handleSelectModule}
        />
        <LessonPanel
          module={selectedModule}
          selectedLessonId={selectedLesson?.id ?? null}
          onSelectLesson={setSelectedLesson}
        />
        <QuestionPanel lesson={selectedLesson} />
      </div>
    </div>
  );
}
