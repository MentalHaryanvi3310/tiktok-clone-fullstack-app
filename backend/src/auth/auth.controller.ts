import { Controller, Post, Body, Req, UseGuards, Get } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Request } from 'express';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  async signup(@Body() body: any) {
    // Signup logic can be handled on frontend with Firebase directly
    // Backend can verify token and create user metadata
    return { message: 'Signup handled by Firebase on frontend' };
  }

  @Post('login')
  async login(@Body('token') token: string) {
    const decodedToken = await this.authService.verifyToken(token);
    const user = await this.authService.findOrCreateUser(decodedToken);
    return { user };
  }

  @Get('me')
  async me(@Req() req: Request) {
    // Assume token is verified by middleware and user info attached to request
    return req['user'] || null;
  }
}
