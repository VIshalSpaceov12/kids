'use client';

import { useQuery } from '@tanstack/react-query';
import type { User, UserDetail, UserProgress, Pagination } from '@/types';

interface UsersResponse {
  users: User[];
  pagination: Pagination;
}

export function useUsers(page: number, search: string, limit = 20) {
  return useQuery<UsersResponse>({
    queryKey: ['users', page, search, limit],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        limit: String(limit),
      });
      if (search) params.set('search', search);

      const res = await fetch(`/api/admin/users?${params}`);
      if (!res.ok) throw new Error('Failed to fetch users');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return { users: data.users, pagination: data.pagination };
    },
  });
}

interface UserDetailResponse {
  user: UserDetail;
  progress: UserProgress[];
}

export function useUserDetail(userId: string | null) {
  return useQuery<UserDetailResponse>({
    queryKey: ['user-detail', userId],
    queryFn: async () => {
      const res = await fetch(`/api/admin/users/${userId}`);
      if (!res.ok) throw new Error('Failed to fetch user details');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return { user: data.user, progress: data.progress };
    },
    enabled: !!userId,
  });
}
