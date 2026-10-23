import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Public } from '../../auth/decorators/public.decorator';
import { ProfileSearchService } from '../services/profile-search.service';
import { ProfileSearchQueryDto } from '../dto/profile-search-query.dto';
import { IPublicProfile } from '../interfaces/public-profile.interface';

@ApiTags('Profile Discovery & Search')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/search')
export class ProfileSearchController {
  constructor(private readonly searchService: ProfileSearchService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Search discoverable public student profiles by skills, university, degree, location' })
  @ApiResponse({
    status: 200,
    description: 'Paginated public profiles search results returned',
  })
  async searchPublicProfiles(
    @Query() queryDto: ProfileSearchQueryDto,
  ): Promise<{ data: IPublicProfile[]; total: number; page: number; limit: number }> {
    return this.searchService.searchPublicProfiles(queryDto);
  }
}
