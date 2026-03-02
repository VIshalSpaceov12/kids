'use client';

import { useQuery } from '@tanstack/react-query';
import type { DashboardStats, ModuleEngagement } from '@/types';

interface DashboardData {
  stats: DashboardStats;
  moduleEngagement: ModuleEngagement[];
}

export function useDashboard() {
  return useQuery<DashboardData>({
    queryKey: ['dashboard'],
    queryFn: async () => {
      const res = await fetch('/api/admin/dashboard');
      if (!res.ok) throw new Error('Failed to fetch dashboard data');
      const data = await res.json();
      if (!data.success) throw new Error(data.message);
      return {
        stats: data.stats,
        moduleEngagement: data.moduleEngagement,
      };
    },
  });
}
