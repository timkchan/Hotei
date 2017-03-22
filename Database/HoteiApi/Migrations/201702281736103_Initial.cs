namespace HoteiApi.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.UserActivities",
                c => new
                    {
                        UserId = c.Int(nullable: false),
                        Activity = c.String(nullable: false, maxLength: 128),
                        Rating = c.Double(nullable: false),
                    })
                .PrimaryKey(t => new { t.UserId, t.Activity });
            
            CreateTable(
                "dbo.UserNeighbourhoods",
                c => new
                    {
                        userId = c.Int(nullable: false),
                        neighbours = c.String(),
                    })
                .PrimaryKey(t => t.userId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.UserNeighbourhoods");
            DropTable("dbo.UserActivities");
        }
    }
}
