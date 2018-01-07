USE [Music];
GO

--clear tables
DELETE FROM [album];
DELETE FROM [interpret];
DELETE FROM [label];
DELETE FROM [rating];
DELETE FROM [genre];
DELETE FROM [title];
DELETE FROM [playlist];
DELETE FROM [playlist_title];
DELETE FROM [title_interpret];
DELETE FROM [user];
GO

-- Fill genre table
INSERT INTO [genre] ([name]) VALUES ('Rock & Roll');
INSERT INTO [genre] ([name]) VALUES ('Pop');
INSERT INTO [genre] ([name]) VALUES ('Classic');
INSERT INTO [genre] ([name]) VALUES ('Jazz');
INSERT INTO [genre] ([name]) VALUES ('Blues');
INSERT INTO [genre] ([name]) VALUES ('Country');
INSERT INTO [genre] ([name]) VALUES ('Electronic');
INSERT INTO [genre] ([name]) VALUES ('Folk');
INSERT INTO [genre] ([name]) VALUES ('Hip-Hop');
INSERT INTO [genre] ([name]) VALUES ('Reggae');
GO

-- Fill label table
INSERT INTO [label] ([name], [location], [website]) VALUES ('4AD', 'United Kingdom', 'www.4AD.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('3 Beat Records', 'United Kingdom', 'www.3BeatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Andmoresound', 'United Kingdom', 'www.Andmoresound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Audio Antihero', 'United Kingdom', 'www.AudioAntihero.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Audiobulb Records', 'United Kingdom', 'www.AudiobulbRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('AudioPorn Records', 'United Kingdom', 'www.AudioPornRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('ATP Recordings', 'United Kingdom', 'www.ATPRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Barely Breaking Even', 'United Kingdom', 'www.BarelyBreakingEven.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Beggars Banquet Records', 'United Kingdom', 'www.BeggarsBanquetRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Bella Union', 'United Kingdom', 'www.BellaUnion.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Best Before Records', 'United Kingdom', 'www.BestBeforeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Black Crow Records', 'United Kingdom', 'www.BlackCrowRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blast First', 'United Kingdom', 'www.BlastFirst.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Bloody Chamber Music', 'United Kingdom', 'www.BloodyChamberMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blow Up Records', 'United Kingdom', 'www.BlowUpRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Dog Records', 'United Kingdom', 'www.BlueDogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Room Released', 'United Kingdom', 'www.BlueRoomReleased.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Horizon', 'United Kingdom', 'www.BlueHorizon.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Boy Better Know', 'United Kingdom', 'www.BoyBetterKnow.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Brownswood Recordings', 'United Kingdom', 'www.BrownswoodRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Butterz', 'United Kingdom', 'www.Butterz.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Candid Records', 'United Kingdom', 'www.CandidRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Celtic Music', 'United Kingdom', 'www.CelticMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Chemikal Underground', 'United Kingdom', 'www.ChemikalUnderground.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Cherry Red', 'United Kingdom', 'www.CherryRed.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Circle Records', 'United Kingdom', 'www.CircleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Citinite', 'United Kingdom', 'www.Citinite.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Clay Records', 'United Kingdom', 'www.ClayRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Cooking Vinyl', 'United Kingdom', 'www.CookingVinyl.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Convivium Records', 'United Kingdom', 'www.ConviviumRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Crass Records', 'United Kingdom', 'www.CrassRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Creation Records', 'United Kingdom', 'www.CreationRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Creeping Bent', 'United Kingdom', 'www.CreepingBent.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Criminal Records', 'United Kingdom', 'www.CriminalRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Damaged Goods Records', 'United Kingdom', 'www.DamagedGoodsRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Damnably', 'United Kingdom', 'www.Damnably.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dance to the Radio', 'United Kingdom', 'www.DancetotheRadio.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dancing Turtle Records', 'United Kingdom', 'www.DancingTurtleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Deltasonic', 'United Kingdom', 'www.Deltasonic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dented Records', 'United Kingdom', 'www.DentedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dick Bros Record Company', 'United Kingdom', 'www.DickBrosRecordCompany.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Different Recordings', 'United Kingdom', 'www.DifferentRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Document Records', 'United Kingdom', 'www.DocumentRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Domino Recording Company', 'United Kingdom', 'www.DominoRecordingCompany.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dreamboat Records', 'United Kingdom', 'www.DreamboatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Drowned in Sound', 'United Kingdom', 'www.DrownedinSound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Él', 'United Kingdom', 'www.Él.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Electric Honey', 'United Kingdom', 'www.ElectricHoney.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Enhanced Music', 'United Kingdom', 'www.EnhancedMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Erased Tapes Records', 'United Kingdom', 'www.ErasedTapesRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Factory Records', 'United Kingdom', 'www.FactoryRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Falling A Records', 'United Kingdom', 'www.FallingARecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fällt', 'United Kingdom', 'www.Fällt.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fanfare Records', 'United Kingdom', 'www.FanfareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fantastic Plastic Records', 'United Kingdom', 'www.FantasticPlasticRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fast Product', 'United Kingdom', 'www.FastProduct.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fat Cat Records', 'United Kingdom', 'www.FatCatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fellside Records', 'United Kingdom', 'www.FellsideRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Field Records', 'United Kingdom', 'www.FieldRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fierce Panda Records', 'United Kingdom', 'www.FiercePandaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fire Records', 'United Kingdom', 'www.FireRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Flicknife Records', 'United Kingdom', 'www.FlicknifeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('FM Records', 'United Kingdom', 'www.FMRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fortuna Pop!', 'United Kingdom', 'www.FortunaPop.uk!');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Full Time Hobby', 'United Kingdom', 'www.FullTimeHobby.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gargleblast Records', 'United Kingdom', 'www.GargleblastRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Glass Records', 'United Kingdom', 'www.GlassRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Grand Central Records', 'United Kingdom', 'www.GrandCentralRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gut Records', 'United Kingdom', 'www.GutRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gwarn Music', 'United Kingdom', 'www.GwarnMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hassle Records', 'United Kingdom', 'www.HassleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heaven Records', 'United Kingdom', 'www.HeavenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heavenly Recordings', 'United Kingdom', 'www.HeavenlyRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heist Or Hit Records', 'United Kingdom', 'www.HeistOrHitRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Holy Roar Records', 'United Kingdom', 'www.HolyRoarRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hospital Records', 'United Kingdom', 'www.HospitalRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hyperdub', 'United Kingdom', 'www.Hyperdub.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hyperion Records', 'United Kingdom', 'www.HyperionRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hope Recordings', 'United Kingdom', 'www.HopeRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ill Flava Records', 'United Kingdom', 'www.IllFlavaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Imaginary Records', 'United Kingdom', 'www.ImaginaryRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Incus Records', 'United Kingdom', 'www.IncusRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Independiente Records', 'United Kingdom', 'www.IndependienteRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Invisible Hands Music', 'United Kingdom', 'www.InvisibleHandsMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Irregular Records', 'United Kingdom', 'www.IrregularRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Jeepster Records', 'United Kingdom', 'www.JeepsterRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Jungle Records', 'United Kingdom', 'www.JungleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Junior Aspirin Records', 'United Kingdom', 'www.JuniorAspirinRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Kitchenware Records', 'United Kingdom', 'www.KitchenwareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Kscope', 'United Kingdom', 'www.Kscope.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('LAB Records', 'United Kingdom', 'www.LABRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Launchpad Records', 'United Kingdom', 'www.LaunchpadRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Leader Records', 'United Kingdom', 'www.LeaderRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Leaf Label', 'United Kingdom', 'www.TheLeafLabel.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Lex Records', 'United Kingdom', 'www.LexRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Lojinx', 'United Kingdom', 'www.Lojinx.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Loose Music', 'United Kingdom', 'www.LooseMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Low Life Records', 'United Kingdom', 'www.LowLifeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Market Square Records', 'United Kingdom', 'www.MarketSquareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Marrakesh Records', 'United Kingdom', 'www.MarrakeshRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Memphis Industries', 'United Kingdom', 'www.MemphisIndustries.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Moshi Moshi', 'United Kingdom', 'www.MoshiMoshi.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Motile', 'United Kingdom', 'www.Motile.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mr Bongo Records', 'United Kingdom', 'www.MrBongoRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mukatsuku Records', 'United Kingdom', 'www.MukatsukuRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mute Records', 'United Kingdom', 'www.MuteRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('My Kung Fu', 'United Kingdom', 'www.MyKungFu.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Naim Edge', 'United Kingdom', 'www.NaimEdge.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Native Records', 'United Kingdom', 'www.NativeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Neat Records', 'United Kingdom', 'www.NeatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Never Fade Records', 'United Kingdom', 'www.NeverFadeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ninja Tune', 'United Kingdom', 'www.NinjaTune.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('No Masters', 'United Kingdom', 'www.NoMasters.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Odd Box Records', 'United Kingdom', 'www.OddBoxRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Or Records', 'United Kingdom', 'www.OrRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Outta Sight Records', 'United Kingdom', 'www.OuttaSightRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ozit Records', 'United Kingdom', 'www.OzitRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Pantone Music', 'United Kingdom', 'www.PantoneMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Peacefrog Records', 'United Kingdom', 'www.PeacefrogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Peaceville Records', 'United Kingdom', 'www.PeacevilleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('People In The Sky', 'United Kingdom', 'www.PeopleInTheSky.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Perfecto Records', 'United Kingdom', 'www.PerfectoRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Phantasy Sound', 'United Kingdom', 'www.PhantasySound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Pickled Egg Records', 'United Kingdom', 'www.PickledEggRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Placid Casual', 'United Kingdom', 'www.PlacidCasual.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Play It Again Sam', 'United Kingdom', 'www.PlayItAgainSam.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Postcard Records', 'United Kingdom', 'www.PostcardRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Probe Plus', 'United Kingdom', 'www.ProbePlus.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Radiant Future Records', 'United Kingdom', 'www.RadiantFutureRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('RAM Records', 'United Kingdom', 'www.RAMRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Real World Records', 'United Kingdom', 'www.RealWorldRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Recommended Records', 'United Kingdom', 'www.RecommendedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Red Girl Records', 'United Kingdom', 'www.RedGirlRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rise Above Records', 'United Kingdom', 'www.RiseAboveRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rock Action Records', 'United Kingdom', 'www.RockActionRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rocket Girl', 'United Kingdom', 'www.RocketGirl.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rockville Records', 'United Kingdom', 'www.RockvilleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ron Johnson Records', 'United Kingdom', 'www.RonJohnsonRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rough Trade Records', 'United Kingdom', 'www.RoughTradeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sarah Records', 'United Kingdom', 'www.SarahRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sain', 'United Kingdom', 'www.Sain.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('See Monkey Do Monkey', 'United Kingdom', 'www.SeeMonkeyDoMonkey.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Setanta Records', 'United Kingdom', 'www.SetantaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Shinkansen Records', 'United Kingdom', 'www.ShinkansenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Silvertone Records', 'United Kingdom', 'www.SilvertoneRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('SimG Records', 'United Kingdom', 'www.SimGRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Situation Two', 'United Kingdom', 'www.SituationTwo.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Skam Records', 'United Kingdom', 'www.SkamRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Skint Records', 'United Kingdom', 'www.SkintRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sleep It Off Records', 'United Kingdom', 'www.SleepItOffRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Smalltown America', 'United Kingdom', 'www.SmalltownAmerica.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Small Wonder Records', 'United Kingdom', 'www.SmallWonderRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Snapper Music', 'United Kingdom', 'www.SnapperMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Some Bizzare Records', 'United Kingdom', 'www.SomeBizzareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sonic Vista Music', 'United Kingdom', 'www.SonicVistaMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Southern Fried Records', 'United Kingdom', 'www.SouthernFriedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Southern Records', 'United Kingdom', 'www.SouthernRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Standby Records', 'United Kingdom', 'www.StandbyRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Steel Tiger Records', 'United Kingdom', 'www.SteelTigerRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Stiff Records', 'United Kingdom', 'www.StiffRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Street Soul Productions', 'United Kingdom', 'www.StreetSoulProductions.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Super Records', 'United Kingdom', 'www.SuperRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Stolen Recordings', 'United Kingdom', 'www.StolenRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tempa Records', 'United Kingdom', 'www.TempaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Third Mind Records', 'United Kingdom', 'www.ThirdMindRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tigertrap Records', 'United Kingdom', 'www.TigertrapRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tin Angel Records', 'United Kingdom', 'www.TinAngelRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tiny Dog Records', 'United Kingdom', 'www.TinyDogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('TNSrecords', 'United Kingdom', 'www.TNSrecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Too Pure', 'United Kingdom', 'www.TooPure.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Topic Records', 'United Kingdom', 'www.TopicRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Touch Music', 'United Kingdom', 'www.TouchMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transatlantic Records', 'United Kingdom', 'www.TransatlanticRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transcend Music', 'United Kingdom', 'www.TranscendMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transgressive Records', 'United Kingdom', 'www.TransgressiveRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trash Aesthetics', 'United Kingdom', 'www.TrashAesthetics.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trepan Records', 'United Kingdom', 'www.TrepanRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trend Records', 'United Kingdom', 'www.TrendRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tru Thoughts', 'United Kingdom', 'www.TruThoughts.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Truck Records', 'United Kingdom', 'www.TruckRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trunk Records', 'United Kingdom', 'www.TrunkRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tumi Music', 'United Kingdom', 'www.TumiMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Valentine Records', 'United Kingdom', 'www.ValentineRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Village Thing', 'United Kingdom', 'www.TheVillageThing.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Viper Label', 'United Kingdom', 'www.TheViperLabel.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('VIP Records', 'United Kingdom', 'www.VIPRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Visible Noise', 'United Kingdom', 'www.VisibleNoise.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Warp Records', 'United Kingdom', 'www.WarpRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Whirlwind Recordings', 'United Kingdom', 'www.WhirlwindRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wichita Recordings', 'United Kingdom', 'www.WichitaRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Willkommen Records', 'United Kingdom', 'www.WillkommenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wiiija', 'United Kingdom', 'www.Wiiija.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wrath Records', 'United Kingdom', 'www.WrathRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('XL Recordings', 'United Kingdom', 'www.XLRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Xtra Mile Recordings', 'United Kingdom', 'www.XtraMileRecordings.uk');
GO

--Prepare additional join tables for User tabel insert.
CREATE TABLE [usernameHelper] (
	[usernameHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[username]			NVARCHAR(32)	NOT NULL
);

CREATE TABLE [firstnameHelper] (
	[firstnameHelper_id]	INT			NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[firstname]			NVARCHAR(32)	NOT NULL
);

CREATE TABLE [surnameHelper] (
	[surnameHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[surname]			NVARCHAR(32)	NOT NULL
);

--CREATE TABLE [persons] (
--	[persons_id]		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
--	[firstname]			NVARCHAR(32)	NOT NULL,
--	[lastname]			NVARCHAR(32)	NOT NULL
--);
--GO

--about 100 firstnames

INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Miguel');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Steven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mirac');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Semih');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sinan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Etienne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ibrahim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mario');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Timon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Xaver');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Armin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Efe');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Janosch');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kerem');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mio');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Wilhelm');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Albert');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Erwin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Hans');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Anthony');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Cem');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emre');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Eymen');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Leonidas');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Aras');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ensar');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kenan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kuzey');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lutz');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Selim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Tamme');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Valentino');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Danny');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emanuel');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Giuliano');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Hassan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kerim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Umut');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Amin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Arda');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Danilo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Eren');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mattes');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Vince');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Arvid');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Darius');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Dustin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jake');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jarne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marten');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('James');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lucien');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rayan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Elian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emirhan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Furkan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jonne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kalle');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Karim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Milian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Timur');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Damon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Enrico');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marek');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Quentin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Alwin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Angelo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jesse');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Otto');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Samir');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Yassin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Bilal');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Caspar');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jannek');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jarno');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Maddox');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mahir');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marlo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rico');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Tjark');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Elija');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Iven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Joscha');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Nikolai');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rocco');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Berkay');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Dion');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Gregor');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jano');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Koray');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ramon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sandro');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Taylan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Davin');
GO

--about 100 surnames
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADOUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADUEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEHR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAELEMANS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERSCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERTELS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESCHKE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESECKE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAETZEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEYENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEZEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAG');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGAGE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGAN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGARY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGEIN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGGI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAHOLTZER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAHRES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIKRICH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILEY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLIEU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLIEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISIR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISSELING');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISSON');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAJO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAK');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAKER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAAS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABALZAR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABINET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABOLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACHEBACH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACHELIÈVRE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACITTI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADAMURO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADENBACH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADOT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAELS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAESAR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAGNEAUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHAY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHMBERS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLARD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLAUD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLETEAU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLIAU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLIET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLOT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLOUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILTEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALBAUM');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALBERSCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALÉ');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALIGO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALIN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLÉ');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLIES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLIGARO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLOCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMENT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMUS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALTEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALVISI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAM');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMBIER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMBY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMERIERI');
GO

--about 100 usernames
INSERT INTO [usernameHelper] ([username]) VALUES ('shieldbreak');
INSERT INTO [usernameHelper] ([username]) VALUES ('tailoredglozing');
INSERT INTO [usernameHelper] ([username]) VALUES ('castorbitwise');
INSERT INTO [usernameHelper] ([username]) VALUES ('millervariant');
INSERT INTO [usernameHelper] ([username]) VALUES ('guardsmanchortle');
INSERT INTO [usernameHelper] ([username]) VALUES ('sybaselimey');
INSERT INTO [usernameHelper] ([username]) VALUES ('visanumnah');
INSERT INTO [usernameHelper] ([username]) VALUES ('seafowlallege');
INSERT INTO [usernameHelper] ([username]) VALUES ('bellatrixceramic');
INSERT INTO [usernameHelper] ([username]) VALUES ('sharesorrel');
INSERT INTO [usernameHelper] ([username]) VALUES ('passionateloophole');
INSERT INTO [usernameHelper] ([username]) VALUES ('neuronrangale');
INSERT INTO [usernameHelper] ([username]) VALUES ('fullcrib');
INSERT INTO [usernameHelper] ([username]) VALUES ('ecologygive');
INSERT INTO [usernameHelper] ([username]) VALUES ('bagscurator');
INSERT INTO [usernameHelper] ([username]) VALUES ('yencrimp');
INSERT INTO [usernameHelper] ([username]) VALUES ('stadiumneedless');
INSERT INTO [usernameHelper] ([username]) VALUES ('siliconconnect');
INSERT INTO [usernameHelper] ([username]) VALUES ('stickerpug');
INSERT INTO [usernameHelper] ([username]) VALUES ('sitesearchbending');
INSERT INTO [usernameHelper] ([username]) VALUES ('scratchsavi');
INSERT INTO [usernameHelper] ([username]) VALUES ('preferredwrench');
INSERT INTO [usernameHelper] ([username]) VALUES ('codatriton');
INSERT INTO [usernameHelper] ([username]) VALUES ('glaziermonumental');
INSERT INTO [usernameHelper] ([username]) VALUES ('valvehole');
INSERT INTO [usernameHelper] ([username]) VALUES ('foulhydroxide');
INSERT INTO [usernameHelper] ([username]) VALUES ('diaphragmvile');
INSERT INTO [usernameHelper] ([username]) VALUES ('rhinitisphoto');
INSERT INTO [usernameHelper] ([username]) VALUES ('cosineposset');
INSERT INTO [usernameHelper] ([username]) VALUES ('mobdull');
INSERT INTO [usernameHelper] ([username]) VALUES ('invincibleshrewdness');
INSERT INTO [usernameHelper] ([username]) VALUES ('forwardsubway');
INSERT INTO [usernameHelper] ([username]) VALUES ('dispenserbluepeter');
INSERT INTO [usernameHelper] ([username]) VALUES ('nibblestrut');
INSERT INTO [usernameHelper] ([username]) VALUES ('compressionhooves');
INSERT INTO [usernameHelper] ([username]) VALUES ('oncologycuckoo');
INSERT INTO [usernameHelper] ([username]) VALUES ('bragladder');
INSERT INTO [usernameHelper] ([username]) VALUES ('hangerrare');
INSERT INTO [usernameHelper] ([username]) VALUES ('pourheater');
INSERT INTO [usernameHelper] ([username]) VALUES ('birdsbundevara');
INSERT INTO [usernameHelper] ([username]) VALUES ('einsteinwindows');
INSERT INTO [usernameHelper] ([username]) VALUES ('seriesrevelation');
INSERT INTO [usernameHelper] ([username]) VALUES ('compressedprogram');
INSERT INTO [usernameHelper] ([username]) VALUES ('cyclasescaup');
INSERT INTO [usernameHelper] ([username]) VALUES ('endconfused');
INSERT INTO [usernameHelper] ([username]) VALUES ('shoessite');
INSERT INTO [usernameHelper] ([username]) VALUES ('hedgecab');
INSERT INTO [usernameHelper] ([username]) VALUES ('interestboastful');
INSERT INTO [usernameHelper] ([username]) VALUES ('laughablemaxwell');
INSERT INTO [usernameHelper] ([username]) VALUES ('wimpprism');
INSERT INTO [usernameHelper] ([username]) VALUES ('rampallianpad');
INSERT INTO [usernameHelper] ([username]) VALUES ('lether');
INSERT INTO [usernameHelper] ([username]) VALUES ('abjectcelebrated');
INSERT INTO [usernameHelper] ([username]) VALUES ('halepod');
INSERT INTO [usernameHelper] ([username]) VALUES ('instinctdebate');
INSERT INTO [usernameHelper] ([username]) VALUES ('frailfreak');
INSERT INTO [usernameHelper] ([username]) VALUES ('minglingfonticons');
INSERT INTO [usernameHelper] ([username]) VALUES ('hijackumbra');
INSERT INTO [usernameHelper] ([username]) VALUES ('softwareshrimp');
INSERT INTO [usernameHelper] ([username]) VALUES ('holesneptune');
INSERT INTO [usernameHelper] ([username]) VALUES ('splatterblinkered');
INSERT INTO [usernameHelper] ([username]) VALUES ('dropboxthrowing');
INSERT INTO [usernameHelper] ([username]) VALUES ('harpyspeedy');
INSERT INTO [usernameHelper] ([username]) VALUES ('doradoheart');
INSERT INTO [usernameHelper] ([username]) VALUES ('yorkshireubiquity');
INSERT INTO [usernameHelper] ([username]) VALUES ('agentcup');
INSERT INTO [usernameHelper] ([username]) VALUES ('twotinosbarcode');
INSERT INTO [usernameHelper] ([username]) VALUES ('madcappupils');
INSERT INTO [usernameHelper] ([username]) VALUES ('porphyryunnatural');
INSERT INTO [usernameHelper] ([username]) VALUES ('liggerfishing');
INSERT INTO [usernameHelper] ([username]) VALUES ('nestingrhyolite');
INSERT INTO [usernameHelper] ([username]) VALUES ('roblego');
INSERT INTO [usernameHelper] ([username]) VALUES ('endothermicpeanut');
INSERT INTO [usernameHelper] ([username]) VALUES ('hollandaiseexperience');
INSERT INTO [usernameHelper] ([username]) VALUES ('umbrellabloated');
INSERT INTO [usernameHelper] ([username]) VALUES ('compasswayward');
INSERT INTO [usernameHelper] ([username]) VALUES ('encouragesuperb');
INSERT INTO [usernameHelper] ([username]) VALUES ('sessionssever');
INSERT INTO [usernameHelper] ([username]) VALUES ('chatfeigned');
INSERT INTO [usernameHelper] ([username]) VALUES ('punishmentsynth');
INSERT INTO [usernameHelper] ([username]) VALUES ('snashpoorly');
INSERT INTO [usernameHelper] ([username]) VALUES ('blowingscholar');
INSERT INTO [usernameHelper] ([username]) VALUES ('ornatetorso');
INSERT INTO [usernameHelper] ([username]) VALUES ('helmmarrow');
INSERT INTO [usernameHelper] ([username]) VALUES ('eyepieceelite');
INSERT INTO [usernameHelper] ([username]) VALUES ('volcanoesreporting');
INSERT INTO [usernameHelper] ([username]) VALUES ('endlesscomments');
INSERT INTO [usernameHelper] ([username]) VALUES ('flossclubs');
INSERT INTO [usernameHelper] ([username]) VALUES ('sacknees');
INSERT INTO [usernameHelper] ([username]) VALUES ('scarpthroated');
INSERT INTO [usernameHelper] ([username]) VALUES ('networksnowboard');
INSERT INTO [usernameHelper] ([username]) VALUES ('aldusbudget');
INSERT INTO [usernameHelper] ([username]) VALUES ('guineafearful');
INSERT INTO [usernameHelper] ([username]) VALUES ('meterpause');
INSERT INTO [usernameHelper] ([username]) VALUES ('clottedvroom');
INSERT INTO [usernameHelper] ([username]) VALUES ('cantermuscles');
INSERT INTO [usernameHelper] ([username]) VALUES ('apricotcarriage');
INSERT INTO [usernameHelper] ([username]) VALUES ('seatarias');
INSERT INTO [usernameHelper] ([username]) VALUES ('cartloadmourning');
INSERT INTO [usernameHelper] ([username]) VALUES ('buttresssustain');
INSERT INTO [usernameHelper] ([username]) VALUES ('isometryalert');
INSERT INTO [usernameHelper] ([username]) VALUES ('fixedcheater');
INSERT INTO [usernameHelper] ([username]) VALUES ('gardenwear');
INSERT INTO [usernameHelper] ([username]) VALUES ('curiumpestle');
INSERT INTO [usernameHelper] ([username]) VALUES ('beingteething');
INSERT INTO [usernameHelper] ([username]) VALUES ('submergemorris');
INSERT INTO [usernameHelper] ([username]) VALUES ('bastingdispenser');
INSERT INTO [usernameHelper] ([username]) VALUES ('dysnomiarich');
INSERT INTO [usernameHelper] ([username]) VALUES ('alcoholicsquid');
INSERT INTO [usernameHelper] ([username]) VALUES ('raysyllable');
INSERT INTO [usernameHelper] ([username]) VALUES ('assureand');
INSERT INTO [usernameHelper] ([username]) VALUES ('whimbrelfrozen');
INSERT INTO [usernameHelper] ([username]) VALUES ('niobiumconvection');
INSERT INTO [usernameHelper] ([username]) VALUES ('maximumfishy');
INSERT INTO [usernameHelper] ([username]) VALUES ('gnuformal');
INSERT INTO [usernameHelper] ([username]) VALUES ('particularboiling');
INSERT INTO [usernameHelper] ([username]) VALUES ('disguisingskull');
INSERT INTO [usernameHelper] ([username]) VALUES ('fesnyingmartingale');
INSERT INTO [usernameHelper] ([username]) VALUES ('liberiangranulation');
INSERT INTO [usernameHelper] ([username]) VALUES ('collagenchildren');
INSERT INTO [usernameHelper] ([username]) VALUES ('shinyperiod');
INSERT INTO [usernameHelper] ([username]) VALUES ('criticalcub');
INSERT INTO [usernameHelper] ([username]) VALUES ('twitchgemini');
INSERT INTO [usernameHelper] ([username]) VALUES ('fonticonsrage');
INSERT INTO [usernameHelper] ([username]) VALUES ('crownflexible');
INSERT INTO [usernameHelper] ([username]) VALUES ('drawhelper');
INSERT INTO [usernameHelper] ([username]) VALUES ('googolgleeking');
INSERT INTO [usernameHelper] ([username]) VALUES ('knowledgetriple');
INSERT INTO [usernameHelper] ([username]) VALUES ('purchasingmountain');
INSERT INTO [usernameHelper] ([username]) VALUES ('pigletsleuth');
INSERT INTO [usernameHelper] ([username]) VALUES ('scuppercheesecake');
INSERT INTO [usernameHelper] ([username]) VALUES ('studchalky');
INSERT INTO [usernameHelper] ([username]) VALUES ('kneeslay');
INSERT INTO [usernameHelper] ([username]) VALUES ('cheekplus');
INSERT INTO [usernameHelper] ([username]) VALUES ('hotpotgalvanic');
INSERT INTO [usernameHelper] ([username]) VALUES ('cherriestrustee');
INSERT INTO [usernameHelper] ([username]) VALUES ('reclusivesneeze');
INSERT INTO [usernameHelper] ([username]) VALUES ('asthmajarring');
INSERT INTO [usernameHelper] ([username]) VALUES ('uttermostcancer');
INSERT INTO [usernameHelper] ([username]) VALUES ('herculesrein');
INSERT INTO [usernameHelper] ([username]) VALUES ('terrylarge');
INSERT INTO [usernameHelper] ([username]) VALUES ('pedagogydartboard');
INSERT INTO [usernameHelper] ([username]) VALUES ('equablecrochet');
INSERT INTO [usernameHelper] ([username]) VALUES ('surfingwinks');
INSERT INTO [usernameHelper] ([username]) VALUES ('careenflex');
INSERT INTO [usernameHelper] ([username]) VALUES ('sparklingdeeply');
INSERT INTO [usernameHelper] ([username]) VALUES ('educatesomething');
INSERT INTO [usernameHelper] ([username]) VALUES ('summeryrotten');
INSERT INTO [usernameHelper] ([username]) VALUES ('xiphoidvolume');
INSERT INTO [usernameHelper] ([username]) VALUES ('breezywhimsical');
INSERT INTO [usernameHelper] ([username]) VALUES ('dominantprominence');
INSERT INTO [usernameHelper] ([username]) VALUES ('jockeyeither');
INSERT INTO [usernameHelper] ([username]) VALUES ('nasalmalaysian');
INSERT INTO [usernameHelper] ([username]) VALUES ('parasitewigga');
INSERT INTO [usernameHelper] ([username]) VALUES ('walkerbee');
INSERT INTO [usernameHelper] ([username]) VALUES ('motorboatbackground');
INSERT INTO [usernameHelper] ([username]) VALUES ('blendunruly');
INSERT INTO [usernameHelper] ([username]) VALUES ('shearwill');
INSERT INTO [usernameHelper] ([username]) VALUES ('radpallas');
INSERT INTO [usernameHelper] ([username]) VALUES ('daintyspotless');
INSERT INTO [usernameHelper] ([username]) VALUES ('mandibleexternal');
INSERT INTO [usernameHelper] ([username]) VALUES ('wrenbones');
INSERT INTO [usernameHelper] ([username]) VALUES ('intendedaphanic');
INSERT INTO [usernameHelper] ([username]) VALUES ('chordperl');
INSERT INTO [usernameHelper] ([username]) VALUES ('canessiblings');
INSERT INTO [usernameHelper] ([username]) VALUES ('collarbonefamiliar');
INSERT INTO [usernameHelper] ([username]) VALUES ('bewitchedmarked');
INSERT INTO [usernameHelper] ([username]) VALUES ('huntingmining');
INSERT INTO [usernameHelper] ([username]) VALUES ('canondeliver');
INSERT INTO [usernameHelper] ([username]) VALUES ('eastertrophy');
INSERT INTO [usernameHelper] ([username]) VALUES ('bioticcartridges');
INSERT INTO [usernameHelper] ([username]) VALUES ('superiorjurassic');
INSERT INTO [usernameHelper] ([username]) VALUES ('busytremolo');
INSERT INTO [usernameHelper] ([username]) VALUES ('hyundaiordinal');
INSERT INTO [usernameHelper] ([username]) VALUES ('enquiryhiccup');
INSERT INTO [usernameHelper] ([username]) VALUES ('coronethurtful');
INSERT INTO [usernameHelper] ([username]) VALUES ('loafflack');
INSERT INTO [usernameHelper] ([username]) VALUES ('twangdepartment');
INSERT INTO [usernameHelper] ([username]) VALUES ('partnerjumbo');
INSERT INTO [usernameHelper] ([username]) VALUES ('musclefibroids');
INSERT INTO [usernameHelper] ([username]) VALUES ('lodgepecan');
INSERT INTO [usernameHelper] ([username]) VALUES ('worldalcoholic');
INSERT INTO [usernameHelper] ([username]) VALUES ('selectionstint');
INSERT INTO [usernameHelper] ([username]) VALUES ('feathernoodle');
INSERT INTO [usernameHelper] ([username]) VALUES ('sortmop');
INSERT INTO [usernameHelper] ([username]) VALUES ('jaundiceraw');
INSERT INTO [usernameHelper] ([username]) VALUES ('crymen');
INSERT INTO [usernameHelper] ([username]) VALUES ('queryinggem');
INSERT INTO [usernameHelper] ([username]) VALUES ('tablecos');
INSERT INTO [usernameHelper] ([username]) VALUES ('glutinousouzel');
INSERT INTO [usernameHelper] ([username]) VALUES ('innercosmetic');
INSERT INTO [usernameHelper] ([username]) VALUES ('justpedals');
INSERT INTO [usernameHelper] ([username]) VALUES ('drafterplay');
INSERT INTO [usernameHelper] ([username]) VALUES ('metscary');
INSERT INTO [usernameHelper] ([username]) VALUES ('medialknife');
INSERT INTO [usernameHelper] ([username]) VALUES ('elaboraterightful');
INSERT INTO [usernameHelper] ([username]) VALUES ('slingingloaf');
INSERT INTO [usernameHelper] ([username]) VALUES ('pejorativekneel');
INSERT INTO [usernameHelper] ([username]) VALUES ('prolapsemckinley');
INSERT INTO [usernameHelper] ([username]) VALUES ('longingconvex');
GO

--fill username table
INSERT INTO [user] ([username], [firstname], [lastname], [password], [email])
SELECT LEFT(cast(Concat(firstnameHelper.firstname, surnameHelper.surname, usernameHelper.username) AS nvarchar), 32), firstnameHelper.firstname, surnameHelper.surname, '1234', Concat(firstnameHelper.firstname, '@', surnameHelper.surname, '.com')
From firstnameHelper
CROSS JOIN surnameHelper
CROSS JOIN usernameHelper;
GO

--fill interpret table
INSERT INTO [interpret] ([name], [origin], [fk_genre_id])
SELECT TOP 10000 Concat(firstnameHelper.firstname, surnameHelper.surname), 'United Kingdom', genre.genre_id
FROM firstnameHelper
CROSS JOIN surnameHelper
INNER JOIN genre
on (((surnameHelper.surnameHelper_id % 10)+1) = genre_id);
GO

SELECT * FROM [interpret];

--fill album table
--DECLARE 
--
--SET @counter = 1;
--
--WHILE @counter < 5 
--   BEGIN  
--      SELECT RAND() Random_Number  
--      SET @counter = @counter + 1  
--   END;  
--GO  


--fill title table

--fill title_interpret table

--fill rating table

--playlist table

--fill playlist_title table


DROP TABLE [usernameHelper];
DROP TABLE [firstnameHelper];
DROP TABLE [surnameHelper];