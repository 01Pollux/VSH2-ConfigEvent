public Action ConfigEvent_Download(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// manage downloadables for files
		"procedure"  "ConfigEvent_Download"

		// 'AddFileToDownloadsTable'
		"downloads"
		{
			"<enum>"	"...."
		}

		// 'PrecacheSound' + 'AddFileToDownloadsTable'
		"sounds"
		{

		}

		// 'AddFileToDownloadsTable'(.vtf) + 'AddFileToDownloadsTable'(.vmt)
		"materials"
		{

		}

		// 'PrecacheModel' + 'AddFileToDownloadsTable'(.mdl, ".dx8.vtx, ".dx9.vtx, sw.vtx, .vvd, .phy)
		"models"
		{

		}
	}
	*/
	int download_stringtable = FindStringTable("downloadables");

	// "downloads"
	{
		ConfigMap downloads = args.GetSection("downloads");
		int downloads_size = downloads ? downloads.Size : 0;
		bool save = LockStringTables(false);
		for (int i = 0; i < downloads_size; i++)
		{
			int file_size = downloads.GetIntKeySize(i);
			char[] file = new char[file_size];
			downloads.GetIntKey(i, file, file_size);
			if (!FileExists(file, true))
			{
				LogError("[VSH2 CfgEvent] Failed to find file \"%s\"", file);
				continue;
			}
			AddToStringTable(download_stringtable, file);
		}
		LockStringTables(save);
	}

	// "sounds"
	{
		ConfigMap sounds = args.GetSection("sounds");
		int sounds_size = sounds ? sounds.Size : 0;
		if (sounds_size)
		{
			bool save = LockStringTables(false);
			for (int i = 0; i < sounds_size; i++)
			{
				int file_size = sounds.GetIntKeySize(i);
				char[] file = new char[file_size + 6 /* sizeof("sounds/)*/];

				sounds.GetIntKey(i, file, file_size);
				if (!FileExists(file, true))
				{
					LogError("[VSH2 CfgEvent] Failed to find file \"%s\"", file);
					continue;
				}
				PrecacheSound(file);

				Format(file, file_size, "sound/%s", file);
				AddToStringTable(download_stringtable, file);
			}
			LockStringTables(save);
		}
	}

	// "materials"
	{
		ConfigMap materials = args.GetSection("materials");
		int materials_size = materials ? materials.Size : 0;
		if (materials_size)
		{
			bool save = LockStringTables(false);
			for (int i = 0; i < materials_size; i++)
			{
				int file_size = materials.GetIntKeySize(i);
				char[] file = new char[file_size + 4 /* sizeof(".v**") */];
				
				int pos = materials.GetIntKey(i, file, file_size);
				if (!pos)
					continue;
				
				file[pos] = '.';
				file[pos + 1] = 'v';

				file[pos + 2] = 'm';
				file[pos + 3] = 't';
				if (!FileExists(file, true))
				{
					LogError("[VSH2 CfgEvent] Failed to find file \"%s\"", file);
					continue;
				}
				AddToStringTable(download_stringtable, file);

				file[pos + 2] = 't';
				file[pos + 3] = 'f';
				if (!FileExists(file, true))
				{
					LogError("[VSH2 CfgEvent] Failed to find file \"%s\"", file);
					continue;
				}
				AddToStringTable(download_stringtable, file);
			}
			LockStringTables(save);
		}
	}
	
	// "models"
	{
		ConfigMap models = args.GetSection("sounds");
		int models_size = models ? models.Size : 0;
		if (models_size)
		{
			char full_path[PLATFORM_MAX_PATH];
			char cur_path[PLATFORM_MAX_PATH];
			char extensions[][] = { "mdl", "dx80.vtx", "dx90.vtx", "sw.vtx", "vvd", "phy" };

			bool save = LockStringTables(false);
			for (int i = 0; i < models_size; i++)
			{
				int pos = models.GetIntKey(i, cur_path, sizeof(cur_path));
				if (!pos)
					continue;
				
				SplitString(cur_path, ".mdl", cur_path, sizeof(cur_path));
				full_path = cur_path;
				bool failed;

				for (int j = 0; j < sizeof(extensions); j++)
				{
					FormatEx(full_path, PLATFORM_MAX_PATH, "%s.%s", cur_path, extensions[j]);
					if (!FileExists(full_path, true))
					{
						failed = true;
						LogError("[VSH2 CfgEvent] Failed to find file \"%s\"", cur_path);
						break;
					}
					AddToStringTable(download_stringtable, full_path);
				}
				if (!failed)
					PrecacheModel(full_path);
			}
			LockStringTables(save);
		}
	}

	return Plugin_Continue;
}
