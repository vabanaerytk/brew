# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `ruby-macho` gem.
# Please instead update this file by running `bin/tapioca sync`.

# typed: true

module MachO
  class << self
    def codesign!(filename); end
    def open(filename); end
  end
end

class MachO::CPUSubtypeError < ::MachO::MachOError
  def initialize(cputype, cpusubtype); end
end

class MachO::CPUTypeError < ::MachO::MachOError
  def initialize(cputype); end
end

class MachO::CodeSigningError < ::MachO::MachOError; end

class MachO::DylibIdMissingError < ::MachO::RecoverableModificationError
  def initialize; end
end

class MachO::DylibUnknownError < ::MachO::RecoverableModificationError
  def initialize(dylib); end
end

class MachO::FatArchOffsetOverflowError < ::MachO::MachOError
  def initialize(offset); end
end

class MachO::FatBinaryError < ::MachO::MachOError
  def initialize; end
end

class MachO::FatFile
  extend ::Forwardable

  def initialize(filename, **opts); end

  def add_rpath(path, options = T.unsafe(nil)); end
  def bundle?(*args, &block); end
  def change_dylib(old_name, new_name, options = T.unsafe(nil)); end
  def change_dylib_id(new_id, options = T.unsafe(nil)); end
  def change_install_name(old_name, new_name, options = T.unsafe(nil)); end
  def change_rpath(old_path, new_path, options = T.unsafe(nil)); end
  def core?(*args, &block); end
  def delete_rpath(path, options = T.unsafe(nil)); end
  def dsym?(*args, &block); end
  def dylib?(*args, &block); end
  def dylib_id(*args, &block); end
  def dylib_id=(new_id, options = T.unsafe(nil)); end
  def dylib_load_commands; end
  def dylinker?(*args, &block); end
  def executable?(*args, &block); end
  def extract(cputype); end
  def fat_archs; end
  def filename; end
  def filename=(_arg0); end
  def filetype(*args, &block); end
  def fvmlib?(*args, &block); end
  def header; end
  def initialize_from_bin(bin, opts); end
  def kext?(*args, &block); end
  def linked_dylibs; end
  def machos; end
  def magic(*args, &block); end
  def magic_string; end
  def object?(*args, &block); end
  def options; end
  def populate_fields; end
  def preload?(*args, &block); end
  def rpaths; end
  def serialize; end
  def to_h; end
  def write(filename); end
  def write!; end

  private

  def canonical_macho; end
  def each_macho(options = T.unsafe(nil)); end
  def populate_fat_archs; end
  def populate_fat_header; end
  def populate_machos; end
  def repopulate_raw_machos; end

  class << self
    def new_from_bin(bin, **opts); end
    def new_from_machos(*machos, fat64: T.unsafe(nil)); end
  end
end

class MachO::FiletypeError < ::MachO::MachOError
  def initialize(num); end
end

class MachO::HeaderPadError < ::MachO::ModificationError
  def initialize(filename); end
end

module MachO::Headers; end
MachO::Headers::CPU_ARCH_ABI32 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_ARCH_ABI64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPES = T.let(T.unsafe(nil), Hash)
MachO::Headers::CPU_SUBTYPE_486 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_486SX = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_586 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM64E = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM64_32_V8 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM64_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM64_V8 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V4T = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V5TEJ = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V6 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V6M = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7EM = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7F = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7K = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7M = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V7S = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_V8 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_ARM_XSCALE = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_I386 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_LIB64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MASK = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC68030 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC68030_ONLY = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC68040 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC680X0_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC88000_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC88100 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MC88110 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_MMAX_JPC = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_PENT = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_PENTII_M3 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_PENTII_M5 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_PENTIUM_4 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_PENTPRO = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC64_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_601 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_602 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_603 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_603E = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_603EV = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_604 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_604E = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_620 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_7400 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_7450 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_750 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_970 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_POWERPC_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_X86_64_ALL = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_SUBTYPE_X86_64_H = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPES = T.let(T.unsafe(nil), Hash)
MachO::Headers::CPU_TYPE_ANY = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_ARM = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_ARM64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_ARM64_32 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_I386 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_MC680X0 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_MC88000 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_POWERPC = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_POWERPC64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::CPU_TYPE_X86_64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::FAT_CIGAM = T.let(T.unsafe(nil), Integer)
MachO::Headers::FAT_CIGAM_64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::FAT_MAGIC = T.let(T.unsafe(nil), Integer)
MachO::Headers::FAT_MAGIC_64 = T.let(T.unsafe(nil), Integer)

class MachO::Headers::FatArch < ::MachO::MachOStructure
  def initialize(cputype, cpusubtype, offset, size, align); end

  def align; end
  def cpusubtype; end
  def cputype; end
  def offset; end
  def serialize; end
  def size; end
  def to_h; end
end

class MachO::Headers::FatArch64 < ::MachO::Headers::FatArch
  def initialize(cputype, cpusubtype, offset, size, align, reserved = T.unsafe(nil)); end

  def reserved; end
  def serialize; end
  def to_h; end
end

MachO::Headers::FatArch64::FORMAT = T.let(T.unsafe(nil), String)
MachO::Headers::FatArch64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::Headers::FatArch::FORMAT = T.let(T.unsafe(nil), String)
MachO::Headers::FatArch::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::Headers::FatHeader < ::MachO::MachOStructure
  def initialize(magic, nfat_arch); end

  def magic; end
  def nfat_arch; end
  def serialize; end
  def to_h; end
end

MachO::Headers::FatHeader::FORMAT = T.let(T.unsafe(nil), String)
MachO::Headers::FatHeader::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_BUNDLE = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_CIGAM = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_CIGAM_64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_CORE = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_DSYM = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_DYLIB = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_DYLIB_STUB = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_DYLINKER = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_EXECUTE = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_FILETYPES = T.let(T.unsafe(nil), Hash)
MachO::Headers::MH_FLAGS = T.let(T.unsafe(nil), Hash)
MachO::Headers::MH_FVMLIB = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_KEXT_BUNDLE = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_MAGIC = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_MAGICS = T.let(T.unsafe(nil), Hash)
MachO::Headers::MH_MAGIC_64 = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_OBJECT = T.let(T.unsafe(nil), Integer)
MachO::Headers::MH_PRELOAD = T.let(T.unsafe(nil), Integer)

class MachO::Headers::MachHeader < ::MachO::MachOStructure
  def initialize(magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags); end

  def alignment; end
  def bundle?; end
  def core?; end
  def cpusubtype; end
  def cputype; end
  def dsym?; end
  def dylib?; end
  def dylinker?; end
  def executable?; end
  def filetype; end
  def flag?(flag); end
  def flags; end
  def fvmlib?; end
  def kext?; end
  def magic; end
  def magic32?; end
  def magic64?; end
  def ncmds; end
  def object?; end
  def preload?; end
  def sizeofcmds; end
  def to_h; end
end

class MachO::Headers::MachHeader64 < ::MachO::Headers::MachHeader
  def initialize(magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags, reserved); end

  def reserved; end
  def to_h; end
end

MachO::Headers::MachHeader64::FORMAT = T.let(T.unsafe(nil), String)
MachO::Headers::MachHeader64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::Headers::MachHeader::FORMAT = T.let(T.unsafe(nil), String)
MachO::Headers::MachHeader::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::JavaClassFileError < ::MachO::NotAMachOError
  def initialize; end
end

class MachO::LCStrMalformedError < ::MachO::MachOError
  def initialize(lc); end
end

class MachO::LoadCommandCreationArityError < ::MachO::MachOError
  def initialize(cmd_sym, expected_arity, actual_arity); end
end

class MachO::LoadCommandError < ::MachO::MachOError
  def initialize(num); end
end

class MachO::LoadCommandNotCreatableError < ::MachO::MachOError
  def initialize(cmd_sym); end
end

class MachO::LoadCommandNotSerializableError < ::MachO::MachOError
  def initialize(cmd_sym); end
end

module MachO::LoadCommands; end

class MachO::LoadCommands::BuildVersionCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, platform, minos, sdk, ntools); end

  def minos; end
  def minos_string; end
  def platform; end
  def sdk; end
  def sdk_string; end
  def to_h; end
  def tool_entries; end
end

MachO::LoadCommands::BuildVersionCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::BuildVersionCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::BuildVersionCommand::ToolEntries
  def initialize(view, ntools); end

  def tools; end
end

class MachO::LoadCommands::BuildVersionCommand::ToolEntries::Tool
  def initialize(tool, version); end

  def to_h; end
  def tool; end
  def version; end
end

MachO::LoadCommands::CREATABLE_LOAD_COMMANDS = T.let(T.unsafe(nil), Array)
MachO::LoadCommands::DYLIB_LOAD_COMMANDS = T.let(T.unsafe(nil), Array)

class MachO::LoadCommands::DyldInfoCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, rebase_off, rebase_size, bind_off, bind_size, weak_bind_off, weak_bind_size, lazy_bind_off, lazy_bind_size, export_off, export_size); end

  def bind_off; end
  def bind_size; end
  def export_off; end
  def export_size; end
  def lazy_bind_off; end
  def lazy_bind_size; end
  def rebase_off; end
  def rebase_size; end
  def to_h; end
  def weak_bind_off; end
  def weak_bind_size; end
end

MachO::LoadCommands::DyldInfoCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::DyldInfoCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::DylibCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, name, timestamp, current_version, compatibility_version); end

  def compatibility_version; end
  def current_version; end
  def name; end
  def serialize(context); end
  def timestamp; end
  def to_h; end
end

MachO::LoadCommands::DylibCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::DylibCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::DylinkerCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, name); end

  def name; end
  def serialize(context); end
  def to_h; end
end

MachO::LoadCommands::DylinkerCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::DylinkerCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::DysymtabCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, ilocalsym, nlocalsym, iextdefsym, nextdefsym, iundefsym, nundefsym, tocoff, ntoc, modtaboff, nmodtab, extrefsymoff, nextrefsyms, indirectsymoff, nindirectsyms, extreloff, nextrel, locreloff, nlocrel); end

  def extrefsymoff; end
  def extreloff; end
  def iextdefsym; end
  def ilocalsym; end
  def indirectsymoff; end
  def iundefsym; end
  def locreloff; end
  def modtaboff; end
  def nextdefsym; end
  def nextrefsyms; end
  def nextrel; end
  def nindirectsyms; end
  def nlocalsym; end
  def nlocrel; end
  def nmodtab; end
  def ntoc; end
  def nundefsym; end
  def to_h; end
  def tocoff; end
end

MachO::LoadCommands::DysymtabCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::DysymtabCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::EncryptionInfoCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, cryptoff, cryptsize, cryptid); end

  def cryptid; end
  def cryptoff; end
  def cryptsize; end
  def to_h; end
end

class MachO::LoadCommands::EncryptionInfoCommand64 < ::MachO::LoadCommands::EncryptionInfoCommand
  def initialize(view, cmd, cmdsize, cryptoff, cryptsize, cryptid, pad); end

  def pad; end
  def to_h; end
end

MachO::LoadCommands::EncryptionInfoCommand64::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::EncryptionInfoCommand64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::EncryptionInfoCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::EncryptionInfoCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::EntryPointCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, entryoff, stacksize); end

  def entryoff; end
  def stacksize; end
  def to_h; end
end

MachO::LoadCommands::EntryPointCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::EntryPointCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::FvmfileCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, name, header_addr); end

  def header_addr; end
  def name; end
  def to_h; end
end

MachO::LoadCommands::FvmfileCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::FvmfileCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::FvmlibCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, name, minor_version, header_addr); end

  def header_addr; end
  def minor_version; end
  def name; end
  def to_h; end
end

MachO::LoadCommands::FvmlibCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::FvmlibCommand::SIZEOF = T.let(T.unsafe(nil), Integer)
class MachO::LoadCommands::IdentCommand < ::MachO::LoadCommands::LoadCommand; end
MachO::LoadCommands::IdentCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::IdentCommand::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::LC_REQ_DYLD = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::LC_STRUCTURES = T.let(T.unsafe(nil), Hash)
MachO::LoadCommands::LOAD_COMMANDS = T.let(T.unsafe(nil), Hash)
MachO::LoadCommands::LOAD_COMMAND_CONSTANTS = T.let(T.unsafe(nil), Hash)

class MachO::LoadCommands::LinkeditDataCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, dataoff, datasize); end

  def dataoff; end
  def datasize; end
  def to_h; end
end

MachO::LoadCommands::LinkeditDataCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::LinkeditDataCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::LinkerOptionCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, count); end

  def count; end
  def to_h; end
end

MachO::LoadCommands::LinkerOptionCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::LinkerOptionCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::LoadCommand < ::MachO::MachOStructure
  def initialize(view, cmd, cmdsize); end

  def cmd; end
  def cmdsize; end
  def offset; end
  def serializable?; end
  def serialize(context); end
  def to_h; end
  def to_s; end
  def to_sym; end
  def type; end
  def view; end

  class << self
    def create(cmd_sym, *args); end
    def new_from_bin(view); end
  end
end

MachO::LoadCommands::LoadCommand::FORMAT = T.let(T.unsafe(nil), String)

class MachO::LoadCommands::LoadCommand::LCStr
  def initialize(lc, lc_str); end

  def to_h; end
  def to_i; end
  def to_s; end
end

MachO::LoadCommands::LoadCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::LoadCommand::SerializationContext
  def initialize(endianness, alignment); end

  def alignment; end
  def endianness; end

  class << self
    def context_for(macho); end
  end
end

class MachO::LoadCommands::NoteCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, data_owner, offset, size); end

  def data_owner; end
  def offset; end
  def size; end
  def to_h; end
end

MachO::LoadCommands::NoteCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::NoteCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::PrebindCksumCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, cksum); end

  def cksum; end
  def to_h; end
end

MachO::LoadCommands::PrebindCksumCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::PrebindCksumCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::PreboundDylibCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, name, nmodules, linked_modules); end

  def linked_modules; end
  def name; end
  def nmodules; end
  def to_h; end
end

MachO::LoadCommands::PreboundDylibCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::PreboundDylibCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::RoutinesCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, init_address, init_module, reserved1, reserved2, reserved3, reserved4, reserved5, reserved6); end

  def init_address; end
  def init_module; end
  def reserved1; end
  def reserved2; end
  def reserved3; end
  def reserved4; end
  def reserved5; end
  def reserved6; end
  def to_h; end
end

class MachO::LoadCommands::RoutinesCommand64 < ::MachO::LoadCommands::RoutinesCommand; end
MachO::LoadCommands::RoutinesCommand64::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::RoutinesCommand64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::RoutinesCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::RoutinesCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::RpathCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, path); end

  def path; end
  def serialize(context); end
  def to_h; end
end

MachO::LoadCommands::RpathCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::RpathCommand::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::SEGMENT_FLAGS = T.let(T.unsafe(nil), Hash)
MachO::LoadCommands::SEGMENT_NAMES = T.let(T.unsafe(nil), Hash)

class MachO::LoadCommands::SegmentCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, segname, vmaddr, vmsize, fileoff, filesize, maxprot, initprot, nsects, flags); end

  def fileoff; end
  def filesize; end
  def flag?(flag); end
  def flags; end
  def guess_align; end
  def initprot; end
  def maxprot; end
  def nsects; end
  def sections; end
  def segname; end
  def to_h; end
  def vmaddr; end
  def vmsize; end
end

class MachO::LoadCommands::SegmentCommand64 < ::MachO::LoadCommands::SegmentCommand; end
MachO::LoadCommands::SegmentCommand64::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SegmentCommand64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::LoadCommands::SegmentCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SegmentCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SourceVersionCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, version); end

  def to_h; end
  def version; end
  def version_string; end
end

MachO::LoadCommands::SourceVersionCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SourceVersionCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SubClientCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, sub_client); end

  def sub_client; end
  def to_h; end
end

MachO::LoadCommands::SubClientCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SubClientCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SubFrameworkCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, umbrella); end

  def to_h; end
  def umbrella; end
end

MachO::LoadCommands::SubFrameworkCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SubFrameworkCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SubLibraryCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, sub_library); end

  def sub_library; end
  def to_h; end
end

MachO::LoadCommands::SubLibraryCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SubLibraryCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SubUmbrellaCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, sub_umbrella); end

  def sub_umbrella; end
  def to_h; end
end

MachO::LoadCommands::SubUmbrellaCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SubUmbrellaCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SymsegCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, offset, size); end

  def offset; end
  def size; end
  def to_h; end
end

MachO::LoadCommands::SymsegCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SymsegCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::SymtabCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, symoff, nsyms, stroff, strsize); end

  def nsyms; end
  def stroff; end
  def strsize; end
  def symoff; end
  def to_h; end
end

MachO::LoadCommands::SymtabCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::SymtabCommand::SIZEOF = T.let(T.unsafe(nil), Integer)
class MachO::LoadCommands::ThreadCommand < ::MachO::LoadCommands::LoadCommand; end
MachO::LoadCommands::ThreadCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::ThreadCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::TwolevelHintsCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, htoffset, nhints); end

  def htoffset; end
  def nhints; end
  def table; end
  def to_h; end
end

MachO::LoadCommands::TwolevelHintsCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::TwolevelHintsCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::TwolevelHintsCommand::TwolevelHintsTable
  def initialize(view, htoffset, nhints); end

  def hints; end
end

class MachO::LoadCommands::TwolevelHintsCommand::TwolevelHintsTable::TwolevelHint
  def initialize(blob); end

  def isub_image; end
  def itoc; end
  def to_h; end
end

class MachO::LoadCommands::UUIDCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, uuid); end

  def to_h; end
  def uuid; end
  def uuid_string; end
end

MachO::LoadCommands::UUIDCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::UUIDCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::LoadCommands::VersionMinCommand < ::MachO::LoadCommands::LoadCommand
  def initialize(view, cmd, cmdsize, version, sdk); end

  def sdk; end
  def sdk_string; end
  def to_h; end
  def version; end
  def version_string; end
end

MachO::LoadCommands::VersionMinCommand::FORMAT = T.let(T.unsafe(nil), String)
MachO::LoadCommands::VersionMinCommand::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::MachOBinaryError < ::MachO::MachOError
  def initialize; end
end

class MachO::MachOError < ::RuntimeError; end

class MachO::MachOFile
  extend ::Forwardable

  def initialize(filename, **opts); end

  def [](name); end
  def add_command(lc, options = T.unsafe(nil)); end
  def add_rpath(path, _options = T.unsafe(nil)); end
  def alignment(*args, &block); end
  def bundle?(*args, &block); end
  def change_dylib(old_name, new_name, _options = T.unsafe(nil)); end
  def change_dylib_id(new_id, _options = T.unsafe(nil)); end
  def change_install_name(old_name, new_name, _options = T.unsafe(nil)); end
  def change_rpath(old_path, new_path, _options = T.unsafe(nil)); end
  def command(name); end
  def core?(*args, &block); end
  def cpusubtype; end
  def cputype; end
  def delete_command(lc, options = T.unsafe(nil)); end
  def delete_rpath(path, _options = T.unsafe(nil)); end
  def dsym?(*args, &block); end
  def dylib?(*args, &block); end
  def dylib_id; end
  def dylib_id=(new_id, _options = T.unsafe(nil)); end
  def dylib_load_commands; end
  def dylinker?(*args, &block); end
  def endianness; end
  def executable?(*args, &block); end
  def filename; end
  def filename=(_arg0); end
  def filetype; end
  def flags(*args, &block); end
  def fvmlib?(*args, &block); end
  def header; end
  def initialize_from_bin(bin, opts); end
  def insert_command(offset, lc, options = T.unsafe(nil)); end
  def kext?(*args, &block); end
  def linked_dylibs; end
  def load_commands; end
  def magic(*args, &block); end
  def magic32?(*args, &block); end
  def magic64?(*args, &block); end
  def magic_string; end
  def ncmds(*args, &block); end
  def object?(*args, &block); end
  def options; end
  def populate_fields; end
  def preload?(*args, &block); end
  def replace_command(old_lc, new_lc); end
  def rpaths; end
  def segment_alignment; end
  def segments; end
  def serialize; end
  def sizeofcmds(*args, &block); end
  def to_h; end
  def write(filename); end
  def write!; end

  private

  def check_cpusubtype(cputype, cpusubtype); end
  def check_cputype(cputype); end
  def check_filetype(filetype); end
  def low_fileoff; end
  def populate_and_check_magic; end
  def populate_load_commands; end
  def populate_mach_header; end
  def update_ncmds(ncmds); end
  def update_sizeofcmds(size); end

  class << self
    def new_from_bin(bin, **opts); end
  end
end

class MachO::MachOStructure
  def to_h; end

  class << self
    def bytesize; end
    def new_from_bin(endianness, bin); end
  end
end

MachO::MachOStructure::FORMAT = T.let(T.unsafe(nil), String)
MachO::MachOStructure::SIZEOF = T.let(T.unsafe(nil), Integer)

class MachO::MachOView
  def initialize(raw_data, endianness, offset); end

  def endianness; end
  def offset; end
  def raw_data; end
  def to_h; end
end

class MachO::MagicError < ::MachO::NotAMachOError
  def initialize(magic); end
end

class MachO::ModificationError < ::MachO::MachOError; end
class MachO::NotAMachOError < ::MachO::MachOError; end

class MachO::OffsetInsertionError < ::MachO::ModificationError
  def initialize(offset); end
end

class MachO::RecoverableModificationError < ::MachO::ModificationError
  def macho_slice; end
  def macho_slice=(_arg0); end
  def to_s; end
end

class MachO::RpathExistsError < ::MachO::RecoverableModificationError
  def initialize(path); end
end

class MachO::RpathUnknownError < ::MachO::RecoverableModificationError
  def initialize(path); end
end

module MachO::Sections; end
MachO::Sections::MAX_SECT_ALIGN = T.let(T.unsafe(nil), Integer)
MachO::Sections::SECTION_ATTRIBUTES = T.let(T.unsafe(nil), Integer)
MachO::Sections::SECTION_ATTRIBUTES_SYS = T.let(T.unsafe(nil), Integer)
MachO::Sections::SECTION_ATTRIBUTES_USR = T.let(T.unsafe(nil), Integer)
MachO::Sections::SECTION_FLAGS = T.let(T.unsafe(nil), Hash)
MachO::Sections::SECTION_NAMES = T.let(T.unsafe(nil), Hash)
MachO::Sections::SECTION_TYPE = T.let(T.unsafe(nil), Integer)

class MachO::Sections::Section < ::MachO::MachOStructure
  def initialize(sectname, segname, addr, size, offset, align, reloff, nreloc, flags, reserved1, reserved2); end

  def addr; end
  def align; end
  def empty?; end
  def flag?(flag); end
  def flags; end
  def nreloc; end
  def offset; end
  def reloff; end
  def reserved1; end
  def reserved2; end
  def section_name; end
  def sectname; end
  def segment_name; end
  def segname; end
  def size; end
  def to_h; end
end

class MachO::Sections::Section64 < ::MachO::Sections::Section
  def initialize(sectname, segname, addr, size, offset, align, reloff, nreloc, flags, reserved1, reserved2, reserved3); end

  def reserved3; end
  def to_h; end
end

MachO::Sections::Section64::FORMAT = T.let(T.unsafe(nil), String)
MachO::Sections::Section64::SIZEOF = T.let(T.unsafe(nil), Integer)
MachO::Sections::Section::FORMAT = T.let(T.unsafe(nil), String)
MachO::Sections::Section::SIZEOF = T.let(T.unsafe(nil), Integer)

module MachO::Tools
  class << self
    def add_rpath(filename, new_path, options = T.unsafe(nil)); end
    def change_dylib_id(filename, new_id, options = T.unsafe(nil)); end
    def change_install_name(filename, old_name, new_name, options = T.unsafe(nil)); end
    def change_rpath(filename, old_path, new_path, options = T.unsafe(nil)); end
    def delete_rpath(filename, old_path, options = T.unsafe(nil)); end
    def dylibs(filename); end
    def merge_machos(filename, *files, fat64: T.unsafe(nil)); end
  end
end

class MachO::TruncatedFileError < ::MachO::NotAMachOError
  def initialize; end
end

class MachO::UnimplementedError < ::MachO::MachOError
  def initialize(thing); end
end

module MachO::Utils
  class << self
    def big_magic?(num); end
    def fat_magic32?(num); end
    def fat_magic64?(num); end
    def fat_magic?(num); end
    def little_magic?(num); end
    def magic32?(num); end
    def magic64?(num); end
    def magic?(num); end
    def nullpad(size); end
    def pack_strings(fixed_offset, alignment, strings = T.unsafe(nil)); end
    def padding_for(size, alignment); end
    def round(value, round); end
    def specialize_format(format, endianness); end
  end
end

MachO::VERSION = T.let(T.unsafe(nil), String)
