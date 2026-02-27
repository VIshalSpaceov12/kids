import { useState, useEffect } from 'react';
import { Trash2 } from 'lucide-react';
import type { Question } from '../types';

type QuestionType = 'multiple_choice' | 'fill_blank' | 'ordering';

interface QuestionEditorProps {
  question?: Question | null;
  lessonId: string;
  onSave: (data: Partial<Question>) => void;
  onDelete?: () => void;
  onCancel: () => void;
}

export default function QuestionEditor({
  question,
  lessonId,
  onSave,
  onDelete,
  onCancel,
}: QuestionEditorProps) {
  const [type, setType] = useState<QuestionType>('multiple_choice');
  const [mcQuestion, setMcQuestion] = useState('');
  const [mcOptions, setMcOptions] = useState(['', '', '', '']);
  const [mcCorrect, setMcCorrect] = useState(0);
  const [fbSentence, setFbSentence] = useState('');
  const [fbAnswer, setFbAnswer] = useState('');
  const [orderItems, setOrderItems] = useState(['', '', '', '']);
  const [isActive, setIsActive] = useState(true);

  useEffect(() => {
    if (question) {
      setType(question.type === 'tracing' ? 'multiple_choice' : question.type);
      setIsActive(question.isActive);

      const qd = question.questionData;
      const ca = question.correctAnswer;

      if (question.type === 'multiple_choice') {
        setMcQuestion((qd.question as string) || '');
        setMcOptions((qd.options as string[]) || ['', '', '', '']);
        const correctAns = (ca.answer as string) || '';
        const options = (qd.options as string[]) || [];
        const idx = options.indexOf(correctAns);
        setMcCorrect(idx >= 0 ? idx : 0);
      } else if (question.type === 'fill_blank') {
        setFbSentence((qd.sentence as string) || '');
        setFbAnswer((ca.answer as string) || '');
      } else if (question.type === 'ordering') {
        setOrderItems((qd.items as string[]) || ['', '', '', '']);
      }
    } else {
      setType('multiple_choice');
      setMcQuestion('');
      setMcOptions(['', '', '', '']);
      setMcCorrect(0);
      setFbSentence('');
      setFbAnswer('');
      setOrderItems(['', '', '', '']);
      setIsActive(true);
    }
  }, [question]);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    let questionData: Record<string, unknown> = {};
    let correctAnswer: Record<string, unknown> = {};

    if (type === 'multiple_choice') {
      questionData = { question: mcQuestion, options: mcOptions };
      correctAnswer = { answer: mcOptions[mcCorrect] };
    } else if (type === 'fill_blank') {
      questionData = { sentence: fbSentence };
      correctAnswer = { answer: fbAnswer };
    } else if (type === 'ordering') {
      questionData = { instruction: 'Arrange in the correct order', items: orderItems };
      correctAnswer = { order: [...orderItems].sort() };
    }

    onSave({
      lessonId,
      type,
      questionData,
      correctAnswer,
      isActive,
    });
  }

  function updateOption(index: number, value: string) {
    const updated = [...mcOptions];
    updated[index] = value;
    setMcOptions(updated);
  }

  function updateOrderItem(index: number, value: string) {
    const updated = [...orderItems];
    updated[index] = value;
    setOrderItems(updated);
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold text-gray-900">
          {question ? 'Edit Question' : 'New Question'}
        </h3>
        {question && onDelete && (
          <button
            type="button"
            onClick={onDelete}
            className="flex items-center gap-1 rounded-lg px-3 py-1.5 text-sm text-red-600 transition-colors hover:bg-red-50"
          >
            <Trash2 className="h-4 w-4" />
            Delete
          </button>
        )}
      </div>

      <div>
        <label className="mb-1 block text-sm font-medium text-gray-700">Question Type</label>
        <select
          value={type}
          onChange={(e) => setType(e.target.value as QuestionType)}
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
        >
          <option value="multiple_choice">Multiple Choice</option>
          <option value="fill_blank">Fill in the Blank</option>
          <option value="ordering">Ordering</option>
        </select>
      </div>

      {type === 'multiple_choice' && (
        <>
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">Question</label>
            <input
              type="text"
              value={mcQuestion}
              onChange={(e) => setMcQuestion(e.target.value)}
              required
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
              placeholder="Enter the question"
            />
          </div>
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              Options (select correct answer)
            </label>
            <div className="space-y-2">
              {mcOptions.map((opt, idx) => (
                <div key={idx} className="flex items-center gap-2">
                  <input
                    type="radio"
                    name="correctAnswer"
                    checked={mcCorrect === idx}
                    onChange={() => setMcCorrect(idx)}
                    className="h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
                  />
                  <input
                    type="text"
                    value={opt}
                    onChange={(e) => updateOption(idx, e.target.value)}
                    className="flex-1 rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
                    placeholder={`Option ${idx + 1}`}
                  />
                </div>
              ))}
            </div>
          </div>
        </>
      )}

      {type === 'fill_blank' && (
        <>
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Sentence (use ___ for blank)
            </label>
            <input
              type="text"
              value={fbSentence}
              onChange={(e) => setFbSentence(e.target.value)}
              required
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
              placeholder="The number after 7 is ___"
            />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">Correct Answer</label>
            <input
              type="text"
              value={fbAnswer}
              onChange={(e) => setFbAnswer(e.target.value)}
              required
              className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
              placeholder="8"
            />
          </div>
        </>
      )}

      {type === 'ordering' && (
        <div>
          <label className="mb-2 block text-sm font-medium text-gray-700">
            Items (in correct order)
          </label>
          <div className="space-y-2">
            {orderItems.map((item, idx) => (
              <div key={idx} className="flex items-center gap-2">
                <span className="w-6 text-center text-sm font-medium text-gray-400">
                  {idx + 1}
                </span>
                <input
                  type="text"
                  value={item}
                  onChange={(e) => updateOrderItem(idx, e.target.value)}
                  className="flex-1 rounded-lg border border-gray-300 px-3 py-1.5 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
                  placeholder={`Item ${idx + 1}`}
                />
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="flex items-center gap-2">
        <input
          type="checkbox"
          id="qActive"
          checked={isActive}
          onChange={(e) => setIsActive(e.target.checked)}
          className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
        />
        <label htmlFor="qActive" className="text-sm font-medium text-gray-700">
          Active
        </label>
      </div>

      <div className="flex gap-2 pt-2">
        <button
          type="submit"
          className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-blue-700"
        >
          {question ? 'Update' : 'Create'} Question
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
