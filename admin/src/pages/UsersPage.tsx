import { useState, useMemo } from 'react';
import { Search } from 'lucide-react';
import UserTable from '../components/UserTable';
import UserDetailModal from '../components/UserDetailModal';
import { mockParents, mockChildren, mockProgress } from '../data/mockData';
import type { Parent } from '../types';

type SortKey = 'name' | 'childrenCount' | 'lastActive' | 'createdAt';
type SortDir = 'asc' | 'desc';

const classOptions = ['All', 'Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3'];

export default function UsersPage() {
  const [search, setSearch] = useState('');
  const [classFilter, setClassFilter] = useState('All');
  const [sortKey, setSortKey] = useState<SortKey>('createdAt');
  const [sortDir, setSortDir] = useState<SortDir>('desc');
  const [selectedUser, setSelectedUser] = useState<Parent | null>(null);

  const filteredUsers = useMemo(() => {
    let users = [...mockParents];

    if (search.trim()) {
      const q = search.toLowerCase();
      users = users.filter(
        (u) =>
          u.name.toLowerCase().includes(q) ||
          (u.email && u.email.toLowerCase().includes(q)) ||
          (u.phone && u.phone.includes(q))
      );
    }

    if (classFilter !== 'All') {
      const childrenByParent = new Set(
        mockChildren
          .filter((c) => c.classLevel === classFilter)
          .map((c) => c.parentId)
      );
      users = users.filter((u) => childrenByParent.has(u.id));
    }

    users.sort((a, b) => {
      let cmp = 0;
      if (sortKey === 'name') {
        cmp = a.name.localeCompare(b.name);
      } else if (sortKey === 'childrenCount') {
        cmp = a.childrenCount - b.childrenCount;
      } else if (sortKey === 'lastActive') {
        cmp = new Date(a.lastActive).getTime() - new Date(b.lastActive).getTime();
      } else if (sortKey === 'createdAt') {
        cmp = new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime();
      }
      return sortDir === 'asc' ? cmp : -cmp;
    });

    return users;
  }, [search, classFilter, sortKey, sortDir]);

  function handleSort(key: SortKey) {
    if (key === sortKey) {
      setSortDir(sortDir === 'asc' ? 'desc' : 'asc');
    } else {
      setSortKey(key);
      setSortDir('asc');
    }
  }

  const selectedChildren = selectedUser
    ? mockChildren.filter((c) => c.parentId === selectedUser.id)
    : [];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Users</h1>
        <p className="text-gray-500">Manage parent accounts and their children</p>
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="relative flex-1 sm:max-w-md">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name, email, or phone..."
            className="w-full rounded-lg border border-gray-300 py-2 pl-10 pr-4 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
          />
        </div>
        <select
          value={classFilter}
          onChange={(e) => setClassFilter(e.target.value)}
          className="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
        >
          {classOptions.map((c) => (
            <option key={c} value={c}>
              {c === 'All' ? 'All Classes' : c}
            </option>
          ))}
        </select>
      </div>

      <UserTable
        users={filteredUsers}
        sortKey={sortKey}
        sortDir={sortDir}
        onSort={handleSort}
        onRowClick={setSelectedUser}
      />

      <p className="text-sm text-gray-400">
        Showing {filteredUsers.length} of {mockParents.length} users
      </p>

      {selectedUser && (
        <UserDetailModal
          parent={selectedUser}
          children={selectedChildren}
          progress={mockProgress}
          onClose={() => setSelectedUser(null)}
        />
      )}
    </div>
  );
}
