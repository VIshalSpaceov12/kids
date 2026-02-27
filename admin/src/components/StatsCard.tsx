import type { LucideIcon } from 'lucide-react';
import clsx from 'clsx';

interface StatsCardProps {
  title: string;
  value: number | string;
  icon: LucideIcon;
  trend?: string;
  color: 'blue' | 'green' | 'orange' | 'purple';
}

const colorMap = {
  blue: {
    bg: 'bg-blue-50',
    icon: 'text-blue-600',
    border: 'border-blue-100',
  },
  green: {
    bg: 'bg-green-50',
    icon: 'text-green-600',
    border: 'border-green-100',
  },
  orange: {
    bg: 'bg-orange-50',
    icon: 'text-orange-600',
    border: 'border-orange-100',
  },
  purple: {
    bg: 'bg-purple-50',
    icon: 'text-purple-600',
    border: 'border-purple-100',
  },
};

export default function StatsCard({ title, value, icon: Icon, trend, color }: StatsCardProps) {
  const colors = colorMap[color];

  return (
    <div className={clsx('rounded-xl border bg-white p-6 shadow-sm', colors.border)}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-500">{title}</p>
          <p className="mt-1 text-3xl font-bold text-gray-900">
            {typeof value === 'number' ? value.toLocaleString() : value}
          </p>
          {trend && (
            <p className="mt-1 text-sm font-medium text-green-600">{trend}</p>
          )}
        </div>
        <div className={clsx('flex h-12 w-12 items-center justify-center rounded-lg', colors.bg)}>
          <Icon className={clsx('h-6 w-6', colors.icon)} />
        </div>
      </div>
    </div>
  );
}
