'use client';

import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { useCallback } from 'react';
import type { AdminUser } from '@/types';

export function useAuth() {
  const router = useRouter();
  const queryClient = useQueryClient();

  const { data: admin, isLoading } = useQuery<AdminUser | null>({
    queryKey: ['admin-me'],
    queryFn: async () => {
      const res = await fetch('/api/admin/me');
      if (!res.ok) return null;
      const data = await res.json();
      return data.success ? data.admin : null;
    },
    staleTime: 5 * 60 * 1000,
    retry: false,
  });

  const logout = useCallback(async () => {
    await fetch('/api/admin/logout', { method: 'POST' });
    queryClient.clear();
    router.push('/login');
    router.refresh();
  }, [queryClient, router]);

  return { admin, isLoading, logout };
}
