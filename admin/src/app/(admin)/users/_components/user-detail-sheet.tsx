'use client';

import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
} from '@/components/ui/sheet';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import { Skeleton } from '@/components/ui/skeleton';
import { useUserDetail } from '@/hooks/use-users';
import { formatDate } from '@/lib/utils';
import { Star, BookOpen, Target } from 'lucide-react';

interface UserDetailSheetProps {
  userId: string | null;
  open: boolean;
  onClose: () => void;
}

export function UserDetailSheet({ userId, open, onClose }: UserDetailSheetProps) {
  const { data, isLoading } = useUserDetail(userId);

  return (
    <Sheet open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <SheetContent className="overflow-y-auto sm:max-w-lg">
        <SheetHeader>
          <SheetTitle>User Details</SheetTitle>
        </SheetHeader>

        {isLoading ? (
          <div className="space-y-4 pt-4">
            <Skeleton className="h-8 w-48" />
            <Skeleton className="h-4 w-32" />
            <Skeleton className="h-20 w-full" />
            <Skeleton className="h-40 w-full" />
          </div>
        ) : data ? (
          <div className="space-y-6 pt-4">
            {/* Basic Info */}
            <div>
              <h3 className="text-lg font-semibold">{data.user.name}</h3>
              <div className="mt-1 space-y-1 text-sm text-muted-foreground">
                {data.user.email && <p>{data.user.email}</p>}
                {data.user.phone && <p>{data.user.phone}</p>}
                <p>Joined {formatDate(data.user.created_at)}</p>
              </div>
              <div className="mt-2 flex gap-2">
                <Badge variant="secondary">{data.user.role}</Badge>
                {data.user.class_level && (
                  <Badge variant="outline">{data.user.class_level}</Badge>
                )}
                <Badge variant={data.user.is_active ? 'default' : 'destructive'}>
                  {data.user.is_active ? 'Active' : 'Inactive'}
                </Badge>
              </div>
            </div>

            <Separator />

            {/* Stats */}
            <div>
              <h4 className="mb-3 font-medium">Learning Stats</h4>
              <div className="grid grid-cols-3 gap-3">
                <div className="rounded-lg border p-3 text-center">
                  <Star className="mx-auto h-5 w-5 text-yellow-500" />
                  <p className="mt-1 text-xl font-bold">{data.user.stats.totalStars}</p>
                  <p className="text-xs text-muted-foreground">Stars</p>
                </div>
                <div className="rounded-lg border p-3 text-center">
                  <BookOpen className="mx-auto h-5 w-5 text-blue-500" />
                  <p className="mt-1 text-xl font-bold">{data.user.stats.completedLessons}</p>
                  <p className="text-xs text-muted-foreground">Completed</p>
                </div>
                <div className="rounded-lg border p-3 text-center">
                  <Target className="mx-auto h-5 w-5 text-green-500" />
                  <p className="mt-1 text-xl font-bold">{data.user.stats.totalAttempts}</p>
                  <p className="text-xs text-muted-foreground">Attempts</p>
                </div>
              </div>
            </div>

            <Separator />

            {/* Preferences */}
            <div>
              <h4 className="mb-2 font-medium">Preferences</h4>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <div>
                  <span className="text-muted-foreground">Avatar:</span>{' '}
                  <span className="capitalize">{data.user.avatar}</span>
                </div>
                <div>
                  <span className="text-muted-foreground">Pet:</span>{' '}
                  <span className="capitalize">{data.user.pet}</span>
                </div>
                <div>
                  <span className="text-muted-foreground">Language:</span>{' '}
                  <span className="uppercase">{data.user.language}</span>
                </div>
                {data.user.age && (
                  <div>
                    <span className="text-muted-foreground">Age:</span> {data.user.age}
                  </div>
                )}
              </div>
            </div>

            {/* Progress */}
            {data.progress.length > 0 && (
              <>
                <Separator />
                <div>
                  <h4 className="mb-3 font-medium">Lesson Progress</h4>
                  <div className="space-y-2">
                    {data.progress.map((p, i) => (
                      <div
                        key={i}
                        className="flex items-center justify-between rounded-md border px-3 py-2 text-sm"
                      >
                        <div>
                          <p className="font-medium">{p.lesson_title}</p>
                          <p className="text-xs text-muted-foreground">{p.module_name}</p>
                        </div>
                        <div className="flex items-center gap-2">
                          <span className="text-muted-foreground">{p.score}%</span>
                          <div className="flex">
                            {Array.from({ length: 3 }).map((_, si) => (
                              <Star
                                key={si}
                                className={`h-3 w-3 ${
                                  si < p.stars
                                    ? 'fill-yellow-400 text-yellow-400'
                                    : 'text-muted-foreground/30'
                                }`}
                              />
                            ))}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </>
            )}
          </div>
        ) : null}
      </SheetContent>
    </Sheet>
  );
}
