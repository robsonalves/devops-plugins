# Docker Cleanup and Pruning

You are helping clean up Docker resources to free up disk space. This includes unused images, containers, volumes, and networks.

Follow these steps:

1. **Check Docker disk usage first**:
   ```bash
   docker system df
   ```
   Shows space used by:
   - Images
   - Containers
   - Volumes
   - Build cache

2. **Show detailed breakdown**:
   ```bash
   docker system df -v
   ```
   Lists all resources with their sizes

3. **Identify what can be cleaned**:

   **Stopped containers**:
   ```bash
   docker ps -a --filter "status=exited" --filter "status=created"
   ```

   **Dangling images** (untagged):
   ```bash
   docker images -f "dangling=true"
   ```

   **Unused images** (not referenced by any container):
   ```bash
   docker images -f "dangling=false" --format "{{.Repository}}:{{.Tag}}" | while read image; do
     [ -z "$(docker ps -a --filter ancestor=$image --format '{{.ID}}')" ] && echo $image
   done
   ```

   **Unused volumes**:
   ```bash
   docker volume ls -f "dangling=true"
   ```

   **Unused networks**:
   ```bash
   docker network ls --filter "type=custom" --format "{{.ID}} {{.Name}}"
   ```

4. **Present cleanup options to user**:
   - Quick cleanup (safe, only unused resources)
   - Aggressive cleanup (all stopped containers, unused images)
   - Selective cleanup (choose what to remove)
   - Full system prune (everything unused)

5. **Execute cleanup based on user choice**:

   **Option 1: Safe cleanup** (recommended):
   ```bash
   # Remove stopped containers
   docker container prune -f

   # Remove dangling images
   docker image prune -f

   # Remove unused volumes (ask first!)
   docker volume prune -f

   # Remove unused networks
   docker network prune -f
   ```

   **Option 2: Aggressive cleanup**:
   ```bash
   # Remove all stopped containers
   docker container prune -f

   # Remove all unused images (not just dangling)
   docker image prune -a -f

   # Remove unused volumes
   docker volume prune -f

   # Remove build cache
   docker builder prune -f
   ```

   **Option 3: Full system prune**:
   ```bash
   # Remove everything unused
   docker system prune -a --volumes -f
   ```

   **Option 4: Selective cleanup**:
   ```bash
   # Remove specific containers
   docker rm <container-id>

   # Remove specific images
   docker rmi <image-id>

   # Remove specific volumes
   docker volume rm <volume-name>
   ```

6. **Show cleanup results**:
   ```bash
   # After cleanup
   docker system df

   # Compare before/after
   # Show space reclaimed
   ```

7. **Verify nothing important was removed**:
   ```bash
   # Check running containers are still ok
   docker ps

   # Verify important volumes still exist
   docker volume ls
   ```

Safety warnings:

**CRITICAL - Always warn before**:
- Removing volumes (data loss possible!)
- Removing all images (will need to re-download)
- Removing images that take long to build

**Protected resources**:
- Never remove running containers
- Never remove volumes that are in use
- Warn about volumes with important data
- Check for containers with restart policies

**Ask for confirmation**:
- Before volume cleanup (potential data loss)
- Before removing all images (time to re-download)
- Before full system prune

Interactive cleanup flow:

```bash
# 1. Show current usage
docker system df

# 2. Estimate reclaimable space
docker system df -v

# 3. Start with safest cleanup
echo "Removing stopped containers..."
docker container prune -f

echo "Removing dangling images..."
docker image prune -f

echo "Removing unused networks..."
docker network prune -f

# 4. Ask about volumes
echo "Found unused volumes:"
docker volume ls -f "dangling=true"
read -p "Remove unused volumes? (y/N) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker volume prune -f
fi

# 5. Ask about all unused images
read -p "Remove all unused images (not just dangling)? (y/N) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker image prune -a -f
fi

# 6. Show results
docker system df
```

Specific scenarios:

**Scenario 1: Low disk space emergency**:
```bash
# Quick aggressive cleanup
docker system prune -a --volumes -f

# Shows space reclaimed immediately
```

**Scenario 2: Development machine cleanup**:
```bash
# Remove old build cache
docker builder prune -f

# Remove unused images
docker image prune -a -f

# Keep volumes (may have important data)
```

**Scenario 3: CI/CD runner cleanup**:
```bash
# Remove everything after builds
docker system prune -a -f

# Don't need to keep anything
```

**Scenario 4: Keep recent images**:
```bash
# Remove images older than 24h not in use
docker image prune -a --filter "until=24h" -f
```

Additional cleanup commands:

**Clean up by pattern**:
```bash
# Remove images by name pattern
docker images | grep "myapp" | awk '{print $3}' | xargs docker rmi

# Remove containers by name pattern
docker ps -a | grep "test-" | awk '{print $1}' | xargs docker rm
```

**Clean up old containers**:
```bash
# Remove containers not updated in 7 days
docker ps -a --filter "until=7d" --format "{{.ID}}" | xargs docker rm
```

**Clean build cache selectively**:
```bash
# Remove build cache older than 7 days
docker builder prune --filter "until=168h" -f
```

Best practices:
1. Run `docker system df` regularly to monitor usage
2. Clean up after major builds or tests
3. Be very careful with volumes (data loss!)
4. Keep images you use frequently
5. Schedule regular cleanup (weekly/monthly)
6. Use `.dockerignore` to reduce build context
7. Use multi-stage builds to reduce image sizes

Show helpful information:
- Current disk usage before cleanup
- Estimated space to be reclaimed
- Actual space reclaimed after cleanup
- List of resources removed
- Warnings about any protected resources
- Recommendations for reducing future disk usage

Common disk space issues and solutions:
1. **Large build cache**: `docker builder prune`
2. **Many old images**: `docker image prune -a`
3. **Stopped containers**: `docker container prune`
4. **Unused volumes**: `docker volume prune` (careful!)
5. **Large logs**: Check container logs in `/var/lib/docker/containers/`

After cleanup recommendations:
- Consider using `docker system prune` regularly
- Set up log rotation for containers
- Use volume mounting instead of copying data
- Clean up test containers immediately
- Use smaller base images
- Implement cleanup in CI/CD pipelines
