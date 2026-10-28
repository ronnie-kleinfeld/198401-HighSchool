using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Store> Stores => Set<Store>();
    public DbSet<Question> Questions => Set<Question>();
    public DbSet<LedgerEntry> Ledger => Set<LedgerEntry>();
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<CourseSection> CourseSections => Set<CourseSection>();
    public DbSet<BlockedSlot> BlockedSlots => Set<BlockedSlot>();
    public DbSet<MicroProgram> MicroPrograms => Set<MicroProgram>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.Entity<Course>().Property(c => c.Id).ValueGeneratedNever();
        b.Entity<MicroProgram>().HasIndex(p => p.Name).IsUnique();
        b.Entity<LedgerEntry>().Property(e => e.Amount).HasConversion<double>();
        b.Entity<LedgerEntry>().Property(e => e.Balance).HasConversion<double>();
    }
}
