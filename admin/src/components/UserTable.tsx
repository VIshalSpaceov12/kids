import type { Parent } from '../types';
import { ChevronUp, ChevronDown } from 'lucide-react';
import clsx from 'clsx';

type SortKey = 'name' | 'childrenCount' | 'lastActive' | 'createdAt';
type SortDir = 'asc' | 'desc';

interface UserTableProps {
  users: Parent[];
  sortKey: SortKey;
  sortDir: SortDir;
  onSort: (key: SortKey) => void;
  onRowClick: (user: Parent) => void;
}

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  });
}

function formatRelative(dateStr: string): string {
  const now = new Date();
  const date = new Date(dateStr);
  const diffMs = now.getTime() - date.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  if (diffDays === 0) return 'Today';
  if (diffDays === 1) return 'Yesterday';
  if (diffDays < 7) return `${diffDays} days ago`;
  return formatDate(dateStr);
}

const columns: { key: SortKey; label: string }[] = [
  { key: 'name', label: 'Name' },
  { key: 'childrenCount', label: 'Children' },
  { key: 'lastActive', label: 'Last Active' },
  { key: 'createdAt', label: 'Registered' },
];

export default function UserTable({ users, sortKey, sortDir, onSort, onRowClick }: UserTableProps) {
  return (
    <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
      <table className="w-full">
        <thead>
          <tr className="border-b border-gray-200 bg-gray-50">
            {columns.map((col) => (
              <th
                key={col.key}
                className="cursor-pointer px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500 transition-colors hover:text-gray-900"
                onClick={() => onSort(col.key)}
              >
                <div className="flex items-center gap-1">
                  {col.label}
                  {sortKey === col.key && (
                    sortDir === 'asc' ? (
                      <ChevronUp className="h-3.5 w-3.5" />
                    ) : (
                      <ChevronDown className="h-3.5 w-3.5" />
                    )
                  )}
                </div>
              </th>
            ))}
            <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">
              Contact
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {users.map((user, index) => (
            <tr
              key={user.id}
              onClick={() => onRowClick(user)}
              className={clsx(
                'cursor-pointer transition-colors hover:bg-blue-50',
                index % 2 === 1 && 'bg-gray-50/50'
              )}
            >
              <td className="px-6 py-4">
                <div className="font-medium text-gray-900">{user.name}</div>
              </td>
              <td className="px-6 py-4 text-gray-600">{user.childrenCount}</td>
              <td className="px-6 py-4 text-gray-600">{formatRelative(user.lastActive)}</td>
              <td className="px-6 py-4 text-gray-600">{formatDate(user.createdAt)}</td>
              <td className="px-6 py-4 text-sm text-gray-500">
                {user.email || user.phone || '-'}
              </td>
            </tr>
          ))}
          {users.length === 0 && (
            <tr>
              <td colSpan={5} className="px-6 py-12 text-center text-gray-400">
                No users found
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
