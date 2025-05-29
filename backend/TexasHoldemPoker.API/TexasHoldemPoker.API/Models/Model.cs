using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class Model
{
    public int ModelId { get; set; }

    public string Name { get; set; } = null!;

    public string? Path { get; set; }

    public string? Difficulty { get; set; }

    public virtual ICollection<UserModel> UserModels { get; set; } = new List<UserModel>();
}
