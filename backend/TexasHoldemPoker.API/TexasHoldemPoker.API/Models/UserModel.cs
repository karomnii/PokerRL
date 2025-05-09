using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class UserModel
{
    public int UserModelId { get; set; }

    public int UserId { get; set; }

    public int ModelId { get; set; }

    public virtual Model Model { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
