import { Injectable, UnauthorizedException } from '@nestjs/common';
import { getAuth } from 'firebase-admin/auth';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async verifyToken(token: string): Promise<any> {
    try {
      const decodedToken = await getAuth().verifyIdToken(token);
      return decodedToken;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }

  async findOrCreateUser(decodedToken: any): Promise<User> {
    let user = await this.usersRepository.findOneBy({ uid: decodedToken.uid });
    if (!user) {
      user = this.usersRepository.create({
        uid: decodedToken.uid,
        username: decodedToken.name || decodedToken.email || 'Unknown',
        avatar: decodedToken.picture || null,
      });
      await this.usersRepository.save(user);
    }
    return user;
  }
}
