
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Drive
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages files in Drive including uploading, downloading, searching, detecting changes, and updating sharing permissions.
## 
## https://developers.google.com/drive/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "drive"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_593692 = ref object of OpenApiRestCall_593424
proc url_DriveAboutGet_593694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveAboutGet_593693(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("userIp")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "userIp", valid_593823
  var valid_593824 = query.getOrDefault("key")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "key", valid_593824
  var valid_593825 = query.getOrDefault("prettyPrint")
  valid_593825 = validateParameter(valid_593825, JBool, required = false,
                                 default = newJBool(true))
  if valid_593825 != nil:
    section.add "prettyPrint", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_DriveAboutGet_593692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_DriveAboutGet_593692; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveAboutGet
  ## Gets information about the user, the user's Drive, and system capabilities.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593920 = newJObject()
  add(query_593920, "fields", newJString(fields))
  add(query_593920, "quotaUser", newJString(quotaUser))
  add(query_593920, "alt", newJString(alt))
  add(query_593920, "oauth_token", newJString(oauthToken))
  add(query_593920, "userIp", newJString(userIp))
  add(query_593920, "key", newJString(key))
  add(query_593920, "prettyPrint", newJBool(prettyPrint))
  result = call_593919.call(nil, query_593920, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_593692(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_593693, base: "/drive/v3",
    url: url_DriveAboutGet_593694, schemes: {Scheme.Https})
type
  Call_DriveChangesList_593960 = ref object of OpenApiRestCall_593424
proc url_DriveChangesList_593962(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesList_593961(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the changes for a user or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of changes to return per page.
  ##   includeRemoved: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   restrictToMyDrive: JBool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  section = newJObject()
  var valid_593963 = query.getOrDefault("driveId")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "driveId", valid_593963
  var valid_593964 = query.getOrDefault("supportsAllDrives")
  valid_593964 = validateParameter(valid_593964, JBool, required = false,
                                 default = newJBool(false))
  if valid_593964 != nil:
    section.add "supportsAllDrives", valid_593964
  var valid_593965 = query.getOrDefault("fields")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "fields", valid_593965
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_593966 = query.getOrDefault("pageToken")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "pageToken", valid_593966
  var valid_593967 = query.getOrDefault("quotaUser")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "quotaUser", valid_593967
  var valid_593968 = query.getOrDefault("alt")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = newJString("json"))
  if valid_593968 != nil:
    section.add "alt", valid_593968
  var valid_593969 = query.getOrDefault("oauth_token")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "oauth_token", valid_593969
  var valid_593970 = query.getOrDefault("includeItemsFromAllDrives")
  valid_593970 = validateParameter(valid_593970, JBool, required = false,
                                 default = newJBool(false))
  if valid_593970 != nil:
    section.add "includeItemsFromAllDrives", valid_593970
  var valid_593971 = query.getOrDefault("userIp")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "userIp", valid_593971
  var valid_593972 = query.getOrDefault("includeTeamDriveItems")
  valid_593972 = validateParameter(valid_593972, JBool, required = false,
                                 default = newJBool(false))
  if valid_593972 != nil:
    section.add "includeTeamDriveItems", valid_593972
  var valid_593973 = query.getOrDefault("teamDriveId")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "teamDriveId", valid_593973
  var valid_593974 = query.getOrDefault("supportsTeamDrives")
  valid_593974 = validateParameter(valid_593974, JBool, required = false,
                                 default = newJBool(false))
  if valid_593974 != nil:
    section.add "supportsTeamDrives", valid_593974
  var valid_593975 = query.getOrDefault("key")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "key", valid_593975
  var valid_593976 = query.getOrDefault("spaces")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("drive"))
  if valid_593976 != nil:
    section.add "spaces", valid_593976
  var valid_593978 = query.getOrDefault("pageSize")
  valid_593978 = validateParameter(valid_593978, JInt, required = false,
                                 default = newJInt(100))
  if valid_593978 != nil:
    section.add "pageSize", valid_593978
  var valid_593979 = query.getOrDefault("includeRemoved")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "includeRemoved", valid_593979
  var valid_593980 = query.getOrDefault("prettyPrint")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(true))
  if valid_593980 != nil:
    section.add "prettyPrint", valid_593980
  var valid_593981 = query.getOrDefault("restrictToMyDrive")
  valid_593981 = validateParameter(valid_593981, JBool, required = false,
                                 default = newJBool(false))
  if valid_593981 != nil:
    section.add "restrictToMyDrive", valid_593981
  var valid_593982 = query.getOrDefault("includeCorpusRemovals")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(false))
  if valid_593982 != nil:
    section.add "includeCorpusRemovals", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_DriveChangesList_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_DriveChangesList_593960; pageToken: string;
          driveId: string = ""; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          supportsTeamDrives: bool = false; key: string = ""; spaces: string = "drive";
          pageSize: int = 100; includeRemoved: bool = true; prettyPrint: bool = true;
          restrictToMyDrive: bool = false; includeCorpusRemovals: bool = false): Recallable =
  ## driveChangesList
  ## Lists the changes for a user or shared drive.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of changes to return per page.
  ##   includeRemoved: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   restrictToMyDrive: bool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  var query_593985 = newJObject()
  add(query_593985, "driveId", newJString(driveId))
  add(query_593985, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_593985, "fields", newJString(fields))
  add(query_593985, "pageToken", newJString(pageToken))
  add(query_593985, "quotaUser", newJString(quotaUser))
  add(query_593985, "alt", newJString(alt))
  add(query_593985, "oauth_token", newJString(oauthToken))
  add(query_593985, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_593985, "userIp", newJString(userIp))
  add(query_593985, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_593985, "teamDriveId", newJString(teamDriveId))
  add(query_593985, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_593985, "key", newJString(key))
  add(query_593985, "spaces", newJString(spaces))
  add(query_593985, "pageSize", newJInt(pageSize))
  add(query_593985, "includeRemoved", newJBool(includeRemoved))
  add(query_593985, "prettyPrint", newJBool(prettyPrint))
  add(query_593985, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_593985, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_593984.call(nil, query_593985, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_593960(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_593961, base: "/drive/v3",
    url: url_DriveChangesList_593962, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_593986 = ref object of OpenApiRestCall_593424
proc url_DriveChangesGetStartPageToken_593988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_593987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the starting pageToken for listing future changes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593989 = query.getOrDefault("driveId")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "driveId", valid_593989
  var valid_593990 = query.getOrDefault("supportsAllDrives")
  valid_593990 = validateParameter(valid_593990, JBool, required = false,
                                 default = newJBool(false))
  if valid_593990 != nil:
    section.add "supportsAllDrives", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("userIp")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "userIp", valid_593995
  var valid_593996 = query.getOrDefault("teamDriveId")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "teamDriveId", valid_593996
  var valid_593997 = query.getOrDefault("supportsTeamDrives")
  valid_593997 = validateParameter(valid_593997, JBool, required = false,
                                 default = newJBool(false))
  if valid_593997 != nil:
    section.add "supportsTeamDrives", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("prettyPrint")
  valid_593999 = validateParameter(valid_593999, JBool, required = false,
                                 default = newJBool(true))
  if valid_593999 != nil:
    section.add "prettyPrint", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_DriveChangesGetStartPageToken_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_DriveChangesGetStartPageToken_593986;
          driveId: string = ""; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; teamDriveId: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveChangesGetStartPageToken
  ## Gets the starting pageToken for listing future changes.
  ##   driveId: string
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594002 = newJObject()
  add(query_594002, "driveId", newJString(driveId))
  add(query_594002, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "userIp", newJString(userIp))
  add(query_594002, "teamDriveId", newJString(teamDriveId))
  add(query_594002, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594002, "key", newJString(key))
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(nil, query_594002, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_593986(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_593987, base: "/drive/v3",
    url: url_DriveChangesGetStartPageToken_593988, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_594003 = ref object of OpenApiRestCall_593424
proc url_DriveChangesWatch_594005(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_594004(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Subscribes to changes for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of changes to return per page.
  ##   includeRemoved: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   restrictToMyDrive: JBool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  section = newJObject()
  var valid_594006 = query.getOrDefault("driveId")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "driveId", valid_594006
  var valid_594007 = query.getOrDefault("supportsAllDrives")
  valid_594007 = validateParameter(valid_594007, JBool, required = false,
                                 default = newJBool(false))
  if valid_594007 != nil:
    section.add "supportsAllDrives", valid_594007
  var valid_594008 = query.getOrDefault("fields")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "fields", valid_594008
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_594009 = query.getOrDefault("pageToken")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "pageToken", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("includeItemsFromAllDrives")
  valid_594013 = validateParameter(valid_594013, JBool, required = false,
                                 default = newJBool(false))
  if valid_594013 != nil:
    section.add "includeItemsFromAllDrives", valid_594013
  var valid_594014 = query.getOrDefault("userIp")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "userIp", valid_594014
  var valid_594015 = query.getOrDefault("includeTeamDriveItems")
  valid_594015 = validateParameter(valid_594015, JBool, required = false,
                                 default = newJBool(false))
  if valid_594015 != nil:
    section.add "includeTeamDriveItems", valid_594015
  var valid_594016 = query.getOrDefault("teamDriveId")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "teamDriveId", valid_594016
  var valid_594017 = query.getOrDefault("supportsTeamDrives")
  valid_594017 = validateParameter(valid_594017, JBool, required = false,
                                 default = newJBool(false))
  if valid_594017 != nil:
    section.add "supportsTeamDrives", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("spaces")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("drive"))
  if valid_594019 != nil:
    section.add "spaces", valid_594019
  var valid_594020 = query.getOrDefault("pageSize")
  valid_594020 = validateParameter(valid_594020, JInt, required = false,
                                 default = newJInt(100))
  if valid_594020 != nil:
    section.add "pageSize", valid_594020
  var valid_594021 = query.getOrDefault("includeRemoved")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "includeRemoved", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
  var valid_594023 = query.getOrDefault("restrictToMyDrive")
  valid_594023 = validateParameter(valid_594023, JBool, required = false,
                                 default = newJBool(false))
  if valid_594023 != nil:
    section.add "restrictToMyDrive", valid_594023
  var valid_594024 = query.getOrDefault("includeCorpusRemovals")
  valid_594024 = validateParameter(valid_594024, JBool, required = false,
                                 default = newJBool(false))
  if valid_594024 != nil:
    section.add "includeCorpusRemovals", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_DriveChangesWatch_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes for a user.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_DriveChangesWatch_594003; pageToken: string;
          driveId: string = ""; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          supportsTeamDrives: bool = false; key: string = ""; spaces: string = "drive";
          pageSize: int = 100; includeRemoved: bool = true; resource: JsonNode = nil;
          prettyPrint: bool = true; restrictToMyDrive: bool = false;
          includeCorpusRemovals: bool = false): Recallable =
  ## driveChangesWatch
  ## Subscribes to changes for a user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of changes to return per page.
  ##   includeRemoved: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   restrictToMyDrive: bool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "driveId", newJString(driveId))
  add(query_594028, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594028, "fields", newJString(fields))
  add(query_594028, "pageToken", newJString(pageToken))
  add(query_594028, "quotaUser", newJString(quotaUser))
  add(query_594028, "alt", newJString(alt))
  add(query_594028, "oauth_token", newJString(oauthToken))
  add(query_594028, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_594028, "userIp", newJString(userIp))
  add(query_594028, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_594028, "teamDriveId", newJString(teamDriveId))
  add(query_594028, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594028, "key", newJString(key))
  add(query_594028, "spaces", newJString(spaces))
  add(query_594028, "pageSize", newJInt(pageSize))
  add(query_594028, "includeRemoved", newJBool(includeRemoved))
  if resource != nil:
    body_594029 = resource
  add(query_594028, "prettyPrint", newJBool(prettyPrint))
  add(query_594028, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_594028, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_594027.call(nil, query_594028, nil, nil, body_594029)

var driveChangesWatch* = Call_DriveChangesWatch_594003(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_594004, base: "/drive/v3",
    url: url_DriveChangesWatch_594005, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_594030 = ref object of OpenApiRestCall_593424
proc url_DriveChannelsStop_594032(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_594031(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("quotaUser")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "quotaUser", valid_594034
  var valid_594035 = query.getOrDefault("alt")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("json"))
  if valid_594035 != nil:
    section.add "alt", valid_594035
  var valid_594036 = query.getOrDefault("oauth_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "oauth_token", valid_594036
  var valid_594037 = query.getOrDefault("userIp")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "userIp", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("prettyPrint")
  valid_594039 = validateParameter(valid_594039, JBool, required = false,
                                 default = newJBool(true))
  if valid_594039 != nil:
    section.add "prettyPrint", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_DriveChannelsStop_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_DriveChannelsStop_594030; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveChannelsStop
  ## Stop watching resources through this channel
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(query_594043, "fields", newJString(fields))
  add(query_594043, "quotaUser", newJString(quotaUser))
  add(query_594043, "alt", newJString(alt))
  add(query_594043, "oauth_token", newJString(oauthToken))
  add(query_594043, "userIp", newJString(userIp))
  add(query_594043, "key", newJString(key))
  if resource != nil:
    body_594044 = resource
  add(query_594043, "prettyPrint", newJBool(prettyPrint))
  result = call_594042.call(nil, query_594043, nil, nil, body_594044)

var driveChannelsStop* = Call_DriveChannelsStop_594030(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_594031, base: "/drive/v3",
    url: url_DriveChannelsStop_594032, schemes: {Scheme.Https})
type
  Call_DriveDrivesCreate_594062 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesCreate_594064(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveDrivesCreate_594063(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594065 = query.getOrDefault("fields")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "fields", valid_594065
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_594066 = query.getOrDefault("requestId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "requestId", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("userIp")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "userIp", valid_594070
  var valid_594071 = query.getOrDefault("key")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "key", valid_594071
  var valid_594072 = query.getOrDefault("prettyPrint")
  valid_594072 = validateParameter(valid_594072, JBool, required = false,
                                 default = newJBool(true))
  if valid_594072 != nil:
    section.add "prettyPrint", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_DriveDrivesCreate_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_DriveDrivesCreate_594062; requestId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveDrivesCreate
  ## Creates a new shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(query_594076, "fields", newJString(fields))
  add(query_594076, "requestId", newJString(requestId))
  add(query_594076, "quotaUser", newJString(quotaUser))
  add(query_594076, "alt", newJString(alt))
  add(query_594076, "oauth_token", newJString(oauthToken))
  add(query_594076, "userIp", newJString(userIp))
  add(query_594076, "key", newJString(key))
  if body != nil:
    body_594077 = body
  add(query_594076, "prettyPrint", newJBool(prettyPrint))
  result = call_594075.call(nil, query_594076, nil, nil, body_594077)

var driveDrivesCreate* = Call_DriveDrivesCreate_594062(name: "driveDrivesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesCreate_594063, base: "/drive/v3",
    url: url_DriveDrivesCreate_594064, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_594045 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesList_594047(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveDrivesList_594046(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the user's shared drives.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for shared drives.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   q: JString
  ##    : Query string for searching shared drives.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   pageSize: JInt
  ##           : Maximum number of shared drives to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594048 = query.getOrDefault("fields")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "fields", valid_594048
  var valid_594049 = query.getOrDefault("pageToken")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "pageToken", valid_594049
  var valid_594050 = query.getOrDefault("quotaUser")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "quotaUser", valid_594050
  var valid_594051 = query.getOrDefault("alt")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("json"))
  if valid_594051 != nil:
    section.add "alt", valid_594051
  var valid_594052 = query.getOrDefault("oauth_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "oauth_token", valid_594052
  var valid_594053 = query.getOrDefault("userIp")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "userIp", valid_594053
  var valid_594054 = query.getOrDefault("q")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "q", valid_594054
  var valid_594055 = query.getOrDefault("key")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "key", valid_594055
  var valid_594056 = query.getOrDefault("useDomainAdminAccess")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(false))
  if valid_594056 != nil:
    section.add "useDomainAdminAccess", valid_594056
  var valid_594057 = query.getOrDefault("pageSize")
  valid_594057 = validateParameter(valid_594057, JInt, required = false,
                                 default = newJInt(10))
  if valid_594057 != nil:
    section.add "pageSize", valid_594057
  var valid_594058 = query.getOrDefault("prettyPrint")
  valid_594058 = validateParameter(valid_594058, JBool, required = false,
                                 default = newJBool(true))
  if valid_594058 != nil:
    section.add "prettyPrint", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_DriveDrivesList_594045; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_DriveDrivesList_594045; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; q: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; pageSize: int = 10;
          prettyPrint: bool = true): Recallable =
  ## driveDrivesList
  ## Lists the user's shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for shared drives.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   q: string
  ##    : Query string for searching shared drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   pageSize: int
  ##           : Maximum number of shared drives to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594061 = newJObject()
  add(query_594061, "fields", newJString(fields))
  add(query_594061, "pageToken", newJString(pageToken))
  add(query_594061, "quotaUser", newJString(quotaUser))
  add(query_594061, "alt", newJString(alt))
  add(query_594061, "oauth_token", newJString(oauthToken))
  add(query_594061, "userIp", newJString(userIp))
  add(query_594061, "q", newJString(q))
  add(query_594061, "key", newJString(key))
  add(query_594061, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594061, "pageSize", newJInt(pageSize))
  add(query_594061, "prettyPrint", newJBool(prettyPrint))
  result = call_594060.call(nil, query_594061, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_594045(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_594046, base: "/drive/v3",
    url: url_DriveDrivesList_594047, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_594078 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesGet_594080(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesGet_594079(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a shared drive's metadata by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_594095 = path.getOrDefault("driveId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "driveId", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594096 = query.getOrDefault("fields")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "fields", valid_594096
  var valid_594097 = query.getOrDefault("quotaUser")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "quotaUser", valid_594097
  var valid_594098 = query.getOrDefault("alt")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = newJString("json"))
  if valid_594098 != nil:
    section.add "alt", valid_594098
  var valid_594099 = query.getOrDefault("oauth_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "oauth_token", valid_594099
  var valid_594100 = query.getOrDefault("userIp")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "userIp", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("useDomainAdminAccess")
  valid_594102 = validateParameter(valid_594102, JBool, required = false,
                                 default = newJBool(false))
  if valid_594102 != nil:
    section.add "useDomainAdminAccess", valid_594102
  var valid_594103 = query.getOrDefault("prettyPrint")
  valid_594103 = validateParameter(valid_594103, JBool, required = false,
                                 default = newJBool(true))
  if valid_594103 != nil:
    section.add "prettyPrint", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_DriveDrivesGet_594078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_DriveDrivesGet_594078; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## driveDrivesGet
  ## Gets a shared drive's metadata by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(query_594107, "fields", newJString(fields))
  add(path_594106, "driveId", newJString(driveId))
  add(query_594107, "quotaUser", newJString(quotaUser))
  add(query_594107, "alt", newJString(alt))
  add(query_594107, "oauth_token", newJString(oauthToken))
  add(query_594107, "userIp", newJString(userIp))
  add(query_594107, "key", newJString(key))
  add(query_594107, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594107, "prettyPrint", newJBool(prettyPrint))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_594078(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_594079,
    base: "/drive/v3", url: url_DriveDrivesGet_594080, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_594123 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesUpdate_594125(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_594124(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the metadate for a shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_594126 = path.getOrDefault("driveId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "driveId", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594127 = query.getOrDefault("fields")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "fields", valid_594127
  var valid_594128 = query.getOrDefault("quotaUser")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "quotaUser", valid_594128
  var valid_594129 = query.getOrDefault("alt")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("json"))
  if valid_594129 != nil:
    section.add "alt", valid_594129
  var valid_594130 = query.getOrDefault("oauth_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "oauth_token", valid_594130
  var valid_594131 = query.getOrDefault("userIp")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "userIp", valid_594131
  var valid_594132 = query.getOrDefault("key")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "key", valid_594132
  var valid_594133 = query.getOrDefault("useDomainAdminAccess")
  valid_594133 = validateParameter(valid_594133, JBool, required = false,
                                 default = newJBool(false))
  if valid_594133 != nil:
    section.add "useDomainAdminAccess", valid_594133
  var valid_594134 = query.getOrDefault("prettyPrint")
  valid_594134 = validateParameter(valid_594134, JBool, required = false,
                                 default = newJBool(true))
  if valid_594134 != nil:
    section.add "prettyPrint", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_DriveDrivesUpdate_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadate for a shared drive.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_DriveDrivesUpdate_594123; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveDrivesUpdate
  ## Updates the metadate for a shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  var body_594140 = newJObject()
  add(query_594139, "fields", newJString(fields))
  add(path_594138, "driveId", newJString(driveId))
  add(query_594139, "quotaUser", newJString(quotaUser))
  add(query_594139, "alt", newJString(alt))
  add(query_594139, "oauth_token", newJString(oauthToken))
  add(query_594139, "userIp", newJString(userIp))
  add(query_594139, "key", newJString(key))
  add(query_594139, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_594140 = body
  add(query_594139, "prettyPrint", newJBool(prettyPrint))
  result = call_594137.call(path_594138, query_594139, nil, nil, body_594140)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_594123(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_594124,
    base: "/drive/v3", url: url_DriveDrivesUpdate_594125, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_594108 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesDelete_594110(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesDelete_594109(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_594111 = path.getOrDefault("driveId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "driveId", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594112 = query.getOrDefault("fields")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fields", valid_594112
  var valid_594113 = query.getOrDefault("quotaUser")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "quotaUser", valid_594113
  var valid_594114 = query.getOrDefault("alt")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("json"))
  if valid_594114 != nil:
    section.add "alt", valid_594114
  var valid_594115 = query.getOrDefault("oauth_token")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "oauth_token", valid_594115
  var valid_594116 = query.getOrDefault("userIp")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "userIp", valid_594116
  var valid_594117 = query.getOrDefault("key")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "key", valid_594117
  var valid_594118 = query.getOrDefault("prettyPrint")
  valid_594118 = validateParameter(valid_594118, JBool, required = false,
                                 default = newJBool(true))
  if valid_594118 != nil:
    section.add "prettyPrint", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_DriveDrivesDelete_594108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_DriveDrivesDelete_594108; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesDelete
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(query_594122, "fields", newJString(fields))
  add(path_594121, "driveId", newJString(driveId))
  add(query_594122, "quotaUser", newJString(quotaUser))
  add(query_594122, "alt", newJString(alt))
  add(query_594122, "oauth_token", newJString(oauthToken))
  add(query_594122, "userIp", newJString(userIp))
  add(query_594122, "key", newJString(key))
  add(query_594122, "prettyPrint", newJBool(prettyPrint))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_594108(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_594109,
    base: "/drive/v3", url: url_DriveDrivesDelete_594110, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_594141 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesHide_594143(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId"),
               (kind: ConstantSegment, value: "/hide")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesHide_594142(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Hides a shared drive from the default view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_594144 = path.getOrDefault("driveId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "driveId", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594145 = query.getOrDefault("fields")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "fields", valid_594145
  var valid_594146 = query.getOrDefault("quotaUser")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "quotaUser", valid_594146
  var valid_594147 = query.getOrDefault("alt")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = newJString("json"))
  if valid_594147 != nil:
    section.add "alt", valid_594147
  var valid_594148 = query.getOrDefault("oauth_token")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "oauth_token", valid_594148
  var valid_594149 = query.getOrDefault("userIp")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "userIp", valid_594149
  var valid_594150 = query.getOrDefault("key")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "key", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_DriveDrivesHide_594141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_DriveDrivesHide_594141; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesHide
  ## Hides a shared drive from the default view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(query_594155, "fields", newJString(fields))
  add(path_594154, "driveId", newJString(driveId))
  add(query_594155, "quotaUser", newJString(quotaUser))
  add(query_594155, "alt", newJString(alt))
  add(query_594155, "oauth_token", newJString(oauthToken))
  add(query_594155, "userIp", newJString(userIp))
  add(query_594155, "key", newJString(key))
  add(query_594155, "prettyPrint", newJBool(prettyPrint))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_594141(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_594142,
    base: "/drive/v3", url: url_DriveDrivesHide_594143, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_594156 = ref object of OpenApiRestCall_593424
proc url_DriveDrivesUnhide_594158(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId"),
               (kind: ConstantSegment, value: "/unhide")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUnhide_594157(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Restores a shared drive to the default view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   driveId: JString (required)
  ##          : The ID of the shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `driveId` field"
  var valid_594159 = path.getOrDefault("driveId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "driveId", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594160 = query.getOrDefault("fields")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "fields", valid_594160
  var valid_594161 = query.getOrDefault("quotaUser")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "quotaUser", valid_594161
  var valid_594162 = query.getOrDefault("alt")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = newJString("json"))
  if valid_594162 != nil:
    section.add "alt", valid_594162
  var valid_594163 = query.getOrDefault("oauth_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "oauth_token", valid_594163
  var valid_594164 = query.getOrDefault("userIp")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "userIp", valid_594164
  var valid_594165 = query.getOrDefault("key")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "key", valid_594165
  var valid_594166 = query.getOrDefault("prettyPrint")
  valid_594166 = validateParameter(valid_594166, JBool, required = false,
                                 default = newJBool(true))
  if valid_594166 != nil:
    section.add "prettyPrint", valid_594166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594167: Call_DriveDrivesUnhide_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_DriveDrivesUnhide_594156; driveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveDrivesUnhide
  ## Restores a shared drive to the default view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  add(query_594170, "fields", newJString(fields))
  add(path_594169, "driveId", newJString(driveId))
  add(query_594170, "quotaUser", newJString(quotaUser))
  add(query_594170, "alt", newJString(alt))
  add(query_594170, "oauth_token", newJString(oauthToken))
  add(query_594170, "userIp", newJString(userIp))
  add(query_594170, "key", newJString(key))
  add(query_594170, "prettyPrint", newJBool(prettyPrint))
  result = call_594168.call(path_594169, query_594170, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_594156(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_594157,
    base: "/drive/v3", url: url_DriveDrivesUnhide_594158, schemes: {Scheme.Https})
type
  Call_DriveFilesCreate_594197 = ref object of OpenApiRestCall_593424
proc url_DriveFilesCreate_594199(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesCreate_594198(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ignoreDefaultVisibility: JBool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  section = newJObject()
  var valid_594200 = query.getOrDefault("supportsAllDrives")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(false))
  if valid_594200 != nil:
    section.add "supportsAllDrives", valid_594200
  var valid_594201 = query.getOrDefault("fields")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "fields", valid_594201
  var valid_594202 = query.getOrDefault("quotaUser")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "quotaUser", valid_594202
  var valid_594203 = query.getOrDefault("alt")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = newJString("json"))
  if valid_594203 != nil:
    section.add "alt", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("userIp")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "userIp", valid_594205
  var valid_594206 = query.getOrDefault("keepRevisionForever")
  valid_594206 = validateParameter(valid_594206, JBool, required = false,
                                 default = newJBool(false))
  if valid_594206 != nil:
    section.add "keepRevisionForever", valid_594206
  var valid_594207 = query.getOrDefault("supportsTeamDrives")
  valid_594207 = validateParameter(valid_594207, JBool, required = false,
                                 default = newJBool(false))
  if valid_594207 != nil:
    section.add "supportsTeamDrives", valid_594207
  var valid_594208 = query.getOrDefault("key")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "key", valid_594208
  var valid_594209 = query.getOrDefault("useContentAsIndexableText")
  valid_594209 = validateParameter(valid_594209, JBool, required = false,
                                 default = newJBool(false))
  if valid_594209 != nil:
    section.add "useContentAsIndexableText", valid_594209
  var valid_594210 = query.getOrDefault("prettyPrint")
  valid_594210 = validateParameter(valid_594210, JBool, required = false,
                                 default = newJBool(true))
  if valid_594210 != nil:
    section.add "prettyPrint", valid_594210
  var valid_594211 = query.getOrDefault("ignoreDefaultVisibility")
  valid_594211 = validateParameter(valid_594211, JBool, required = false,
                                 default = newJBool(false))
  if valid_594211 != nil:
    section.add "ignoreDefaultVisibility", valid_594211
  var valid_594212 = query.getOrDefault("ocrLanguage")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "ocrLanguage", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594214: Call_DriveFilesCreate_594197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new file.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_DriveFilesCreate_594197;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          keepRevisionForever: bool = false; supportsTeamDrives: bool = false;
          key: string = ""; useContentAsIndexableText: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true;
          ignoreDefaultVisibility: bool = false; ocrLanguage: string = ""): Recallable =
  ## driveFilesCreate
  ## Creates a new file.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ignoreDefaultVisibility: bool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  var query_594216 = newJObject()
  var body_594217 = newJObject()
  add(query_594216, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594216, "fields", newJString(fields))
  add(query_594216, "quotaUser", newJString(quotaUser))
  add(query_594216, "alt", newJString(alt))
  add(query_594216, "oauth_token", newJString(oauthToken))
  add(query_594216, "userIp", newJString(userIp))
  add(query_594216, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_594216, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594216, "key", newJString(key))
  add(query_594216, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_594217 = body
  add(query_594216, "prettyPrint", newJBool(prettyPrint))
  add(query_594216, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_594216, "ocrLanguage", newJString(ocrLanguage))
  result = call_594215.call(nil, query_594216, nil, nil, body_594217)

var driveFilesCreate* = Call_DriveFilesCreate_594197(name: "driveFilesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesCreate_594198, base: "/drive/v3",
    url: url_DriveFilesCreate_594199, schemes: {Scheme.Https})
type
  Call_DriveFilesList_594171 = ref object of OpenApiRestCall_593424
proc url_DriveFilesList_594173(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesList_594172(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists or searches files.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   driveId: JString
  ##          : ID of the shared drive to search.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  ##   corpus: JString
  ##         : The source of files to list. Deprecated: use 'corpora' instead.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedTime desc,name. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: JString
  ##    : A query for filtering the file results. See the "Search for Files" guide for supported syntax.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   corpora: JString
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'user', 'domain', 'drive' and 'allDrives'. Prefer 'user' or 'drive' to 'allDrives' for efficiency.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594174 = query.getOrDefault("driveId")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "driveId", valid_594174
  var valid_594175 = query.getOrDefault("supportsAllDrives")
  valid_594175 = validateParameter(valid_594175, JBool, required = false,
                                 default = newJBool(false))
  if valid_594175 != nil:
    section.add "supportsAllDrives", valid_594175
  var valid_594176 = query.getOrDefault("fields")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "fields", valid_594176
  var valid_594177 = query.getOrDefault("pageToken")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "pageToken", valid_594177
  var valid_594178 = query.getOrDefault("quotaUser")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "quotaUser", valid_594178
  var valid_594179 = query.getOrDefault("alt")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("json"))
  if valid_594179 != nil:
    section.add "alt", valid_594179
  var valid_594180 = query.getOrDefault("oauth_token")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "oauth_token", valid_594180
  var valid_594181 = query.getOrDefault("includeItemsFromAllDrives")
  valid_594181 = validateParameter(valid_594181, JBool, required = false,
                                 default = newJBool(false))
  if valid_594181 != nil:
    section.add "includeItemsFromAllDrives", valid_594181
  var valid_594182 = query.getOrDefault("userIp")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "userIp", valid_594182
  var valid_594183 = query.getOrDefault("includeTeamDriveItems")
  valid_594183 = validateParameter(valid_594183, JBool, required = false,
                                 default = newJBool(false))
  if valid_594183 != nil:
    section.add "includeTeamDriveItems", valid_594183
  var valid_594184 = query.getOrDefault("teamDriveId")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "teamDriveId", valid_594184
  var valid_594185 = query.getOrDefault("corpus")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = newJString("domain"))
  if valid_594185 != nil:
    section.add "corpus", valid_594185
  var valid_594186 = query.getOrDefault("orderBy")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "orderBy", valid_594186
  var valid_594187 = query.getOrDefault("q")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "q", valid_594187
  var valid_594188 = query.getOrDefault("supportsTeamDrives")
  valid_594188 = validateParameter(valid_594188, JBool, required = false,
                                 default = newJBool(false))
  if valid_594188 != nil:
    section.add "supportsTeamDrives", valid_594188
  var valid_594189 = query.getOrDefault("key")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "key", valid_594189
  var valid_594190 = query.getOrDefault("spaces")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = newJString("drive"))
  if valid_594190 != nil:
    section.add "spaces", valid_594190
  var valid_594191 = query.getOrDefault("pageSize")
  valid_594191 = validateParameter(valid_594191, JInt, required = false,
                                 default = newJInt(100))
  if valid_594191 != nil:
    section.add "pageSize", valid_594191
  var valid_594192 = query.getOrDefault("corpora")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "corpora", valid_594192
  var valid_594193 = query.getOrDefault("prettyPrint")
  valid_594193 = validateParameter(valid_594193, JBool, required = false,
                                 default = newJBool(true))
  if valid_594193 != nil:
    section.add "prettyPrint", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_DriveFilesList_594171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists or searches files.
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_DriveFilesList_594171; driveId: string = "";
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          includeItemsFromAllDrives: bool = false; userIp: string = "";
          includeTeamDriveItems: bool = false; teamDriveId: string = "";
          corpus: string = "domain"; orderBy: string = ""; q: string = "";
          supportsTeamDrives: bool = false; key: string = ""; spaces: string = "drive";
          pageSize: int = 100; corpora: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesList
  ## Lists or searches files.
  ##   driveId: string
  ##          : ID of the shared drive to search.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  ##   corpus: string
  ##         : The source of files to list. Deprecated: use 'corpora' instead.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedTime desc,name. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   q: string
  ##    : A query for filtering the file results. See the "Search for Files" guide for supported syntax.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   corpora: string
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'user', 'domain', 'drive' and 'allDrives'. Prefer 'user' or 'drive' to 'allDrives' for efficiency.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594196 = newJObject()
  add(query_594196, "driveId", newJString(driveId))
  add(query_594196, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594196, "fields", newJString(fields))
  add(query_594196, "pageToken", newJString(pageToken))
  add(query_594196, "quotaUser", newJString(quotaUser))
  add(query_594196, "alt", newJString(alt))
  add(query_594196, "oauth_token", newJString(oauthToken))
  add(query_594196, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_594196, "userIp", newJString(userIp))
  add(query_594196, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_594196, "teamDriveId", newJString(teamDriveId))
  add(query_594196, "corpus", newJString(corpus))
  add(query_594196, "orderBy", newJString(orderBy))
  add(query_594196, "q", newJString(q))
  add(query_594196, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594196, "key", newJString(key))
  add(query_594196, "spaces", newJString(spaces))
  add(query_594196, "pageSize", newJInt(pageSize))
  add(query_594196, "corpora", newJString(corpora))
  add(query_594196, "prettyPrint", newJBool(prettyPrint))
  result = call_594195.call(nil, query_594196, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_594171(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_594172, base: "/drive/v3",
    url: url_DriveFilesList_594173, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_594218 = ref object of OpenApiRestCall_593424
proc url_DriveFilesGenerateIds_594220(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_594219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   space: JString
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   count: JInt
  ##        : The number of IDs to return.
  section = newJObject()
  var valid_594221 = query.getOrDefault("fields")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "fields", valid_594221
  var valid_594222 = query.getOrDefault("quotaUser")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "quotaUser", valid_594222
  var valid_594223 = query.getOrDefault("alt")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = newJString("json"))
  if valid_594223 != nil:
    section.add "alt", valid_594223
  var valid_594224 = query.getOrDefault("oauth_token")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "oauth_token", valid_594224
  var valid_594225 = query.getOrDefault("space")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = newJString("drive"))
  if valid_594225 != nil:
    section.add "space", valid_594225
  var valid_594226 = query.getOrDefault("userIp")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "userIp", valid_594226
  var valid_594227 = query.getOrDefault("key")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "key", valid_594227
  var valid_594228 = query.getOrDefault("prettyPrint")
  valid_594228 = validateParameter(valid_594228, JBool, required = false,
                                 default = newJBool(true))
  if valid_594228 != nil:
    section.add "prettyPrint", valid_594228
  var valid_594229 = query.getOrDefault("count")
  valid_594229 = validateParameter(valid_594229, JInt, required = false,
                                 default = newJInt(10))
  if valid_594229 != nil:
    section.add "count", valid_594229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594230: Call_DriveFilesGenerateIds_594218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_DriveFilesGenerateIds_594218; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          space: string = "drive"; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; count: int = 10): Recallable =
  ## driveFilesGenerateIds
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   space: string
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   count: int
  ##        : The number of IDs to return.
  var query_594232 = newJObject()
  add(query_594232, "fields", newJString(fields))
  add(query_594232, "quotaUser", newJString(quotaUser))
  add(query_594232, "alt", newJString(alt))
  add(query_594232, "oauth_token", newJString(oauthToken))
  add(query_594232, "space", newJString(space))
  add(query_594232, "userIp", newJString(userIp))
  add(query_594232, "key", newJString(key))
  add(query_594232, "prettyPrint", newJBool(prettyPrint))
  add(query_594232, "count", newJInt(count))
  result = call_594231.call(nil, query_594232, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_594218(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_594219, base: "/drive/v3",
    url: url_DriveFilesGenerateIds_594220, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_594233 = ref object of OpenApiRestCall_593424
proc url_DriveFilesEmptyTrash_594235(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_594234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes all of the user's trashed files.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594236 = query.getOrDefault("fields")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "fields", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("oauth_token")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "oauth_token", valid_594239
  var valid_594240 = query.getOrDefault("userIp")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "userIp", valid_594240
  var valid_594241 = query.getOrDefault("key")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "key", valid_594241
  var valid_594242 = query.getOrDefault("prettyPrint")
  valid_594242 = validateParameter(valid_594242, JBool, required = false,
                                 default = newJBool(true))
  if valid_594242 != nil:
    section.add "prettyPrint", valid_594242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594243: Call_DriveFilesEmptyTrash_594233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_DriveFilesEmptyTrash_594233; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesEmptyTrash
  ## Permanently deletes all of the user's trashed files.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594245 = newJObject()
  add(query_594245, "fields", newJString(fields))
  add(query_594245, "quotaUser", newJString(quotaUser))
  add(query_594245, "alt", newJString(alt))
  add(query_594245, "oauth_token", newJString(oauthToken))
  add(query_594245, "userIp", newJString(userIp))
  add(query_594245, "key", newJString(key))
  add(query_594245, "prettyPrint", newJBool(prettyPrint))
  result = call_594244.call(nil, query_594245, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_594233(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_594234, base: "/drive/v3",
    url: url_DriveFilesEmptyTrash_594235, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_594246 = ref object of OpenApiRestCall_593424
proc url_DriveFilesGet_594248(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesGet_594247(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a file's metadata or content by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594249 = path.getOrDefault("fileId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "fileId", valid_594249
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594250 = query.getOrDefault("supportsAllDrives")
  valid_594250 = validateParameter(valid_594250, JBool, required = false,
                                 default = newJBool(false))
  if valid_594250 != nil:
    section.add "supportsAllDrives", valid_594250
  var valid_594251 = query.getOrDefault("fields")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "fields", valid_594251
  var valid_594252 = query.getOrDefault("quotaUser")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "quotaUser", valid_594252
  var valid_594253 = query.getOrDefault("alt")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = newJString("json"))
  if valid_594253 != nil:
    section.add "alt", valid_594253
  var valid_594254 = query.getOrDefault("acknowledgeAbuse")
  valid_594254 = validateParameter(valid_594254, JBool, required = false,
                                 default = newJBool(false))
  if valid_594254 != nil:
    section.add "acknowledgeAbuse", valid_594254
  var valid_594255 = query.getOrDefault("oauth_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "oauth_token", valid_594255
  var valid_594256 = query.getOrDefault("userIp")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "userIp", valid_594256
  var valid_594257 = query.getOrDefault("supportsTeamDrives")
  valid_594257 = validateParameter(valid_594257, JBool, required = false,
                                 default = newJBool(false))
  if valid_594257 != nil:
    section.add "supportsTeamDrives", valid_594257
  var valid_594258 = query.getOrDefault("key")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "key", valid_594258
  var valid_594259 = query.getOrDefault("prettyPrint")
  valid_594259 = validateParameter(valid_594259, JBool, required = false,
                                 default = newJBool(true))
  if valid_594259 != nil:
    section.add "prettyPrint", valid_594259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594260: Call_DriveFilesGet_594246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata or content by ID.
  ## 
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_DriveFilesGet_594246; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acknowledgeAbuse: bool = false; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveFilesGet
  ## Gets a file's metadata or content by ID.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  add(query_594263, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594263, "fields", newJString(fields))
  add(query_594263, "quotaUser", newJString(quotaUser))
  add(path_594262, "fileId", newJString(fileId))
  add(query_594263, "alt", newJString(alt))
  add(query_594263, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_594263, "oauth_token", newJString(oauthToken))
  add(query_594263, "userIp", newJString(userIp))
  add(query_594263, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594263, "key", newJString(key))
  add(query_594263, "prettyPrint", newJBool(prettyPrint))
  result = call_594261.call(path_594262, query_594263, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_594246(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_594247, base: "/drive/v3",
    url: url_DriveFilesGet_594248, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_594281 = ref object of OpenApiRestCall_593424
proc url_DriveFilesUpdate_594283(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesUpdate_594282(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594284 = path.getOrDefault("fileId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "fileId", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   addParents: JString
  ##             : A comma-separated list of parent IDs to add.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   removeParents: JString
  ##                : A comma-separated list of parent IDs to remove.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  section = newJObject()
  var valid_594285 = query.getOrDefault("supportsAllDrives")
  valid_594285 = validateParameter(valid_594285, JBool, required = false,
                                 default = newJBool(false))
  if valid_594285 != nil:
    section.add "supportsAllDrives", valid_594285
  var valid_594286 = query.getOrDefault("fields")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "fields", valid_594286
  var valid_594287 = query.getOrDefault("quotaUser")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "quotaUser", valid_594287
  var valid_594288 = query.getOrDefault("alt")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("json"))
  if valid_594288 != nil:
    section.add "alt", valid_594288
  var valid_594289 = query.getOrDefault("oauth_token")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "oauth_token", valid_594289
  var valid_594290 = query.getOrDefault("userIp")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "userIp", valid_594290
  var valid_594291 = query.getOrDefault("keepRevisionForever")
  valid_594291 = validateParameter(valid_594291, JBool, required = false,
                                 default = newJBool(false))
  if valid_594291 != nil:
    section.add "keepRevisionForever", valid_594291
  var valid_594292 = query.getOrDefault("supportsTeamDrives")
  valid_594292 = validateParameter(valid_594292, JBool, required = false,
                                 default = newJBool(false))
  if valid_594292 != nil:
    section.add "supportsTeamDrives", valid_594292
  var valid_594293 = query.getOrDefault("key")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "key", valid_594293
  var valid_594294 = query.getOrDefault("useContentAsIndexableText")
  valid_594294 = validateParameter(valid_594294, JBool, required = false,
                                 default = newJBool(false))
  if valid_594294 != nil:
    section.add "useContentAsIndexableText", valid_594294
  var valid_594295 = query.getOrDefault("addParents")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "addParents", valid_594295
  var valid_594296 = query.getOrDefault("prettyPrint")
  valid_594296 = validateParameter(valid_594296, JBool, required = false,
                                 default = newJBool(true))
  if valid_594296 != nil:
    section.add "prettyPrint", valid_594296
  var valid_594297 = query.getOrDefault("removeParents")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "removeParents", valid_594297
  var valid_594298 = query.getOrDefault("ocrLanguage")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "ocrLanguage", valid_594298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594300: Call_DriveFilesUpdate_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  let valid = call_594300.validator(path, query, header, formData, body)
  let scheme = call_594300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594300.url(scheme.get, call_594300.host, call_594300.base,
                         call_594300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594300, url, valid)

proc call*(call_594301: Call_DriveFilesUpdate_594281; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          keepRevisionForever: bool = false; supportsTeamDrives: bool = false;
          key: string = ""; useContentAsIndexableText: bool = false;
          addParents: string = ""; prettyPrint: bool = true; body: JsonNode = nil;
          removeParents: string = ""; ocrLanguage: string = ""): Recallable =
  ## driveFilesUpdate
  ## Updates a file's metadata and/or content with patch semantics.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   addParents: string
  ##             : A comma-separated list of parent IDs to add.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   body: JObject
  ##   removeParents: string
  ##                : A comma-separated list of parent IDs to remove.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  var path_594302 = newJObject()
  var query_594303 = newJObject()
  var body_594304 = newJObject()
  add(query_594303, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594303, "fields", newJString(fields))
  add(query_594303, "quotaUser", newJString(quotaUser))
  add(path_594302, "fileId", newJString(fileId))
  add(query_594303, "alt", newJString(alt))
  add(query_594303, "oauth_token", newJString(oauthToken))
  add(query_594303, "userIp", newJString(userIp))
  add(query_594303, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_594303, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594303, "key", newJString(key))
  add(query_594303, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_594303, "addParents", newJString(addParents))
  add(query_594303, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_594304 = body
  add(query_594303, "removeParents", newJString(removeParents))
  add(query_594303, "ocrLanguage", newJString(ocrLanguage))
  result = call_594301.call(path_594302, query_594303, nil, nil, body_594304)

var driveFilesUpdate* = Call_DriveFilesUpdate_594281(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesUpdate_594282,
    base: "/drive/v3", url: url_DriveFilesUpdate_594283, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_594264 = ref object of OpenApiRestCall_593424
proc url_DriveFilesDelete_594266(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesDelete_594265(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594267 = path.getOrDefault("fileId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "fileId", valid_594267
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594268 = query.getOrDefault("supportsAllDrives")
  valid_594268 = validateParameter(valid_594268, JBool, required = false,
                                 default = newJBool(false))
  if valid_594268 != nil:
    section.add "supportsAllDrives", valid_594268
  var valid_594269 = query.getOrDefault("fields")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "fields", valid_594269
  var valid_594270 = query.getOrDefault("quotaUser")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "quotaUser", valid_594270
  var valid_594271 = query.getOrDefault("alt")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = newJString("json"))
  if valid_594271 != nil:
    section.add "alt", valid_594271
  var valid_594272 = query.getOrDefault("oauth_token")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "oauth_token", valid_594272
  var valid_594273 = query.getOrDefault("userIp")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "userIp", valid_594273
  var valid_594274 = query.getOrDefault("supportsTeamDrives")
  valid_594274 = validateParameter(valid_594274, JBool, required = false,
                                 default = newJBool(false))
  if valid_594274 != nil:
    section.add "supportsTeamDrives", valid_594274
  var valid_594275 = query.getOrDefault("key")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "key", valid_594275
  var valid_594276 = query.getOrDefault("prettyPrint")
  valid_594276 = validateParameter(valid_594276, JBool, required = false,
                                 default = newJBool(true))
  if valid_594276 != nil:
    section.add "prettyPrint", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_DriveFilesDelete_594264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_DriveFilesDelete_594264; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesDelete
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(query_594280, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594280, "fields", newJString(fields))
  add(query_594280, "quotaUser", newJString(quotaUser))
  add(path_594279, "fileId", newJString(fileId))
  add(query_594280, "alt", newJString(alt))
  add(query_594280, "oauth_token", newJString(oauthToken))
  add(query_594280, "userIp", newJString(userIp))
  add(query_594280, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594280, "key", newJString(key))
  add(query_594280, "prettyPrint", newJBool(prettyPrint))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_594264(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_594265,
    base: "/drive/v3", url: url_DriveFilesDelete_594266, schemes: {Scheme.Https})
type
  Call_DriveCommentsCreate_594324 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsCreate_594326(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsCreate_594325(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new comment on a file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594327 = path.getOrDefault("fileId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "fileId", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594328 = query.getOrDefault("fields")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "fields", valid_594328
  var valid_594329 = query.getOrDefault("quotaUser")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "quotaUser", valid_594329
  var valid_594330 = query.getOrDefault("alt")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = newJString("json"))
  if valid_594330 != nil:
    section.add "alt", valid_594330
  var valid_594331 = query.getOrDefault("oauth_token")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "oauth_token", valid_594331
  var valid_594332 = query.getOrDefault("userIp")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "userIp", valid_594332
  var valid_594333 = query.getOrDefault("key")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "key", valid_594333
  var valid_594334 = query.getOrDefault("prettyPrint")
  valid_594334 = validateParameter(valid_594334, JBool, required = false,
                                 default = newJBool(true))
  if valid_594334 != nil:
    section.add "prettyPrint", valid_594334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594336: Call_DriveCommentsCreate_594324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on a file.
  ## 
  let valid = call_594336.validator(path, query, header, formData, body)
  let scheme = call_594336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594336.url(scheme.get, call_594336.host, call_594336.base,
                         call_594336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594336, url, valid)

proc call*(call_594337: Call_DriveCommentsCreate_594324; fileId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveCommentsCreate
  ## Creates a new comment on a file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594338 = newJObject()
  var query_594339 = newJObject()
  var body_594340 = newJObject()
  add(query_594339, "fields", newJString(fields))
  add(query_594339, "quotaUser", newJString(quotaUser))
  add(path_594338, "fileId", newJString(fileId))
  add(query_594339, "alt", newJString(alt))
  add(query_594339, "oauth_token", newJString(oauthToken))
  add(query_594339, "userIp", newJString(userIp))
  add(query_594339, "key", newJString(key))
  if body != nil:
    body_594340 = body
  add(query_594339, "prettyPrint", newJBool(prettyPrint))
  result = call_594337.call(path_594338, query_594339, nil, nil, body_594340)

var driveCommentsCreate* = Call_DriveCommentsCreate_594324(
    name: "driveCommentsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsCreate_594325, base: "/drive/v3",
    url: url_DriveCommentsCreate_594326, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_594305 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsList_594307(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsList_594306(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a file's comments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594308 = path.getOrDefault("fileId")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "fileId", valid_594308
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to include deleted comments. Deleted comments will not include their original content.
  ##   pageSize: JInt
  ##           : The maximum number of comments to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startModifiedTime: JString
  ##                    : The minimum value of 'modifiedTime' for the result comments (RFC 3339 date-time).
  section = newJObject()
  var valid_594309 = query.getOrDefault("fields")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "fields", valid_594309
  var valid_594310 = query.getOrDefault("pageToken")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "pageToken", valid_594310
  var valid_594311 = query.getOrDefault("quotaUser")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "quotaUser", valid_594311
  var valid_594312 = query.getOrDefault("alt")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = newJString("json"))
  if valid_594312 != nil:
    section.add "alt", valid_594312
  var valid_594313 = query.getOrDefault("oauth_token")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "oauth_token", valid_594313
  var valid_594314 = query.getOrDefault("userIp")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "userIp", valid_594314
  var valid_594315 = query.getOrDefault("key")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "key", valid_594315
  var valid_594316 = query.getOrDefault("includeDeleted")
  valid_594316 = validateParameter(valid_594316, JBool, required = false,
                                 default = newJBool(false))
  if valid_594316 != nil:
    section.add "includeDeleted", valid_594316
  var valid_594317 = query.getOrDefault("pageSize")
  valid_594317 = validateParameter(valid_594317, JInt, required = false,
                                 default = newJInt(20))
  if valid_594317 != nil:
    section.add "pageSize", valid_594317
  var valid_594318 = query.getOrDefault("prettyPrint")
  valid_594318 = validateParameter(valid_594318, JBool, required = false,
                                 default = newJBool(true))
  if valid_594318 != nil:
    section.add "prettyPrint", valid_594318
  var valid_594319 = query.getOrDefault("startModifiedTime")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "startModifiedTime", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594320: Call_DriveCommentsList_594305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_DriveCommentsList_594305; fileId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; includeDeleted: bool = false; pageSize: int = 20;
          prettyPrint: bool = true; startModifiedTime: string = ""): Recallable =
  ## driveCommentsList
  ## Lists a file's comments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : Whether to include deleted comments. Deleted comments will not include their original content.
  ##   pageSize: int
  ##           : The maximum number of comments to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startModifiedTime: string
  ##                    : The minimum value of 'modifiedTime' for the result comments (RFC 3339 date-time).
  var path_594322 = newJObject()
  var query_594323 = newJObject()
  add(query_594323, "fields", newJString(fields))
  add(query_594323, "pageToken", newJString(pageToken))
  add(query_594323, "quotaUser", newJString(quotaUser))
  add(path_594322, "fileId", newJString(fileId))
  add(query_594323, "alt", newJString(alt))
  add(query_594323, "oauth_token", newJString(oauthToken))
  add(query_594323, "userIp", newJString(userIp))
  add(query_594323, "key", newJString(key))
  add(query_594323, "includeDeleted", newJBool(includeDeleted))
  add(query_594323, "pageSize", newJInt(pageSize))
  add(query_594323, "prettyPrint", newJBool(prettyPrint))
  add(query_594323, "startModifiedTime", newJString(startModifiedTime))
  result = call_594321.call(path_594322, query_594323, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_594305(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_594306,
    base: "/drive/v3", url: url_DriveCommentsList_594307, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_594341 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsGet_594343(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsGet_594342(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594344 = path.getOrDefault("fileId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "fileId", valid_594344
  var valid_594345 = path.getOrDefault("commentId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "commentId", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to return deleted comments. Deleted comments will not include their original content.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594346 = query.getOrDefault("fields")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "fields", valid_594346
  var valid_594347 = query.getOrDefault("quotaUser")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "quotaUser", valid_594347
  var valid_594348 = query.getOrDefault("alt")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = newJString("json"))
  if valid_594348 != nil:
    section.add "alt", valid_594348
  var valid_594349 = query.getOrDefault("oauth_token")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "oauth_token", valid_594349
  var valid_594350 = query.getOrDefault("userIp")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "userIp", valid_594350
  var valid_594351 = query.getOrDefault("key")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "key", valid_594351
  var valid_594352 = query.getOrDefault("includeDeleted")
  valid_594352 = validateParameter(valid_594352, JBool, required = false,
                                 default = newJBool(false))
  if valid_594352 != nil:
    section.add "includeDeleted", valid_594352
  var valid_594353 = query.getOrDefault("prettyPrint")
  valid_594353 = validateParameter(valid_594353, JBool, required = false,
                                 default = newJBool(true))
  if valid_594353 != nil:
    section.add "prettyPrint", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_DriveCommentsGet_594341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_DriveCommentsGet_594341; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveCommentsGet
  ## Gets a comment by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to return deleted comments. Deleted comments will not include their original content.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(query_594357, "fields", newJString(fields))
  add(query_594357, "quotaUser", newJString(quotaUser))
  add(path_594356, "fileId", newJString(fileId))
  add(query_594357, "alt", newJString(alt))
  add(query_594357, "oauth_token", newJString(oauthToken))
  add(query_594357, "userIp", newJString(userIp))
  add(query_594357, "key", newJString(key))
  add(path_594356, "commentId", newJString(commentId))
  add(query_594357, "includeDeleted", newJBool(includeDeleted))
  add(query_594357, "prettyPrint", newJBool(prettyPrint))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_594341(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_594342, base: "/drive/v3",
    url: url_DriveCommentsGet_594343, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_594374 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsUpdate_594376(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsUpdate_594375(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a comment with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594377 = path.getOrDefault("fileId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "fileId", valid_594377
  var valid_594378 = path.getOrDefault("commentId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "commentId", valid_594378
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594379 = query.getOrDefault("fields")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "fields", valid_594379
  var valid_594380 = query.getOrDefault("quotaUser")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "quotaUser", valid_594380
  var valid_594381 = query.getOrDefault("alt")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = newJString("json"))
  if valid_594381 != nil:
    section.add "alt", valid_594381
  var valid_594382 = query.getOrDefault("oauth_token")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "oauth_token", valid_594382
  var valid_594383 = query.getOrDefault("userIp")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "userIp", valid_594383
  var valid_594384 = query.getOrDefault("key")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "key", valid_594384
  var valid_594385 = query.getOrDefault("prettyPrint")
  valid_594385 = validateParameter(valid_594385, JBool, required = false,
                                 default = newJBool(true))
  if valid_594385 != nil:
    section.add "prettyPrint", valid_594385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594387: Call_DriveCommentsUpdate_594374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a comment with patch semantics.
  ## 
  let valid = call_594387.validator(path, query, header, formData, body)
  let scheme = call_594387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594387.url(scheme.get, call_594387.host, call_594387.base,
                         call_594387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594387, url, valid)

proc call*(call_594388: Call_DriveCommentsUpdate_594374; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveCommentsUpdate
  ## Updates a comment with patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594389 = newJObject()
  var query_594390 = newJObject()
  var body_594391 = newJObject()
  add(query_594390, "fields", newJString(fields))
  add(query_594390, "quotaUser", newJString(quotaUser))
  add(path_594389, "fileId", newJString(fileId))
  add(query_594390, "alt", newJString(alt))
  add(query_594390, "oauth_token", newJString(oauthToken))
  add(query_594390, "userIp", newJString(userIp))
  add(query_594390, "key", newJString(key))
  add(path_594389, "commentId", newJString(commentId))
  if body != nil:
    body_594391 = body
  add(query_594390, "prettyPrint", newJBool(prettyPrint))
  result = call_594388.call(path_594389, query_594390, nil, nil, body_594391)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_594374(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_594375, base: "/drive/v3",
    url: url_DriveCommentsUpdate_594376, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_594358 = ref object of OpenApiRestCall_593424
proc url_DriveCommentsDelete_594360(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveCommentsDelete_594359(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594361 = path.getOrDefault("fileId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "fileId", valid_594361
  var valid_594362 = path.getOrDefault("commentId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "commentId", valid_594362
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594363 = query.getOrDefault("fields")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "fields", valid_594363
  var valid_594364 = query.getOrDefault("quotaUser")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "quotaUser", valid_594364
  var valid_594365 = query.getOrDefault("alt")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = newJString("json"))
  if valid_594365 != nil:
    section.add "alt", valid_594365
  var valid_594366 = query.getOrDefault("oauth_token")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "oauth_token", valid_594366
  var valid_594367 = query.getOrDefault("userIp")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "userIp", valid_594367
  var valid_594368 = query.getOrDefault("key")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "key", valid_594368
  var valid_594369 = query.getOrDefault("prettyPrint")
  valid_594369 = validateParameter(valid_594369, JBool, required = false,
                                 default = newJBool(true))
  if valid_594369 != nil:
    section.add "prettyPrint", valid_594369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594370: Call_DriveCommentsDelete_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_DriveCommentsDelete_594358; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveCommentsDelete
  ## Deletes a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  add(query_594373, "fields", newJString(fields))
  add(query_594373, "quotaUser", newJString(quotaUser))
  add(path_594372, "fileId", newJString(fileId))
  add(query_594373, "alt", newJString(alt))
  add(query_594373, "oauth_token", newJString(oauthToken))
  add(query_594373, "userIp", newJString(userIp))
  add(query_594373, "key", newJString(key))
  add(path_594372, "commentId", newJString(commentId))
  add(query_594373, "prettyPrint", newJBool(prettyPrint))
  result = call_594371.call(path_594372, query_594373, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_594358(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_594359, base: "/drive/v3",
    url: url_DriveCommentsDelete_594360, schemes: {Scheme.Https})
type
  Call_DriveRepliesCreate_594411 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesCreate_594413(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesCreate_594412(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new reply to a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594414 = path.getOrDefault("fileId")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "fileId", valid_594414
  var valid_594415 = path.getOrDefault("commentId")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "commentId", valid_594415
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594416 = query.getOrDefault("fields")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "fields", valid_594416
  var valid_594417 = query.getOrDefault("quotaUser")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "quotaUser", valid_594417
  var valid_594418 = query.getOrDefault("alt")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = newJString("json"))
  if valid_594418 != nil:
    section.add "alt", valid_594418
  var valid_594419 = query.getOrDefault("oauth_token")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "oauth_token", valid_594419
  var valid_594420 = query.getOrDefault("userIp")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "userIp", valid_594420
  var valid_594421 = query.getOrDefault("key")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "key", valid_594421
  var valid_594422 = query.getOrDefault("prettyPrint")
  valid_594422 = validateParameter(valid_594422, JBool, required = false,
                                 default = newJBool(true))
  if valid_594422 != nil:
    section.add "prettyPrint", valid_594422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594424: Call_DriveRepliesCreate_594411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to a comment.
  ## 
  let valid = call_594424.validator(path, query, header, formData, body)
  let scheme = call_594424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594424.url(scheme.get, call_594424.host, call_594424.base,
                         call_594424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594424, url, valid)

proc call*(call_594425: Call_DriveRepliesCreate_594411; fileId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveRepliesCreate
  ## Creates a new reply to a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594426 = newJObject()
  var query_594427 = newJObject()
  var body_594428 = newJObject()
  add(query_594427, "fields", newJString(fields))
  add(query_594427, "quotaUser", newJString(quotaUser))
  add(path_594426, "fileId", newJString(fileId))
  add(query_594427, "alt", newJString(alt))
  add(query_594427, "oauth_token", newJString(oauthToken))
  add(query_594427, "userIp", newJString(userIp))
  add(query_594427, "key", newJString(key))
  add(path_594426, "commentId", newJString(commentId))
  if body != nil:
    body_594428 = body
  add(query_594427, "prettyPrint", newJBool(prettyPrint))
  result = call_594425.call(path_594426, query_594427, nil, nil, body_594428)

var driveRepliesCreate* = Call_DriveRepliesCreate_594411(
    name: "driveRepliesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesCreate_594412, base: "/drive/v3",
    url: url_DriveRepliesCreate_594413, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_594392 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesList_594394(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesList_594393(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists a comment's replies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594395 = path.getOrDefault("fileId")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "fileId", valid_594395
  var valid_594396 = path.getOrDefault("commentId")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "commentId", valid_594396
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to include deleted replies. Deleted replies will not include their original content.
  ##   pageSize: JInt
  ##           : The maximum number of replies to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594397 = query.getOrDefault("fields")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "fields", valid_594397
  var valid_594398 = query.getOrDefault("pageToken")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "pageToken", valid_594398
  var valid_594399 = query.getOrDefault("quotaUser")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "quotaUser", valid_594399
  var valid_594400 = query.getOrDefault("alt")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = newJString("json"))
  if valid_594400 != nil:
    section.add "alt", valid_594400
  var valid_594401 = query.getOrDefault("oauth_token")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "oauth_token", valid_594401
  var valid_594402 = query.getOrDefault("userIp")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "userIp", valid_594402
  var valid_594403 = query.getOrDefault("key")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "key", valid_594403
  var valid_594404 = query.getOrDefault("includeDeleted")
  valid_594404 = validateParameter(valid_594404, JBool, required = false,
                                 default = newJBool(false))
  if valid_594404 != nil:
    section.add "includeDeleted", valid_594404
  var valid_594405 = query.getOrDefault("pageSize")
  valid_594405 = validateParameter(valid_594405, JInt, required = false,
                                 default = newJInt(20))
  if valid_594405 != nil:
    section.add "pageSize", valid_594405
  var valid_594406 = query.getOrDefault("prettyPrint")
  valid_594406 = validateParameter(valid_594406, JBool, required = false,
                                 default = newJBool(true))
  if valid_594406 != nil:
    section.add "prettyPrint", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_DriveRepliesList_594392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a comment's replies.
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_DriveRepliesList_594392; fileId: string;
          commentId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; includeDeleted: bool = false;
          pageSize: int = 20; prettyPrint: bool = true): Recallable =
  ## driveRepliesList
  ## Lists a comment's replies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to include deleted replies. Deleted replies will not include their original content.
  ##   pageSize: int
  ##           : The maximum number of replies to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(query_594410, "fields", newJString(fields))
  add(query_594410, "pageToken", newJString(pageToken))
  add(query_594410, "quotaUser", newJString(quotaUser))
  add(path_594409, "fileId", newJString(fileId))
  add(query_594410, "alt", newJString(alt))
  add(query_594410, "oauth_token", newJString(oauthToken))
  add(query_594410, "userIp", newJString(userIp))
  add(query_594410, "key", newJString(key))
  add(path_594409, "commentId", newJString(commentId))
  add(query_594410, "includeDeleted", newJBool(includeDeleted))
  add(query_594410, "pageSize", newJInt(pageSize))
  add(query_594410, "prettyPrint", newJBool(prettyPrint))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_594392(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_594393, base: "/drive/v3",
    url: url_DriveRepliesList_594394, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_594429 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesGet_594431(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesGet_594430(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a reply by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594432 = path.getOrDefault("fileId")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "fileId", valid_594432
  var valid_594433 = path.getOrDefault("replyId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "replyId", valid_594433
  var valid_594434 = path.getOrDefault("commentId")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "commentId", valid_594434
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : Whether to return deleted replies. Deleted replies will not include their original content.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594435 = query.getOrDefault("fields")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "fields", valid_594435
  var valid_594436 = query.getOrDefault("quotaUser")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "quotaUser", valid_594436
  var valid_594437 = query.getOrDefault("alt")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = newJString("json"))
  if valid_594437 != nil:
    section.add "alt", valid_594437
  var valid_594438 = query.getOrDefault("oauth_token")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "oauth_token", valid_594438
  var valid_594439 = query.getOrDefault("userIp")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "userIp", valid_594439
  var valid_594440 = query.getOrDefault("key")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "key", valid_594440
  var valid_594441 = query.getOrDefault("includeDeleted")
  valid_594441 = validateParameter(valid_594441, JBool, required = false,
                                 default = newJBool(false))
  if valid_594441 != nil:
    section.add "includeDeleted", valid_594441
  var valid_594442 = query.getOrDefault("prettyPrint")
  valid_594442 = validateParameter(valid_594442, JBool, required = false,
                                 default = newJBool(true))
  if valid_594442 != nil:
    section.add "prettyPrint", valid_594442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594443: Call_DriveRepliesGet_594429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply by ID.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_DriveRepliesGet_594429; fileId: string; replyId: string;
          commentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; includeDeleted: bool = false; prettyPrint: bool = true): Recallable =
  ## driveRepliesGet
  ## Gets a reply by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to return deleted replies. Deleted replies will not include their original content.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  add(query_594446, "fields", newJString(fields))
  add(query_594446, "quotaUser", newJString(quotaUser))
  add(path_594445, "fileId", newJString(fileId))
  add(query_594446, "alt", newJString(alt))
  add(query_594446, "oauth_token", newJString(oauthToken))
  add(query_594446, "userIp", newJString(userIp))
  add(query_594446, "key", newJString(key))
  add(path_594445, "replyId", newJString(replyId))
  add(path_594445, "commentId", newJString(commentId))
  add(query_594446, "includeDeleted", newJBool(includeDeleted))
  add(query_594446, "prettyPrint", newJBool(prettyPrint))
  result = call_594444.call(path_594445, query_594446, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_594429(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_594430, base: "/drive/v3",
    url: url_DriveRepliesGet_594431, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_594464 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesUpdate_594466(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesUpdate_594465(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a reply with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594467 = path.getOrDefault("fileId")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "fileId", valid_594467
  var valid_594468 = path.getOrDefault("replyId")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "replyId", valid_594468
  var valid_594469 = path.getOrDefault("commentId")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "commentId", valid_594469
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594470 = query.getOrDefault("fields")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "fields", valid_594470
  var valid_594471 = query.getOrDefault("quotaUser")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "quotaUser", valid_594471
  var valid_594472 = query.getOrDefault("alt")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = newJString("json"))
  if valid_594472 != nil:
    section.add "alt", valid_594472
  var valid_594473 = query.getOrDefault("oauth_token")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "oauth_token", valid_594473
  var valid_594474 = query.getOrDefault("userIp")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "userIp", valid_594474
  var valid_594475 = query.getOrDefault("key")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "key", valid_594475
  var valid_594476 = query.getOrDefault("prettyPrint")
  valid_594476 = validateParameter(valid_594476, JBool, required = false,
                                 default = newJBool(true))
  if valid_594476 != nil:
    section.add "prettyPrint", valid_594476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594478: Call_DriveRepliesUpdate_594464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a reply with patch semantics.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_DriveRepliesUpdate_594464; fileId: string;
          replyId: string; commentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveRepliesUpdate
  ## Updates a reply with patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  var body_594482 = newJObject()
  add(query_594481, "fields", newJString(fields))
  add(query_594481, "quotaUser", newJString(quotaUser))
  add(path_594480, "fileId", newJString(fileId))
  add(query_594481, "alt", newJString(alt))
  add(query_594481, "oauth_token", newJString(oauthToken))
  add(query_594481, "userIp", newJString(userIp))
  add(query_594481, "key", newJString(key))
  add(path_594480, "replyId", newJString(replyId))
  add(path_594480, "commentId", newJString(commentId))
  if body != nil:
    body_594482 = body
  add(query_594481, "prettyPrint", newJBool(prettyPrint))
  result = call_594479.call(path_594480, query_594481, nil, nil, body_594482)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_594464(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_594465, base: "/drive/v3",
    url: url_DriveRepliesUpdate_594466, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_594447 = ref object of OpenApiRestCall_593424
proc url_DriveRepliesDelete_594449(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  assert "replyId" in path, "`replyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/replies/"),
               (kind: VariableSegment, value: "replyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRepliesDelete_594448(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594450 = path.getOrDefault("fileId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "fileId", valid_594450
  var valid_594451 = path.getOrDefault("replyId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "replyId", valid_594451
  var valid_594452 = path.getOrDefault("commentId")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "commentId", valid_594452
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594453 = query.getOrDefault("fields")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "fields", valid_594453
  var valid_594454 = query.getOrDefault("quotaUser")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "quotaUser", valid_594454
  var valid_594455 = query.getOrDefault("alt")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = newJString("json"))
  if valid_594455 != nil:
    section.add "alt", valid_594455
  var valid_594456 = query.getOrDefault("oauth_token")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "oauth_token", valid_594456
  var valid_594457 = query.getOrDefault("userIp")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = nil)
  if valid_594457 != nil:
    section.add "userIp", valid_594457
  var valid_594458 = query.getOrDefault("key")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "key", valid_594458
  var valid_594459 = query.getOrDefault("prettyPrint")
  valid_594459 = validateParameter(valid_594459, JBool, required = false,
                                 default = newJBool(true))
  if valid_594459 != nil:
    section.add "prettyPrint", valid_594459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594460: Call_DriveRepliesDelete_594447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_594460.validator(path, query, header, formData, body)
  let scheme = call_594460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594460.url(scheme.get, call_594460.host, call_594460.base,
                         call_594460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594460, url, valid)

proc call*(call_594461: Call_DriveRepliesDelete_594447; fileId: string;
          replyId: string; commentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRepliesDelete
  ## Deletes a reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594462 = newJObject()
  var query_594463 = newJObject()
  add(query_594463, "fields", newJString(fields))
  add(query_594463, "quotaUser", newJString(quotaUser))
  add(path_594462, "fileId", newJString(fileId))
  add(query_594463, "alt", newJString(alt))
  add(query_594463, "oauth_token", newJString(oauthToken))
  add(query_594463, "userIp", newJString(userIp))
  add(query_594463, "key", newJString(key))
  add(path_594462, "replyId", newJString(replyId))
  add(path_594462, "commentId", newJString(commentId))
  add(query_594463, "prettyPrint", newJBool(prettyPrint))
  result = call_594461.call(path_594462, query_594463, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_594447(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_594448, base: "/drive/v3",
    url: url_DriveRepliesDelete_594449, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_594483 = ref object of OpenApiRestCall_593424
proc url_DriveFilesCopy_594485(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesCopy_594484(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594486 = path.getOrDefault("fileId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "fileId", valid_594486
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ignoreDefaultVisibility: JBool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  section = newJObject()
  var valid_594487 = query.getOrDefault("supportsAllDrives")
  valid_594487 = validateParameter(valid_594487, JBool, required = false,
                                 default = newJBool(false))
  if valid_594487 != nil:
    section.add "supportsAllDrives", valid_594487
  var valid_594488 = query.getOrDefault("fields")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "fields", valid_594488
  var valid_594489 = query.getOrDefault("quotaUser")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "quotaUser", valid_594489
  var valid_594490 = query.getOrDefault("alt")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = newJString("json"))
  if valid_594490 != nil:
    section.add "alt", valid_594490
  var valid_594491 = query.getOrDefault("oauth_token")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "oauth_token", valid_594491
  var valid_594492 = query.getOrDefault("userIp")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "userIp", valid_594492
  var valid_594493 = query.getOrDefault("keepRevisionForever")
  valid_594493 = validateParameter(valid_594493, JBool, required = false,
                                 default = newJBool(false))
  if valid_594493 != nil:
    section.add "keepRevisionForever", valid_594493
  var valid_594494 = query.getOrDefault("supportsTeamDrives")
  valid_594494 = validateParameter(valid_594494, JBool, required = false,
                                 default = newJBool(false))
  if valid_594494 != nil:
    section.add "supportsTeamDrives", valid_594494
  var valid_594495 = query.getOrDefault("key")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "key", valid_594495
  var valid_594496 = query.getOrDefault("prettyPrint")
  valid_594496 = validateParameter(valid_594496, JBool, required = false,
                                 default = newJBool(true))
  if valid_594496 != nil:
    section.add "prettyPrint", valid_594496
  var valid_594497 = query.getOrDefault("ignoreDefaultVisibility")
  valid_594497 = validateParameter(valid_594497, JBool, required = false,
                                 default = newJBool(false))
  if valid_594497 != nil:
    section.add "ignoreDefaultVisibility", valid_594497
  var valid_594498 = query.getOrDefault("ocrLanguage")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "ocrLanguage", valid_594498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594500: Call_DriveFilesCopy_594483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_DriveFilesCopy_594483; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          keepRevisionForever: bool = false; supportsTeamDrives: bool = false;
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          ignoreDefaultVisibility: bool = false; ocrLanguage: string = ""): Recallable =
  ## driveFilesCopy
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ignoreDefaultVisibility: bool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  var path_594502 = newJObject()
  var query_594503 = newJObject()
  var body_594504 = newJObject()
  add(query_594503, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594503, "fields", newJString(fields))
  add(query_594503, "quotaUser", newJString(quotaUser))
  add(path_594502, "fileId", newJString(fileId))
  add(query_594503, "alt", newJString(alt))
  add(query_594503, "oauth_token", newJString(oauthToken))
  add(query_594503, "userIp", newJString(userIp))
  add(query_594503, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_594503, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594503, "key", newJString(key))
  if body != nil:
    body_594504 = body
  add(query_594503, "prettyPrint", newJBool(prettyPrint))
  add(query_594503, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_594503, "ocrLanguage", newJString(ocrLanguage))
  result = call_594501.call(path_594502, query_594503, nil, nil, body_594504)

var driveFilesCopy* = Call_DriveFilesCopy_594483(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_594484,
    base: "/drive/v3", url: url_DriveFilesCopy_594485, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_594505 = ref object of OpenApiRestCall_593424
proc url_DriveFilesExport_594507(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesExport_594506(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594508 = path.getOrDefault("fileId")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "fileId", valid_594508
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   mimeType: JString (required)
  ##           : The MIME type of the format requested for this export.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594509 = query.getOrDefault("fields")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "fields", valid_594509
  var valid_594510 = query.getOrDefault("quotaUser")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "quotaUser", valid_594510
  var valid_594511 = query.getOrDefault("alt")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = newJString("json"))
  if valid_594511 != nil:
    section.add "alt", valid_594511
  var valid_594512 = query.getOrDefault("oauth_token")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = nil)
  if valid_594512 != nil:
    section.add "oauth_token", valid_594512
  var valid_594513 = query.getOrDefault("userIp")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "userIp", valid_594513
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_594514 = query.getOrDefault("mimeType")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "mimeType", valid_594514
  var valid_594515 = query.getOrDefault("key")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "key", valid_594515
  var valid_594516 = query.getOrDefault("prettyPrint")
  valid_594516 = validateParameter(valid_594516, JBool, required = false,
                                 default = newJBool(true))
  if valid_594516 != nil:
    section.add "prettyPrint", valid_594516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594517: Call_DriveFilesExport_594505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_DriveFilesExport_594505; fileId: string;
          mimeType: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveFilesExport
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   mimeType: string (required)
  ##           : The MIME type of the format requested for this export.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  add(query_594520, "fields", newJString(fields))
  add(query_594520, "quotaUser", newJString(quotaUser))
  add(path_594519, "fileId", newJString(fileId))
  add(query_594520, "alt", newJString(alt))
  add(query_594520, "oauth_token", newJString(oauthToken))
  add(query_594520, "userIp", newJString(userIp))
  add(query_594520, "mimeType", newJString(mimeType))
  add(query_594520, "key", newJString(key))
  add(query_594520, "prettyPrint", newJBool(prettyPrint))
  result = call_594518.call(path_594519, query_594520, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_594505(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_594506,
    base: "/drive/v3", url: url_DriveFilesExport_594507, schemes: {Scheme.Https})
type
  Call_DrivePermissionsCreate_594541 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsCreate_594543(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsCreate_594542(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a permission for a file or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file or shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594544 = path.getOrDefault("fileId")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "fileId", valid_594544
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotificationEmail: JBool
  ##                        : Whether to send a notification email when sharing to users or groups. This defaults to true for users and groups, and is not allowed for other requests. It must not be disabled for ownership transfers.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   emailMessage: JString
  ##               : A plain text custom message to include in the notification email.
  ##   transferOwnership: JBool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594545 = query.getOrDefault("supportsAllDrives")
  valid_594545 = validateParameter(valid_594545, JBool, required = false,
                                 default = newJBool(false))
  if valid_594545 != nil:
    section.add "supportsAllDrives", valid_594545
  var valid_594546 = query.getOrDefault("fields")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "fields", valid_594546
  var valid_594547 = query.getOrDefault("quotaUser")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "quotaUser", valid_594547
  var valid_594548 = query.getOrDefault("alt")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = newJString("json"))
  if valid_594548 != nil:
    section.add "alt", valid_594548
  var valid_594549 = query.getOrDefault("sendNotificationEmail")
  valid_594549 = validateParameter(valid_594549, JBool, required = false, default = nil)
  if valid_594549 != nil:
    section.add "sendNotificationEmail", valid_594549
  var valid_594550 = query.getOrDefault("oauth_token")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "oauth_token", valid_594550
  var valid_594551 = query.getOrDefault("userIp")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "userIp", valid_594551
  var valid_594552 = query.getOrDefault("supportsTeamDrives")
  valid_594552 = validateParameter(valid_594552, JBool, required = false,
                                 default = newJBool(false))
  if valid_594552 != nil:
    section.add "supportsTeamDrives", valid_594552
  var valid_594553 = query.getOrDefault("key")
  valid_594553 = validateParameter(valid_594553, JString, required = false,
                                 default = nil)
  if valid_594553 != nil:
    section.add "key", valid_594553
  var valid_594554 = query.getOrDefault("useDomainAdminAccess")
  valid_594554 = validateParameter(valid_594554, JBool, required = false,
                                 default = newJBool(false))
  if valid_594554 != nil:
    section.add "useDomainAdminAccess", valid_594554
  var valid_594555 = query.getOrDefault("emailMessage")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "emailMessage", valid_594555
  var valid_594556 = query.getOrDefault("transferOwnership")
  valid_594556 = validateParameter(valid_594556, JBool, required = false,
                                 default = newJBool(false))
  if valid_594556 != nil:
    section.add "transferOwnership", valid_594556
  var valid_594557 = query.getOrDefault("prettyPrint")
  valid_594557 = validateParameter(valid_594557, JBool, required = false,
                                 default = newJBool(true))
  if valid_594557 != nil:
    section.add "prettyPrint", valid_594557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594559: Call_DrivePermissionsCreate_594541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a permission for a file or shared drive.
  ## 
  let valid = call_594559.validator(path, query, header, formData, body)
  let scheme = call_594559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594559.url(scheme.get, call_594559.host, call_594559.base,
                         call_594559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594559, url, valid)

proc call*(call_594560: Call_DrivePermissionsCreate_594541; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; sendNotificationEmail: bool = false;
          oauthToken: string = ""; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; emailMessage: string = "";
          transferOwnership: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## drivePermissionsCreate
  ## Creates a permission for a file or shared drive.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendNotificationEmail: bool
  ##                        : Whether to send a notification email when sharing to users or groups. This defaults to true for users and groups, and is not allowed for other requests. It must not be disabled for ownership transfers.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   emailMessage: string
  ##               : A plain text custom message to include in the notification email.
  ##   transferOwnership: bool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594561 = newJObject()
  var query_594562 = newJObject()
  var body_594563 = newJObject()
  add(query_594562, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594562, "fields", newJString(fields))
  add(query_594562, "quotaUser", newJString(quotaUser))
  add(path_594561, "fileId", newJString(fileId))
  add(query_594562, "alt", newJString(alt))
  add(query_594562, "sendNotificationEmail", newJBool(sendNotificationEmail))
  add(query_594562, "oauth_token", newJString(oauthToken))
  add(query_594562, "userIp", newJString(userIp))
  add(query_594562, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594562, "key", newJString(key))
  add(query_594562, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594562, "emailMessage", newJString(emailMessage))
  add(query_594562, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_594563 = body
  add(query_594562, "prettyPrint", newJBool(prettyPrint))
  result = call_594560.call(path_594561, query_594562, nil, nil, body_594563)

var drivePermissionsCreate* = Call_DrivePermissionsCreate_594541(
    name: "drivePermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsCreate_594542, base: "/drive/v3",
    url: url_DrivePermissionsCreate_594543, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_594521 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsList_594523(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsList_594522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a file's or shared drive's permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file or shared drive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594524 = path.getOrDefault("fileId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "fileId", valid_594524
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   pageSize: JInt
  ##           : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594525 = query.getOrDefault("supportsAllDrives")
  valid_594525 = validateParameter(valid_594525, JBool, required = false,
                                 default = newJBool(false))
  if valid_594525 != nil:
    section.add "supportsAllDrives", valid_594525
  var valid_594526 = query.getOrDefault("fields")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "fields", valid_594526
  var valid_594527 = query.getOrDefault("pageToken")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "pageToken", valid_594527
  var valid_594528 = query.getOrDefault("quotaUser")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "quotaUser", valid_594528
  var valid_594529 = query.getOrDefault("alt")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = newJString("json"))
  if valid_594529 != nil:
    section.add "alt", valid_594529
  var valid_594530 = query.getOrDefault("oauth_token")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "oauth_token", valid_594530
  var valid_594531 = query.getOrDefault("userIp")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "userIp", valid_594531
  var valid_594532 = query.getOrDefault("supportsTeamDrives")
  valid_594532 = validateParameter(valid_594532, JBool, required = false,
                                 default = newJBool(false))
  if valid_594532 != nil:
    section.add "supportsTeamDrives", valid_594532
  var valid_594533 = query.getOrDefault("key")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "key", valid_594533
  var valid_594534 = query.getOrDefault("useDomainAdminAccess")
  valid_594534 = validateParameter(valid_594534, JBool, required = false,
                                 default = newJBool(false))
  if valid_594534 != nil:
    section.add "useDomainAdminAccess", valid_594534
  var valid_594535 = query.getOrDefault("pageSize")
  valid_594535 = validateParameter(valid_594535, JInt, required = false, default = nil)
  if valid_594535 != nil:
    section.add "pageSize", valid_594535
  var valid_594536 = query.getOrDefault("prettyPrint")
  valid_594536 = validateParameter(valid_594536, JBool, required = false,
                                 default = newJBool(true))
  if valid_594536 != nil:
    section.add "prettyPrint", valid_594536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594537: Call_DrivePermissionsList_594521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_594537.validator(path, query, header, formData, body)
  let scheme = call_594537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594537.url(scheme.get, call_594537.host, call_594537.base,
                         call_594537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594537, url, valid)

proc call*(call_594538: Call_DrivePermissionsList_594521; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## drivePermissionsList
  ## Lists a file's or shared drive's permissions.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   pageSize: int
  ##           : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594539 = newJObject()
  var query_594540 = newJObject()
  add(query_594540, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594540, "fields", newJString(fields))
  add(query_594540, "pageToken", newJString(pageToken))
  add(query_594540, "quotaUser", newJString(quotaUser))
  add(path_594539, "fileId", newJString(fileId))
  add(query_594540, "alt", newJString(alt))
  add(query_594540, "oauth_token", newJString(oauthToken))
  add(query_594540, "userIp", newJString(userIp))
  add(query_594540, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594540, "key", newJString(key))
  add(query_594540, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594540, "pageSize", newJInt(pageSize))
  add(query_594540, "prettyPrint", newJBool(prettyPrint))
  result = call_594538.call(path_594539, query_594540, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_594521(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_594522, base: "/drive/v3",
    url: url_DrivePermissionsList_594523, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_594564 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsGet_594566(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsGet_594565(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a permission by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   permissionId: JString (required)
  ##               : The ID of the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594567 = path.getOrDefault("fileId")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "fileId", valid_594567
  var valid_594568 = path.getOrDefault("permissionId")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "permissionId", valid_594568
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594569 = query.getOrDefault("supportsAllDrives")
  valid_594569 = validateParameter(valid_594569, JBool, required = false,
                                 default = newJBool(false))
  if valid_594569 != nil:
    section.add "supportsAllDrives", valid_594569
  var valid_594570 = query.getOrDefault("fields")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "fields", valid_594570
  var valid_594571 = query.getOrDefault("quotaUser")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = nil)
  if valid_594571 != nil:
    section.add "quotaUser", valid_594571
  var valid_594572 = query.getOrDefault("alt")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = newJString("json"))
  if valid_594572 != nil:
    section.add "alt", valid_594572
  var valid_594573 = query.getOrDefault("oauth_token")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = nil)
  if valid_594573 != nil:
    section.add "oauth_token", valid_594573
  var valid_594574 = query.getOrDefault("userIp")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "userIp", valid_594574
  var valid_594575 = query.getOrDefault("supportsTeamDrives")
  valid_594575 = validateParameter(valid_594575, JBool, required = false,
                                 default = newJBool(false))
  if valid_594575 != nil:
    section.add "supportsTeamDrives", valid_594575
  var valid_594576 = query.getOrDefault("key")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "key", valid_594576
  var valid_594577 = query.getOrDefault("useDomainAdminAccess")
  valid_594577 = validateParameter(valid_594577, JBool, required = false,
                                 default = newJBool(false))
  if valid_594577 != nil:
    section.add "useDomainAdminAccess", valid_594577
  var valid_594578 = query.getOrDefault("prettyPrint")
  valid_594578 = validateParameter(valid_594578, JBool, required = false,
                                 default = newJBool(true))
  if valid_594578 != nil:
    section.add "prettyPrint", valid_594578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594579: Call_DrivePermissionsGet_594564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_594579.validator(path, query, header, formData, body)
  let scheme = call_594579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594579.url(scheme.get, call_594579.host, call_594579.base,
                         call_594579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594579, url, valid)

proc call*(call_594580: Call_DrivePermissionsGet_594564; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## drivePermissionsGet
  ## Gets a permission by ID.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594581 = newJObject()
  var query_594582 = newJObject()
  add(query_594582, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594582, "fields", newJString(fields))
  add(query_594582, "quotaUser", newJString(quotaUser))
  add(path_594581, "fileId", newJString(fileId))
  add(query_594582, "alt", newJString(alt))
  add(query_594582, "oauth_token", newJString(oauthToken))
  add(path_594581, "permissionId", newJString(permissionId))
  add(query_594582, "userIp", newJString(userIp))
  add(query_594582, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594582, "key", newJString(key))
  add(query_594582, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594582, "prettyPrint", newJBool(prettyPrint))
  result = call_594580.call(path_594581, query_594582, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_594564(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_594565, base: "/drive/v3",
    url: url_DrivePermissionsGet_594566, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_594602 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsUpdate_594604(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsUpdate_594603(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a permission with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID of the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594605 = path.getOrDefault("fileId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "fileId", valid_594605
  var valid_594606 = path.getOrDefault("permissionId")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "permissionId", valid_594606
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: JBool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594607 = query.getOrDefault("supportsAllDrives")
  valid_594607 = validateParameter(valid_594607, JBool, required = false,
                                 default = newJBool(false))
  if valid_594607 != nil:
    section.add "supportsAllDrives", valid_594607
  var valid_594608 = query.getOrDefault("fields")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = nil)
  if valid_594608 != nil:
    section.add "fields", valid_594608
  var valid_594609 = query.getOrDefault("quotaUser")
  valid_594609 = validateParameter(valid_594609, JString, required = false,
                                 default = nil)
  if valid_594609 != nil:
    section.add "quotaUser", valid_594609
  var valid_594610 = query.getOrDefault("alt")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = newJString("json"))
  if valid_594610 != nil:
    section.add "alt", valid_594610
  var valid_594611 = query.getOrDefault("oauth_token")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "oauth_token", valid_594611
  var valid_594612 = query.getOrDefault("removeExpiration")
  valid_594612 = validateParameter(valid_594612, JBool, required = false,
                                 default = newJBool(false))
  if valid_594612 != nil:
    section.add "removeExpiration", valid_594612
  var valid_594613 = query.getOrDefault("userIp")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "userIp", valid_594613
  var valid_594614 = query.getOrDefault("supportsTeamDrives")
  valid_594614 = validateParameter(valid_594614, JBool, required = false,
                                 default = newJBool(false))
  if valid_594614 != nil:
    section.add "supportsTeamDrives", valid_594614
  var valid_594615 = query.getOrDefault("key")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "key", valid_594615
  var valid_594616 = query.getOrDefault("useDomainAdminAccess")
  valid_594616 = validateParameter(valid_594616, JBool, required = false,
                                 default = newJBool(false))
  if valid_594616 != nil:
    section.add "useDomainAdminAccess", valid_594616
  var valid_594617 = query.getOrDefault("transferOwnership")
  valid_594617 = validateParameter(valid_594617, JBool, required = false,
                                 default = newJBool(false))
  if valid_594617 != nil:
    section.add "transferOwnership", valid_594617
  var valid_594618 = query.getOrDefault("prettyPrint")
  valid_594618 = validateParameter(valid_594618, JBool, required = false,
                                 default = newJBool(true))
  if valid_594618 != nil:
    section.add "prettyPrint", valid_594618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594620: Call_DrivePermissionsUpdate_594602; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission with patch semantics.
  ## 
  let valid = call_594620.validator(path, query, header, formData, body)
  let scheme = call_594620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594620.url(scheme.get, call_594620.host, call_594620.base,
                         call_594620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594620, url, valid)

proc call*(call_594621: Call_DrivePermissionsUpdate_594602; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          removeExpiration: bool = false; userIp: string = "";
          supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; transferOwnership: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## drivePermissionsUpdate
  ## Updates a permission with patch semantics.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   transferOwnership: bool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594622 = newJObject()
  var query_594623 = newJObject()
  var body_594624 = newJObject()
  add(query_594623, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594623, "fields", newJString(fields))
  add(query_594623, "quotaUser", newJString(quotaUser))
  add(path_594622, "fileId", newJString(fileId))
  add(query_594623, "alt", newJString(alt))
  add(query_594623, "oauth_token", newJString(oauthToken))
  add(path_594622, "permissionId", newJString(permissionId))
  add(query_594623, "removeExpiration", newJBool(removeExpiration))
  add(query_594623, "userIp", newJString(userIp))
  add(query_594623, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594623, "key", newJString(key))
  add(query_594623, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594623, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_594624 = body
  add(query_594623, "prettyPrint", newJBool(prettyPrint))
  result = call_594621.call(path_594622, query_594623, nil, nil, body_594624)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_594602(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_594603, base: "/drive/v3",
    url: url_DrivePermissionsUpdate_594604, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_594583 = ref object of OpenApiRestCall_593424
proc url_DrivePermissionsDelete_594585(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DrivePermissionsDelete_594584(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file or shared drive.
  ##   permissionId: JString (required)
  ##               : The ID of the permission.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594586 = path.getOrDefault("fileId")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "fileId", valid_594586
  var valid_594587 = path.getOrDefault("permissionId")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "permissionId", valid_594587
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594588 = query.getOrDefault("supportsAllDrives")
  valid_594588 = validateParameter(valid_594588, JBool, required = false,
                                 default = newJBool(false))
  if valid_594588 != nil:
    section.add "supportsAllDrives", valid_594588
  var valid_594589 = query.getOrDefault("fields")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "fields", valid_594589
  var valid_594590 = query.getOrDefault("quotaUser")
  valid_594590 = validateParameter(valid_594590, JString, required = false,
                                 default = nil)
  if valid_594590 != nil:
    section.add "quotaUser", valid_594590
  var valid_594591 = query.getOrDefault("alt")
  valid_594591 = validateParameter(valid_594591, JString, required = false,
                                 default = newJString("json"))
  if valid_594591 != nil:
    section.add "alt", valid_594591
  var valid_594592 = query.getOrDefault("oauth_token")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "oauth_token", valid_594592
  var valid_594593 = query.getOrDefault("userIp")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "userIp", valid_594593
  var valid_594594 = query.getOrDefault("supportsTeamDrives")
  valid_594594 = validateParameter(valid_594594, JBool, required = false,
                                 default = newJBool(false))
  if valid_594594 != nil:
    section.add "supportsTeamDrives", valid_594594
  var valid_594595 = query.getOrDefault("key")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "key", valid_594595
  var valid_594596 = query.getOrDefault("useDomainAdminAccess")
  valid_594596 = validateParameter(valid_594596, JBool, required = false,
                                 default = newJBool(false))
  if valid_594596 != nil:
    section.add "useDomainAdminAccess", valid_594596
  var valid_594597 = query.getOrDefault("prettyPrint")
  valid_594597 = validateParameter(valid_594597, JBool, required = false,
                                 default = newJBool(true))
  if valid_594597 != nil:
    section.add "prettyPrint", valid_594597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594598: Call_DrivePermissionsDelete_594583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission.
  ## 
  let valid = call_594598.validator(path, query, header, formData, body)
  let scheme = call_594598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594598.url(scheme.get, call_594598.host, call_594598.base,
                         call_594598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594598, url, valid)

proc call*(call_594599: Call_DrivePermissionsDelete_594583; fileId: string;
          permissionId: string; supportsAllDrives: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## drivePermissionsDelete
  ## Deletes a permission.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594600 = newJObject()
  var query_594601 = newJObject()
  add(query_594601, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594601, "fields", newJString(fields))
  add(query_594601, "quotaUser", newJString(quotaUser))
  add(path_594600, "fileId", newJString(fileId))
  add(query_594601, "alt", newJString(alt))
  add(query_594601, "oauth_token", newJString(oauthToken))
  add(path_594600, "permissionId", newJString(permissionId))
  add(query_594601, "userIp", newJString(userIp))
  add(query_594601, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594601, "key", newJString(key))
  add(query_594601, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594601, "prettyPrint", newJBool(prettyPrint))
  result = call_594599.call(path_594600, query_594601, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_594583(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_594584, base: "/drive/v3",
    url: url_DrivePermissionsDelete_594585, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_594625 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsList_594627(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsList_594626(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a file's revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594628 = path.getOrDefault("fileId")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "fileId", valid_594628
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The maximum number of revisions to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594629 = query.getOrDefault("fields")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "fields", valid_594629
  var valid_594630 = query.getOrDefault("pageToken")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = nil)
  if valid_594630 != nil:
    section.add "pageToken", valid_594630
  var valid_594631 = query.getOrDefault("quotaUser")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "quotaUser", valid_594631
  var valid_594632 = query.getOrDefault("alt")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = newJString("json"))
  if valid_594632 != nil:
    section.add "alt", valid_594632
  var valid_594633 = query.getOrDefault("oauth_token")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "oauth_token", valid_594633
  var valid_594634 = query.getOrDefault("userIp")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "userIp", valid_594634
  var valid_594635 = query.getOrDefault("key")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "key", valid_594635
  var valid_594636 = query.getOrDefault("pageSize")
  valid_594636 = validateParameter(valid_594636, JInt, required = false,
                                 default = newJInt(200))
  if valid_594636 != nil:
    section.add "pageSize", valid_594636
  var valid_594637 = query.getOrDefault("prettyPrint")
  valid_594637 = validateParameter(valid_594637, JBool, required = false,
                                 default = newJBool(true))
  if valid_594637 != nil:
    section.add "prettyPrint", valid_594637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594638: Call_DriveRevisionsList_594625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_594638.validator(path, query, header, formData, body)
  let scheme = call_594638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594638.url(scheme.get, call_594638.host, call_594638.base,
                         call_594638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594638, url, valid)

proc call*(call_594639: Call_DriveRevisionsList_594625; fileId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; pageSize: int = 200; prettyPrint: bool = true): Recallable =
  ## driveRevisionsList
  ## Lists a file's revisions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: int
  ##           : The maximum number of revisions to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594640 = newJObject()
  var query_594641 = newJObject()
  add(query_594641, "fields", newJString(fields))
  add(query_594641, "pageToken", newJString(pageToken))
  add(query_594641, "quotaUser", newJString(quotaUser))
  add(path_594640, "fileId", newJString(fileId))
  add(query_594641, "alt", newJString(alt))
  add(query_594641, "oauth_token", newJString(oauthToken))
  add(query_594641, "userIp", newJString(userIp))
  add(query_594641, "key", newJString(key))
  add(query_594641, "pageSize", newJInt(pageSize))
  add(query_594641, "prettyPrint", newJBool(prettyPrint))
  result = call_594639.call(path_594640, query_594641, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_594625(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_594626, base: "/drive/v3",
    url: url_DriveRevisionsList_594627, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_594642 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsGet_594644(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsGet_594643(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a revision's metadata or content by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   revisionId: JString (required)
  ##             : The ID of the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594645 = path.getOrDefault("fileId")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "fileId", valid_594645
  var valid_594646 = path.getOrDefault("revisionId")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "revisionId", valid_594646
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594647 = query.getOrDefault("fields")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "fields", valid_594647
  var valid_594648 = query.getOrDefault("quotaUser")
  valid_594648 = validateParameter(valid_594648, JString, required = false,
                                 default = nil)
  if valid_594648 != nil:
    section.add "quotaUser", valid_594648
  var valid_594649 = query.getOrDefault("alt")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = newJString("json"))
  if valid_594649 != nil:
    section.add "alt", valid_594649
  var valid_594650 = query.getOrDefault("acknowledgeAbuse")
  valid_594650 = validateParameter(valid_594650, JBool, required = false,
                                 default = newJBool(false))
  if valid_594650 != nil:
    section.add "acknowledgeAbuse", valid_594650
  var valid_594651 = query.getOrDefault("oauth_token")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "oauth_token", valid_594651
  var valid_594652 = query.getOrDefault("userIp")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "userIp", valid_594652
  var valid_594653 = query.getOrDefault("key")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "key", valid_594653
  var valid_594654 = query.getOrDefault("prettyPrint")
  valid_594654 = validateParameter(valid_594654, JBool, required = false,
                                 default = newJBool(true))
  if valid_594654 != nil:
    section.add "prettyPrint", valid_594654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594655: Call_DriveRevisionsGet_594642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a revision's metadata or content by ID.
  ## 
  let valid = call_594655.validator(path, query, header, formData, body)
  let scheme = call_594655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594655.url(scheme.get, call_594655.host, call_594655.base,
                         call_594655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594655, url, valid)

proc call*(call_594656: Call_DriveRevisionsGet_594642; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acknowledgeAbuse: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRevisionsGet
  ## Gets a revision's metadata or content by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594657 = newJObject()
  var query_594658 = newJObject()
  add(query_594658, "fields", newJString(fields))
  add(query_594658, "quotaUser", newJString(quotaUser))
  add(path_594657, "fileId", newJString(fileId))
  add(query_594658, "alt", newJString(alt))
  add(query_594658, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_594658, "oauth_token", newJString(oauthToken))
  add(path_594657, "revisionId", newJString(revisionId))
  add(query_594658, "userIp", newJString(userIp))
  add(query_594658, "key", newJString(key))
  add(query_594658, "prettyPrint", newJBool(prettyPrint))
  result = call_594656.call(path_594657, query_594658, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_594642(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_594643, base: "/drive/v3",
    url: url_DriveRevisionsGet_594644, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_594675 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsUpdate_594677(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsUpdate_594676(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a revision with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   revisionId: JString (required)
  ##             : The ID of the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594678 = path.getOrDefault("fileId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "fileId", valid_594678
  var valid_594679 = path.getOrDefault("revisionId")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "revisionId", valid_594679
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594680 = query.getOrDefault("fields")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = nil)
  if valid_594680 != nil:
    section.add "fields", valid_594680
  var valid_594681 = query.getOrDefault("quotaUser")
  valid_594681 = validateParameter(valid_594681, JString, required = false,
                                 default = nil)
  if valid_594681 != nil:
    section.add "quotaUser", valid_594681
  var valid_594682 = query.getOrDefault("alt")
  valid_594682 = validateParameter(valid_594682, JString, required = false,
                                 default = newJString("json"))
  if valid_594682 != nil:
    section.add "alt", valid_594682
  var valid_594683 = query.getOrDefault("oauth_token")
  valid_594683 = validateParameter(valid_594683, JString, required = false,
                                 default = nil)
  if valid_594683 != nil:
    section.add "oauth_token", valid_594683
  var valid_594684 = query.getOrDefault("userIp")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = nil)
  if valid_594684 != nil:
    section.add "userIp", valid_594684
  var valid_594685 = query.getOrDefault("key")
  valid_594685 = validateParameter(valid_594685, JString, required = false,
                                 default = nil)
  if valid_594685 != nil:
    section.add "key", valid_594685
  var valid_594686 = query.getOrDefault("prettyPrint")
  valid_594686 = validateParameter(valid_594686, JBool, required = false,
                                 default = newJBool(true))
  if valid_594686 != nil:
    section.add "prettyPrint", valid_594686
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594688: Call_DriveRevisionsUpdate_594675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision with patch semantics.
  ## 
  let valid = call_594688.validator(path, query, header, formData, body)
  let scheme = call_594688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594688.url(scheme.get, call_594688.host, call_594688.base,
                         call_594688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594688, url, valid)

proc call*(call_594689: Call_DriveRevisionsUpdate_594675; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveRevisionsUpdate
  ## Updates a revision with patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594690 = newJObject()
  var query_594691 = newJObject()
  var body_594692 = newJObject()
  add(query_594691, "fields", newJString(fields))
  add(query_594691, "quotaUser", newJString(quotaUser))
  add(path_594690, "fileId", newJString(fileId))
  add(query_594691, "alt", newJString(alt))
  add(query_594691, "oauth_token", newJString(oauthToken))
  add(path_594690, "revisionId", newJString(revisionId))
  add(query_594691, "userIp", newJString(userIp))
  add(query_594691, "key", newJString(key))
  if body != nil:
    body_594692 = body
  add(query_594691, "prettyPrint", newJBool(prettyPrint))
  result = call_594689.call(path_594690, query_594691, nil, nil, body_594692)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_594675(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_594676, base: "/drive/v3",
    url: url_DriveRevisionsUpdate_594677, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_594659 = ref object of OpenApiRestCall_593424
proc url_DriveRevisionsDelete_594661(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  assert "revisionId" in path, "`revisionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/revisions/"),
               (kind: VariableSegment, value: "revisionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveRevisionsDelete_594660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   revisionId: JString (required)
  ##             : The ID of the revision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594662 = path.getOrDefault("fileId")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "fileId", valid_594662
  var valid_594663 = path.getOrDefault("revisionId")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "revisionId", valid_594663
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594664 = query.getOrDefault("fields")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "fields", valid_594664
  var valid_594665 = query.getOrDefault("quotaUser")
  valid_594665 = validateParameter(valid_594665, JString, required = false,
                                 default = nil)
  if valid_594665 != nil:
    section.add "quotaUser", valid_594665
  var valid_594666 = query.getOrDefault("alt")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = newJString("json"))
  if valid_594666 != nil:
    section.add "alt", valid_594666
  var valid_594667 = query.getOrDefault("oauth_token")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "oauth_token", valid_594667
  var valid_594668 = query.getOrDefault("userIp")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "userIp", valid_594668
  var valid_594669 = query.getOrDefault("key")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "key", valid_594669
  var valid_594670 = query.getOrDefault("prettyPrint")
  valid_594670 = validateParameter(valid_594670, JBool, required = false,
                                 default = newJBool(true))
  if valid_594670 != nil:
    section.add "prettyPrint", valid_594670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594671: Call_DriveRevisionsDelete_594659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_594671.validator(path, query, header, formData, body)
  let scheme = call_594671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594671.url(scheme.get, call_594671.host, call_594671.base,
                         call_594671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594671, url, valid)

proc call*(call_594672: Call_DriveRevisionsDelete_594659; fileId: string;
          revisionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## driveRevisionsDelete
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594673 = newJObject()
  var query_594674 = newJObject()
  add(query_594674, "fields", newJString(fields))
  add(query_594674, "quotaUser", newJString(quotaUser))
  add(path_594673, "fileId", newJString(fileId))
  add(query_594674, "alt", newJString(alt))
  add(query_594674, "oauth_token", newJString(oauthToken))
  add(path_594673, "revisionId", newJString(revisionId))
  add(query_594674, "userIp", newJString(userIp))
  add(query_594674, "key", newJString(key))
  add(query_594674, "prettyPrint", newJBool(prettyPrint))
  result = call_594672.call(path_594673, query_594674, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_594659(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_594660, base: "/drive/v3",
    url: url_DriveRevisionsDelete_594661, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_594693 = ref object of OpenApiRestCall_593424
proc url_DriveFilesWatch_594695(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId"),
               (kind: ConstantSegment, value: "/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesWatch_594694(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Subscribes to changes to a file
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fileId: JString (required)
  ##         : The ID of the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fileId` field"
  var valid_594696 = path.getOrDefault("fileId")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "fileId", valid_594696
  result.add "path", section
  ## parameters in `query` object:
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594697 = query.getOrDefault("supportsAllDrives")
  valid_594697 = validateParameter(valid_594697, JBool, required = false,
                                 default = newJBool(false))
  if valid_594697 != nil:
    section.add "supportsAllDrives", valid_594697
  var valid_594698 = query.getOrDefault("fields")
  valid_594698 = validateParameter(valid_594698, JString, required = false,
                                 default = nil)
  if valid_594698 != nil:
    section.add "fields", valid_594698
  var valid_594699 = query.getOrDefault("quotaUser")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "quotaUser", valid_594699
  var valid_594700 = query.getOrDefault("alt")
  valid_594700 = validateParameter(valid_594700, JString, required = false,
                                 default = newJString("json"))
  if valid_594700 != nil:
    section.add "alt", valid_594700
  var valid_594701 = query.getOrDefault("acknowledgeAbuse")
  valid_594701 = validateParameter(valid_594701, JBool, required = false,
                                 default = newJBool(false))
  if valid_594701 != nil:
    section.add "acknowledgeAbuse", valid_594701
  var valid_594702 = query.getOrDefault("oauth_token")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "oauth_token", valid_594702
  var valid_594703 = query.getOrDefault("userIp")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "userIp", valid_594703
  var valid_594704 = query.getOrDefault("supportsTeamDrives")
  valid_594704 = validateParameter(valid_594704, JBool, required = false,
                                 default = newJBool(false))
  if valid_594704 != nil:
    section.add "supportsTeamDrives", valid_594704
  var valid_594705 = query.getOrDefault("key")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "key", valid_594705
  var valid_594706 = query.getOrDefault("prettyPrint")
  valid_594706 = validateParameter(valid_594706, JBool, required = false,
                                 default = newJBool(true))
  if valid_594706 != nil:
    section.add "prettyPrint", valid_594706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594708: Call_DriveFilesWatch_594693; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes to a file
  ## 
  let valid = call_594708.validator(path, query, header, formData, body)
  let scheme = call_594708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594708.url(scheme.get, call_594708.host, call_594708.base,
                         call_594708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594708, url, valid)

proc call*(call_594709: Call_DriveFilesWatch_594693; fileId: string;
          supportsAllDrives: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acknowledgeAbuse: bool = false; oauthToken: string = "";
          userIp: string = ""; supportsTeamDrives: bool = false; key: string = "";
          resource: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveFilesWatch
  ## Subscribes to changes to a file
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   alt: string
  ##      : Data format for the response.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594710 = newJObject()
  var query_594711 = newJObject()
  var body_594712 = newJObject()
  add(query_594711, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_594711, "fields", newJString(fields))
  add(query_594711, "quotaUser", newJString(quotaUser))
  add(path_594710, "fileId", newJString(fileId))
  add(query_594711, "alt", newJString(alt))
  add(query_594711, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_594711, "oauth_token", newJString(oauthToken))
  add(query_594711, "userIp", newJString(userIp))
  add(query_594711, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_594711, "key", newJString(key))
  if resource != nil:
    body_594712 = resource
  add(query_594711, "prettyPrint", newJBool(prettyPrint))
  result = call_594709.call(path_594710, query_594711, nil, nil, body_594712)

var driveFilesWatch* = Call_DriveFilesWatch_594693(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_594694,
    base: "/drive/v3", url: url_DriveFilesWatch_594695, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesCreate_594730 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesCreate_594732(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesCreate_594731(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.create instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594733 = query.getOrDefault("fields")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "fields", valid_594733
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_594734 = query.getOrDefault("requestId")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "requestId", valid_594734
  var valid_594735 = query.getOrDefault("quotaUser")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "quotaUser", valid_594735
  var valid_594736 = query.getOrDefault("alt")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = newJString("json"))
  if valid_594736 != nil:
    section.add "alt", valid_594736
  var valid_594737 = query.getOrDefault("oauth_token")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "oauth_token", valid_594737
  var valid_594738 = query.getOrDefault("userIp")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = nil)
  if valid_594738 != nil:
    section.add "userIp", valid_594738
  var valid_594739 = query.getOrDefault("key")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = nil)
  if valid_594739 != nil:
    section.add "key", valid_594739
  var valid_594740 = query.getOrDefault("prettyPrint")
  valid_594740 = validateParameter(valid_594740, JBool, required = false,
                                 default = newJBool(true))
  if valid_594740 != nil:
    section.add "prettyPrint", valid_594740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594742: Call_DriveTeamdrivesCreate_594730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.create instead.
  ## 
  let valid = call_594742.validator(path, query, header, formData, body)
  let scheme = call_594742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594742.url(scheme.get, call_594742.host, call_594742.base,
                         call_594742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594742, url, valid)

proc call*(call_594743: Call_DriveTeamdrivesCreate_594730; requestId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesCreate
  ## Deprecated use drives.create instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594744 = newJObject()
  var body_594745 = newJObject()
  add(query_594744, "fields", newJString(fields))
  add(query_594744, "requestId", newJString(requestId))
  add(query_594744, "quotaUser", newJString(quotaUser))
  add(query_594744, "alt", newJString(alt))
  add(query_594744, "oauth_token", newJString(oauthToken))
  add(query_594744, "userIp", newJString(userIp))
  add(query_594744, "key", newJString(key))
  if body != nil:
    body_594745 = body
  add(query_594744, "prettyPrint", newJBool(prettyPrint))
  result = call_594743.call(nil, query_594744, nil, nil, body_594745)

var driveTeamdrivesCreate* = Call_DriveTeamdrivesCreate_594730(
    name: "driveTeamdrivesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesCreate_594731, base: "/drive/v3",
    url: url_DriveTeamdrivesCreate_594732, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_594713 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesList_594715(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_594714(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated use drives.list instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token for Team Drives.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   q: JString
  ##    : Query string for searching Team Drives.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   pageSize: JInt
  ##           : Maximum number of Team Drives to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594716 = query.getOrDefault("fields")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "fields", valid_594716
  var valid_594717 = query.getOrDefault("pageToken")
  valid_594717 = validateParameter(valid_594717, JString, required = false,
                                 default = nil)
  if valid_594717 != nil:
    section.add "pageToken", valid_594717
  var valid_594718 = query.getOrDefault("quotaUser")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "quotaUser", valid_594718
  var valid_594719 = query.getOrDefault("alt")
  valid_594719 = validateParameter(valid_594719, JString, required = false,
                                 default = newJString("json"))
  if valid_594719 != nil:
    section.add "alt", valid_594719
  var valid_594720 = query.getOrDefault("oauth_token")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = nil)
  if valid_594720 != nil:
    section.add "oauth_token", valid_594720
  var valid_594721 = query.getOrDefault("userIp")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "userIp", valid_594721
  var valid_594722 = query.getOrDefault("q")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = nil)
  if valid_594722 != nil:
    section.add "q", valid_594722
  var valid_594723 = query.getOrDefault("key")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "key", valid_594723
  var valid_594724 = query.getOrDefault("useDomainAdminAccess")
  valid_594724 = validateParameter(valid_594724, JBool, required = false,
                                 default = newJBool(false))
  if valid_594724 != nil:
    section.add "useDomainAdminAccess", valid_594724
  var valid_594725 = query.getOrDefault("pageSize")
  valid_594725 = validateParameter(valid_594725, JInt, required = false,
                                 default = newJInt(10))
  if valid_594725 != nil:
    section.add "pageSize", valid_594725
  var valid_594726 = query.getOrDefault("prettyPrint")
  valid_594726 = validateParameter(valid_594726, JBool, required = false,
                                 default = newJBool(true))
  if valid_594726 != nil:
    section.add "prettyPrint", valid_594726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594727: Call_DriveTeamdrivesList_594713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_594727.validator(path, query, header, formData, body)
  let scheme = call_594727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594727.url(scheme.get, call_594727.host, call_594727.base,
                         call_594727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594727, url, valid)

proc call*(call_594728: Call_DriveTeamdrivesList_594713; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; q: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; pageSize: int = 10;
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesList
  ## Deprecated use drives.list instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token for Team Drives.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   q: string
  ##    : Query string for searching Team Drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   pageSize: int
  ##           : Maximum number of Team Drives to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594729 = newJObject()
  add(query_594729, "fields", newJString(fields))
  add(query_594729, "pageToken", newJString(pageToken))
  add(query_594729, "quotaUser", newJString(quotaUser))
  add(query_594729, "alt", newJString(alt))
  add(query_594729, "oauth_token", newJString(oauthToken))
  add(query_594729, "userIp", newJString(userIp))
  add(query_594729, "q", newJString(q))
  add(query_594729, "key", newJString(key))
  add(query_594729, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594729, "pageSize", newJInt(pageSize))
  add(query_594729, "prettyPrint", newJBool(prettyPrint))
  result = call_594728.call(nil, query_594729, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_594713(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_594714, base: "/drive/v3",
    url: url_DriveTeamdrivesList_594715, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_594746 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesGet_594748(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_594747(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deprecated use drives.get instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_594749 = path.getOrDefault("teamDriveId")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "teamDriveId", valid_594749
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594750 = query.getOrDefault("fields")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = nil)
  if valid_594750 != nil:
    section.add "fields", valid_594750
  var valid_594751 = query.getOrDefault("quotaUser")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "quotaUser", valid_594751
  var valid_594752 = query.getOrDefault("alt")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = newJString("json"))
  if valid_594752 != nil:
    section.add "alt", valid_594752
  var valid_594753 = query.getOrDefault("oauth_token")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "oauth_token", valid_594753
  var valid_594754 = query.getOrDefault("userIp")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = nil)
  if valid_594754 != nil:
    section.add "userIp", valid_594754
  var valid_594755 = query.getOrDefault("key")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "key", valid_594755
  var valid_594756 = query.getOrDefault("useDomainAdminAccess")
  valid_594756 = validateParameter(valid_594756, JBool, required = false,
                                 default = newJBool(false))
  if valid_594756 != nil:
    section.add "useDomainAdminAccess", valid_594756
  var valid_594757 = query.getOrDefault("prettyPrint")
  valid_594757 = validateParameter(valid_594757, JBool, required = false,
                                 default = newJBool(true))
  if valid_594757 != nil:
    section.add "prettyPrint", valid_594757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594758: Call_DriveTeamdrivesGet_594746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_594758.validator(path, query, header, formData, body)
  let scheme = call_594758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594758.url(scheme.get, call_594758.host, call_594758.base,
                         call_594758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594758, url, valid)

proc call*(call_594759: Call_DriveTeamdrivesGet_594746; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesGet
  ## Deprecated use drives.get instead.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594760 = newJObject()
  var query_594761 = newJObject()
  add(path_594760, "teamDriveId", newJString(teamDriveId))
  add(query_594761, "fields", newJString(fields))
  add(query_594761, "quotaUser", newJString(quotaUser))
  add(query_594761, "alt", newJString(alt))
  add(query_594761, "oauth_token", newJString(oauthToken))
  add(query_594761, "userIp", newJString(userIp))
  add(query_594761, "key", newJString(key))
  add(query_594761, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_594761, "prettyPrint", newJBool(prettyPrint))
  result = call_594759.call(path_594760, query_594761, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_594746(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_594747, base: "/drive/v3",
    url: url_DriveTeamdrivesGet_594748, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_594777 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesUpdate_594779(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_594778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.update instead
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_594780 = path.getOrDefault("teamDriveId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "teamDriveId", valid_594780
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594781 = query.getOrDefault("fields")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "fields", valid_594781
  var valid_594782 = query.getOrDefault("quotaUser")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "quotaUser", valid_594782
  var valid_594783 = query.getOrDefault("alt")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = newJString("json"))
  if valid_594783 != nil:
    section.add "alt", valid_594783
  var valid_594784 = query.getOrDefault("oauth_token")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "oauth_token", valid_594784
  var valid_594785 = query.getOrDefault("userIp")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "userIp", valid_594785
  var valid_594786 = query.getOrDefault("key")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "key", valid_594786
  var valid_594787 = query.getOrDefault("useDomainAdminAccess")
  valid_594787 = validateParameter(valid_594787, JBool, required = false,
                                 default = newJBool(false))
  if valid_594787 != nil:
    section.add "useDomainAdminAccess", valid_594787
  var valid_594788 = query.getOrDefault("prettyPrint")
  valid_594788 = validateParameter(valid_594788, JBool, required = false,
                                 default = newJBool(true))
  if valid_594788 != nil:
    section.add "prettyPrint", valid_594788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594790: Call_DriveTeamdrivesUpdate_594777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead
  ## 
  let valid = call_594790.validator(path, query, header, formData, body)
  let scheme = call_594790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594790.url(scheme.get, call_594790.host, call_594790.base,
                         call_594790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594790, url, valid)

proc call*(call_594791: Call_DriveTeamdrivesUpdate_594777; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          useDomainAdminAccess: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesUpdate
  ## Deprecated use drives.update instead
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594792 = newJObject()
  var query_594793 = newJObject()
  var body_594794 = newJObject()
  add(path_594792, "teamDriveId", newJString(teamDriveId))
  add(query_594793, "fields", newJString(fields))
  add(query_594793, "quotaUser", newJString(quotaUser))
  add(query_594793, "alt", newJString(alt))
  add(query_594793, "oauth_token", newJString(oauthToken))
  add(query_594793, "userIp", newJString(userIp))
  add(query_594793, "key", newJString(key))
  add(query_594793, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_594794 = body
  add(query_594793, "prettyPrint", newJBool(prettyPrint))
  result = call_594791.call(path_594792, query_594793, nil, nil, body_594794)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_594777(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_594778, base: "/drive/v3",
    url: url_DriveTeamdrivesUpdate_594779, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_594762 = ref object of OpenApiRestCall_593424
proc url_DriveTeamdrivesDelete_594764(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_594763(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.delete instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamDriveId: JString (required)
  ##              : The ID of the Team Drive
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `teamDriveId` field"
  var valid_594765 = path.getOrDefault("teamDriveId")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "teamDriveId", valid_594765
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594766 = query.getOrDefault("fields")
  valid_594766 = validateParameter(valid_594766, JString, required = false,
                                 default = nil)
  if valid_594766 != nil:
    section.add "fields", valid_594766
  var valid_594767 = query.getOrDefault("quotaUser")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "quotaUser", valid_594767
  var valid_594768 = query.getOrDefault("alt")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = newJString("json"))
  if valid_594768 != nil:
    section.add "alt", valid_594768
  var valid_594769 = query.getOrDefault("oauth_token")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = nil)
  if valid_594769 != nil:
    section.add "oauth_token", valid_594769
  var valid_594770 = query.getOrDefault("userIp")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "userIp", valid_594770
  var valid_594771 = query.getOrDefault("key")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = nil)
  if valid_594771 != nil:
    section.add "key", valid_594771
  var valid_594772 = query.getOrDefault("prettyPrint")
  valid_594772 = validateParameter(valid_594772, JBool, required = false,
                                 default = newJBool(true))
  if valid_594772 != nil:
    section.add "prettyPrint", valid_594772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594773: Call_DriveTeamdrivesDelete_594762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_594773.validator(path, query, header, formData, body)
  let scheme = call_594773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594773.url(scheme.get, call_594773.host, call_594773.base,
                         call_594773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594773, url, valid)

proc call*(call_594774: Call_DriveTeamdrivesDelete_594762; teamDriveId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## driveTeamdrivesDelete
  ## Deprecated use drives.delete instead.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594775 = newJObject()
  var query_594776 = newJObject()
  add(path_594775, "teamDriveId", newJString(teamDriveId))
  add(query_594776, "fields", newJString(fields))
  add(query_594776, "quotaUser", newJString(quotaUser))
  add(query_594776, "alt", newJString(alt))
  add(query_594776, "oauth_token", newJString(oauthToken))
  add(query_594776, "userIp", newJString(userIp))
  add(query_594776, "key", newJString(key))
  add(query_594776, "prettyPrint", newJBool(prettyPrint))
  result = call_594774.call(path_594775, query_594776, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_594762(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_594763, base: "/drive/v3",
    url: url_DriveTeamdrivesDelete_594764, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
