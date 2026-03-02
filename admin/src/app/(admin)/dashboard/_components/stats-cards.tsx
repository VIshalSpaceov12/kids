import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Users, Activity, UserPlus } from 'lucide-react';
import type { DashboardStats } from '@/types';

export function StatsCards({ stats }: { stats: DashboardStats }) {
  const cards = [
    {
      title: 'Total Users',
      value: stats.totalUsers,
      icon: Users,
      description: 'Registered learners',
    },
    {
      title: 'Active Today',
      value: stats.activeToday,
      icon: Activity,
      description: 'Users active today',
    },
    {
      title: 'New This Week',
      value: stats.newThisWeek,
      icon: UserPlus,
      description: 'Joined in last 7 days',
    },
  ];

  return (
    <div className="grid gap-4 sm:grid-cols-3">
      {cards.map((card) => (
        <Card key={card.title}>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              {card.title}
            </CardTitle>
            <card.icon className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{card.value.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground">{card.description}</p>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
