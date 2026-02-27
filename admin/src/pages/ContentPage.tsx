import { useState } from 'react';
import { Plus, ChevronRight, Edit2 } from 'lucide-react';
import ModuleList from '../components/ModuleList';
import LessonEditor from '../components/LessonEditor';
import QuestionEditor from '../components/QuestionEditor';
import { mockModules, mockLessons, mockQuestions } from '../data/mockData';
import type { Module, Lesson, Question } from '../types';
import clsx from 'clsx';

export default function ContentPage() {
  const [selectedModule, setSelectedModule] = useState<Module | null>(null);
  const [selectedLesson, setSelectedLesson] = useState<Lesson | null>(null);
  const [editingLesson, setEditingLesson] = useState<Lesson | null | 'new'>(null);
  const [editingQuestion, setEditingQuestion] = useState<Question | null | 'new'>(null);

  const lessons = selectedModule ? mockLessons[selectedModule.id] || [] : [];
  const questions = selectedLesson ? mockQuestions[selectedLesson.id] || [] : [];

  function handleModuleSelect(mod: Module) {
    setSelectedModule(mod);
    setSelectedLesson(null);
    setEditingLesson(null);
    setEditingQuestion(null);
  }

  function handleLessonSelect(lesson: Lesson) {
    setSelectedLesson(lesson);
    setEditingLesson(null);
    setEditingQuestion(null);
  }

  function handleLessonSave(_data: Partial<Lesson>) {
    setEditingLesson(null);
  }

  function handleQuestionSave(_data: Partial<Question>) {
    setEditingQuestion(null);
  }

  function handleQuestionDelete() {
    setEditingQuestion(null);
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Content Management</h1>
        <p className="text-gray-500">Manage modules, lessons, and questions</p>
      </div>

      <div className="flex gap-6">
        {/* Left panel: Module list */}
        <div className="w-64 shrink-0 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          <ModuleList
            modules={mockModules}
            selectedId={selectedModule?.id || null}
            onSelect={handleModuleSelect}
          />
        </div>

        {/* Middle panel: Lessons */}
        <div className="min-w-0 flex-1 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          {selectedModule ? (
            <>
              {editingLesson ? (
                <LessonEditor
                  lesson={editingLesson === 'new' ? null : editingLesson}
                  moduleId={selectedModule.id}
                  onSave={handleLessonSave}
                  onCancel={() => setEditingLesson(null)}
                />
              ) : (
                <>
                  <div className="mb-4 flex items-center justify-between">
                    <h3 className="text-lg font-semibold text-gray-900">
                      {selectedModule.icon} {selectedModule.name} Lessons
                    </h3>
                    <button
                      onClick={() => setEditingLesson('new')}
                      className="flex items-center gap-1.5 rounded-lg bg-blue-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-blue-700"
                    >
                      <Plus className="h-4 w-4" />
                      Add Lesson
                    </button>
                  </div>

                  {lessons.length > 0 ? (
                    <div className="space-y-2">
                      {lessons.map((lesson) => (
                        <div
                          key={lesson.id}
                          className={clsx(
                            'flex cursor-pointer items-center justify-between rounded-lg border px-4 py-3 transition-colors',
                            selectedLesson?.id === lesson.id
                              ? 'border-blue-200 bg-blue-50'
                              : 'border-gray-100 hover:bg-gray-50'
                          )}
                          onClick={() => handleLessonSelect(lesson)}
                        >
                          <div className="min-w-0 flex-1">
                            <div className="flex items-center gap-2">
                              <p className="truncate font-medium text-gray-900">
                                {lesson.title}
                              </p>
                              {!lesson.isActive && (
                                <span className="shrink-0 rounded bg-gray-200 px-1.5 py-0.5 text-xs text-gray-500">
                                  Inactive
                                </span>
                              )}
                            </div>
                            <p className="mt-0.5 truncate text-sm text-gray-500">
                              {lesson.description}
                            </p>
                            <div className="mt-1 flex gap-3 text-xs text-gray-400">
                              <span>Difficulty: {lesson.difficultyLevel}</span>
                              <span>
                                {lesson.classRangeMin} - {lesson.classRangeMax}
                              </span>
                              <span>{lesson.questionCount} questions</span>
                            </div>
                          </div>
                          <div className="ml-3 flex items-center gap-1">
                            <button
                              onClick={(e) => {
                                e.stopPropagation();
                                setEditingLesson(lesson);
                              }}
                              className="rounded p-1 text-gray-400 hover:bg-gray-200 hover:text-gray-600"
                            >
                              <Edit2 className="h-4 w-4" />
                            </button>
                            <ChevronRight className="h-4 w-4 text-gray-300" />
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="py-8 text-center text-gray-400">
                      No lessons yet. Click "Add Lesson" to get started.
                    </p>
                  )}
                </>
              )}
            </>
          ) : (
            <div className="flex h-64 items-center justify-center text-gray-400">
              Select a module to view its lessons
            </div>
          )}
        </div>

        {/* Right panel: Questions */}
        <div className="w-80 shrink-0 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          {selectedLesson ? (
            <>
              {editingQuestion ? (
                <QuestionEditor
                  question={editingQuestion === 'new' ? null : editingQuestion}
                  lessonId={selectedLesson.id}
                  onSave={handleQuestionSave}
                  onDelete={
                    editingQuestion !== 'new' ? handleQuestionDelete : undefined
                  }
                  onCancel={() => setEditingQuestion(null)}
                />
              ) : (
                <>
                  <div className="mb-4 flex items-center justify-between">
                    <h3 className="text-sm font-semibold uppercase tracking-wider text-gray-500">
                      Questions
                    </h3>
                    <button
                      onClick={() => setEditingQuestion('new')}
                      className="flex items-center gap-1 rounded-lg bg-blue-600 px-2.5 py-1 text-xs font-medium text-white transition-colors hover:bg-blue-700"
                    >
                      <Plus className="h-3.5 w-3.5" />
                      Add
                    </button>
                  </div>

                  {questions.length > 0 ? (
                    <div className="space-y-2">
                      {questions.map((q, idx) => (
                        <button
                          key={q.id}
                          onClick={() => setEditingQuestion(q)}
                          className="w-full rounded-lg border border-gray-100 px-3 py-2.5 text-left transition-colors hover:bg-gray-50"
                        >
                          <div className="flex items-center justify-between">
                            <span className="text-sm font-medium text-gray-900">
                              Q{idx + 1}
                            </span>
                            <span className="rounded bg-gray-100 px-1.5 py-0.5 text-xs text-gray-500">
                              {q.type.replace('_', ' ')}
                            </span>
                          </div>
                          <p className="mt-1 truncate text-xs text-gray-500">
                            {(q.questionData.question as string) ||
                              (q.questionData.sentence as string) ||
                              (q.questionData.instruction as string) ||
                              'Question data'}
                          </p>
                        </button>
                      ))}
                    </div>
                  ) : (
                    <p className="py-8 text-center text-sm text-gray-400">
                      No questions yet
                    </p>
                  )}
                </>
              )}
            </>
          ) : (
            <div className="flex h-48 items-center justify-center text-sm text-gray-400">
              Select a lesson to view questions
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
