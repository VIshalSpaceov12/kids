'use client';

import { useDashboard } from '@/hooks/use-dashboard';
import { StatsCards } from './_components/stats-cards';
import { ModuleEngagement } from './_components/module-engagement';
import { Skeleton } from '@/components/ui/skeleton';
import { Button } from '@/components/ui/button';
import { AlertCircle, RefreshCw } from 'lucide-react';

export default function DashboardPage() {
  const { data, isLoading, error, refetch } = useDashboard();

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-12">
        <AlertCircle className="h-10 w-10 text-destructive" />
        <p className="text-muted-foreground">Failed to load dashboard data</p>
        <Button variant="outline" onClick={() => refetch()}>
          <RefreshCw className="mr-2 h-4 w-4" />
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Dashboard</h1>

      {isLoading ? (
        <div className="grid gap-4 sm:grid-cols-3">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-28" />
          ))}
        </div>
      ) : data ? (
        <StatsCards stats={data.stats} />
      ) : null}

      {isLoading ? (
        <Skeleton className="h-80" />
      ) : data ? (
        <ModuleEngagement data={data.moduleEngagement} />
      ) : null}
    </div>
  );
}
