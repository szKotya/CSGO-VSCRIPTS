::EXPERIENCE_BASE <- 25;
::EXPERIENCE_MULT <- 1.18;
::MAX_LEVELS <- 100;
::MAX_INVENTORY <- 20;

enum Enum_ROLE
{
	DD = 0,				//ДД
	TANK = 1,			//Танк
	CASTER = 2,			//Кастер
}
::Enum_ROLE <- getconsttable().Enum_ROLE;
::STARTROLE <- Enum_ROLE.DD;

enum Enum_STAT
{
	AGILITY = 0,				//Ловкость
	STRENGTH = 1,				//Сила
	INTELLECT = 2,				//Инта
}

::Enum_STAT <- getconsttable().Enum_STAT;

::STAST_POINT_PER_LEVEL <- 5;									//Стат поин за уровень

::STATS_PHYS_RESIS_PER_STAMINA <- 0.2;						//Физ резист от стамины
::STATS_PHYS_RESIS_PER_STRENGTH <- 0.1;					//Физ резист от силы
::STATS_PHYS_RESIS_PER_MULT <- 1.0;							//Множитель физ резиста

::STATS_MAGIC_RESIS_PER_STAMINA <- 0.2;					//Маг резист от стамины
::STATS_MAGIC_RESIS_PER_INTELLECT <- 0.1;					//Маг резист от инты
::STATS_MAGIC_RESIS_PER_MULT <- 1.0;						//Множитель маг резиста

::STATS_PHYS_DAMAGE_PER_AGILITY <- 0.2;					//Физ урон от ловкости
::STATS_PHYS_DAMAGE_PER_STRENGTH <- 0.3;					//Физ урон от силы
::STATS_PHYS_DAMAGE_PER_INTELLECT <- 0.2;					//Физ урон от инты

::STATS_PHYS_DAMAGE_DOWN_MULT <- 0.95;						//Множитель нижнего порога физического урона
::STATS_PHYS_DAMAGE_CRIT_CHANCE_PER_AGILITY <- 0.05;	//Шанс крита от ловкости
::STATS_PHYS_DAMAGE_CRIT_MULT <- 2.00;						//Множитель крита

::STATS_MAGIC_DAMAGE_PER_INTELLECT <- 20.0;				//Маг урон от инты

::class_role <- class
{
	Name = "";						//Название

	Agility = 0;					//Ловкость
	Strength = 0;					//Сила
	Intellect = 0;					//Инта
	Stamina = 0;					//Выносливость

	Health = 0;
	Mana = 0;
	HealthRegen = 0.0;
	ManaRegen = 0.0;

	HealthStaminaRole = 1.0;
	ManaIntellectRole = 1.0;

	HealthRegenStaminaRole = 1.0;
	ManaRegenIntellectRole = 1.0;

	LevelHealth = 5;
	LevelMana = 5;

	PhysicalResist = 3;
	MagicalResist = 2;

	// IncreaseAgility = 0;			//Прирост Ловкости
	// IncreaseStrength = 0;		//Прирост Силы
	// IncreaseIntellect = 0;		//Прирост Инты
	// IncreaseStamina = 0;			//Прирост Выносливости

	MainStat = -1;					//Основной стат

	AttackSpeed = 0.0;			//Скорость атаки
	AttackMelee = false;			//Ближник

	constructor(_Name, _MainStat)
	{
		this.Name = _Name;
		this.MainStat = _MainStat;
	}
	function SetAgility(i)
	{
		this.Agility = i;
	}
	function SetStrength(i)
	{
		this.Strength = i;
	}
	function SetIntellect(i)
	{
		this.Intellect = i;
	}
	function SetStamina(i)
	{
		this.Stamina = i;
	}
	function SetHealth(i)
	{
		this.Health = i;
	}
	function SetMana(i)
	{
		this.Mana = i;
	}
	function SetLevelHealth(i)
	{
		this.LevelHealth = i;
	}
	function SetLevelMana(i)
	{
		this.LevelMana = i;
	}
	function SetHealthStaminaRole(i)
	{
		this.HealthStaminaRole = i;
	}
	function SetManaIntellectRole(i)
	{
		this.ManaIntellectRole = i;
	}

	function SetHealthRegen(i)
	{
		this.HealthRegen = i;
	}
	function SetManaRegen(i)
	{
		this.ManaRegen = i;
	}
	function SetHealthRegenStaminaRole(i)
	{
		this.HealthRegenStaminaRole = i;
	}
	function SetManaRegenIntellectRole(i)
	{
		this.ManaRegenIntellectRole = i;
	}

	function SetAttackSpeed(i)
	{
		this.AttackSpeed = i;
	}
	function SetAttackMelee(i)
	{
		this.AttackMelee = i;
	}
}

::class_player <- class
{
	Role = -1;											//Класс

	Agility = 0;										//Ловкость
	Strength = 0;										//Сила
	Intellect = 0;										//Инта
	Stamina = 0;										//Выносливость

	Health = 0.0;										//ХП Сейчас
	Mana = 0.0;											//Мана Сейчас

	MaxHealth = 0.0;									//ХП от статов
	MaxMana = 0.0;										//Мана от статов

	HealthRegen = 0.0;								//Реген ХП
	ManaRegen = 0.0;									//Мана реген

	PhysicalResist = 0.0;							//Сопративление физическим атакам
	MagicalResist = 0.0;								//Сопративление магическим атакам

	PhysicalDamage_CritChance = 0.0;				//Шанс крита
	PhysicalDamage_CritMult = 2.00;				//Множитель крита
	PhysicalDamage_Up = 0.0;						//Физический урон верхний порог
	PhysicalDamage_Down = 0.0;						//Физический урон нижний порог

	MagicalDamage = 0.0;								//Магический урон

	SpellCastSpeed = 1.0;							//Скорость кастования скила

	Items = null;
	Equipments = null;

	Level = 0;
	Experience = 0;
	StatsPoint = 0;

	constructor(_Role = STARTROLE)
	{
		this.Role = _Role;
		this.Items = [];

		for (local i = 0; i < MAX_INVENTORY; i++)
		{
			this.Items.push(-1);
		}

		this.Equipments = [];
		for (local i = 0; i < MAX_EQUIPMENTS; i++)
		{
			this.Equipments.push(-1);
		}

		this.Level = 1;
		this.Experience = 0;

		this.StatsPoint = STAST_POINT_PER_LEVEL;

		this.Agility = CLASS_DATA[this.Role].Agility;		//Выставляем статы в зависимости от базовых статов
		this.Strength = CLASS_DATA[this.Role].Strength;		//Выставляем статы в зависимости от базовых статов
		this.Intellect = CLASS_DATA[this.Role].Intellect;	//Выставляем статы в зависимости от базовых статов
		this.Stamina = CLASS_DATA[this.Role].Stamina;		//Выставляем статы в зависимости от базовых статов

		this.UpDateStats();
		this.RestoreHP();
		this.RestoreMana();
		this.Display();
	}

	function GiveItem(item_data)
	{
		foreach (index, item in Items)
		{
			if (item == -1)
			{
				local new_item_data = item_data;
				this.Items[index] = new_item_data;
				return;
			}
		}
	}

	function UnEquipment(ID)
	{
		if (this.Equipments.len() < MAX_EQUIPMENTS)
		{
			return;
		}

		if (this.Equipments[ID] == -1)
		{
			return
		}

		local freeID = -1;
		foreach (index, item in Items)
		{
			if (item == -1)
			{
				freeID = index;
				break;
			}
		}

		if (freeID == -1)
		{
			return;
		}

		this.Items[freeID] = this.Equipments[ID];
		this.Equipments[ID] = -1;
	}

	function UseItem(ID)
	{
		if (this.Items.len() <= ID)
		{
			return;
		}

		if (this.Items[ID] == -1)
		{
			return;
		}

		local item_equment_type = GetEqumentTypeByItemType(this.Items[ID].Type);

		//Экипировка
		if (item_equment_type != -1)
		{
			if (!IsAllowItemForPlayerByRole(this.Items[ID], this))
			{
				return;
			}

			// if (!IsAllowItemForPlayerByLevel(this.Items[ID], this))
			// {
			// 	return;
			// }

			// if (!IsAllowItemForPlayerByStats(this.Items[ID], this))
			// {
			// 	return;
			// }

			if (this.Equipments[item_equment_type] == -1)
			{
				this.Equipments[item_equment_type] = this.Items[ID];
				this.Items[ID] = -1;
			}
			else
			{
				local OldEquipment = this.Equipments[item_equment_type];
				this.Equipments[item_equment_type] = this.Items[ID];
				this.Items[ID] = OldEquipment;
			}
		}
	}

	function GiveExperience(i)
	{
		this.Experience += i;

		this.UpDateLevel();
	}

	function UpDateLevel()
	{
		local iLevel = this.Level - 1;
		local iLevelUp = 0;

		while (EXPERIENCE_DATA[iLevel] <= this.Experience)
		{
			this.Experience -= EXPERIENCE_DATA[iLevel];

			iLevelUp++;
			iLevel++;

			if (iLevel >= MAX_LEVELS)
			{
				iLevel = MAX_LEVELS;
				this.Experience = 0;
				break;
			}
		}

		if (iLevelUp > 0)
		{
			this.LevelUP(iLevelUp);
		}

		if (this.Experience < 1)
		{
			this.Experience = 0;
		}
	}

	function SuccessStatsPoint(i)
	{
		if (this.StatsPoint - i >= 0)
		{
			this.StatsPoint -= i;
			return true;
		}

		return false;
	}

	function StatsPointToAgility(i = 1)
	{
		if (SuccessStatsPoint(i))
		{
			this.Agility += i;
			this.UpDateStats();
		}
	}

	function StatsPointToStrength(i = 1)
	{
		if (SuccessStatsPoint(i))
		{
			this.Strength += i;
			this.UpDateStats();
		}
	}
	function StatsPointToIntellect(i = 1)
	{
		if (SuccessStatsPoint(i))
		{
			this.Intellect += i;
			this.UpDateStats();
		}
	}
	function StatsPointToStamina(i = 1)
	{
		if (SuccessStatsPoint(i))
		{
			this.Stamina += i;
			this.UpDateStats();
		}
	}

	function LevelUP(i = 1)
	{
		this.Level += i;
		this.StatsPoint += i * STAST_POINT_PER_LEVEL;

		this.UpDateStats();

		this.RestoreHP();
		this.RestoreMana();
	}

	function LevelSet(i)
	{
		local OldLevel = this.Level;

		this.Level = i;
		this.Experience = 0;

		if (this.Level - OldLevel > 0)
		{
			this.StatsPoint += (this.Level - OldLevel) * STAST_POINT_PER_LEVEL;
		}

		this.UpDateStats();

		this.RestoreHP();
		this.RestoreMana();
	}

	function UpDateStats()
	{
		this.MaxHealth = CLASS_DATA[this.Role].Health + this.Stamina * CLASS_DATA[this.Role].HealthStaminaRole + (this.Level - 1) * CLASS_DATA[this.Role].LevelHealth;
		this.MaxMana = CLASS_DATA[this.Role].Mana + this.Intellect * CLASS_DATA[this.Role].ManaIntellectRole + (this.Level - 1) * CLASS_DATA[this.Role].LevelMana;

		local iDamageStats = 0;
		switch (CLASS_DATA[this.Role].MainStat)
		{
			case Enum_STAT.AGILITY:
				iDamageStats = this.Agility * STATS_PHYS_DAMAGE_PER_AGILITY;
				break;

			case Enum_STAT.STRENGTH:
				iDamageStats = this.Strength * STATS_PHYS_DAMAGE_PER_STRENGTH;
				break;

			case Enum_STAT.INTELLECT:
				iDamageStats = this.Intellect * STATS_PHYS_DAMAGE_PER_INTELLECT;
				break;
			// default:
			// 	this.PhysicalDamage = 0;
			// 	break;
		}

		this.PhysicalDamage_Up = this.Level + iDamageStats;
		this.PhysicalDamage_Down = this.PhysicalDamage_Up * STATS_PHYS_DAMAGE_DOWN_MULT;

		this.PhysicalDamage_CritChance = 1.0 + (this.Agility * STATS_PHYS_DAMAGE_CRIT_CHANCE_PER_AGILITY);
		this.PhysicalDamage_CritMult = STATS_PHYS_DAMAGE_CRIT_MULT;

		this.HealthRegen = CLASS_DATA[this.Role].HealthRegen + this.Stamina * CLASS_DATA[this.Role].HealthRegenStaminaRole;
		this.ManaRegen = CLASS_DATA[this.Role].ManaRegen + this.Intellect * CLASS_DATA[this.Role].ManaRegenIntellectRole;

		this.PhysicalResist = CLASS_DATA[this.Role].PhysicalResist + ((this.Stamina + this.Strength - 2) / 4);
		this.MagicalResist = CLASS_DATA[this.Role].MagicalResist + ((this.Stamina + this.Intellect - 2) / 4);
		// this.PhysicalResist = (this.Stamina * STATS_PHYS_RESIS_PER_STAMINA + this.Strength * STATS_PHYS_RESIS_PER_STRENGTH) * STATS_PHYS_RESIS_PER_MULT;
		// this.MagicalResist = (this.Stamina * STATS_MAGIC_RESIS_PER_STAMINA + this.Intellect * STATS_MAGIC_RESIS_PER_INTELLECT) * STATS_MAGIC_RESIS_PER_MULT;

		this.MagicalDamage = this.Intellect * STATS_MAGIC_DAMAGE_PER_INTELLECT;
	}

	function Tick_RegenHP()
	{
		this.Health += this.HealthRegen;
		if (this.Health >= this.MaxHealth)
		{
			this.Health = this.MaxHealth;
		}
	}

	function Tick_RegenMana()
	{
		this.Mana += this.ManaRegen;
		if (this.Mana >= this.MaxMana)
		{
			this.Mana = this.MaxMana;
		}
	}
	function Attack()
	{
		printl("");
		printl("");
		printl("-- Damage --");

		printl(format("%i Damage", this.GetDamage()));

		printl("------------");
		printl("");
		printl("");
	}

	function GetDamage()
	{
		local iDamage = RandomInt(this.PhysicalDamage_Down, this.PhysicalDamage_Up);
		if (GetChance(this.PhysicalDamage_CritChance))
		{
			iDamage *= this.PhysicalDamage_CritMult;
		}

		return iDamage;
	}

	function RestoreHP()
	{
		this.Health = this.MaxHealth;
	}
	function RestoreMana()
	{
		this.Mana = this.MaxMana;
	}

	function Display()
	{
		printl("");
		printl("");
		printl("--------------");
		printl(format("%s", CLASS_DATA[this.Role].Name));
		printl(format("%i/%i Level | %i/%i Experience", this.Level, MAX_LEVELS, this.Experience, EXPERIENCE_DATA[this.Level - 1]));
		printl(format("%i Stats Points", this.StatsPoint));


		printl(format(""));
		printl(format("-- HP/MANA --"));
		printl(format(""));

		printl(format("%i/%i HP", this.Health, this.MaxHealth));
		printl(format("%i/%i Mana", this.Mana, this.MaxMana));

		printl(format("%.2f HP Regen", this.HealthRegen));
		printl(format("%.2f Mana Regen", this.ManaRegen));

		printl(format(""));
		printl(format("-- Resist --"));
		printl(format(""));

		printl(format("%i Phys Resist", this.PhysicalResist));
		printl(format("%i Magic Resist", this.MagicalResist));

		printl(format(""));
		printl(format("-- Damage --"));
		printl(format(""));

		printl(format("%i - %i Phys Damage", this.PhysicalDamage_Down, this.PhysicalDamage_Up));
		printl(format("%i Phys Crit chance", this.PhysicalDamage_CritChance));
		printl(format("%.2f Phys Crit multiple", this.PhysicalDamage_CritMult));

		printl(format(""));
		printl(format("%i Magic Damage", this.MagicalDamage));

		printl(format(""));
		printl(format("-- Stats --"));
		printl(format(""));

		printl(format("%i Agility", this.Agility + STAST_POINT_PER_LEVEL));
		printl(format("%i Strength", this.Strength + STAST_POINT_PER_LEVEL));
		printl(format("%i Intellect", this.Intellect + STAST_POINT_PER_LEVEL));
		printl(format("%i Stamina", this.Stamina + STAST_POINT_PER_LEVEL));

		if (this.Items.len() > 0)
		{
			local bHasItems = false;
			foreach (item in this.Items)
			{
				if (item != -1)
				{
					bHasItems = true;
				}
			}

			if (bHasItems)
			{
				printl(format(""));
				printl(format("-- Items --"));
				printl(format(""));

				foreach (index, item in this.Items)
				{
					if (item != -1)
					{
						printl(format("-- %i) %i %s --", index, item.ID, item.Name));
					}
				}
			}
		}


		if (this.Equipments.len() > 0)
		{
			local item_equment_sztype
			printl(format(""));
			printl(format("-- Equipments --"));
			printl(format(""));

			foreach (index, equipment in Equipments)
			{
				item_equment_sztype = GetEqumentSzByEqumentType(index);
				if (equipment == -1)
				{
					printl(format("-- %i|%s: None --", index, item_equment_sztype));
				}
				else
				{
					printl(format("-- %i|%s: %i %s --", index, item_equment_sztype, equipment.ID, equipment.Name));
				}
			}
		}

		printl("--------------");
	}
}

::class_ability <- class
{
	Name = "";						//Название
	CastTime = 0.0;				//Скорость применения
	CD = 0.0;						//Перезарядка

	constructor(_Name, _CastTime, _CD)
	{
		this.Name = _Name;
		this.CastTime = _CastTime;
		this.CD = _CD;
	}
}
enum Enum_EQUIPMENT_TYPE
{
	BODY = 0,
	PANTS = 1,
	BOOTS = 2,
	HEAD = 3,
	ARMS = 4,
	CAPE = 5,
}
::Enum_EQUIPMENT_TYPE <- getconsttable().Enum_EQUIPMENT_TYPE;

::MAX_EQUIPMENTS <- 6;

enum Enum_ITEM_TYPE
{
	NONE = 0,
	BODY = 1,
	PANTS = 2,
	BOOTS = 3,
	HEAD = 4,
	ARMS = 5,
	CAPE = 6,
}
::Enum_ITEM_TYPE <- getconsttable().Enum_ITEM_TYPE;

enum Enum_ITEM_FLAG_ALLOW
{
	NONE = 0,

	AGILITY = 1,
	STRENGTH = 2,
	INTELLECT = 4,

	DD = 8,
	TANK = 16,
	CASTER = 32,
}
::Enum_ITEM_FLAG_ALLOW <- getconsttable().Enum_ITEM_FLAG_ALLOW;

::class_item <- class
{
	////////////////
	// ITEM DATA  //
	////////////////

	ID	= 0;								//ID
	Name = ""; 							//Имя

	Type = Enum_ITEM_TYPE.NONE;	//Тип

	InventoryLimit = 1;				//Кол-во в 1 ячейке

	Durability = 0.0;					//Прочность сейчас
	MaxDurability = 0.0;				//Прочность макс

	////////////////
	// NEED STATS //
	////////////////

	NeedRoleFlags = Enum_ITEM_FLAG_ALLOW.NONE;
	NeedLevel = 0;

	NeedAgility = 0;
	NeedStrength = 0;
	NeedIntellect = 0;
	NeedStamina = 0;

	////////////////
	// GIVE STATS //
	////////////////

	Damage = 0;

	Agility = 0;
	Strength = 0;
	Intellect = 0;
	Stamina = 0;

	PhysicalResist = 0;
	MagicalResist = 0;

	Health = 0;
	Mana = 0;

	HealthRegen = 0.0;
	ManaRegen = 0.0;

	constructor(_Name, _ID)
	{
		this.Name = _Name;
		this.ID = _ID;
	}

	function Print()
	{

		local bNeed = (this.NeedLevel > 0 ||
		this.NeedRoleFlags != Enum_ITEM_FLAG_ALLOW.NONE ||
		this.NeedAgility > 0 ||
		this.NeedStrength > 0 ||
		this.NeedIntellect > 0 ||
		this.NeedStamina > 0);

		printl("---------New item---------");
		printl(format("ID: %i", this.ID));
		printl(format("Name: %s", this.Name));
		printl("");


		if (this.MaxDurability > 0.0)
		{
			printl(format("Durability %i/%i", this.Durability, this.MaxDurability));
		}

		if (this.NeedRoleFlags != Enum_ITEM_FLAG_ALLOW.NONE)
		{
			printl(format("Role: %s", GetFlagString(this.NeedRoleFlags)));
		}

		if (this.NeedLevel > 0)
		{
			printl(format("Need Level: %i", this.NeedLevel));
		}

		if (this.NeedAgility > 0)
		{
			printl(format("Need Agility: %i", this.NeedAgility));
		}
		if (this.NeedStrength > 0)
		{
			printl(format("Need Strength: %i", this.NeedStrength));
		}
		if (this.NeedIntellect > 0)
		{
			printl(format("Need Intellect: %i", this.NeedIntellect));
		}
		if (this.NeedStamina > 0)
		{
			printl(format("Need Stamina: %i", this.NeedStamina));
		}

		if (bNeed)
		{
			printl("");
		}

		if (this.Damage > 0)
		{
			printl(format("Damage: %i", this.Damage));
		}
		if (this.Agility > 0)
		{
			printl(format("Agility: %i", this.Agility));
		}
		if (this.Strength > 0)
		{
			printl(format("Strength: %i", this.Strength));
		}
		if (this.Intellect > 0)
		{
			printl(format("Intellect: %i", this.Intellect));
		}
		if (this.Stamina > 0)
		{
			printl(format("Stamina: %i", this.Stamina));
		}

		if (this.PhysicalResist > 0)
		{
			printl(format("Physical Resist: %i", this.PhysicalResist));
		}
		if (this.MagicalResist > 0)
		{
			printl(format("Magical Resist: %i", this.MagicalResist));
		}
		if (this.Health > 0)
		{
			printl(format("Health: %i", this.Health));
		}
		if (this.Mana > 0)
		{
			printl(format("Mana: %i", this.Mana));
		}
		if (this.HealthRegen > 0)
		{
			printl(format("Health Regen: %i", this.HealthRegen));
		}
		if (this.ManaRegen > 0)
		{
			printl(format("Mana Regen: %i", this.ManaRegen));
		}
	}
}

::CLASS_DATA <- [];

::EXPERIENCE_DATA <- [];

::ITEMS_DATA <- [];

function Init()
{
	ClassData_Init();
	ExperienceData_Init();
	ItemData_Init();
}

function ExperienceData_Init()
{
	EXPERIENCE_DATA.push(EXPERIENCE_BASE);
	for (local iLevel = 1; iLevel < MAX_LEVELS - 1; iLevel++)
	{
		EXPERIENCE_DATA.push((EXPERIENCE_DATA[iLevel - 1] * EXPERIENCE_MULT).tointeger());
	}
	EXPERIENCE_DATA.push(0);
}

function ClassData_Init()
{
	local class_data;

	class_data = class_role("DD", Enum_STAT.AGILITY);
	// class_data.SetAgility(10);
	// class_data.SetStrength(4);
	// class_data.SetIntellect(3);
	// class_data.SetStamina(6);
	class_data.SetHealthRegen(2.0);
	class_data.SetManaRegen(1.3);

	class_data.SetHealthRegenStaminaRole(0.1);
	class_data.SetManaRegenIntellectRole(0.05);

	class_data.SetHealth(65);
	class_data.SetLevelHealth(26);
	class_data.SetHealthStaminaRole(13);

	class_data.SetMana(55);
	class_data.SetLevelMana(22);
	class_data.SetManaIntellectRole(11);

	class_data.SetAttackSpeed(1.0);
	class_data.SetAttackMelee(false);
	CLASS_DATA.push(class_data);

	/*		CLASS		*/

	class_data = class_role("Tank", Enum_STAT.STRENGTH);
	// class_data.SetAgility(3);
	// class_data.SetStrength(10);
	// class_data.SetIntellect(5);
	// class_data.SetStamina(8);
	class_data.SetHealthRegen(2.0);
	class_data.SetManaRegen(1.3);

	class_data.SetHealthRegenStaminaRole(0.1);
	class_data.SetManaRegenIntellectRole(0.05);

	class_data.SetHealth(85);
	class_data.SetLevelHealth(34);
	class_data.SetHealthStaminaRole(17);

	class_data.SetMana(35);
	class_data.SetLevelMana(14);
	class_data.SetManaIntellectRole(7);

	class_data.SetAttackSpeed(1.0);
	class_data.SetAttackMelee(true);
	CLASS_DATA.push(class_data);

	/*		CLASS		*/

	class_data = class_role("Caster", Enum_STAT.INTELLECT);
	// class_data.SetAgility(3);
	// class_data.SetStrength(6);
	// class_data.SetIntellect(10);
	// class_data.SetStamina(7);
	class_data.SetHealthRegen(1.0);
	class_data.SetManaRegen(2.3);

	class_data.SetHealthRegenStaminaRole(0.1);
	class_data.SetManaRegenIntellectRole(0.05);

	class_data.SetHealth(50);
	class_data.SetLevelHealth(20);
	class_data.SetHealthStaminaRole(10);

	class_data.SetMana(70);
	class_data.SetLevelMana(28);
	class_data.SetManaIntellectRole(14);

	class_data.SetAttackSpeed(1.0);
	class_data.SetAttackMelee(false);
	CLASS_DATA.push(class_data);
}

function ItemData_Init()
{
	local item_data;

	//////////
	// ITEM //
	//////////

	item_data = class_item("Броня новичка(Agility)", 0);
	item_data.Type = Enum_ITEM_TYPE.BODY;

	item_data.NeedRoleFlags = Enum_ITEM_FLAG_ALLOW.AGILITY;
	item_data.NeedStrength = 5;
	item_data.NeedAgility = 5;

	item_data.PhysicalResist = 3;
	item_data.MagicalResist = 5;

	ITEMS_DATA.push(item_data);

	//////////
	// ITEM //
	//////////

	item_data = class_item("Наголенники новичка(Agility)", 1);
	item_data.Type = Enum_ITEM_TYPE.PANTS;

	item_data.NeedRoleFlags = Enum_ITEM_FLAG_ALLOW.AGILITY;
	item_data.NeedStrength = 5;
	item_data.NeedAgility = 5;

	item_data.PhysicalResist = 2;
	item_data.MagicalResist = 5;

	ITEMS_DATA.push(item_data);

	//////////
	// ITEM //
	//////////

	item_data = class_item("Туфли новичка(Agility)", 2);
	item_data.Type = Enum_ITEM_TYPE.BOOTS;

	item_data.NeedRoleFlags = Enum_ITEM_FLAG_ALLOW.AGILITY;
	item_data.NeedStrength = 5;
	item_data.NeedAgility = 5;

	item_data.PhysicalResist = 2;

	ITEMS_DATA.push(item_data);

	//////////
	// ITEM //
	//////////

	item_data = class_item("Наручи новичка(Agility)", 3);
	item_data.Type = Enum_ITEM_TYPE.ARMS;

	item_data.NeedRoleFlags = Enum_ITEM_FLAG_ALLOW.AGILITY;
	item_data.NeedStrength = 5;
	item_data.NeedAgility = 5;

	item_data.PhysicalResist = 1;

	ITEMS_DATA.push(item_data);
}

::PrintItems <- function()
{
	printl("");
	printl("--ITEM DATA--");
	foreach (i, item in ITEMS_DATA)
	{
		item.Print();
	}
	printl("--ITEM DATA END--");
	printl("");
}

::GiveItem <- function(ID, player_data)
{
	foreach (item in ITEMS_DATA)
	{
		if (item.ID == ID)
		{
			player_data.GiveItem(item);
			return;
		}
	}
}

::PrintLevels <- function()
{
	printl("");
	printl("");
	printl("-- LEVELS -- " + (EXPERIENCE_DATA.len()+1));

	for (local iLevel = 0; iLevel < EXPERIENCE_DATA.len(); iLevel++)
	{
		printl(format("%i level - %i exp", iLevel + 2, EXPERIENCE_DATA[iLevel]));
	}

	printl("------------");
	printl("");
	printl("");
}

::GetEqumentSzByEqumentType <- function(EqumentType)
{
	if (Enum_EQUIPMENT_TYPE.BODY == EqumentType)
	{
		return "Body";
	}

	if (Enum_EQUIPMENT_TYPE.PANTS == EqumentType)
	{
		return "Pants";
	}

	if (Enum_EQUIPMENT_TYPE.BOOTS == EqumentType)
	{
		return "Boots";
	}

	if (Enum_EQUIPMENT_TYPE.HEAD == EqumentType)
	{
		return "Head";
	}

	if (Enum_EQUIPMENT_TYPE.ARMS == EqumentType)
	{
		return "Arms";
	}

	if (Enum_EQUIPMENT_TYPE.CAPE == EqumentType)
	{
		return "Cape";
	}

	return -1;
}

::GetEqumentTypeByItemType <- function(Type)
{
	if (Type == Enum_ITEM_TYPE.BODY)
	{
		return Enum_EQUIPMENT_TYPE.BODY;
	}

	if (Type == Enum_ITEM_TYPE.PANTS)
	{
		return Enum_EQUIPMENT_TYPE.PANTS;
	}

	if (Type == Enum_ITEM_TYPE.BOOTS)
	{
		return Enum_EQUIPMENT_TYPE.BOOTS;
	}

	if (Type == Enum_ITEM_TYPE.HEAD)
	{
		return Enum_EQUIPMENT_TYPE.HEAD;
	}

	if (Type == Enum_ITEM_TYPE.ARMS)
	{
		return Enum_EQUIPMENT_TYPE.ARMS;
	}

	if (Type == Enum_ITEM_TYPE.CAPE)
	{
		return Enum_EQUIPMENT_TYPE.CAPE;
	}

	return -1;
}

::GetFlagString <- function(Flags)
{
	if (Enum_ITEM_FLAG_ALLOW.NONE == Flags)
	{
		return 0;
	}
	local szFlags = "";

	if (Flags & Enum_ITEM_FLAG_ALLOW.AGILITY)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += "Agility";
	}

	if (Flags & Enum_ITEM_FLAG_ALLOW.STRENGTH)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += "Strength";
	}

	if (Flags & Enum_ITEM_FLAG_ALLOW.INTELLECT)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += "Intllect";
	}

	if (Flags & Enum_ITEM_FLAG_ALLOW.DD)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += CLASS_DATA[DD].Name;
	}

	if (Flags & Enum_ITEM_FLAG_ALLOW.TANK)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += CLASS_DATA[TANK].Name;
	}

	if (Flags & Enum_ITEM_FLAG_ALLOW.CASTER)
	{
		if (szFlags.len() > 0)
		{
			szFlags += "/"
		}
		szFlags += CLASS_DATA[CASTER].Name;
	}

	return szFlags;
}

::GetItemByItemID <- function(ID)
{
	foreach (index, item in ITEMS_DATA)
	{
		if (item.ID == ID)
		{
			return index;
		}
	}

	return -1;
}

::IsAllowItemForPlayerByRole <- function(item_data, player_data)
{
	if (item_data.NeedRoleFlags == Enum_ITEM_FLAG_ALLOW.NONE)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.AGILITY) && CLASS_DATA[player_data.Role].MainStat == Enum_STAT.AGILITY)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.STRENGTH) && CLASS_DATA[player_data.Role].MainStat == Enum_STAT.STRENGTH)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.INTELLECT) && CLASS_DATA[player_data.Role].MainStat == Enum_STAT.INTELLECT)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.DD) && player_data.Role == Enum_ROLE.DD)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.TANK) && player_data.Role == Enum_ROLE.TANK)
	{
		return true;
	}

	if ((item_data.NeedRoleFlags & Enum_ITEM_FLAG_ALLOW.CASTER) && player_data.Role == Enum_ROLE.CASTER)
	{
		return true;
	}

	return false;
}

::IsAllowItemForPlayerByLevel <- function(item_data, player_data)
{
	if (item_data.NeedLevel != 0 && item_data.NeedLevel > player_data.Level)
	{
		return false
	}

	return true;
}

::IsAllowItemForPlayerByStats <- function(item_data, player_data)
{
	if (item_data.NeedAgility != 0 && item_data.NeedAgility > player_data.Agility)
	{
		return false
	}

	if (item_data.NeedStrength != 0 && item_data.NeedStrength > player_data.Strength)
	{
		return false
	}

	if (item_data.NeedIntellect != 0 && item_data.NeedIntellect > player_data.Intellect)
	{
		return false
	}

	if (item_data.NeedStamina != 0 && item_data.NeedStamina > player_data.Stamina)
	{
		return false
	}

	return true;
}

::GetChance <- function(i)
{
	return (RandomInt(1, 100) <= i);
}

Init();