
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_588725 = ref object of OpenApiRestCall_588457
proc url_DriveAboutGet_588727(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_588726(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588854 = query.getOrDefault("alt")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = newJString("json"))
  if valid_588854 != nil:
    section.add "alt", valid_588854
  var valid_588855 = query.getOrDefault("oauth_token")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "oauth_token", valid_588855
  var valid_588856 = query.getOrDefault("userIp")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "userIp", valid_588856
  var valid_588857 = query.getOrDefault("key")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "key", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588881: Call_DriveAboutGet_588725; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  let valid = call_588881.validator(path, query, header, formData, body)
  let scheme = call_588881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588881.url(scheme.get, call_588881.host, call_588881.base,
                         call_588881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588881, url, valid)

proc call*(call_588952: Call_DriveAboutGet_588725; fields: string = "";
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
  var query_588953 = newJObject()
  add(query_588953, "fields", newJString(fields))
  add(query_588953, "quotaUser", newJString(quotaUser))
  add(query_588953, "alt", newJString(alt))
  add(query_588953, "oauth_token", newJString(oauthToken))
  add(query_588953, "userIp", newJString(userIp))
  add(query_588953, "key", newJString(key))
  add(query_588953, "prettyPrint", newJBool(prettyPrint))
  result = call_588952.call(nil, query_588953, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_588725(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_588726, base: "/drive/v3",
    url: url_DriveAboutGet_588727, schemes: {Scheme.Https})
type
  Call_DriveChangesList_588993 = ref object of OpenApiRestCall_588457
proc url_DriveChangesList_588995(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_588994(path: JsonNode; query: JsonNode;
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
  var valid_588996 = query.getOrDefault("driveId")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "driveId", valid_588996
  var valid_588997 = query.getOrDefault("supportsAllDrives")
  valid_588997 = validateParameter(valid_588997, JBool, required = false,
                                 default = newJBool(false))
  if valid_588997 != nil:
    section.add "supportsAllDrives", valid_588997
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_588999 = query.getOrDefault("pageToken")
  valid_588999 = validateParameter(valid_588999, JString, required = true,
                                 default = nil)
  if valid_588999 != nil:
    section.add "pageToken", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("oauth_token")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "oauth_token", valid_589002
  var valid_589003 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(false))
  if valid_589003 != nil:
    section.add "includeItemsFromAllDrives", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("includeTeamDriveItems")
  valid_589005 = validateParameter(valid_589005, JBool, required = false,
                                 default = newJBool(false))
  if valid_589005 != nil:
    section.add "includeTeamDriveItems", valid_589005
  var valid_589006 = query.getOrDefault("teamDriveId")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "teamDriveId", valid_589006
  var valid_589007 = query.getOrDefault("supportsTeamDrives")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(false))
  if valid_589007 != nil:
    section.add "supportsTeamDrives", valid_589007
  var valid_589008 = query.getOrDefault("key")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "key", valid_589008
  var valid_589009 = query.getOrDefault("spaces")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("drive"))
  if valid_589009 != nil:
    section.add "spaces", valid_589009
  var valid_589011 = query.getOrDefault("pageSize")
  valid_589011 = validateParameter(valid_589011, JInt, required = false,
                                 default = newJInt(100))
  if valid_589011 != nil:
    section.add "pageSize", valid_589011
  var valid_589012 = query.getOrDefault("includeRemoved")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "includeRemoved", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  var valid_589014 = query.getOrDefault("restrictToMyDrive")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(false))
  if valid_589014 != nil:
    section.add "restrictToMyDrive", valid_589014
  var valid_589015 = query.getOrDefault("includeCorpusRemovals")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(false))
  if valid_589015 != nil:
    section.add "includeCorpusRemovals", valid_589015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589016: Call_DriveChangesList_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_DriveChangesList_588993; pageToken: string;
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
  var query_589018 = newJObject()
  add(query_589018, "driveId", newJString(driveId))
  add(query_589018, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "pageToken", newJString(pageToken))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589018, "userIp", newJString(userIp))
  add(query_589018, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589018, "teamDriveId", newJString(teamDriveId))
  add(query_589018, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589018, "key", newJString(key))
  add(query_589018, "spaces", newJString(spaces))
  add(query_589018, "pageSize", newJInt(pageSize))
  add(query_589018, "includeRemoved", newJBool(includeRemoved))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  add(query_589018, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_589018, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_589017.call(nil, query_589018, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_588993(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_588994, base: "/drive/v3",
    url: url_DriveChangesList_588995, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_589019 = ref object of OpenApiRestCall_588457
proc url_DriveChangesGetStartPageToken_589021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_589020(path: JsonNode; query: JsonNode;
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
  var valid_589022 = query.getOrDefault("driveId")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "driveId", valid_589022
  var valid_589023 = query.getOrDefault("supportsAllDrives")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(false))
  if valid_589023 != nil:
    section.add "supportsAllDrives", valid_589023
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("quotaUser")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "quotaUser", valid_589025
  var valid_589026 = query.getOrDefault("alt")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("json"))
  if valid_589026 != nil:
    section.add "alt", valid_589026
  var valid_589027 = query.getOrDefault("oauth_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "oauth_token", valid_589027
  var valid_589028 = query.getOrDefault("userIp")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "userIp", valid_589028
  var valid_589029 = query.getOrDefault("teamDriveId")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "teamDriveId", valid_589029
  var valid_589030 = query.getOrDefault("supportsTeamDrives")
  valid_589030 = validateParameter(valid_589030, JBool, required = false,
                                 default = newJBool(false))
  if valid_589030 != nil:
    section.add "supportsTeamDrives", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589033: Call_DriveChangesGetStartPageToken_589019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_589033.validator(path, query, header, formData, body)
  let scheme = call_589033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589033.url(scheme.get, call_589033.host, call_589033.base,
                         call_589033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589033, url, valid)

proc call*(call_589034: Call_DriveChangesGetStartPageToken_589019;
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
  var query_589035 = newJObject()
  add(query_589035, "driveId", newJString(driveId))
  add(query_589035, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589035, "fields", newJString(fields))
  add(query_589035, "quotaUser", newJString(quotaUser))
  add(query_589035, "alt", newJString(alt))
  add(query_589035, "oauth_token", newJString(oauthToken))
  add(query_589035, "userIp", newJString(userIp))
  add(query_589035, "teamDriveId", newJString(teamDriveId))
  add(query_589035, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589035, "key", newJString(key))
  add(query_589035, "prettyPrint", newJBool(prettyPrint))
  result = call_589034.call(nil, query_589035, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_589019(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_589020, base: "/drive/v3",
    url: url_DriveChangesGetStartPageToken_589021, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_589036 = ref object of OpenApiRestCall_588457
proc url_DriveChangesWatch_589038(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_589037(path: JsonNode; query: JsonNode;
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
  var valid_589039 = query.getOrDefault("driveId")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "driveId", valid_589039
  var valid_589040 = query.getOrDefault("supportsAllDrives")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(false))
  if valid_589040 != nil:
    section.add "supportsAllDrives", valid_589040
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_589042 = query.getOrDefault("pageToken")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "pageToken", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("oauth_token")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "oauth_token", valid_589045
  var valid_589046 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589046 = validateParameter(valid_589046, JBool, required = false,
                                 default = newJBool(false))
  if valid_589046 != nil:
    section.add "includeItemsFromAllDrives", valid_589046
  var valid_589047 = query.getOrDefault("userIp")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "userIp", valid_589047
  var valid_589048 = query.getOrDefault("includeTeamDriveItems")
  valid_589048 = validateParameter(valid_589048, JBool, required = false,
                                 default = newJBool(false))
  if valid_589048 != nil:
    section.add "includeTeamDriveItems", valid_589048
  var valid_589049 = query.getOrDefault("teamDriveId")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "teamDriveId", valid_589049
  var valid_589050 = query.getOrDefault("supportsTeamDrives")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(false))
  if valid_589050 != nil:
    section.add "supportsTeamDrives", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("spaces")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("drive"))
  if valid_589052 != nil:
    section.add "spaces", valid_589052
  var valid_589053 = query.getOrDefault("pageSize")
  valid_589053 = validateParameter(valid_589053, JInt, required = false,
                                 default = newJInt(100))
  if valid_589053 != nil:
    section.add "pageSize", valid_589053
  var valid_589054 = query.getOrDefault("includeRemoved")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "includeRemoved", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  var valid_589056 = query.getOrDefault("restrictToMyDrive")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(false))
  if valid_589056 != nil:
    section.add "restrictToMyDrive", valid_589056
  var valid_589057 = query.getOrDefault("includeCorpusRemovals")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(false))
  if valid_589057 != nil:
    section.add "includeCorpusRemovals", valid_589057
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

proc call*(call_589059: Call_DriveChangesWatch_589036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes for a user.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_DriveChangesWatch_589036; pageToken: string;
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
  var query_589061 = newJObject()
  var body_589062 = newJObject()
  add(query_589061, "driveId", newJString(driveId))
  add(query_589061, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "pageToken", newJString(pageToken))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(query_589061, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589061, "userIp", newJString(userIp))
  add(query_589061, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589061, "teamDriveId", newJString(teamDriveId))
  add(query_589061, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589061, "key", newJString(key))
  add(query_589061, "spaces", newJString(spaces))
  add(query_589061, "pageSize", newJInt(pageSize))
  add(query_589061, "includeRemoved", newJBool(includeRemoved))
  if resource != nil:
    body_589062 = resource
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  add(query_589061, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_589061, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_589060.call(nil, query_589061, nil, nil, body_589062)

var driveChangesWatch* = Call_DriveChangesWatch_589036(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_589037, base: "/drive/v3",
    url: url_DriveChangesWatch_589038, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_589063 = ref object of OpenApiRestCall_588457
proc url_DriveChannelsStop_589065(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_589064(path: JsonNode; query: JsonNode;
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
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("userIp")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "userIp", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
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

proc call*(call_589074: Call_DriveChannelsStop_589063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_DriveChannelsStop_589063; fields: string = "";
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
  var query_589076 = newJObject()
  var body_589077 = newJObject()
  add(query_589076, "fields", newJString(fields))
  add(query_589076, "quotaUser", newJString(quotaUser))
  add(query_589076, "alt", newJString(alt))
  add(query_589076, "oauth_token", newJString(oauthToken))
  add(query_589076, "userIp", newJString(userIp))
  add(query_589076, "key", newJString(key))
  if resource != nil:
    body_589077 = resource
  add(query_589076, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(nil, query_589076, nil, nil, body_589077)

var driveChannelsStop* = Call_DriveChannelsStop_589063(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_589064, base: "/drive/v3",
    url: url_DriveChannelsStop_589065, schemes: {Scheme.Https})
type
  Call_DriveDrivesCreate_589095 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesCreate_589097(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesCreate_589096(path: JsonNode; query: JsonNode;
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
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_589099 = query.getOrDefault("requestId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "requestId", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("userIp")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "userIp", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("prettyPrint")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "prettyPrint", valid_589105
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

proc call*(call_589107: Call_DriveDrivesCreate_589095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_589107.validator(path, query, header, formData, body)
  let scheme = call_589107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589107.url(scheme.get, call_589107.host, call_589107.base,
                         call_589107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589107, url, valid)

proc call*(call_589108: Call_DriveDrivesCreate_589095; requestId: string;
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
  var query_589109 = newJObject()
  var body_589110 = newJObject()
  add(query_589109, "fields", newJString(fields))
  add(query_589109, "requestId", newJString(requestId))
  add(query_589109, "quotaUser", newJString(quotaUser))
  add(query_589109, "alt", newJString(alt))
  add(query_589109, "oauth_token", newJString(oauthToken))
  add(query_589109, "userIp", newJString(userIp))
  add(query_589109, "key", newJString(key))
  if body != nil:
    body_589110 = body
  add(query_589109, "prettyPrint", newJBool(prettyPrint))
  result = call_589108.call(nil, query_589109, nil, nil, body_589110)

var driveDrivesCreate* = Call_DriveDrivesCreate_589095(name: "driveDrivesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesCreate_589096, base: "/drive/v3",
    url: url_DriveDrivesCreate_589097, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_589078 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesList_589080(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_589079(path: JsonNode; query: JsonNode;
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
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("pageToken")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "pageToken", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("userIp")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "userIp", valid_589086
  var valid_589087 = query.getOrDefault("q")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "q", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("useDomainAdminAccess")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(false))
  if valid_589089 != nil:
    section.add "useDomainAdminAccess", valid_589089
  var valid_589090 = query.getOrDefault("pageSize")
  valid_589090 = validateParameter(valid_589090, JInt, required = false,
                                 default = newJInt(10))
  if valid_589090 != nil:
    section.add "pageSize", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_DriveDrivesList_589078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_DriveDrivesList_589078; fields: string = "";
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
  var query_589094 = newJObject()
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "pageToken", newJString(pageToken))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "userIp", newJString(userIp))
  add(query_589094, "q", newJString(q))
  add(query_589094, "key", newJString(key))
  add(query_589094, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589094, "pageSize", newJInt(pageSize))
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(nil, query_589094, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_589078(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_589079, base: "/drive/v3",
    url: url_DriveDrivesList_589080, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_589111 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesGet_589113(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesGet_589112(path: JsonNode; query: JsonNode;
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
  var valid_589128 = path.getOrDefault("driveId")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "driveId", valid_589128
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
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("userIp")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "userIp", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("useDomainAdminAccess")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(false))
  if valid_589135 != nil:
    section.add "useDomainAdminAccess", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_DriveDrivesGet_589111; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_DriveDrivesGet_589111; driveId: string;
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
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  add(query_589140, "fields", newJString(fields))
  add(path_589139, "driveId", newJString(driveId))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "userIp", newJString(userIp))
  add(query_589140, "key", newJString(key))
  add(query_589140, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_589111(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_589112,
    base: "/drive/v3", url: url_DriveDrivesGet_589113, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_589156 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesUpdate_589158(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_589157(path: JsonNode; query: JsonNode;
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
  var valid_589159 = path.getOrDefault("driveId")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "driveId", valid_589159
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
  var valid_589160 = query.getOrDefault("fields")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "fields", valid_589160
  var valid_589161 = query.getOrDefault("quotaUser")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "quotaUser", valid_589161
  var valid_589162 = query.getOrDefault("alt")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("json"))
  if valid_589162 != nil:
    section.add "alt", valid_589162
  var valid_589163 = query.getOrDefault("oauth_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "oauth_token", valid_589163
  var valid_589164 = query.getOrDefault("userIp")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "userIp", valid_589164
  var valid_589165 = query.getOrDefault("key")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "key", valid_589165
  var valid_589166 = query.getOrDefault("useDomainAdminAccess")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(false))
  if valid_589166 != nil:
    section.add "useDomainAdminAccess", valid_589166
  var valid_589167 = query.getOrDefault("prettyPrint")
  valid_589167 = validateParameter(valid_589167, JBool, required = false,
                                 default = newJBool(true))
  if valid_589167 != nil:
    section.add "prettyPrint", valid_589167
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

proc call*(call_589169: Call_DriveDrivesUpdate_589156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadate for a shared drive.
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_DriveDrivesUpdate_589156; driveId: string;
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
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  var body_589173 = newJObject()
  add(query_589172, "fields", newJString(fields))
  add(path_589171, "driveId", newJString(driveId))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(query_589172, "alt", newJString(alt))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "userIp", newJString(userIp))
  add(query_589172, "key", newJString(key))
  add(query_589172, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_589173 = body
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  result = call_589170.call(path_589171, query_589172, nil, nil, body_589173)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_589156(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_589157,
    base: "/drive/v3", url: url_DriveDrivesUpdate_589158, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_589141 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesDelete_589143(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "driveId" in path, "`driveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/drives/"),
               (kind: VariableSegment, value: "driveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveDrivesDelete_589142(path: JsonNode; query: JsonNode;
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
  var valid_589144 = path.getOrDefault("driveId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "driveId", valid_589144
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
  var valid_589145 = query.getOrDefault("fields")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "fields", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("userIp")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "userIp", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589152: Call_DriveDrivesDelete_589141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_DriveDrivesDelete_589141; driveId: string;
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
  var path_589154 = newJObject()
  var query_589155 = newJObject()
  add(query_589155, "fields", newJString(fields))
  add(path_589154, "driveId", newJString(driveId))
  add(query_589155, "quotaUser", newJString(quotaUser))
  add(query_589155, "alt", newJString(alt))
  add(query_589155, "oauth_token", newJString(oauthToken))
  add(query_589155, "userIp", newJString(userIp))
  add(query_589155, "key", newJString(key))
  add(query_589155, "prettyPrint", newJBool(prettyPrint))
  result = call_589153.call(path_589154, query_589155, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_589141(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_589142,
    base: "/drive/v3", url: url_DriveDrivesDelete_589143, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_589174 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesHide_589176(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveDrivesHide_589175(path: JsonNode; query: JsonNode;
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
  var valid_589177 = path.getOrDefault("driveId")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "driveId", valid_589177
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
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("quotaUser")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "quotaUser", valid_589179
  var valid_589180 = query.getOrDefault("alt")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("json"))
  if valid_589180 != nil:
    section.add "alt", valid_589180
  var valid_589181 = query.getOrDefault("oauth_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "oauth_token", valid_589181
  var valid_589182 = query.getOrDefault("userIp")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "userIp", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("prettyPrint")
  valid_589184 = validateParameter(valid_589184, JBool, required = false,
                                 default = newJBool(true))
  if valid_589184 != nil:
    section.add "prettyPrint", valid_589184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589185: Call_DriveDrivesHide_589174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_DriveDrivesHide_589174; driveId: string;
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
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  add(query_589188, "fields", newJString(fields))
  add(path_589187, "driveId", newJString(driveId))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "userIp", newJString(userIp))
  add(query_589188, "key", newJString(key))
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589186.call(path_589187, query_589188, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_589174(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_589175,
    base: "/drive/v3", url: url_DriveDrivesHide_589176, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_589189 = ref object of OpenApiRestCall_588457
proc url_DriveDrivesUnhide_589191(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveDrivesUnhide_589190(path: JsonNode; query: JsonNode;
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
  var valid_589192 = path.getOrDefault("driveId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "driveId", valid_589192
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
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("userIp")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "userIp", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589200: Call_DriveDrivesUnhide_589189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_DriveDrivesUnhide_589189; driveId: string;
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
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  add(query_589203, "fields", newJString(fields))
  add(path_589202, "driveId", newJString(driveId))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(query_589203, "userIp", newJString(userIp))
  add(query_589203, "key", newJString(key))
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(path_589202, query_589203, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_589189(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_589190,
    base: "/drive/v3", url: url_DriveDrivesUnhide_589191, schemes: {Scheme.Https})
type
  Call_DriveFilesCreate_589230 = ref object of OpenApiRestCall_588457
proc url_DriveFilesCreate_589232(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesCreate_589231(path: JsonNode; query: JsonNode;
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
  var valid_589233 = query.getOrDefault("supportsAllDrives")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(false))
  if valid_589233 != nil:
    section.add "supportsAllDrives", valid_589233
  var valid_589234 = query.getOrDefault("fields")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "fields", valid_589234
  var valid_589235 = query.getOrDefault("quotaUser")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "quotaUser", valid_589235
  var valid_589236 = query.getOrDefault("alt")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("json"))
  if valid_589236 != nil:
    section.add "alt", valid_589236
  var valid_589237 = query.getOrDefault("oauth_token")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "oauth_token", valid_589237
  var valid_589238 = query.getOrDefault("userIp")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "userIp", valid_589238
  var valid_589239 = query.getOrDefault("keepRevisionForever")
  valid_589239 = validateParameter(valid_589239, JBool, required = false,
                                 default = newJBool(false))
  if valid_589239 != nil:
    section.add "keepRevisionForever", valid_589239
  var valid_589240 = query.getOrDefault("supportsTeamDrives")
  valid_589240 = validateParameter(valid_589240, JBool, required = false,
                                 default = newJBool(false))
  if valid_589240 != nil:
    section.add "supportsTeamDrives", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("useContentAsIndexableText")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(false))
  if valid_589242 != nil:
    section.add "useContentAsIndexableText", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
  var valid_589244 = query.getOrDefault("ignoreDefaultVisibility")
  valid_589244 = validateParameter(valid_589244, JBool, required = false,
                                 default = newJBool(false))
  if valid_589244 != nil:
    section.add "ignoreDefaultVisibility", valid_589244
  var valid_589245 = query.getOrDefault("ocrLanguage")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "ocrLanguage", valid_589245
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

proc call*(call_589247: Call_DriveFilesCreate_589230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new file.
  ## 
  let valid = call_589247.validator(path, query, header, formData, body)
  let scheme = call_589247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589247.url(scheme.get, call_589247.host, call_589247.base,
                         call_589247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589247, url, valid)

proc call*(call_589248: Call_DriveFilesCreate_589230;
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
  var query_589249 = newJObject()
  var body_589250 = newJObject()
  add(query_589249, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589249, "fields", newJString(fields))
  add(query_589249, "quotaUser", newJString(quotaUser))
  add(query_589249, "alt", newJString(alt))
  add(query_589249, "oauth_token", newJString(oauthToken))
  add(query_589249, "userIp", newJString(userIp))
  add(query_589249, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_589249, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589249, "key", newJString(key))
  add(query_589249, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_589250 = body
  add(query_589249, "prettyPrint", newJBool(prettyPrint))
  add(query_589249, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_589249, "ocrLanguage", newJString(ocrLanguage))
  result = call_589248.call(nil, query_589249, nil, nil, body_589250)

var driveFilesCreate* = Call_DriveFilesCreate_589230(name: "driveFilesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesCreate_589231, base: "/drive/v3",
    url: url_DriveFilesCreate_589232, schemes: {Scheme.Https})
type
  Call_DriveFilesList_589204 = ref object of OpenApiRestCall_588457
proc url_DriveFilesList_589206(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_589205(path: JsonNode; query: JsonNode;
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
  var valid_589207 = query.getOrDefault("driveId")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "driveId", valid_589207
  var valid_589208 = query.getOrDefault("supportsAllDrives")
  valid_589208 = validateParameter(valid_589208, JBool, required = false,
                                 default = newJBool(false))
  if valid_589208 != nil:
    section.add "supportsAllDrives", valid_589208
  var valid_589209 = query.getOrDefault("fields")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "fields", valid_589209
  var valid_589210 = query.getOrDefault("pageToken")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "pageToken", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("includeItemsFromAllDrives")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(false))
  if valid_589214 != nil:
    section.add "includeItemsFromAllDrives", valid_589214
  var valid_589215 = query.getOrDefault("userIp")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "userIp", valid_589215
  var valid_589216 = query.getOrDefault("includeTeamDriveItems")
  valid_589216 = validateParameter(valid_589216, JBool, required = false,
                                 default = newJBool(false))
  if valid_589216 != nil:
    section.add "includeTeamDriveItems", valid_589216
  var valid_589217 = query.getOrDefault("teamDriveId")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "teamDriveId", valid_589217
  var valid_589218 = query.getOrDefault("corpus")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("domain"))
  if valid_589218 != nil:
    section.add "corpus", valid_589218
  var valid_589219 = query.getOrDefault("orderBy")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "orderBy", valid_589219
  var valid_589220 = query.getOrDefault("q")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "q", valid_589220
  var valid_589221 = query.getOrDefault("supportsTeamDrives")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(false))
  if valid_589221 != nil:
    section.add "supportsTeamDrives", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("spaces")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("drive"))
  if valid_589223 != nil:
    section.add "spaces", valid_589223
  var valid_589224 = query.getOrDefault("pageSize")
  valid_589224 = validateParameter(valid_589224, JInt, required = false,
                                 default = newJInt(100))
  if valid_589224 != nil:
    section.add "pageSize", valid_589224
  var valid_589225 = query.getOrDefault("corpora")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "corpora", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589227: Call_DriveFilesList_589204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists or searches files.
  ## 
  let valid = call_589227.validator(path, query, header, formData, body)
  let scheme = call_589227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589227.url(scheme.get, call_589227.host, call_589227.base,
                         call_589227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589227, url, valid)

proc call*(call_589228: Call_DriveFilesList_589204; driveId: string = "";
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
  var query_589229 = newJObject()
  add(query_589229, "driveId", newJString(driveId))
  add(query_589229, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "pageToken", newJString(pageToken))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(query_589229, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_589229, "userIp", newJString(userIp))
  add(query_589229, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_589229, "teamDriveId", newJString(teamDriveId))
  add(query_589229, "corpus", newJString(corpus))
  add(query_589229, "orderBy", newJString(orderBy))
  add(query_589229, "q", newJString(q))
  add(query_589229, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589229, "key", newJString(key))
  add(query_589229, "spaces", newJString(spaces))
  add(query_589229, "pageSize", newJInt(pageSize))
  add(query_589229, "corpora", newJString(corpora))
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  result = call_589228.call(nil, query_589229, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_589204(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_589205, base: "/drive/v3",
    url: url_DriveFilesList_589206, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_589251 = ref object of OpenApiRestCall_588457
proc url_DriveFilesGenerateIds_589253(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_589252(path: JsonNode; query: JsonNode;
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
  var valid_589254 = query.getOrDefault("fields")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "fields", valid_589254
  var valid_589255 = query.getOrDefault("quotaUser")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "quotaUser", valid_589255
  var valid_589256 = query.getOrDefault("alt")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("json"))
  if valid_589256 != nil:
    section.add "alt", valid_589256
  var valid_589257 = query.getOrDefault("oauth_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "oauth_token", valid_589257
  var valid_589258 = query.getOrDefault("space")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = newJString("drive"))
  if valid_589258 != nil:
    section.add "space", valid_589258
  var valid_589259 = query.getOrDefault("userIp")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "userIp", valid_589259
  var valid_589260 = query.getOrDefault("key")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "key", valid_589260
  var valid_589261 = query.getOrDefault("prettyPrint")
  valid_589261 = validateParameter(valid_589261, JBool, required = false,
                                 default = newJBool(true))
  if valid_589261 != nil:
    section.add "prettyPrint", valid_589261
  var valid_589262 = query.getOrDefault("count")
  valid_589262 = validateParameter(valid_589262, JInt, required = false,
                                 default = newJInt(10))
  if valid_589262 != nil:
    section.add "count", valid_589262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589263: Call_DriveFilesGenerateIds_589251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  let valid = call_589263.validator(path, query, header, formData, body)
  let scheme = call_589263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589263.url(scheme.get, call_589263.host, call_589263.base,
                         call_589263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589263, url, valid)

proc call*(call_589264: Call_DriveFilesGenerateIds_589251; fields: string = "";
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
  var query_589265 = newJObject()
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(query_589265, "space", newJString(space))
  add(query_589265, "userIp", newJString(userIp))
  add(query_589265, "key", newJString(key))
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  add(query_589265, "count", newJInt(count))
  result = call_589264.call(nil, query_589265, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_589251(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_589252, base: "/drive/v3",
    url: url_DriveFilesGenerateIds_589253, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_589266 = ref object of OpenApiRestCall_588457
proc url_DriveFilesEmptyTrash_589268(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_589267(path: JsonNode; query: JsonNode;
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
  var valid_589269 = query.getOrDefault("fields")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "fields", valid_589269
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("userIp")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "userIp", valid_589273
  var valid_589274 = query.getOrDefault("key")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "key", valid_589274
  var valid_589275 = query.getOrDefault("prettyPrint")
  valid_589275 = validateParameter(valid_589275, JBool, required = false,
                                 default = newJBool(true))
  if valid_589275 != nil:
    section.add "prettyPrint", valid_589275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589276: Call_DriveFilesEmptyTrash_589266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_589276.validator(path, query, header, formData, body)
  let scheme = call_589276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589276.url(scheme.get, call_589276.host, call_589276.base,
                         call_589276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589276, url, valid)

proc call*(call_589277: Call_DriveFilesEmptyTrash_589266; fields: string = "";
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
  var query_589278 = newJObject()
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(query_589278, "userIp", newJString(userIp))
  add(query_589278, "key", newJString(key))
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  result = call_589277.call(nil, query_589278, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_589266(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_589267, base: "/drive/v3",
    url: url_DriveFilesEmptyTrash_589268, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_589279 = ref object of OpenApiRestCall_588457
proc url_DriveFilesGet_589281(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesGet_589280(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589282 = path.getOrDefault("fileId")
  valid_589282 = validateParameter(valid_589282, JString, required = true,
                                 default = nil)
  if valid_589282 != nil:
    section.add "fileId", valid_589282
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
  var valid_589283 = query.getOrDefault("supportsAllDrives")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(false))
  if valid_589283 != nil:
    section.add "supportsAllDrives", valid_589283
  var valid_589284 = query.getOrDefault("fields")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "fields", valid_589284
  var valid_589285 = query.getOrDefault("quotaUser")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "quotaUser", valid_589285
  var valid_589286 = query.getOrDefault("alt")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = newJString("json"))
  if valid_589286 != nil:
    section.add "alt", valid_589286
  var valid_589287 = query.getOrDefault("acknowledgeAbuse")
  valid_589287 = validateParameter(valid_589287, JBool, required = false,
                                 default = newJBool(false))
  if valid_589287 != nil:
    section.add "acknowledgeAbuse", valid_589287
  var valid_589288 = query.getOrDefault("oauth_token")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "oauth_token", valid_589288
  var valid_589289 = query.getOrDefault("userIp")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "userIp", valid_589289
  var valid_589290 = query.getOrDefault("supportsTeamDrives")
  valid_589290 = validateParameter(valid_589290, JBool, required = false,
                                 default = newJBool(false))
  if valid_589290 != nil:
    section.add "supportsTeamDrives", valid_589290
  var valid_589291 = query.getOrDefault("key")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "key", valid_589291
  var valid_589292 = query.getOrDefault("prettyPrint")
  valid_589292 = validateParameter(valid_589292, JBool, required = false,
                                 default = newJBool(true))
  if valid_589292 != nil:
    section.add "prettyPrint", valid_589292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589293: Call_DriveFilesGet_589279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata or content by ID.
  ## 
  let valid = call_589293.validator(path, query, header, formData, body)
  let scheme = call_589293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589293.url(scheme.get, call_589293.host, call_589293.base,
                         call_589293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589293, url, valid)

proc call*(call_589294: Call_DriveFilesGet_589279; fileId: string;
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
  var path_589295 = newJObject()
  var query_589296 = newJObject()
  add(query_589296, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589296, "fields", newJString(fields))
  add(query_589296, "quotaUser", newJString(quotaUser))
  add(path_589295, "fileId", newJString(fileId))
  add(query_589296, "alt", newJString(alt))
  add(query_589296, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_589296, "oauth_token", newJString(oauthToken))
  add(query_589296, "userIp", newJString(userIp))
  add(query_589296, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589296, "key", newJString(key))
  add(query_589296, "prettyPrint", newJBool(prettyPrint))
  result = call_589294.call(path_589295, query_589296, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_589279(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_589280, base: "/drive/v3",
    url: url_DriveFilesGet_589281, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_589314 = ref object of OpenApiRestCall_588457
proc url_DriveFilesUpdate_589316(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesUpdate_589315(path: JsonNode; query: JsonNode;
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
  var valid_589317 = path.getOrDefault("fileId")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "fileId", valid_589317
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
  var valid_589318 = query.getOrDefault("supportsAllDrives")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(false))
  if valid_589318 != nil:
    section.add "supportsAllDrives", valid_589318
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("keepRevisionForever")
  valid_589324 = validateParameter(valid_589324, JBool, required = false,
                                 default = newJBool(false))
  if valid_589324 != nil:
    section.add "keepRevisionForever", valid_589324
  var valid_589325 = query.getOrDefault("supportsTeamDrives")
  valid_589325 = validateParameter(valid_589325, JBool, required = false,
                                 default = newJBool(false))
  if valid_589325 != nil:
    section.add "supportsTeamDrives", valid_589325
  var valid_589326 = query.getOrDefault("key")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "key", valid_589326
  var valid_589327 = query.getOrDefault("useContentAsIndexableText")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(false))
  if valid_589327 != nil:
    section.add "useContentAsIndexableText", valid_589327
  var valid_589328 = query.getOrDefault("addParents")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "addParents", valid_589328
  var valid_589329 = query.getOrDefault("prettyPrint")
  valid_589329 = validateParameter(valid_589329, JBool, required = false,
                                 default = newJBool(true))
  if valid_589329 != nil:
    section.add "prettyPrint", valid_589329
  var valid_589330 = query.getOrDefault("removeParents")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "removeParents", valid_589330
  var valid_589331 = query.getOrDefault("ocrLanguage")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "ocrLanguage", valid_589331
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

proc call*(call_589333: Call_DriveFilesUpdate_589314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  let valid = call_589333.validator(path, query, header, formData, body)
  let scheme = call_589333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589333.url(scheme.get, call_589333.host, call_589333.base,
                         call_589333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589333, url, valid)

proc call*(call_589334: Call_DriveFilesUpdate_589314; fileId: string;
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
  var path_589335 = newJObject()
  var query_589336 = newJObject()
  var body_589337 = newJObject()
  add(query_589336, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589336, "fields", newJString(fields))
  add(query_589336, "quotaUser", newJString(quotaUser))
  add(path_589335, "fileId", newJString(fileId))
  add(query_589336, "alt", newJString(alt))
  add(query_589336, "oauth_token", newJString(oauthToken))
  add(query_589336, "userIp", newJString(userIp))
  add(query_589336, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_589336, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589336, "key", newJString(key))
  add(query_589336, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_589336, "addParents", newJString(addParents))
  add(query_589336, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_589337 = body
  add(query_589336, "removeParents", newJString(removeParents))
  add(query_589336, "ocrLanguage", newJString(ocrLanguage))
  result = call_589334.call(path_589335, query_589336, nil, nil, body_589337)

var driveFilesUpdate* = Call_DriveFilesUpdate_589314(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesUpdate_589315,
    base: "/drive/v3", url: url_DriveFilesUpdate_589316, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_589297 = ref object of OpenApiRestCall_588457
proc url_DriveFilesDelete_589299(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "fileId" in path, "`fileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "fileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveFilesDelete_589298(path: JsonNode; query: JsonNode;
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
  var valid_589300 = path.getOrDefault("fileId")
  valid_589300 = validateParameter(valid_589300, JString, required = true,
                                 default = nil)
  if valid_589300 != nil:
    section.add "fileId", valid_589300
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
  var valid_589301 = query.getOrDefault("supportsAllDrives")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(false))
  if valid_589301 != nil:
    section.add "supportsAllDrives", valid_589301
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("quotaUser")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "quotaUser", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("userIp")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "userIp", valid_589306
  var valid_589307 = query.getOrDefault("supportsTeamDrives")
  valid_589307 = validateParameter(valid_589307, JBool, required = false,
                                 default = newJBool(false))
  if valid_589307 != nil:
    section.add "supportsTeamDrives", valid_589307
  var valid_589308 = query.getOrDefault("key")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "key", valid_589308
  var valid_589309 = query.getOrDefault("prettyPrint")
  valid_589309 = validateParameter(valid_589309, JBool, required = false,
                                 default = newJBool(true))
  if valid_589309 != nil:
    section.add "prettyPrint", valid_589309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589310: Call_DriveFilesDelete_589297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  let valid = call_589310.validator(path, query, header, formData, body)
  let scheme = call_589310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589310.url(scheme.get, call_589310.host, call_589310.base,
                         call_589310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589310, url, valid)

proc call*(call_589311: Call_DriveFilesDelete_589297; fileId: string;
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
  var path_589312 = newJObject()
  var query_589313 = newJObject()
  add(query_589313, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589313, "fields", newJString(fields))
  add(query_589313, "quotaUser", newJString(quotaUser))
  add(path_589312, "fileId", newJString(fileId))
  add(query_589313, "alt", newJString(alt))
  add(query_589313, "oauth_token", newJString(oauthToken))
  add(query_589313, "userIp", newJString(userIp))
  add(query_589313, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589313, "key", newJString(key))
  add(query_589313, "prettyPrint", newJBool(prettyPrint))
  result = call_589311.call(path_589312, query_589313, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_589297(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_589298,
    base: "/drive/v3", url: url_DriveFilesDelete_589299, schemes: {Scheme.Https})
type
  Call_DriveCommentsCreate_589357 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsCreate_589359(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveCommentsCreate_589358(path: JsonNode; query: JsonNode;
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
  var valid_589360 = path.getOrDefault("fileId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "fileId", valid_589360
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
  var valid_589361 = query.getOrDefault("fields")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "fields", valid_589361
  var valid_589362 = query.getOrDefault("quotaUser")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "quotaUser", valid_589362
  var valid_589363 = query.getOrDefault("alt")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("json"))
  if valid_589363 != nil:
    section.add "alt", valid_589363
  var valid_589364 = query.getOrDefault("oauth_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "oauth_token", valid_589364
  var valid_589365 = query.getOrDefault("userIp")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "userIp", valid_589365
  var valid_589366 = query.getOrDefault("key")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "key", valid_589366
  var valid_589367 = query.getOrDefault("prettyPrint")
  valid_589367 = validateParameter(valid_589367, JBool, required = false,
                                 default = newJBool(true))
  if valid_589367 != nil:
    section.add "prettyPrint", valid_589367
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

proc call*(call_589369: Call_DriveCommentsCreate_589357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on a file.
  ## 
  let valid = call_589369.validator(path, query, header, formData, body)
  let scheme = call_589369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589369.url(scheme.get, call_589369.host, call_589369.base,
                         call_589369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589369, url, valid)

proc call*(call_589370: Call_DriveCommentsCreate_589357; fileId: string;
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
  var path_589371 = newJObject()
  var query_589372 = newJObject()
  var body_589373 = newJObject()
  add(query_589372, "fields", newJString(fields))
  add(query_589372, "quotaUser", newJString(quotaUser))
  add(path_589371, "fileId", newJString(fileId))
  add(query_589372, "alt", newJString(alt))
  add(query_589372, "oauth_token", newJString(oauthToken))
  add(query_589372, "userIp", newJString(userIp))
  add(query_589372, "key", newJString(key))
  if body != nil:
    body_589373 = body
  add(query_589372, "prettyPrint", newJBool(prettyPrint))
  result = call_589370.call(path_589371, query_589372, nil, nil, body_589373)

var driveCommentsCreate* = Call_DriveCommentsCreate_589357(
    name: "driveCommentsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsCreate_589358, base: "/drive/v3",
    url: url_DriveCommentsCreate_589359, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_589338 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsList_589340(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveCommentsList_589339(path: JsonNode; query: JsonNode;
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
  var valid_589341 = path.getOrDefault("fileId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "fileId", valid_589341
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
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("pageToken")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "pageToken", valid_589343
  var valid_589344 = query.getOrDefault("quotaUser")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "quotaUser", valid_589344
  var valid_589345 = query.getOrDefault("alt")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = newJString("json"))
  if valid_589345 != nil:
    section.add "alt", valid_589345
  var valid_589346 = query.getOrDefault("oauth_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "oauth_token", valid_589346
  var valid_589347 = query.getOrDefault("userIp")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "userIp", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("includeDeleted")
  valid_589349 = validateParameter(valid_589349, JBool, required = false,
                                 default = newJBool(false))
  if valid_589349 != nil:
    section.add "includeDeleted", valid_589349
  var valid_589350 = query.getOrDefault("pageSize")
  valid_589350 = validateParameter(valid_589350, JInt, required = false,
                                 default = newJInt(20))
  if valid_589350 != nil:
    section.add "pageSize", valid_589350
  var valid_589351 = query.getOrDefault("prettyPrint")
  valid_589351 = validateParameter(valid_589351, JBool, required = false,
                                 default = newJBool(true))
  if valid_589351 != nil:
    section.add "prettyPrint", valid_589351
  var valid_589352 = query.getOrDefault("startModifiedTime")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "startModifiedTime", valid_589352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589353: Call_DriveCommentsList_589338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_DriveCommentsList_589338; fileId: string;
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
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "pageToken", newJString(pageToken))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(path_589355, "fileId", newJString(fileId))
  add(query_589356, "alt", newJString(alt))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(query_589356, "userIp", newJString(userIp))
  add(query_589356, "key", newJString(key))
  add(query_589356, "includeDeleted", newJBool(includeDeleted))
  add(query_589356, "pageSize", newJInt(pageSize))
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  add(query_589356, "startModifiedTime", newJString(startModifiedTime))
  result = call_589354.call(path_589355, query_589356, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_589338(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_589339,
    base: "/drive/v3", url: url_DriveCommentsList_589340, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_589374 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsGet_589376(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveCommentsGet_589375(path: JsonNode; query: JsonNode;
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
  var valid_589377 = path.getOrDefault("fileId")
  valid_589377 = validateParameter(valid_589377, JString, required = true,
                                 default = nil)
  if valid_589377 != nil:
    section.add "fileId", valid_589377
  var valid_589378 = path.getOrDefault("commentId")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "commentId", valid_589378
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
  var valid_589379 = query.getOrDefault("fields")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "fields", valid_589379
  var valid_589380 = query.getOrDefault("quotaUser")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "quotaUser", valid_589380
  var valid_589381 = query.getOrDefault("alt")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = newJString("json"))
  if valid_589381 != nil:
    section.add "alt", valid_589381
  var valid_589382 = query.getOrDefault("oauth_token")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "oauth_token", valid_589382
  var valid_589383 = query.getOrDefault("userIp")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "userIp", valid_589383
  var valid_589384 = query.getOrDefault("key")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "key", valid_589384
  var valid_589385 = query.getOrDefault("includeDeleted")
  valid_589385 = validateParameter(valid_589385, JBool, required = false,
                                 default = newJBool(false))
  if valid_589385 != nil:
    section.add "includeDeleted", valid_589385
  var valid_589386 = query.getOrDefault("prettyPrint")
  valid_589386 = validateParameter(valid_589386, JBool, required = false,
                                 default = newJBool(true))
  if valid_589386 != nil:
    section.add "prettyPrint", valid_589386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589387: Call_DriveCommentsGet_589374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_589387.validator(path, query, header, formData, body)
  let scheme = call_589387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589387.url(scheme.get, call_589387.host, call_589387.base,
                         call_589387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589387, url, valid)

proc call*(call_589388: Call_DriveCommentsGet_589374; fileId: string;
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
  var path_589389 = newJObject()
  var query_589390 = newJObject()
  add(query_589390, "fields", newJString(fields))
  add(query_589390, "quotaUser", newJString(quotaUser))
  add(path_589389, "fileId", newJString(fileId))
  add(query_589390, "alt", newJString(alt))
  add(query_589390, "oauth_token", newJString(oauthToken))
  add(query_589390, "userIp", newJString(userIp))
  add(query_589390, "key", newJString(key))
  add(path_589389, "commentId", newJString(commentId))
  add(query_589390, "includeDeleted", newJBool(includeDeleted))
  add(query_589390, "prettyPrint", newJBool(prettyPrint))
  result = call_589388.call(path_589389, query_589390, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_589374(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_589375, base: "/drive/v3",
    url: url_DriveCommentsGet_589376, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_589407 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsUpdate_589409(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveCommentsUpdate_589408(path: JsonNode; query: JsonNode;
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
  var valid_589410 = path.getOrDefault("fileId")
  valid_589410 = validateParameter(valid_589410, JString, required = true,
                                 default = nil)
  if valid_589410 != nil:
    section.add "fileId", valid_589410
  var valid_589411 = path.getOrDefault("commentId")
  valid_589411 = validateParameter(valid_589411, JString, required = true,
                                 default = nil)
  if valid_589411 != nil:
    section.add "commentId", valid_589411
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
  var valid_589412 = query.getOrDefault("fields")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "fields", valid_589412
  var valid_589413 = query.getOrDefault("quotaUser")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "quotaUser", valid_589413
  var valid_589414 = query.getOrDefault("alt")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = newJString("json"))
  if valid_589414 != nil:
    section.add "alt", valid_589414
  var valid_589415 = query.getOrDefault("oauth_token")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "oauth_token", valid_589415
  var valid_589416 = query.getOrDefault("userIp")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "userIp", valid_589416
  var valid_589417 = query.getOrDefault("key")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "key", valid_589417
  var valid_589418 = query.getOrDefault("prettyPrint")
  valid_589418 = validateParameter(valid_589418, JBool, required = false,
                                 default = newJBool(true))
  if valid_589418 != nil:
    section.add "prettyPrint", valid_589418
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

proc call*(call_589420: Call_DriveCommentsUpdate_589407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a comment with patch semantics.
  ## 
  let valid = call_589420.validator(path, query, header, formData, body)
  let scheme = call_589420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589420.url(scheme.get, call_589420.host, call_589420.base,
                         call_589420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589420, url, valid)

proc call*(call_589421: Call_DriveCommentsUpdate_589407; fileId: string;
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
  var path_589422 = newJObject()
  var query_589423 = newJObject()
  var body_589424 = newJObject()
  add(query_589423, "fields", newJString(fields))
  add(query_589423, "quotaUser", newJString(quotaUser))
  add(path_589422, "fileId", newJString(fileId))
  add(query_589423, "alt", newJString(alt))
  add(query_589423, "oauth_token", newJString(oauthToken))
  add(query_589423, "userIp", newJString(userIp))
  add(query_589423, "key", newJString(key))
  add(path_589422, "commentId", newJString(commentId))
  if body != nil:
    body_589424 = body
  add(query_589423, "prettyPrint", newJBool(prettyPrint))
  result = call_589421.call(path_589422, query_589423, nil, nil, body_589424)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_589407(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_589408, base: "/drive/v3",
    url: url_DriveCommentsUpdate_589409, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_589391 = ref object of OpenApiRestCall_588457
proc url_DriveCommentsDelete_589393(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveCommentsDelete_589392(path: JsonNode; query: JsonNode;
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
  var valid_589394 = path.getOrDefault("fileId")
  valid_589394 = validateParameter(valid_589394, JString, required = true,
                                 default = nil)
  if valid_589394 != nil:
    section.add "fileId", valid_589394
  var valid_589395 = path.getOrDefault("commentId")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "commentId", valid_589395
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
  var valid_589396 = query.getOrDefault("fields")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "fields", valid_589396
  var valid_589397 = query.getOrDefault("quotaUser")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "quotaUser", valid_589397
  var valid_589398 = query.getOrDefault("alt")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = newJString("json"))
  if valid_589398 != nil:
    section.add "alt", valid_589398
  var valid_589399 = query.getOrDefault("oauth_token")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "oauth_token", valid_589399
  var valid_589400 = query.getOrDefault("userIp")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "userIp", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589403: Call_DriveCommentsDelete_589391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_DriveCommentsDelete_589391; fileId: string;
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
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  add(query_589406, "fields", newJString(fields))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(path_589405, "fileId", newJString(fileId))
  add(query_589406, "alt", newJString(alt))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(query_589406, "userIp", newJString(userIp))
  add(query_589406, "key", newJString(key))
  add(path_589405, "commentId", newJString(commentId))
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  result = call_589404.call(path_589405, query_589406, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_589391(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_589392, base: "/drive/v3",
    url: url_DriveCommentsDelete_589393, schemes: {Scheme.Https})
type
  Call_DriveRepliesCreate_589444 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesCreate_589446(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRepliesCreate_589445(path: JsonNode; query: JsonNode;
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
  var valid_589447 = path.getOrDefault("fileId")
  valid_589447 = validateParameter(valid_589447, JString, required = true,
                                 default = nil)
  if valid_589447 != nil:
    section.add "fileId", valid_589447
  var valid_589448 = path.getOrDefault("commentId")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "commentId", valid_589448
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
  var valid_589449 = query.getOrDefault("fields")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "fields", valid_589449
  var valid_589450 = query.getOrDefault("quotaUser")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "quotaUser", valid_589450
  var valid_589451 = query.getOrDefault("alt")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = newJString("json"))
  if valid_589451 != nil:
    section.add "alt", valid_589451
  var valid_589452 = query.getOrDefault("oauth_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "oauth_token", valid_589452
  var valid_589453 = query.getOrDefault("userIp")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "userIp", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("prettyPrint")
  valid_589455 = validateParameter(valid_589455, JBool, required = false,
                                 default = newJBool(true))
  if valid_589455 != nil:
    section.add "prettyPrint", valid_589455
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

proc call*(call_589457: Call_DriveRepliesCreate_589444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to a comment.
  ## 
  let valid = call_589457.validator(path, query, header, formData, body)
  let scheme = call_589457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589457.url(scheme.get, call_589457.host, call_589457.base,
                         call_589457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589457, url, valid)

proc call*(call_589458: Call_DriveRepliesCreate_589444; fileId: string;
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
  var path_589459 = newJObject()
  var query_589460 = newJObject()
  var body_589461 = newJObject()
  add(query_589460, "fields", newJString(fields))
  add(query_589460, "quotaUser", newJString(quotaUser))
  add(path_589459, "fileId", newJString(fileId))
  add(query_589460, "alt", newJString(alt))
  add(query_589460, "oauth_token", newJString(oauthToken))
  add(query_589460, "userIp", newJString(userIp))
  add(query_589460, "key", newJString(key))
  add(path_589459, "commentId", newJString(commentId))
  if body != nil:
    body_589461 = body
  add(query_589460, "prettyPrint", newJBool(prettyPrint))
  result = call_589458.call(path_589459, query_589460, nil, nil, body_589461)

var driveRepliesCreate* = Call_DriveRepliesCreate_589444(
    name: "driveRepliesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesCreate_589445, base: "/drive/v3",
    url: url_DriveRepliesCreate_589446, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_589425 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesList_589427(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRepliesList_589426(path: JsonNode; query: JsonNode;
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
  var valid_589428 = path.getOrDefault("fileId")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "fileId", valid_589428
  var valid_589429 = path.getOrDefault("commentId")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "commentId", valid_589429
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
  var valid_589430 = query.getOrDefault("fields")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "fields", valid_589430
  var valid_589431 = query.getOrDefault("pageToken")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "pageToken", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("userIp")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "userIp", valid_589435
  var valid_589436 = query.getOrDefault("key")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "key", valid_589436
  var valid_589437 = query.getOrDefault("includeDeleted")
  valid_589437 = validateParameter(valid_589437, JBool, required = false,
                                 default = newJBool(false))
  if valid_589437 != nil:
    section.add "includeDeleted", valid_589437
  var valid_589438 = query.getOrDefault("pageSize")
  valid_589438 = validateParameter(valid_589438, JInt, required = false,
                                 default = newJInt(20))
  if valid_589438 != nil:
    section.add "pageSize", valid_589438
  var valid_589439 = query.getOrDefault("prettyPrint")
  valid_589439 = validateParameter(valid_589439, JBool, required = false,
                                 default = newJBool(true))
  if valid_589439 != nil:
    section.add "prettyPrint", valid_589439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589440: Call_DriveRepliesList_589425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a comment's replies.
  ## 
  let valid = call_589440.validator(path, query, header, formData, body)
  let scheme = call_589440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589440.url(scheme.get, call_589440.host, call_589440.base,
                         call_589440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589440, url, valid)

proc call*(call_589441: Call_DriveRepliesList_589425; fileId: string;
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
  var path_589442 = newJObject()
  var query_589443 = newJObject()
  add(query_589443, "fields", newJString(fields))
  add(query_589443, "pageToken", newJString(pageToken))
  add(query_589443, "quotaUser", newJString(quotaUser))
  add(path_589442, "fileId", newJString(fileId))
  add(query_589443, "alt", newJString(alt))
  add(query_589443, "oauth_token", newJString(oauthToken))
  add(query_589443, "userIp", newJString(userIp))
  add(query_589443, "key", newJString(key))
  add(path_589442, "commentId", newJString(commentId))
  add(query_589443, "includeDeleted", newJBool(includeDeleted))
  add(query_589443, "pageSize", newJInt(pageSize))
  add(query_589443, "prettyPrint", newJBool(prettyPrint))
  result = call_589441.call(path_589442, query_589443, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_589425(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_589426, base: "/drive/v3",
    url: url_DriveRepliesList_589427, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_589462 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesGet_589464(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRepliesGet_589463(path: JsonNode; query: JsonNode;
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
  var valid_589465 = path.getOrDefault("fileId")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "fileId", valid_589465
  var valid_589466 = path.getOrDefault("replyId")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "replyId", valid_589466
  var valid_589467 = path.getOrDefault("commentId")
  valid_589467 = validateParameter(valid_589467, JString, required = true,
                                 default = nil)
  if valid_589467 != nil:
    section.add "commentId", valid_589467
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
  var valid_589468 = query.getOrDefault("fields")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "fields", valid_589468
  var valid_589469 = query.getOrDefault("quotaUser")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "quotaUser", valid_589469
  var valid_589470 = query.getOrDefault("alt")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("json"))
  if valid_589470 != nil:
    section.add "alt", valid_589470
  var valid_589471 = query.getOrDefault("oauth_token")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "oauth_token", valid_589471
  var valid_589472 = query.getOrDefault("userIp")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "userIp", valid_589472
  var valid_589473 = query.getOrDefault("key")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "key", valid_589473
  var valid_589474 = query.getOrDefault("includeDeleted")
  valid_589474 = validateParameter(valid_589474, JBool, required = false,
                                 default = newJBool(false))
  if valid_589474 != nil:
    section.add "includeDeleted", valid_589474
  var valid_589475 = query.getOrDefault("prettyPrint")
  valid_589475 = validateParameter(valid_589475, JBool, required = false,
                                 default = newJBool(true))
  if valid_589475 != nil:
    section.add "prettyPrint", valid_589475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589476: Call_DriveRepliesGet_589462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply by ID.
  ## 
  let valid = call_589476.validator(path, query, header, formData, body)
  let scheme = call_589476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589476.url(scheme.get, call_589476.host, call_589476.base,
                         call_589476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589476, url, valid)

proc call*(call_589477: Call_DriveRepliesGet_589462; fileId: string; replyId: string;
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
  var path_589478 = newJObject()
  var query_589479 = newJObject()
  add(query_589479, "fields", newJString(fields))
  add(query_589479, "quotaUser", newJString(quotaUser))
  add(path_589478, "fileId", newJString(fileId))
  add(query_589479, "alt", newJString(alt))
  add(query_589479, "oauth_token", newJString(oauthToken))
  add(query_589479, "userIp", newJString(userIp))
  add(query_589479, "key", newJString(key))
  add(path_589478, "replyId", newJString(replyId))
  add(path_589478, "commentId", newJString(commentId))
  add(query_589479, "includeDeleted", newJBool(includeDeleted))
  add(query_589479, "prettyPrint", newJBool(prettyPrint))
  result = call_589477.call(path_589478, query_589479, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_589462(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_589463, base: "/drive/v3",
    url: url_DriveRepliesGet_589464, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_589497 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesUpdate_589499(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRepliesUpdate_589498(path: JsonNode; query: JsonNode;
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
  var valid_589500 = path.getOrDefault("fileId")
  valid_589500 = validateParameter(valid_589500, JString, required = true,
                                 default = nil)
  if valid_589500 != nil:
    section.add "fileId", valid_589500
  var valid_589501 = path.getOrDefault("replyId")
  valid_589501 = validateParameter(valid_589501, JString, required = true,
                                 default = nil)
  if valid_589501 != nil:
    section.add "replyId", valid_589501
  var valid_589502 = path.getOrDefault("commentId")
  valid_589502 = validateParameter(valid_589502, JString, required = true,
                                 default = nil)
  if valid_589502 != nil:
    section.add "commentId", valid_589502
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
  var valid_589503 = query.getOrDefault("fields")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "fields", valid_589503
  var valid_589504 = query.getOrDefault("quotaUser")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "quotaUser", valid_589504
  var valid_589505 = query.getOrDefault("alt")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = newJString("json"))
  if valid_589505 != nil:
    section.add "alt", valid_589505
  var valid_589506 = query.getOrDefault("oauth_token")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "oauth_token", valid_589506
  var valid_589507 = query.getOrDefault("userIp")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "userIp", valid_589507
  var valid_589508 = query.getOrDefault("key")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "key", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
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

proc call*(call_589511: Call_DriveRepliesUpdate_589497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a reply with patch semantics.
  ## 
  let valid = call_589511.validator(path, query, header, formData, body)
  let scheme = call_589511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589511.url(scheme.get, call_589511.host, call_589511.base,
                         call_589511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589511, url, valid)

proc call*(call_589512: Call_DriveRepliesUpdate_589497; fileId: string;
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
  var path_589513 = newJObject()
  var query_589514 = newJObject()
  var body_589515 = newJObject()
  add(query_589514, "fields", newJString(fields))
  add(query_589514, "quotaUser", newJString(quotaUser))
  add(path_589513, "fileId", newJString(fileId))
  add(query_589514, "alt", newJString(alt))
  add(query_589514, "oauth_token", newJString(oauthToken))
  add(query_589514, "userIp", newJString(userIp))
  add(query_589514, "key", newJString(key))
  add(path_589513, "replyId", newJString(replyId))
  add(path_589513, "commentId", newJString(commentId))
  if body != nil:
    body_589515 = body
  add(query_589514, "prettyPrint", newJBool(prettyPrint))
  result = call_589512.call(path_589513, query_589514, nil, nil, body_589515)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_589497(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_589498, base: "/drive/v3",
    url: url_DriveRepliesUpdate_589499, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_589480 = ref object of OpenApiRestCall_588457
proc url_DriveRepliesDelete_589482(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRepliesDelete_589481(path: JsonNode; query: JsonNode;
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
  var valid_589483 = path.getOrDefault("fileId")
  valid_589483 = validateParameter(valid_589483, JString, required = true,
                                 default = nil)
  if valid_589483 != nil:
    section.add "fileId", valid_589483
  var valid_589484 = path.getOrDefault("replyId")
  valid_589484 = validateParameter(valid_589484, JString, required = true,
                                 default = nil)
  if valid_589484 != nil:
    section.add "replyId", valid_589484
  var valid_589485 = path.getOrDefault("commentId")
  valid_589485 = validateParameter(valid_589485, JString, required = true,
                                 default = nil)
  if valid_589485 != nil:
    section.add "commentId", valid_589485
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
  var valid_589486 = query.getOrDefault("fields")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "fields", valid_589486
  var valid_589487 = query.getOrDefault("quotaUser")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "quotaUser", valid_589487
  var valid_589488 = query.getOrDefault("alt")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = newJString("json"))
  if valid_589488 != nil:
    section.add "alt", valid_589488
  var valid_589489 = query.getOrDefault("oauth_token")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "oauth_token", valid_589489
  var valid_589490 = query.getOrDefault("userIp")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "userIp", valid_589490
  var valid_589491 = query.getOrDefault("key")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "key", valid_589491
  var valid_589492 = query.getOrDefault("prettyPrint")
  valid_589492 = validateParameter(valid_589492, JBool, required = false,
                                 default = newJBool(true))
  if valid_589492 != nil:
    section.add "prettyPrint", valid_589492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589493: Call_DriveRepliesDelete_589480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_589493.validator(path, query, header, formData, body)
  let scheme = call_589493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589493.url(scheme.get, call_589493.host, call_589493.base,
                         call_589493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589493, url, valid)

proc call*(call_589494: Call_DriveRepliesDelete_589480; fileId: string;
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
  var path_589495 = newJObject()
  var query_589496 = newJObject()
  add(query_589496, "fields", newJString(fields))
  add(query_589496, "quotaUser", newJString(quotaUser))
  add(path_589495, "fileId", newJString(fileId))
  add(query_589496, "alt", newJString(alt))
  add(query_589496, "oauth_token", newJString(oauthToken))
  add(query_589496, "userIp", newJString(userIp))
  add(query_589496, "key", newJString(key))
  add(path_589495, "replyId", newJString(replyId))
  add(path_589495, "commentId", newJString(commentId))
  add(query_589496, "prettyPrint", newJBool(prettyPrint))
  result = call_589494.call(path_589495, query_589496, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_589480(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_589481, base: "/drive/v3",
    url: url_DriveRepliesDelete_589482, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_589516 = ref object of OpenApiRestCall_588457
proc url_DriveFilesCopy_589518(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveFilesCopy_589517(path: JsonNode; query: JsonNode;
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
  var valid_589519 = path.getOrDefault("fileId")
  valid_589519 = validateParameter(valid_589519, JString, required = true,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fileId", valid_589519
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
  var valid_589520 = query.getOrDefault("supportsAllDrives")
  valid_589520 = validateParameter(valid_589520, JBool, required = false,
                                 default = newJBool(false))
  if valid_589520 != nil:
    section.add "supportsAllDrives", valid_589520
  var valid_589521 = query.getOrDefault("fields")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "fields", valid_589521
  var valid_589522 = query.getOrDefault("quotaUser")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "quotaUser", valid_589522
  var valid_589523 = query.getOrDefault("alt")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = newJString("json"))
  if valid_589523 != nil:
    section.add "alt", valid_589523
  var valid_589524 = query.getOrDefault("oauth_token")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "oauth_token", valid_589524
  var valid_589525 = query.getOrDefault("userIp")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "userIp", valid_589525
  var valid_589526 = query.getOrDefault("keepRevisionForever")
  valid_589526 = validateParameter(valid_589526, JBool, required = false,
                                 default = newJBool(false))
  if valid_589526 != nil:
    section.add "keepRevisionForever", valid_589526
  var valid_589527 = query.getOrDefault("supportsTeamDrives")
  valid_589527 = validateParameter(valid_589527, JBool, required = false,
                                 default = newJBool(false))
  if valid_589527 != nil:
    section.add "supportsTeamDrives", valid_589527
  var valid_589528 = query.getOrDefault("key")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "key", valid_589528
  var valid_589529 = query.getOrDefault("prettyPrint")
  valid_589529 = validateParameter(valid_589529, JBool, required = false,
                                 default = newJBool(true))
  if valid_589529 != nil:
    section.add "prettyPrint", valid_589529
  var valid_589530 = query.getOrDefault("ignoreDefaultVisibility")
  valid_589530 = validateParameter(valid_589530, JBool, required = false,
                                 default = newJBool(false))
  if valid_589530 != nil:
    section.add "ignoreDefaultVisibility", valid_589530
  var valid_589531 = query.getOrDefault("ocrLanguage")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "ocrLanguage", valid_589531
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

proc call*(call_589533: Call_DriveFilesCopy_589516; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  let valid = call_589533.validator(path, query, header, formData, body)
  let scheme = call_589533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589533.url(scheme.get, call_589533.host, call_589533.base,
                         call_589533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589533, url, valid)

proc call*(call_589534: Call_DriveFilesCopy_589516; fileId: string;
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
  var path_589535 = newJObject()
  var query_589536 = newJObject()
  var body_589537 = newJObject()
  add(query_589536, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589536, "fields", newJString(fields))
  add(query_589536, "quotaUser", newJString(quotaUser))
  add(path_589535, "fileId", newJString(fileId))
  add(query_589536, "alt", newJString(alt))
  add(query_589536, "oauth_token", newJString(oauthToken))
  add(query_589536, "userIp", newJString(userIp))
  add(query_589536, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_589536, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589536, "key", newJString(key))
  if body != nil:
    body_589537 = body
  add(query_589536, "prettyPrint", newJBool(prettyPrint))
  add(query_589536, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_589536, "ocrLanguage", newJString(ocrLanguage))
  result = call_589534.call(path_589535, query_589536, nil, nil, body_589537)

var driveFilesCopy* = Call_DriveFilesCopy_589516(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_589517,
    base: "/drive/v3", url: url_DriveFilesCopy_589518, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_589538 = ref object of OpenApiRestCall_588457
proc url_DriveFilesExport_589540(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveFilesExport_589539(path: JsonNode; query: JsonNode;
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
  var valid_589541 = path.getOrDefault("fileId")
  valid_589541 = validateParameter(valid_589541, JString, required = true,
                                 default = nil)
  if valid_589541 != nil:
    section.add "fileId", valid_589541
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
  var valid_589542 = query.getOrDefault("fields")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "fields", valid_589542
  var valid_589543 = query.getOrDefault("quotaUser")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "quotaUser", valid_589543
  var valid_589544 = query.getOrDefault("alt")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = newJString("json"))
  if valid_589544 != nil:
    section.add "alt", valid_589544
  var valid_589545 = query.getOrDefault("oauth_token")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "oauth_token", valid_589545
  var valid_589546 = query.getOrDefault("userIp")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "userIp", valid_589546
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_589547 = query.getOrDefault("mimeType")
  valid_589547 = validateParameter(valid_589547, JString, required = true,
                                 default = nil)
  if valid_589547 != nil:
    section.add "mimeType", valid_589547
  var valid_589548 = query.getOrDefault("key")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "key", valid_589548
  var valid_589549 = query.getOrDefault("prettyPrint")
  valid_589549 = validateParameter(valid_589549, JBool, required = false,
                                 default = newJBool(true))
  if valid_589549 != nil:
    section.add "prettyPrint", valid_589549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589550: Call_DriveFilesExport_589538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_589550.validator(path, query, header, formData, body)
  let scheme = call_589550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589550.url(scheme.get, call_589550.host, call_589550.base,
                         call_589550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589550, url, valid)

proc call*(call_589551: Call_DriveFilesExport_589538; fileId: string;
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
  var path_589552 = newJObject()
  var query_589553 = newJObject()
  add(query_589553, "fields", newJString(fields))
  add(query_589553, "quotaUser", newJString(quotaUser))
  add(path_589552, "fileId", newJString(fileId))
  add(query_589553, "alt", newJString(alt))
  add(query_589553, "oauth_token", newJString(oauthToken))
  add(query_589553, "userIp", newJString(userIp))
  add(query_589553, "mimeType", newJString(mimeType))
  add(query_589553, "key", newJString(key))
  add(query_589553, "prettyPrint", newJBool(prettyPrint))
  result = call_589551.call(path_589552, query_589553, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_589538(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_589539,
    base: "/drive/v3", url: url_DriveFilesExport_589540, schemes: {Scheme.Https})
type
  Call_DrivePermissionsCreate_589574 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsCreate_589576(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DrivePermissionsCreate_589575(path: JsonNode; query: JsonNode;
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
  var valid_589577 = path.getOrDefault("fileId")
  valid_589577 = validateParameter(valid_589577, JString, required = true,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fileId", valid_589577
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
  var valid_589578 = query.getOrDefault("supportsAllDrives")
  valid_589578 = validateParameter(valid_589578, JBool, required = false,
                                 default = newJBool(false))
  if valid_589578 != nil:
    section.add "supportsAllDrives", valid_589578
  var valid_589579 = query.getOrDefault("fields")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "fields", valid_589579
  var valid_589580 = query.getOrDefault("quotaUser")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "quotaUser", valid_589580
  var valid_589581 = query.getOrDefault("alt")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = newJString("json"))
  if valid_589581 != nil:
    section.add "alt", valid_589581
  var valid_589582 = query.getOrDefault("sendNotificationEmail")
  valid_589582 = validateParameter(valid_589582, JBool, required = false, default = nil)
  if valid_589582 != nil:
    section.add "sendNotificationEmail", valid_589582
  var valid_589583 = query.getOrDefault("oauth_token")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "oauth_token", valid_589583
  var valid_589584 = query.getOrDefault("userIp")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "userIp", valid_589584
  var valid_589585 = query.getOrDefault("supportsTeamDrives")
  valid_589585 = validateParameter(valid_589585, JBool, required = false,
                                 default = newJBool(false))
  if valid_589585 != nil:
    section.add "supportsTeamDrives", valid_589585
  var valid_589586 = query.getOrDefault("key")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "key", valid_589586
  var valid_589587 = query.getOrDefault("useDomainAdminAccess")
  valid_589587 = validateParameter(valid_589587, JBool, required = false,
                                 default = newJBool(false))
  if valid_589587 != nil:
    section.add "useDomainAdminAccess", valid_589587
  var valid_589588 = query.getOrDefault("emailMessage")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "emailMessage", valid_589588
  var valid_589589 = query.getOrDefault("transferOwnership")
  valid_589589 = validateParameter(valid_589589, JBool, required = false,
                                 default = newJBool(false))
  if valid_589589 != nil:
    section.add "transferOwnership", valid_589589
  var valid_589590 = query.getOrDefault("prettyPrint")
  valid_589590 = validateParameter(valid_589590, JBool, required = false,
                                 default = newJBool(true))
  if valid_589590 != nil:
    section.add "prettyPrint", valid_589590
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

proc call*(call_589592: Call_DrivePermissionsCreate_589574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a permission for a file or shared drive.
  ## 
  let valid = call_589592.validator(path, query, header, formData, body)
  let scheme = call_589592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589592.url(scheme.get, call_589592.host, call_589592.base,
                         call_589592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589592, url, valid)

proc call*(call_589593: Call_DrivePermissionsCreate_589574; fileId: string;
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
  var path_589594 = newJObject()
  var query_589595 = newJObject()
  var body_589596 = newJObject()
  add(query_589595, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589595, "fields", newJString(fields))
  add(query_589595, "quotaUser", newJString(quotaUser))
  add(path_589594, "fileId", newJString(fileId))
  add(query_589595, "alt", newJString(alt))
  add(query_589595, "sendNotificationEmail", newJBool(sendNotificationEmail))
  add(query_589595, "oauth_token", newJString(oauthToken))
  add(query_589595, "userIp", newJString(userIp))
  add(query_589595, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589595, "key", newJString(key))
  add(query_589595, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589595, "emailMessage", newJString(emailMessage))
  add(query_589595, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_589596 = body
  add(query_589595, "prettyPrint", newJBool(prettyPrint))
  result = call_589593.call(path_589594, query_589595, nil, nil, body_589596)

var drivePermissionsCreate* = Call_DrivePermissionsCreate_589574(
    name: "drivePermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsCreate_589575, base: "/drive/v3",
    url: url_DrivePermissionsCreate_589576, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_589554 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsList_589556(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DrivePermissionsList_589555(path: JsonNode; query: JsonNode;
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
  var valid_589557 = path.getOrDefault("fileId")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "fileId", valid_589557
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
  var valid_589558 = query.getOrDefault("supportsAllDrives")
  valid_589558 = validateParameter(valid_589558, JBool, required = false,
                                 default = newJBool(false))
  if valid_589558 != nil:
    section.add "supportsAllDrives", valid_589558
  var valid_589559 = query.getOrDefault("fields")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "fields", valid_589559
  var valid_589560 = query.getOrDefault("pageToken")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "pageToken", valid_589560
  var valid_589561 = query.getOrDefault("quotaUser")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "quotaUser", valid_589561
  var valid_589562 = query.getOrDefault("alt")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = newJString("json"))
  if valid_589562 != nil:
    section.add "alt", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("userIp")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "userIp", valid_589564
  var valid_589565 = query.getOrDefault("supportsTeamDrives")
  valid_589565 = validateParameter(valid_589565, JBool, required = false,
                                 default = newJBool(false))
  if valid_589565 != nil:
    section.add "supportsTeamDrives", valid_589565
  var valid_589566 = query.getOrDefault("key")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "key", valid_589566
  var valid_589567 = query.getOrDefault("useDomainAdminAccess")
  valid_589567 = validateParameter(valid_589567, JBool, required = false,
                                 default = newJBool(false))
  if valid_589567 != nil:
    section.add "useDomainAdminAccess", valid_589567
  var valid_589568 = query.getOrDefault("pageSize")
  valid_589568 = validateParameter(valid_589568, JInt, required = false, default = nil)
  if valid_589568 != nil:
    section.add "pageSize", valid_589568
  var valid_589569 = query.getOrDefault("prettyPrint")
  valid_589569 = validateParameter(valid_589569, JBool, required = false,
                                 default = newJBool(true))
  if valid_589569 != nil:
    section.add "prettyPrint", valid_589569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589570: Call_DrivePermissionsList_589554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_589570.validator(path, query, header, formData, body)
  let scheme = call_589570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589570.url(scheme.get, call_589570.host, call_589570.base,
                         call_589570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589570, url, valid)

proc call*(call_589571: Call_DrivePermissionsList_589554; fileId: string;
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
  var path_589572 = newJObject()
  var query_589573 = newJObject()
  add(query_589573, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589573, "fields", newJString(fields))
  add(query_589573, "pageToken", newJString(pageToken))
  add(query_589573, "quotaUser", newJString(quotaUser))
  add(path_589572, "fileId", newJString(fileId))
  add(query_589573, "alt", newJString(alt))
  add(query_589573, "oauth_token", newJString(oauthToken))
  add(query_589573, "userIp", newJString(userIp))
  add(query_589573, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589573, "key", newJString(key))
  add(query_589573, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589573, "pageSize", newJInt(pageSize))
  add(query_589573, "prettyPrint", newJBool(prettyPrint))
  result = call_589571.call(path_589572, query_589573, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_589554(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_589555, base: "/drive/v3",
    url: url_DrivePermissionsList_589556, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_589597 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsGet_589599(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DrivePermissionsGet_589598(path: JsonNode; query: JsonNode;
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
  var valid_589600 = path.getOrDefault("fileId")
  valid_589600 = validateParameter(valid_589600, JString, required = true,
                                 default = nil)
  if valid_589600 != nil:
    section.add "fileId", valid_589600
  var valid_589601 = path.getOrDefault("permissionId")
  valid_589601 = validateParameter(valid_589601, JString, required = true,
                                 default = nil)
  if valid_589601 != nil:
    section.add "permissionId", valid_589601
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
  var valid_589602 = query.getOrDefault("supportsAllDrives")
  valid_589602 = validateParameter(valid_589602, JBool, required = false,
                                 default = newJBool(false))
  if valid_589602 != nil:
    section.add "supportsAllDrives", valid_589602
  var valid_589603 = query.getOrDefault("fields")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "fields", valid_589603
  var valid_589604 = query.getOrDefault("quotaUser")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "quotaUser", valid_589604
  var valid_589605 = query.getOrDefault("alt")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = newJString("json"))
  if valid_589605 != nil:
    section.add "alt", valid_589605
  var valid_589606 = query.getOrDefault("oauth_token")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "oauth_token", valid_589606
  var valid_589607 = query.getOrDefault("userIp")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "userIp", valid_589607
  var valid_589608 = query.getOrDefault("supportsTeamDrives")
  valid_589608 = validateParameter(valid_589608, JBool, required = false,
                                 default = newJBool(false))
  if valid_589608 != nil:
    section.add "supportsTeamDrives", valid_589608
  var valid_589609 = query.getOrDefault("key")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "key", valid_589609
  var valid_589610 = query.getOrDefault("useDomainAdminAccess")
  valid_589610 = validateParameter(valid_589610, JBool, required = false,
                                 default = newJBool(false))
  if valid_589610 != nil:
    section.add "useDomainAdminAccess", valid_589610
  var valid_589611 = query.getOrDefault("prettyPrint")
  valid_589611 = validateParameter(valid_589611, JBool, required = false,
                                 default = newJBool(true))
  if valid_589611 != nil:
    section.add "prettyPrint", valid_589611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589612: Call_DrivePermissionsGet_589597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_589612.validator(path, query, header, formData, body)
  let scheme = call_589612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589612.url(scheme.get, call_589612.host, call_589612.base,
                         call_589612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589612, url, valid)

proc call*(call_589613: Call_DrivePermissionsGet_589597; fileId: string;
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
  var path_589614 = newJObject()
  var query_589615 = newJObject()
  add(query_589615, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589615, "fields", newJString(fields))
  add(query_589615, "quotaUser", newJString(quotaUser))
  add(path_589614, "fileId", newJString(fileId))
  add(query_589615, "alt", newJString(alt))
  add(query_589615, "oauth_token", newJString(oauthToken))
  add(path_589614, "permissionId", newJString(permissionId))
  add(query_589615, "userIp", newJString(userIp))
  add(query_589615, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589615, "key", newJString(key))
  add(query_589615, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589615, "prettyPrint", newJBool(prettyPrint))
  result = call_589613.call(path_589614, query_589615, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_589597(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_589598, base: "/drive/v3",
    url: url_DrivePermissionsGet_589599, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_589635 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsUpdate_589637(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DrivePermissionsUpdate_589636(path: JsonNode; query: JsonNode;
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
  var valid_589638 = path.getOrDefault("fileId")
  valid_589638 = validateParameter(valid_589638, JString, required = true,
                                 default = nil)
  if valid_589638 != nil:
    section.add "fileId", valid_589638
  var valid_589639 = path.getOrDefault("permissionId")
  valid_589639 = validateParameter(valid_589639, JString, required = true,
                                 default = nil)
  if valid_589639 != nil:
    section.add "permissionId", valid_589639
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
  var valid_589640 = query.getOrDefault("supportsAllDrives")
  valid_589640 = validateParameter(valid_589640, JBool, required = false,
                                 default = newJBool(false))
  if valid_589640 != nil:
    section.add "supportsAllDrives", valid_589640
  var valid_589641 = query.getOrDefault("fields")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "fields", valid_589641
  var valid_589642 = query.getOrDefault("quotaUser")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "quotaUser", valid_589642
  var valid_589643 = query.getOrDefault("alt")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = newJString("json"))
  if valid_589643 != nil:
    section.add "alt", valid_589643
  var valid_589644 = query.getOrDefault("oauth_token")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "oauth_token", valid_589644
  var valid_589645 = query.getOrDefault("removeExpiration")
  valid_589645 = validateParameter(valid_589645, JBool, required = false,
                                 default = newJBool(false))
  if valid_589645 != nil:
    section.add "removeExpiration", valid_589645
  var valid_589646 = query.getOrDefault("userIp")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "userIp", valid_589646
  var valid_589647 = query.getOrDefault("supportsTeamDrives")
  valid_589647 = validateParameter(valid_589647, JBool, required = false,
                                 default = newJBool(false))
  if valid_589647 != nil:
    section.add "supportsTeamDrives", valid_589647
  var valid_589648 = query.getOrDefault("key")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "key", valid_589648
  var valid_589649 = query.getOrDefault("useDomainAdminAccess")
  valid_589649 = validateParameter(valid_589649, JBool, required = false,
                                 default = newJBool(false))
  if valid_589649 != nil:
    section.add "useDomainAdminAccess", valid_589649
  var valid_589650 = query.getOrDefault("transferOwnership")
  valid_589650 = validateParameter(valid_589650, JBool, required = false,
                                 default = newJBool(false))
  if valid_589650 != nil:
    section.add "transferOwnership", valid_589650
  var valid_589651 = query.getOrDefault("prettyPrint")
  valid_589651 = validateParameter(valid_589651, JBool, required = false,
                                 default = newJBool(true))
  if valid_589651 != nil:
    section.add "prettyPrint", valid_589651
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

proc call*(call_589653: Call_DrivePermissionsUpdate_589635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission with patch semantics.
  ## 
  let valid = call_589653.validator(path, query, header, formData, body)
  let scheme = call_589653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589653.url(scheme.get, call_589653.host, call_589653.base,
                         call_589653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589653, url, valid)

proc call*(call_589654: Call_DrivePermissionsUpdate_589635; fileId: string;
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
  var path_589655 = newJObject()
  var query_589656 = newJObject()
  var body_589657 = newJObject()
  add(query_589656, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589656, "fields", newJString(fields))
  add(query_589656, "quotaUser", newJString(quotaUser))
  add(path_589655, "fileId", newJString(fileId))
  add(query_589656, "alt", newJString(alt))
  add(query_589656, "oauth_token", newJString(oauthToken))
  add(path_589655, "permissionId", newJString(permissionId))
  add(query_589656, "removeExpiration", newJBool(removeExpiration))
  add(query_589656, "userIp", newJString(userIp))
  add(query_589656, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589656, "key", newJString(key))
  add(query_589656, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589656, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_589657 = body
  add(query_589656, "prettyPrint", newJBool(prettyPrint))
  result = call_589654.call(path_589655, query_589656, nil, nil, body_589657)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_589635(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_589636, base: "/drive/v3",
    url: url_DrivePermissionsUpdate_589637, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_589616 = ref object of OpenApiRestCall_588457
proc url_DrivePermissionsDelete_589618(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DrivePermissionsDelete_589617(path: JsonNode; query: JsonNode;
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
  var valid_589619 = path.getOrDefault("fileId")
  valid_589619 = validateParameter(valid_589619, JString, required = true,
                                 default = nil)
  if valid_589619 != nil:
    section.add "fileId", valid_589619
  var valid_589620 = path.getOrDefault("permissionId")
  valid_589620 = validateParameter(valid_589620, JString, required = true,
                                 default = nil)
  if valid_589620 != nil:
    section.add "permissionId", valid_589620
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
  var valid_589621 = query.getOrDefault("supportsAllDrives")
  valid_589621 = validateParameter(valid_589621, JBool, required = false,
                                 default = newJBool(false))
  if valid_589621 != nil:
    section.add "supportsAllDrives", valid_589621
  var valid_589622 = query.getOrDefault("fields")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "fields", valid_589622
  var valid_589623 = query.getOrDefault("quotaUser")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "quotaUser", valid_589623
  var valid_589624 = query.getOrDefault("alt")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = newJString("json"))
  if valid_589624 != nil:
    section.add "alt", valid_589624
  var valid_589625 = query.getOrDefault("oauth_token")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "oauth_token", valid_589625
  var valid_589626 = query.getOrDefault("userIp")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "userIp", valid_589626
  var valid_589627 = query.getOrDefault("supportsTeamDrives")
  valid_589627 = validateParameter(valid_589627, JBool, required = false,
                                 default = newJBool(false))
  if valid_589627 != nil:
    section.add "supportsTeamDrives", valid_589627
  var valid_589628 = query.getOrDefault("key")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "key", valid_589628
  var valid_589629 = query.getOrDefault("useDomainAdminAccess")
  valid_589629 = validateParameter(valid_589629, JBool, required = false,
                                 default = newJBool(false))
  if valid_589629 != nil:
    section.add "useDomainAdminAccess", valid_589629
  var valid_589630 = query.getOrDefault("prettyPrint")
  valid_589630 = validateParameter(valid_589630, JBool, required = false,
                                 default = newJBool(true))
  if valid_589630 != nil:
    section.add "prettyPrint", valid_589630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589631: Call_DrivePermissionsDelete_589616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission.
  ## 
  let valid = call_589631.validator(path, query, header, formData, body)
  let scheme = call_589631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589631.url(scheme.get, call_589631.host, call_589631.base,
                         call_589631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589631, url, valid)

proc call*(call_589632: Call_DrivePermissionsDelete_589616; fileId: string;
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
  var path_589633 = newJObject()
  var query_589634 = newJObject()
  add(query_589634, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589634, "fields", newJString(fields))
  add(query_589634, "quotaUser", newJString(quotaUser))
  add(path_589633, "fileId", newJString(fileId))
  add(query_589634, "alt", newJString(alt))
  add(query_589634, "oauth_token", newJString(oauthToken))
  add(path_589633, "permissionId", newJString(permissionId))
  add(query_589634, "userIp", newJString(userIp))
  add(query_589634, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589634, "key", newJString(key))
  add(query_589634, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589634, "prettyPrint", newJBool(prettyPrint))
  result = call_589632.call(path_589633, query_589634, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_589616(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_589617, base: "/drive/v3",
    url: url_DrivePermissionsDelete_589618, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_589658 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsList_589660(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRevisionsList_589659(path: JsonNode; query: JsonNode;
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
  var valid_589661 = path.getOrDefault("fileId")
  valid_589661 = validateParameter(valid_589661, JString, required = true,
                                 default = nil)
  if valid_589661 != nil:
    section.add "fileId", valid_589661
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
  var valid_589662 = query.getOrDefault("fields")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "fields", valid_589662
  var valid_589663 = query.getOrDefault("pageToken")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "pageToken", valid_589663
  var valid_589664 = query.getOrDefault("quotaUser")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "quotaUser", valid_589664
  var valid_589665 = query.getOrDefault("alt")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = newJString("json"))
  if valid_589665 != nil:
    section.add "alt", valid_589665
  var valid_589666 = query.getOrDefault("oauth_token")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "oauth_token", valid_589666
  var valid_589667 = query.getOrDefault("userIp")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = nil)
  if valid_589667 != nil:
    section.add "userIp", valid_589667
  var valid_589668 = query.getOrDefault("key")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "key", valid_589668
  var valid_589669 = query.getOrDefault("pageSize")
  valid_589669 = validateParameter(valid_589669, JInt, required = false,
                                 default = newJInt(200))
  if valid_589669 != nil:
    section.add "pageSize", valid_589669
  var valid_589670 = query.getOrDefault("prettyPrint")
  valid_589670 = validateParameter(valid_589670, JBool, required = false,
                                 default = newJBool(true))
  if valid_589670 != nil:
    section.add "prettyPrint", valid_589670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589671: Call_DriveRevisionsList_589658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_589671.validator(path, query, header, formData, body)
  let scheme = call_589671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589671.url(scheme.get, call_589671.host, call_589671.base,
                         call_589671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589671, url, valid)

proc call*(call_589672: Call_DriveRevisionsList_589658; fileId: string;
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
  var path_589673 = newJObject()
  var query_589674 = newJObject()
  add(query_589674, "fields", newJString(fields))
  add(query_589674, "pageToken", newJString(pageToken))
  add(query_589674, "quotaUser", newJString(quotaUser))
  add(path_589673, "fileId", newJString(fileId))
  add(query_589674, "alt", newJString(alt))
  add(query_589674, "oauth_token", newJString(oauthToken))
  add(query_589674, "userIp", newJString(userIp))
  add(query_589674, "key", newJString(key))
  add(query_589674, "pageSize", newJInt(pageSize))
  add(query_589674, "prettyPrint", newJBool(prettyPrint))
  result = call_589672.call(path_589673, query_589674, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_589658(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_589659, base: "/drive/v3",
    url: url_DriveRevisionsList_589660, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_589675 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsGet_589677(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRevisionsGet_589676(path: JsonNode; query: JsonNode;
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
  var valid_589678 = path.getOrDefault("fileId")
  valid_589678 = validateParameter(valid_589678, JString, required = true,
                                 default = nil)
  if valid_589678 != nil:
    section.add "fileId", valid_589678
  var valid_589679 = path.getOrDefault("revisionId")
  valid_589679 = validateParameter(valid_589679, JString, required = true,
                                 default = nil)
  if valid_589679 != nil:
    section.add "revisionId", valid_589679
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
  var valid_589680 = query.getOrDefault("fields")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "fields", valid_589680
  var valid_589681 = query.getOrDefault("quotaUser")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "quotaUser", valid_589681
  var valid_589682 = query.getOrDefault("alt")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = newJString("json"))
  if valid_589682 != nil:
    section.add "alt", valid_589682
  var valid_589683 = query.getOrDefault("acknowledgeAbuse")
  valid_589683 = validateParameter(valid_589683, JBool, required = false,
                                 default = newJBool(false))
  if valid_589683 != nil:
    section.add "acknowledgeAbuse", valid_589683
  var valid_589684 = query.getOrDefault("oauth_token")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "oauth_token", valid_589684
  var valid_589685 = query.getOrDefault("userIp")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "userIp", valid_589685
  var valid_589686 = query.getOrDefault("key")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "key", valid_589686
  var valid_589687 = query.getOrDefault("prettyPrint")
  valid_589687 = validateParameter(valid_589687, JBool, required = false,
                                 default = newJBool(true))
  if valid_589687 != nil:
    section.add "prettyPrint", valid_589687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589688: Call_DriveRevisionsGet_589675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a revision's metadata or content by ID.
  ## 
  let valid = call_589688.validator(path, query, header, formData, body)
  let scheme = call_589688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589688.url(scheme.get, call_589688.host, call_589688.base,
                         call_589688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589688, url, valid)

proc call*(call_589689: Call_DriveRevisionsGet_589675; fileId: string;
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
  var path_589690 = newJObject()
  var query_589691 = newJObject()
  add(query_589691, "fields", newJString(fields))
  add(query_589691, "quotaUser", newJString(quotaUser))
  add(path_589690, "fileId", newJString(fileId))
  add(query_589691, "alt", newJString(alt))
  add(query_589691, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_589691, "oauth_token", newJString(oauthToken))
  add(path_589690, "revisionId", newJString(revisionId))
  add(query_589691, "userIp", newJString(userIp))
  add(query_589691, "key", newJString(key))
  add(query_589691, "prettyPrint", newJBool(prettyPrint))
  result = call_589689.call(path_589690, query_589691, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_589675(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_589676, base: "/drive/v3",
    url: url_DriveRevisionsGet_589677, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_589708 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsUpdate_589710(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRevisionsUpdate_589709(path: JsonNode; query: JsonNode;
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
  var valid_589711 = path.getOrDefault("fileId")
  valid_589711 = validateParameter(valid_589711, JString, required = true,
                                 default = nil)
  if valid_589711 != nil:
    section.add "fileId", valid_589711
  var valid_589712 = path.getOrDefault("revisionId")
  valid_589712 = validateParameter(valid_589712, JString, required = true,
                                 default = nil)
  if valid_589712 != nil:
    section.add "revisionId", valid_589712
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
  var valid_589713 = query.getOrDefault("fields")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "fields", valid_589713
  var valid_589714 = query.getOrDefault("quotaUser")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "quotaUser", valid_589714
  var valid_589715 = query.getOrDefault("alt")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = newJString("json"))
  if valid_589715 != nil:
    section.add "alt", valid_589715
  var valid_589716 = query.getOrDefault("oauth_token")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "oauth_token", valid_589716
  var valid_589717 = query.getOrDefault("userIp")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "userIp", valid_589717
  var valid_589718 = query.getOrDefault("key")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "key", valid_589718
  var valid_589719 = query.getOrDefault("prettyPrint")
  valid_589719 = validateParameter(valid_589719, JBool, required = false,
                                 default = newJBool(true))
  if valid_589719 != nil:
    section.add "prettyPrint", valid_589719
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

proc call*(call_589721: Call_DriveRevisionsUpdate_589708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision with patch semantics.
  ## 
  let valid = call_589721.validator(path, query, header, formData, body)
  let scheme = call_589721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589721.url(scheme.get, call_589721.host, call_589721.base,
                         call_589721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589721, url, valid)

proc call*(call_589722: Call_DriveRevisionsUpdate_589708; fileId: string;
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
  var path_589723 = newJObject()
  var query_589724 = newJObject()
  var body_589725 = newJObject()
  add(query_589724, "fields", newJString(fields))
  add(query_589724, "quotaUser", newJString(quotaUser))
  add(path_589723, "fileId", newJString(fileId))
  add(query_589724, "alt", newJString(alt))
  add(query_589724, "oauth_token", newJString(oauthToken))
  add(path_589723, "revisionId", newJString(revisionId))
  add(query_589724, "userIp", newJString(userIp))
  add(query_589724, "key", newJString(key))
  if body != nil:
    body_589725 = body
  add(query_589724, "prettyPrint", newJBool(prettyPrint))
  result = call_589722.call(path_589723, query_589724, nil, nil, body_589725)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_589708(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_589709, base: "/drive/v3",
    url: url_DriveRevisionsUpdate_589710, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_589692 = ref object of OpenApiRestCall_588457
proc url_DriveRevisionsDelete_589694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveRevisionsDelete_589693(path: JsonNode; query: JsonNode;
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
  var valid_589695 = path.getOrDefault("fileId")
  valid_589695 = validateParameter(valid_589695, JString, required = true,
                                 default = nil)
  if valid_589695 != nil:
    section.add "fileId", valid_589695
  var valid_589696 = path.getOrDefault("revisionId")
  valid_589696 = validateParameter(valid_589696, JString, required = true,
                                 default = nil)
  if valid_589696 != nil:
    section.add "revisionId", valid_589696
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
  var valid_589697 = query.getOrDefault("fields")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "fields", valid_589697
  var valid_589698 = query.getOrDefault("quotaUser")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "quotaUser", valid_589698
  var valid_589699 = query.getOrDefault("alt")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = newJString("json"))
  if valid_589699 != nil:
    section.add "alt", valid_589699
  var valid_589700 = query.getOrDefault("oauth_token")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "oauth_token", valid_589700
  var valid_589701 = query.getOrDefault("userIp")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "userIp", valid_589701
  var valid_589702 = query.getOrDefault("key")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "key", valid_589702
  var valid_589703 = query.getOrDefault("prettyPrint")
  valid_589703 = validateParameter(valid_589703, JBool, required = false,
                                 default = newJBool(true))
  if valid_589703 != nil:
    section.add "prettyPrint", valid_589703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589704: Call_DriveRevisionsDelete_589692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_589704.validator(path, query, header, formData, body)
  let scheme = call_589704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589704.url(scheme.get, call_589704.host, call_589704.base,
                         call_589704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589704, url, valid)

proc call*(call_589705: Call_DriveRevisionsDelete_589692; fileId: string;
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
  var path_589706 = newJObject()
  var query_589707 = newJObject()
  add(query_589707, "fields", newJString(fields))
  add(query_589707, "quotaUser", newJString(quotaUser))
  add(path_589706, "fileId", newJString(fileId))
  add(query_589707, "alt", newJString(alt))
  add(query_589707, "oauth_token", newJString(oauthToken))
  add(path_589706, "revisionId", newJString(revisionId))
  add(query_589707, "userIp", newJString(userIp))
  add(query_589707, "key", newJString(key))
  add(query_589707, "prettyPrint", newJBool(prettyPrint))
  result = call_589705.call(path_589706, query_589707, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_589692(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_589693, base: "/drive/v3",
    url: url_DriveRevisionsDelete_589694, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_589726 = ref object of OpenApiRestCall_588457
proc url_DriveFilesWatch_589728(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DriveFilesWatch_589727(path: JsonNode; query: JsonNode;
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
  var valid_589729 = path.getOrDefault("fileId")
  valid_589729 = validateParameter(valid_589729, JString, required = true,
                                 default = nil)
  if valid_589729 != nil:
    section.add "fileId", valid_589729
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
  var valid_589730 = query.getOrDefault("supportsAllDrives")
  valid_589730 = validateParameter(valid_589730, JBool, required = false,
                                 default = newJBool(false))
  if valid_589730 != nil:
    section.add "supportsAllDrives", valid_589730
  var valid_589731 = query.getOrDefault("fields")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "fields", valid_589731
  var valid_589732 = query.getOrDefault("quotaUser")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "quotaUser", valid_589732
  var valid_589733 = query.getOrDefault("alt")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = newJString("json"))
  if valid_589733 != nil:
    section.add "alt", valid_589733
  var valid_589734 = query.getOrDefault("acknowledgeAbuse")
  valid_589734 = validateParameter(valid_589734, JBool, required = false,
                                 default = newJBool(false))
  if valid_589734 != nil:
    section.add "acknowledgeAbuse", valid_589734
  var valid_589735 = query.getOrDefault("oauth_token")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "oauth_token", valid_589735
  var valid_589736 = query.getOrDefault("userIp")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "userIp", valid_589736
  var valid_589737 = query.getOrDefault("supportsTeamDrives")
  valid_589737 = validateParameter(valid_589737, JBool, required = false,
                                 default = newJBool(false))
  if valid_589737 != nil:
    section.add "supportsTeamDrives", valid_589737
  var valid_589738 = query.getOrDefault("key")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "key", valid_589738
  var valid_589739 = query.getOrDefault("prettyPrint")
  valid_589739 = validateParameter(valid_589739, JBool, required = false,
                                 default = newJBool(true))
  if valid_589739 != nil:
    section.add "prettyPrint", valid_589739
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

proc call*(call_589741: Call_DriveFilesWatch_589726; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes to a file
  ## 
  let valid = call_589741.validator(path, query, header, formData, body)
  let scheme = call_589741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589741.url(scheme.get, call_589741.host, call_589741.base,
                         call_589741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589741, url, valid)

proc call*(call_589742: Call_DriveFilesWatch_589726; fileId: string;
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
  var path_589743 = newJObject()
  var query_589744 = newJObject()
  var body_589745 = newJObject()
  add(query_589744, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_589744, "fields", newJString(fields))
  add(query_589744, "quotaUser", newJString(quotaUser))
  add(path_589743, "fileId", newJString(fileId))
  add(query_589744, "alt", newJString(alt))
  add(query_589744, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_589744, "oauth_token", newJString(oauthToken))
  add(query_589744, "userIp", newJString(userIp))
  add(query_589744, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_589744, "key", newJString(key))
  if resource != nil:
    body_589745 = resource
  add(query_589744, "prettyPrint", newJBool(prettyPrint))
  result = call_589742.call(path_589743, query_589744, nil, nil, body_589745)

var driveFilesWatch* = Call_DriveFilesWatch_589726(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_589727,
    base: "/drive/v3", url: url_DriveFilesWatch_589728, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesCreate_589763 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesCreate_589765(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesCreate_589764(path: JsonNode; query: JsonNode;
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
  var valid_589766 = query.getOrDefault("fields")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "fields", valid_589766
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_589767 = query.getOrDefault("requestId")
  valid_589767 = validateParameter(valid_589767, JString, required = true,
                                 default = nil)
  if valid_589767 != nil:
    section.add "requestId", valid_589767
  var valid_589768 = query.getOrDefault("quotaUser")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "quotaUser", valid_589768
  var valid_589769 = query.getOrDefault("alt")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = newJString("json"))
  if valid_589769 != nil:
    section.add "alt", valid_589769
  var valid_589770 = query.getOrDefault("oauth_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "oauth_token", valid_589770
  var valid_589771 = query.getOrDefault("userIp")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "userIp", valid_589771
  var valid_589772 = query.getOrDefault("key")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = nil)
  if valid_589772 != nil:
    section.add "key", valid_589772
  var valid_589773 = query.getOrDefault("prettyPrint")
  valid_589773 = validateParameter(valid_589773, JBool, required = false,
                                 default = newJBool(true))
  if valid_589773 != nil:
    section.add "prettyPrint", valid_589773
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

proc call*(call_589775: Call_DriveTeamdrivesCreate_589763; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.create instead.
  ## 
  let valid = call_589775.validator(path, query, header, formData, body)
  let scheme = call_589775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589775.url(scheme.get, call_589775.host, call_589775.base,
                         call_589775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589775, url, valid)

proc call*(call_589776: Call_DriveTeamdrivesCreate_589763; requestId: string;
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
  var query_589777 = newJObject()
  var body_589778 = newJObject()
  add(query_589777, "fields", newJString(fields))
  add(query_589777, "requestId", newJString(requestId))
  add(query_589777, "quotaUser", newJString(quotaUser))
  add(query_589777, "alt", newJString(alt))
  add(query_589777, "oauth_token", newJString(oauthToken))
  add(query_589777, "userIp", newJString(userIp))
  add(query_589777, "key", newJString(key))
  if body != nil:
    body_589778 = body
  add(query_589777, "prettyPrint", newJBool(prettyPrint))
  result = call_589776.call(nil, query_589777, nil, nil, body_589778)

var driveTeamdrivesCreate* = Call_DriveTeamdrivesCreate_589763(
    name: "driveTeamdrivesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesCreate_589764, base: "/drive/v3",
    url: url_DriveTeamdrivesCreate_589765, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_589746 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesList_589748(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_589747(path: JsonNode; query: JsonNode;
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
  var valid_589749 = query.getOrDefault("fields")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "fields", valid_589749
  var valid_589750 = query.getOrDefault("pageToken")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "pageToken", valid_589750
  var valid_589751 = query.getOrDefault("quotaUser")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "quotaUser", valid_589751
  var valid_589752 = query.getOrDefault("alt")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = newJString("json"))
  if valid_589752 != nil:
    section.add "alt", valid_589752
  var valid_589753 = query.getOrDefault("oauth_token")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = nil)
  if valid_589753 != nil:
    section.add "oauth_token", valid_589753
  var valid_589754 = query.getOrDefault("userIp")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "userIp", valid_589754
  var valid_589755 = query.getOrDefault("q")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "q", valid_589755
  var valid_589756 = query.getOrDefault("key")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "key", valid_589756
  var valid_589757 = query.getOrDefault("useDomainAdminAccess")
  valid_589757 = validateParameter(valid_589757, JBool, required = false,
                                 default = newJBool(false))
  if valid_589757 != nil:
    section.add "useDomainAdminAccess", valid_589757
  var valid_589758 = query.getOrDefault("pageSize")
  valid_589758 = validateParameter(valid_589758, JInt, required = false,
                                 default = newJInt(10))
  if valid_589758 != nil:
    section.add "pageSize", valid_589758
  var valid_589759 = query.getOrDefault("prettyPrint")
  valid_589759 = validateParameter(valid_589759, JBool, required = false,
                                 default = newJBool(true))
  if valid_589759 != nil:
    section.add "prettyPrint", valid_589759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589760: Call_DriveTeamdrivesList_589746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_589760.validator(path, query, header, formData, body)
  let scheme = call_589760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589760.url(scheme.get, call_589760.host, call_589760.base,
                         call_589760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589760, url, valid)

proc call*(call_589761: Call_DriveTeamdrivesList_589746; fields: string = "";
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
  var query_589762 = newJObject()
  add(query_589762, "fields", newJString(fields))
  add(query_589762, "pageToken", newJString(pageToken))
  add(query_589762, "quotaUser", newJString(quotaUser))
  add(query_589762, "alt", newJString(alt))
  add(query_589762, "oauth_token", newJString(oauthToken))
  add(query_589762, "userIp", newJString(userIp))
  add(query_589762, "q", newJString(q))
  add(query_589762, "key", newJString(key))
  add(query_589762, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589762, "pageSize", newJInt(pageSize))
  add(query_589762, "prettyPrint", newJBool(prettyPrint))
  result = call_589761.call(nil, query_589762, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_589746(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_589747, base: "/drive/v3",
    url: url_DriveTeamdrivesList_589748, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_589779 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesGet_589781(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_589780(path: JsonNode; query: JsonNode;
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
  var valid_589782 = path.getOrDefault("teamDriveId")
  valid_589782 = validateParameter(valid_589782, JString, required = true,
                                 default = nil)
  if valid_589782 != nil:
    section.add "teamDriveId", valid_589782
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
  var valid_589783 = query.getOrDefault("fields")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = nil)
  if valid_589783 != nil:
    section.add "fields", valid_589783
  var valid_589784 = query.getOrDefault("quotaUser")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "quotaUser", valid_589784
  var valid_589785 = query.getOrDefault("alt")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = newJString("json"))
  if valid_589785 != nil:
    section.add "alt", valid_589785
  var valid_589786 = query.getOrDefault("oauth_token")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "oauth_token", valid_589786
  var valid_589787 = query.getOrDefault("userIp")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "userIp", valid_589787
  var valid_589788 = query.getOrDefault("key")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "key", valid_589788
  var valid_589789 = query.getOrDefault("useDomainAdminAccess")
  valid_589789 = validateParameter(valid_589789, JBool, required = false,
                                 default = newJBool(false))
  if valid_589789 != nil:
    section.add "useDomainAdminAccess", valid_589789
  var valid_589790 = query.getOrDefault("prettyPrint")
  valid_589790 = validateParameter(valid_589790, JBool, required = false,
                                 default = newJBool(true))
  if valid_589790 != nil:
    section.add "prettyPrint", valid_589790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589791: Call_DriveTeamdrivesGet_589779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_589791.validator(path, query, header, formData, body)
  let scheme = call_589791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589791.url(scheme.get, call_589791.host, call_589791.base,
                         call_589791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589791, url, valid)

proc call*(call_589792: Call_DriveTeamdrivesGet_589779; teamDriveId: string;
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
  var path_589793 = newJObject()
  var query_589794 = newJObject()
  add(path_589793, "teamDriveId", newJString(teamDriveId))
  add(query_589794, "fields", newJString(fields))
  add(query_589794, "quotaUser", newJString(quotaUser))
  add(query_589794, "alt", newJString(alt))
  add(query_589794, "oauth_token", newJString(oauthToken))
  add(query_589794, "userIp", newJString(userIp))
  add(query_589794, "key", newJString(key))
  add(query_589794, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_589794, "prettyPrint", newJBool(prettyPrint))
  result = call_589792.call(path_589793, query_589794, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_589779(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_589780, base: "/drive/v3",
    url: url_DriveTeamdrivesGet_589781, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_589810 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesUpdate_589812(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_589811(path: JsonNode; query: JsonNode;
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
  var valid_589813 = path.getOrDefault("teamDriveId")
  valid_589813 = validateParameter(valid_589813, JString, required = true,
                                 default = nil)
  if valid_589813 != nil:
    section.add "teamDriveId", valid_589813
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
  var valid_589814 = query.getOrDefault("fields")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "fields", valid_589814
  var valid_589815 = query.getOrDefault("quotaUser")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "quotaUser", valid_589815
  var valid_589816 = query.getOrDefault("alt")
  valid_589816 = validateParameter(valid_589816, JString, required = false,
                                 default = newJString("json"))
  if valid_589816 != nil:
    section.add "alt", valid_589816
  var valid_589817 = query.getOrDefault("oauth_token")
  valid_589817 = validateParameter(valid_589817, JString, required = false,
                                 default = nil)
  if valid_589817 != nil:
    section.add "oauth_token", valid_589817
  var valid_589818 = query.getOrDefault("userIp")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "userIp", valid_589818
  var valid_589819 = query.getOrDefault("key")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = nil)
  if valid_589819 != nil:
    section.add "key", valid_589819
  var valid_589820 = query.getOrDefault("useDomainAdminAccess")
  valid_589820 = validateParameter(valid_589820, JBool, required = false,
                                 default = newJBool(false))
  if valid_589820 != nil:
    section.add "useDomainAdminAccess", valid_589820
  var valid_589821 = query.getOrDefault("prettyPrint")
  valid_589821 = validateParameter(valid_589821, JBool, required = false,
                                 default = newJBool(true))
  if valid_589821 != nil:
    section.add "prettyPrint", valid_589821
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

proc call*(call_589823: Call_DriveTeamdrivesUpdate_589810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead
  ## 
  let valid = call_589823.validator(path, query, header, formData, body)
  let scheme = call_589823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589823.url(scheme.get, call_589823.host, call_589823.base,
                         call_589823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589823, url, valid)

proc call*(call_589824: Call_DriveTeamdrivesUpdate_589810; teamDriveId: string;
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
  var path_589825 = newJObject()
  var query_589826 = newJObject()
  var body_589827 = newJObject()
  add(path_589825, "teamDriveId", newJString(teamDriveId))
  add(query_589826, "fields", newJString(fields))
  add(query_589826, "quotaUser", newJString(quotaUser))
  add(query_589826, "alt", newJString(alt))
  add(query_589826, "oauth_token", newJString(oauthToken))
  add(query_589826, "userIp", newJString(userIp))
  add(query_589826, "key", newJString(key))
  add(query_589826, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_589827 = body
  add(query_589826, "prettyPrint", newJBool(prettyPrint))
  result = call_589824.call(path_589825, query_589826, nil, nil, body_589827)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_589810(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_589811, base: "/drive/v3",
    url: url_DriveTeamdrivesUpdate_589812, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_589795 = ref object of OpenApiRestCall_588457
proc url_DriveTeamdrivesDelete_589797(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamDriveId" in path, "`teamDriveId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/teamdrives/"),
               (kind: VariableSegment, value: "teamDriveId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_589796(path: JsonNode; query: JsonNode;
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
  var valid_589798 = path.getOrDefault("teamDriveId")
  valid_589798 = validateParameter(valid_589798, JString, required = true,
                                 default = nil)
  if valid_589798 != nil:
    section.add "teamDriveId", valid_589798
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
  var valid_589799 = query.getOrDefault("fields")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = nil)
  if valid_589799 != nil:
    section.add "fields", valid_589799
  var valid_589800 = query.getOrDefault("quotaUser")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = nil)
  if valid_589800 != nil:
    section.add "quotaUser", valid_589800
  var valid_589801 = query.getOrDefault("alt")
  valid_589801 = validateParameter(valid_589801, JString, required = false,
                                 default = newJString("json"))
  if valid_589801 != nil:
    section.add "alt", valid_589801
  var valid_589802 = query.getOrDefault("oauth_token")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "oauth_token", valid_589802
  var valid_589803 = query.getOrDefault("userIp")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "userIp", valid_589803
  var valid_589804 = query.getOrDefault("key")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "key", valid_589804
  var valid_589805 = query.getOrDefault("prettyPrint")
  valid_589805 = validateParameter(valid_589805, JBool, required = false,
                                 default = newJBool(true))
  if valid_589805 != nil:
    section.add "prettyPrint", valid_589805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589806: Call_DriveTeamdrivesDelete_589795; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_589806.validator(path, query, header, formData, body)
  let scheme = call_589806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589806.url(scheme.get, call_589806.host, call_589806.base,
                         call_589806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589806, url, valid)

proc call*(call_589807: Call_DriveTeamdrivesDelete_589795; teamDriveId: string;
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
  var path_589808 = newJObject()
  var query_589809 = newJObject()
  add(path_589808, "teamDriveId", newJString(teamDriveId))
  add(query_589809, "fields", newJString(fields))
  add(query_589809, "quotaUser", newJString(quotaUser))
  add(query_589809, "alt", newJString(alt))
  add(query_589809, "oauth_token", newJString(oauthToken))
  add(query_589809, "userIp", newJString(userIp))
  add(query_589809, "key", newJString(key))
  add(query_589809, "prettyPrint", newJBool(prettyPrint))
  result = call_589807.call(path_589808, query_589809, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_589795(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_589796, base: "/drive/v3",
    url: url_DriveTeamdrivesDelete_589797, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
