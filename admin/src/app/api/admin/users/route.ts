import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/api-client';

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const params = new URLSearchParams();

  const page = searchParams.get('page');
  const limit = searchParams.get('limit');
  const search = searchParams.get('search');
  const role = searchParams.get('role');

  if (page) params.set('page', page);
  if (limit) params.set('limit', limit);
  if (search) params.set('search', search);
  if (role) params.set('role', role);

  const res = await backendFetch(`/api/admin/users?${params.toString()}`);
  const data = await res.json();
  return NextResponse.json(data, { status: res.status });
}
