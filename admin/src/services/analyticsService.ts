import api from './api';
import type { DashboardStats } from '../types';

export const analyticsService = {
  async getDashboardStats(): Promise<DashboardStats> {
    const response = await api.get('/admin/dashboard');
    return response.data;
  },
};
