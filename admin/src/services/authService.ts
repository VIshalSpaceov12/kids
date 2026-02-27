import api from './api';
import type { AdminUser } from '../types';

export const authService = {
  async login(email: string, password: string): Promise<{ token: string; user: AdminUser }> {
    const response = await api.post('/admin/login', { email, password });
    return response.data;
  },

  async getProfile(): Promise<{ user: AdminUser }> {
    const response = await api.get('/admin/profile');
    return response.data;
  },
};
