# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\}.obj::
	$(CXX) $(LIBGDKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\ /c @<<
$<
<<

{..\gdk\gdkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\}.obj::
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\ md vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm
	$(CXX) $(LIBGDKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\ /c @<<
$<
<<

{..\gdk\src\}.ccg{vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\}.obj:
	@if not exist $(@D)\private\ md $(@D)\private
	@for %%s in ($(<D)\*.ccg) do @if not exist ..\gdk\gdkmm\%%~ns.cc if not exist $(@D)\%%~ns.cc $(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../tools/m4 -I $(GMMPROC_PANGO_DIR) -I $(GMMPROC_ATK_DIR) --defs $(<D:\=/) %%~ns $(<D:\=/) $(@D)
	@if exist $(@D)\$(<B).cc $(CXX) $(LIBGDKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c $(@D)\$(<B).cc
	@if exist ..\gdk\gdkmm\$(<B).cc $(CXX) $(LIBGDKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c ..\gdk\gdkmm\$(<B).cc

{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\}.obj::
	$(CXX) $(LIBGTKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\ /c @<<
$<
<<

{..\gtk\gtkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\}.obj::
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\ md vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm
	$(CXX) $(LIBGTKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\ /c @<<
$<
<<

{..\gtk\src\}.ccg{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\}.obj:
	@if not exist $(@D)\private\ md $(@D)\private
	@for %%s in ($(<D)\*.ccg) do @if not exist ..\gtk\gtkmm\%%~ns.cc if not exist $(@D)\%%~ns.cc $(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../tools/m4 -I $(GMMPROC_PANGO_DIR) -I $(GMMPROC_ATK_DIR) --defs $(<D:\=/) %%~ns $(<D:\=/) $(@D)
	@if exist $(@D)\$(<B).cc $(CXX) $(LIBGTKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c $(@D)\$(<B).cc
	@if exist ..\gtk\gtkmm\$(<B).cc $(CXX) $(LIBGTKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c ..\gtk\gtkmm\$(<B).cc

{.\gtkmm\}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\}.res:
	@if not exist $(@D)\ md $(@D)
	rc /fo$@ $<

{..\demos\gtk-demo\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\}.obj::
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\ md vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo
	$(CXX) $(GTKMM_DEMO_CFLAGS) $(CFLAGS) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\ /c @<<
$<
<<

{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\}.c{vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\}.obj::
	$(CC) $(GTKMM_DEMO_CFLAGS) $(CFLAGS) /Fovs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\ /c @<<
$<
<<

# Rules for building .lib files
$(GTKMM_LIB): $(GTKMM_DLL)

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

$(GTKMM_DLL): vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\gtkmm.def $(gtkmm_OBJS) $(gdkmm_OBJS)
	link /DLL $(LDFLAGS_NOLTCG) $(GTKMM_DEP_LIBS) /implib:$(GTKMM_LIB) /def:vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\gtkmm.def -out:$@ @<<
$(gtkmm_OBJS) $(gdkmm_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

# Rules for linking Executables
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

# For the gendef tool
{.\gendef\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\}.exe:
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\gendef\ md vs$(VSVER)\$(CFG)\$(PLAT)\gendef
	$(CXX) $(GTKMM_BASE_CFLAGS) $(CFLAGS) /Fo$(@D)\gendef\ /Fd$(@D)\gendef\ $< /link $(LDFLAGS) /out:$@
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

$(GTKMM4_DEMO): $(GTKMM_LIB) vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo $(gtkmm_demo_OBJS)
	link $(LDFLAGS) $(GTKMM_LIB) $(GTKMM_DEMO_DEP_LIBS) -out:$@ @<<
$(gtkmm_demo_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-builder.exe: ..\tests\builder\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget.exe: ..\tests\child_widget\main.cc ..\tests\child_widget\testwindow.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget2.exe: ..\tests\child_widget2\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget_managed.exe: ..\tests\child_widget_managed\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-delete_cpp_child.exe: ..\tests\delete_cpp_child\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-dialog_deletethis.exe: ..\tests\dialog_deletethis\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-main_with_options.exe: ..\tests\main_with_options\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-menu_destruction.exe: ..\tests\menu_destruction\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-object_move.exe: ..\tests\object_move\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-property_notification.exe: ..\tests\property_notification\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-refcount_dialog.exe: ..\tests\refcount_dialog\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-scrolledwindow.exe: ..\tests\scrolledwindow\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-tree_model_iterator.exe: ..\tests\tree_model_iterator\main.cc
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-wrap_existing.exe: ..\tests\wrap_existing\main.cc

vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-builder.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget2.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-child_widget_managed.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-delete_cpp_child.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-dialog_deletethis.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-main_with_options.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-menu_destruction.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-object_move.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-property_notification.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-refcount_dialog.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-scrolledwindow.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-tree_model_iterator.exe	\
vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-wrap_existing.exe:
	@if not exist $(GTKMM_LIB) $(MAKE) /f Makefile.vc $(SAVED_OPTIONS) $(GTKMM_LIB)
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(@B) md vs$(VSVER)\$(CFG)\$(PLAT)\$(@B)
	$(CXX) $(GTKMM_DEMO_CFLAGS) $(CFLAGS) /Fo$(@D)\$(@B)\ /Fd$(@D)\$(@B)\ $**	\
	/link  $(LDFLAGS) $(GTKMM_LIB) $(GTKMM_DEMO_DEP_LIBS) -out:$@
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

clean:
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exe
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.dll
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.ilk
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exp
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.lib
	@-for /f %d in ('dir /ad /b ..\tests') do @if exist vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-%d (for %x in (obj pdb) do @del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-%d\*.%x)
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\demo_resources.c
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\private\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.def
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.res
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.cc
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\private\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\*.cc
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gendef\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\gendef\*.obj
	@-for /f %d in ('dir /ad /b ..\tests') do @if exist vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-%d rd vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-test-%d
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm4-demo
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm\private
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gtkmm
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm\private
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gdkmm
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\gendef

.SUFFIXES: .cc .h .ccg .hg .obj
