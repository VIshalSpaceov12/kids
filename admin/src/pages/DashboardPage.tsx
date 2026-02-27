import { Users, Activity, UserPlus, Baby } from 'lucide-react';
import StatsCard from '../components/StatsCard';
import ActivityChart from '../components/ActivityChart';
import ModuleEngagementChart from '../components/ModuleEngagementChart';
import { mockDashboardStats } from '../data/mockData';

export default function DashboardPage() {
  const stats = mockDashboardStats;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-500">Overview of Chhotu Genius app performance</p>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatsCard
          title="Total Users"
          value={stats.totalUsers}
          icon={Users}
          trend="+12% this month"
          color="blue"
        />
        <StatsCard
          title="Active Today"
          value={stats.activeToday}
          icon={Activity}
          trend="+5% vs yesterday"
          color="green"
        />
        <StatsCard
          title="New This Week"
          value={stats.newThisWeek}
          icon={UserPlus}
          trend="+8% vs last week"
          color="orange"
        />
        <StatsCard
          title="Total Children"
          value={stats.totalChildren}
          icon={Baby}
          color="purple"
        />
      </div>

      <ActivityChart data={stats.dailyActiveUsers} />

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <ModuleEngagementChart data={stats.moduleEngagement} />

        <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
          <h3 className="mb-4 text-lg font-semibold text-gray-900">Recent Registrations</h3>
          <div className="space-y-3">
            {stats.recentRegistrations.map((reg) => {
              const date = new Date(reg.createdAt);
              const daysDiff = Math.floor(
                (Date.now() - date.getTime()) / (1000 * 60 * 60 * 24)
              );
              const timeLabel =
                daysDiff === 0
                  ? 'Today'
                  : daysDiff === 1
                    ? 'Yesterday'
                    : `${daysDiff} days ago`;

              return (
                <div
                  key={reg.id}
                  className="flex items-center justify-between rounded-lg border border-gray-100 px-4 py-3"
                >
                  <div className="flex items-center gap-3">
                    <div className="flex h-9 w-9 items-center justify-center rounded-full bg-blue-100 text-sm font-semibold text-blue-600">
                      {reg.name
                        .split(' ')
                        .map((n) => n[0])
                        .join('')}
                    </div>
                    <span className="font-medium text-gray-900">{reg.name}</span>
                  </div>
                  <span className="text-sm text-gray-500">{timeLabel}</span>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
