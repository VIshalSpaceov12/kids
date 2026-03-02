'use client';

import { useState } from 'react';
import { useUsers } from '@/hooks/use-users';
import { UserSearchBar } from './_components/user-search-bar';
import { UsersTable } from './_components/users-table';
import { UserDetailSheet } from './_components/user-detail-sheet';
import { Skeleton } from '@/components/ui/skeleton';
import { Button } from '@/components/ui/button';
import { AlertCircle, RefreshCw } from 'lucide-react';

export default function UsersPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [selectedUserId, setSelectedUserId] = useState<string | null>(null);

  const { data, isLoading, error, refetch } = useUsers(page, search);

  function handleSearch(value: string) {
    setSearch(value);
    setPage(1);
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-12">
        <AlertCircle className="h-10 w-10 text-destructive" />
        <p className="text-muted-foreground">Failed to load users</p>
        <Button variant="outline" onClick={() => refetch()}>
          <RefreshCw className="mr-2 h-4 w-4" />
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Users</h1>
        {data && (
          <span className="text-sm text-muted-foreground">
            {data.pagination.total} total users
          </span>
        )}
      </div>

      <UserSearchBar value={search} onChange={handleSearch} />

      {isLoading ? (
        <div className="space-y-2">
          {Array.from({ length: 5 }).map((_, i) => (
            <Skeleton key={i} className="h-12 w-full" />
          ))}
        </div>
      ) : data ? (
        <UsersTable
          users={data.users}
          pagination={data.pagination}
          page={page}
          onPageChange={setPage}
          onSelectUser={setSelectedUserId}
        />
      ) : null}

      <UserDetailSheet
        userId={selectedUserId}
        open={!!selectedUserId}
        onClose={() => setSelectedUserId(null)}
      />
    </div>
  );
}
