import { NextResponse } from 'next/server';
import { backendFetch } from '@/lib/api-client';

export async function GET() {
  const res = await backendFetch('/api/admin/content/modules');
  const data = await res.json();
  return NextResponse.json(data, { status: res.status });
}
