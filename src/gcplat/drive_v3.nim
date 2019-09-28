
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_579692 = ref object of OpenApiRestCall_579424
proc url_DriveAboutGet_579694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_579693(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("key")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "key", valid_579824
  var valid_579825 = query.getOrDefault("prettyPrint")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "prettyPrint", valid_579825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579848: Call_DriveAboutGet_579692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  let valid = call_579848.validator(path, query, header, formData, body)
  let scheme = call_579848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579848.url(scheme.get, call_579848.host, call_579848.base,
                         call_579848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579848, url, valid)

proc call*(call_579919: Call_DriveAboutGet_579692; fields: string = "";
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
  var query_579920 = newJObject()
  add(query_579920, "fields", newJString(fields))
  add(query_579920, "quotaUser", newJString(quotaUser))
  add(query_579920, "alt", newJString(alt))
  add(query_579920, "oauth_token", newJString(oauthToken))
  add(query_579920, "userIp", newJString(userIp))
  add(query_579920, "key", newJString(key))
  add(query_579920, "prettyPrint", newJBool(prettyPrint))
  result = call_579919.call(nil, query_579920, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_579692(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_579693, base: "/drive/v3",
    url: url_DriveAboutGet_579694, schemes: {Scheme.Https})
type
  Call_DriveChangesList_579960 = ref object of OpenApiRestCall_579424
proc url_DriveChangesList_579962(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_579961(path: JsonNode; query: JsonNode;
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
  var valid_579963 = query.getOrDefault("driveId")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "driveId", valid_579963
  var valid_579964 = query.getOrDefault("supportsAllDrives")
  valid_579964 = validateParameter(valid_579964, JBool, required = false,
                                 default = newJBool(false))
  if valid_579964 != nil:
    section.add "supportsAllDrives", valid_579964
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_579966 = query.getOrDefault("pageToken")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "pageToken", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("oauth_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "oauth_token", valid_579969
  var valid_579970 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(false))
  if valid_579970 != nil:
    section.add "includeItemsFromAllDrives", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("includeTeamDriveItems")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(false))
  if valid_579972 != nil:
    section.add "includeTeamDriveItems", valid_579972
  var valid_579973 = query.getOrDefault("teamDriveId")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "teamDriveId", valid_579973
  var valid_579974 = query.getOrDefault("supportsTeamDrives")
  valid_579974 = validateParameter(valid_579974, JBool, required = false,
                                 default = newJBool(false))
  if valid_579974 != nil:
    section.add "supportsTeamDrives", valid_579974
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("spaces")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("drive"))
  if valid_579976 != nil:
    section.add "spaces", valid_579976
  var valid_579978 = query.getOrDefault("pageSize")
  valid_579978 = validateParameter(valid_579978, JInt, required = false,
                                 default = newJInt(100))
  if valid_579978 != nil:
    section.add "pageSize", valid_579978
  var valid_579979 = query.getOrDefault("includeRemoved")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "includeRemoved", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("restrictToMyDrive")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(false))
  if valid_579981 != nil:
    section.add "restrictToMyDrive", valid_579981
  var valid_579982 = query.getOrDefault("includeCorpusRemovals")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(false))
  if valid_579982 != nil:
    section.add "includeCorpusRemovals", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_DriveChangesList_579960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_DriveChangesList_579960; pageToken: string;
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
  var query_579985 = newJObject()
  add(query_579985, "driveId", newJString(driveId))
  add(query_579985, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "pageToken", newJString(pageToken))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579985, "userIp", newJString(userIp))
  add(query_579985, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_579985, "teamDriveId", newJString(teamDriveId))
  add(query_579985, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579985, "key", newJString(key))
  add(query_579985, "spaces", newJString(spaces))
  add(query_579985, "pageSize", newJInt(pageSize))
  add(query_579985, "includeRemoved", newJBool(includeRemoved))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_579985, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_579960(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_579961, base: "/drive/v3",
    url: url_DriveChangesList_579962, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_579986 = ref object of OpenApiRestCall_579424
proc url_DriveChangesGetStartPageToken_579988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_579987(path: JsonNode; query: JsonNode;
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
  var valid_579989 = query.getOrDefault("driveId")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "driveId", valid_579989
  var valid_579990 = query.getOrDefault("supportsAllDrives")
  valid_579990 = validateParameter(valid_579990, JBool, required = false,
                                 default = newJBool(false))
  if valid_579990 != nil:
    section.add "supportsAllDrives", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("teamDriveId")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "teamDriveId", valid_579996
  var valid_579997 = query.getOrDefault("supportsTeamDrives")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(false))
  if valid_579997 != nil:
    section.add "supportsTeamDrives", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_DriveChangesGetStartPageToken_579986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_DriveChangesGetStartPageToken_579986;
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
  var query_580002 = newJObject()
  add(query_580002, "driveId", newJString(driveId))
  add(query_580002, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(query_580002, "teamDriveId", newJString(teamDriveId))
  add(query_580002, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(nil, query_580002, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_579986(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_579987, base: "/drive/v3",
    url: url_DriveChangesGetStartPageToken_579988, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_580003 = ref object of OpenApiRestCall_579424
proc url_DriveChangesWatch_580005(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_580004(path: JsonNode; query: JsonNode;
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
  var valid_580006 = query.getOrDefault("driveId")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "driveId", valid_580006
  var valid_580007 = query.getOrDefault("supportsAllDrives")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(false))
  if valid_580007 != nil:
    section.add "supportsAllDrives", valid_580007
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_580009 = query.getOrDefault("pageToken")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "pageToken", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(false))
  if valid_580013 != nil:
    section.add "includeItemsFromAllDrives", valid_580013
  var valid_580014 = query.getOrDefault("userIp")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "userIp", valid_580014
  var valid_580015 = query.getOrDefault("includeTeamDriveItems")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(false))
  if valid_580015 != nil:
    section.add "includeTeamDriveItems", valid_580015
  var valid_580016 = query.getOrDefault("teamDriveId")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "teamDriveId", valid_580016
  var valid_580017 = query.getOrDefault("supportsTeamDrives")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(false))
  if valid_580017 != nil:
    section.add "supportsTeamDrives", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("spaces")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("drive"))
  if valid_580019 != nil:
    section.add "spaces", valid_580019
  var valid_580020 = query.getOrDefault("pageSize")
  valid_580020 = validateParameter(valid_580020, JInt, required = false,
                                 default = newJInt(100))
  if valid_580020 != nil:
    section.add "pageSize", valid_580020
  var valid_580021 = query.getOrDefault("includeRemoved")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "includeRemoved", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("restrictToMyDrive")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(false))
  if valid_580023 != nil:
    section.add "restrictToMyDrive", valid_580023
  var valid_580024 = query.getOrDefault("includeCorpusRemovals")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(false))
  if valid_580024 != nil:
    section.add "includeCorpusRemovals", valid_580024
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

proc call*(call_580026: Call_DriveChangesWatch_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes for a user.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_DriveChangesWatch_580003; pageToken: string;
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
  var query_580028 = newJObject()
  var body_580029 = newJObject()
  add(query_580028, "driveId", newJString(driveId))
  add(query_580028, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580028, "fields", newJString(fields))
  add(query_580028, "pageToken", newJString(pageToken))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580028, "userIp", newJString(userIp))
  add(query_580028, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580028, "teamDriveId", newJString(teamDriveId))
  add(query_580028, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580028, "key", newJString(key))
  add(query_580028, "spaces", newJString(spaces))
  add(query_580028, "pageSize", newJInt(pageSize))
  add(query_580028, "includeRemoved", newJBool(includeRemoved))
  if resource != nil:
    body_580029 = resource
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_580028, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  result = call_580027.call(nil, query_580028, nil, nil, body_580029)

var driveChangesWatch* = Call_DriveChangesWatch_580003(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_580004, base: "/drive/v3",
    url: url_DriveChangesWatch_580005, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_580030 = ref object of OpenApiRestCall_579424
proc url_DriveChannelsStop_580032(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_580031(path: JsonNode; query: JsonNode;
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
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
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

proc call*(call_580041: Call_DriveChannelsStop_580030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_DriveChannelsStop_580030; fields: string = "";
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
  var query_580043 = newJObject()
  var body_580044 = newJObject()
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "userIp", newJString(userIp))
  add(query_580043, "key", newJString(key))
  if resource != nil:
    body_580044 = resource
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  result = call_580042.call(nil, query_580043, nil, nil, body_580044)

var driveChannelsStop* = Call_DriveChannelsStop_580030(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_580031, base: "/drive/v3",
    url: url_DriveChannelsStop_580032, schemes: {Scheme.Https})
type
  Call_DriveDrivesCreate_580062 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesCreate_580064(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesCreate_580063(path: JsonNode; query: JsonNode;
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
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580066 = query.getOrDefault("requestId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "requestId", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
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

proc call*(call_580074: Call_DriveDrivesCreate_580062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_DriveDrivesCreate_580062; requestId: string;
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
  var query_580076 = newJObject()
  var body_580077 = newJObject()
  add(query_580076, "fields", newJString(fields))
  add(query_580076, "requestId", newJString(requestId))
  add(query_580076, "quotaUser", newJString(quotaUser))
  add(query_580076, "alt", newJString(alt))
  add(query_580076, "oauth_token", newJString(oauthToken))
  add(query_580076, "userIp", newJString(userIp))
  add(query_580076, "key", newJString(key))
  if body != nil:
    body_580077 = body
  add(query_580076, "prettyPrint", newJBool(prettyPrint))
  result = call_580075.call(nil, query_580076, nil, nil, body_580077)

var driveDrivesCreate* = Call_DriveDrivesCreate_580062(name: "driveDrivesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesCreate_580063, base: "/drive/v3",
    url: url_DriveDrivesCreate_580064, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_580045 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesList_580047(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_580046(path: JsonNode; query: JsonNode;
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
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("pageToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "pageToken", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("q")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "q", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("useDomainAdminAccess")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(false))
  if valid_580056 != nil:
    section.add "useDomainAdminAccess", valid_580056
  var valid_580057 = query.getOrDefault("pageSize")
  valid_580057 = validateParameter(valid_580057, JInt, required = false,
                                 default = newJInt(10))
  if valid_580057 != nil:
    section.add "pageSize", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580059: Call_DriveDrivesList_580045; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_DriveDrivesList_580045; fields: string = "";
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
  var query_580061 = newJObject()
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "pageToken", newJString(pageToken))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "userIp", newJString(userIp))
  add(query_580061, "q", newJString(q))
  add(query_580061, "key", newJString(key))
  add(query_580061, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580061, "pageSize", newJInt(pageSize))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  result = call_580060.call(nil, query_580061, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_580045(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_580046, base: "/drive/v3",
    url: url_DriveDrivesList_580047, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_580078 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesGet_580080(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesGet_580079(path: JsonNode; query: JsonNode;
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
  var valid_580095 = path.getOrDefault("driveId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "driveId", valid_580095
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
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("userIp")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "userIp", valid_580100
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("useDomainAdminAccess")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(false))
  if valid_580102 != nil:
    section.add "useDomainAdminAccess", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580104: Call_DriveDrivesGet_580078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_DriveDrivesGet_580078; driveId: string;
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
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  add(query_580107, "fields", newJString(fields))
  add(path_580106, "driveId", newJString(driveId))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "userIp", newJString(userIp))
  add(query_580107, "key", newJString(key))
  add(query_580107, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(path_580106, query_580107, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_580078(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_580079,
    base: "/drive/v3", url: url_DriveDrivesGet_580080, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_580123 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesUpdate_580125(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUpdate_580124(path: JsonNode; query: JsonNode;
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
  var valid_580126 = path.getOrDefault("driveId")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "driveId", valid_580126
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
  var valid_580127 = query.getOrDefault("fields")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "fields", valid_580127
  var valid_580128 = query.getOrDefault("quotaUser")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "quotaUser", valid_580128
  var valid_580129 = query.getOrDefault("alt")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("json"))
  if valid_580129 != nil:
    section.add "alt", valid_580129
  var valid_580130 = query.getOrDefault("oauth_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "oauth_token", valid_580130
  var valid_580131 = query.getOrDefault("userIp")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "userIp", valid_580131
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("useDomainAdminAccess")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(false))
  if valid_580133 != nil:
    section.add "useDomainAdminAccess", valid_580133
  var valid_580134 = query.getOrDefault("prettyPrint")
  valid_580134 = validateParameter(valid_580134, JBool, required = false,
                                 default = newJBool(true))
  if valid_580134 != nil:
    section.add "prettyPrint", valid_580134
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

proc call*(call_580136: Call_DriveDrivesUpdate_580123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadate for a shared drive.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_DriveDrivesUpdate_580123; driveId: string;
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
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  var body_580140 = newJObject()
  add(query_580139, "fields", newJString(fields))
  add(path_580138, "driveId", newJString(driveId))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "userIp", newJString(userIp))
  add(query_580139, "key", newJString(key))
  add(query_580139, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_580140 = body
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  result = call_580137.call(path_580138, query_580139, nil, nil, body_580140)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_580123(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_580124,
    base: "/drive/v3", url: url_DriveDrivesUpdate_580125, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_580108 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesDelete_580110(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesDelete_580109(path: JsonNode; query: JsonNode;
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
  var valid_580111 = path.getOrDefault("driveId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "driveId", valid_580111
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
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_DriveDrivesDelete_580108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_DriveDrivesDelete_580108; driveId: string;
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
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "fields", newJString(fields))
  add(path_580121, "driveId", newJString(driveId))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "userIp", newJString(userIp))
  add(query_580122, "key", newJString(key))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_580108(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_580109,
    base: "/drive/v3", url: url_DriveDrivesDelete_580110, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_580141 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesHide_580143(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesHide_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("driveId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "driveId", valid_580144
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
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("oauth_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "oauth_token", valid_580148
  var valid_580149 = query.getOrDefault("userIp")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "userIp", valid_580149
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580152: Call_DriveDrivesHide_580141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_580152.validator(path, query, header, formData, body)
  let scheme = call_580152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580152.url(scheme.get, call_580152.host, call_580152.base,
                         call_580152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580152, url, valid)

proc call*(call_580153: Call_DriveDrivesHide_580141; driveId: string;
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
  var path_580154 = newJObject()
  var query_580155 = newJObject()
  add(query_580155, "fields", newJString(fields))
  add(path_580154, "driveId", newJString(driveId))
  add(query_580155, "quotaUser", newJString(quotaUser))
  add(query_580155, "alt", newJString(alt))
  add(query_580155, "oauth_token", newJString(oauthToken))
  add(query_580155, "userIp", newJString(userIp))
  add(query_580155, "key", newJString(key))
  add(query_580155, "prettyPrint", newJBool(prettyPrint))
  result = call_580153.call(path_580154, query_580155, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_580141(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_580142,
    base: "/drive/v3", url: url_DriveDrivesHide_580143, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_580156 = ref object of OpenApiRestCall_579424
proc url_DriveDrivesUnhide_580158(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUnhide_580157(path: JsonNode; query: JsonNode;
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
  var valid_580159 = path.getOrDefault("driveId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "driveId", valid_580159
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
  var valid_580160 = query.getOrDefault("fields")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fields", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("userIp")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "userIp", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580167: Call_DriveDrivesUnhide_580156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_DriveDrivesUnhide_580156; driveId: string;
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
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  add(query_580170, "fields", newJString(fields))
  add(path_580169, "driveId", newJString(driveId))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(query_580170, "userIp", newJString(userIp))
  add(query_580170, "key", newJString(key))
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_580156(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_580157,
    base: "/drive/v3", url: url_DriveDrivesUnhide_580158, schemes: {Scheme.Https})
type
  Call_DriveFilesCreate_580197 = ref object of OpenApiRestCall_579424
proc url_DriveFilesCreate_580199(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesCreate_580198(path: JsonNode; query: JsonNode;
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
  var valid_580200 = query.getOrDefault("supportsAllDrives")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(false))
  if valid_580200 != nil:
    section.add "supportsAllDrives", valid_580200
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("keepRevisionForever")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(false))
  if valid_580206 != nil:
    section.add "keepRevisionForever", valid_580206
  var valid_580207 = query.getOrDefault("supportsTeamDrives")
  valid_580207 = validateParameter(valid_580207, JBool, required = false,
                                 default = newJBool(false))
  if valid_580207 != nil:
    section.add "supportsTeamDrives", valid_580207
  var valid_580208 = query.getOrDefault("key")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "key", valid_580208
  var valid_580209 = query.getOrDefault("useContentAsIndexableText")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(false))
  if valid_580209 != nil:
    section.add "useContentAsIndexableText", valid_580209
  var valid_580210 = query.getOrDefault("prettyPrint")
  valid_580210 = validateParameter(valid_580210, JBool, required = false,
                                 default = newJBool(true))
  if valid_580210 != nil:
    section.add "prettyPrint", valid_580210
  var valid_580211 = query.getOrDefault("ignoreDefaultVisibility")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(false))
  if valid_580211 != nil:
    section.add "ignoreDefaultVisibility", valid_580211
  var valid_580212 = query.getOrDefault("ocrLanguage")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "ocrLanguage", valid_580212
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

proc call*(call_580214: Call_DriveFilesCreate_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new file.
  ## 
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_DriveFilesCreate_580197;
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
  var query_580216 = newJObject()
  var body_580217 = newJObject()
  add(query_580216, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580216, "fields", newJString(fields))
  add(query_580216, "quotaUser", newJString(quotaUser))
  add(query_580216, "alt", newJString(alt))
  add(query_580216, "oauth_token", newJString(oauthToken))
  add(query_580216, "userIp", newJString(userIp))
  add(query_580216, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_580216, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580216, "key", newJString(key))
  add(query_580216, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  if body != nil:
    body_580217 = body
  add(query_580216, "prettyPrint", newJBool(prettyPrint))
  add(query_580216, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_580216, "ocrLanguage", newJString(ocrLanguage))
  result = call_580215.call(nil, query_580216, nil, nil, body_580217)

var driveFilesCreate* = Call_DriveFilesCreate_580197(name: "driveFilesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesCreate_580198, base: "/drive/v3",
    url: url_DriveFilesCreate_580199, schemes: {Scheme.Https})
type
  Call_DriveFilesList_580171 = ref object of OpenApiRestCall_579424
proc url_DriveFilesList_580173(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_580172(path: JsonNode; query: JsonNode;
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
  var valid_580174 = query.getOrDefault("driveId")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "driveId", valid_580174
  var valid_580175 = query.getOrDefault("supportsAllDrives")
  valid_580175 = validateParameter(valid_580175, JBool, required = false,
                                 default = newJBool(false))
  if valid_580175 != nil:
    section.add "supportsAllDrives", valid_580175
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("pageToken")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "pageToken", valid_580177
  var valid_580178 = query.getOrDefault("quotaUser")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "quotaUser", valid_580178
  var valid_580179 = query.getOrDefault("alt")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("json"))
  if valid_580179 != nil:
    section.add "alt", valid_580179
  var valid_580180 = query.getOrDefault("oauth_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "oauth_token", valid_580180
  var valid_580181 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(false))
  if valid_580181 != nil:
    section.add "includeItemsFromAllDrives", valid_580181
  var valid_580182 = query.getOrDefault("userIp")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "userIp", valid_580182
  var valid_580183 = query.getOrDefault("includeTeamDriveItems")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(false))
  if valid_580183 != nil:
    section.add "includeTeamDriveItems", valid_580183
  var valid_580184 = query.getOrDefault("teamDriveId")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "teamDriveId", valid_580184
  var valid_580185 = query.getOrDefault("corpus")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("domain"))
  if valid_580185 != nil:
    section.add "corpus", valid_580185
  var valid_580186 = query.getOrDefault("orderBy")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "orderBy", valid_580186
  var valid_580187 = query.getOrDefault("q")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "q", valid_580187
  var valid_580188 = query.getOrDefault("supportsTeamDrives")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(false))
  if valid_580188 != nil:
    section.add "supportsTeamDrives", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("spaces")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("drive"))
  if valid_580190 != nil:
    section.add "spaces", valid_580190
  var valid_580191 = query.getOrDefault("pageSize")
  valid_580191 = validateParameter(valid_580191, JInt, required = false,
                                 default = newJInt(100))
  if valid_580191 != nil:
    section.add "pageSize", valid_580191
  var valid_580192 = query.getOrDefault("corpora")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "corpora", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580194: Call_DriveFilesList_580171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists or searches files.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_DriveFilesList_580171; driveId: string = "";
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
  var query_580196 = newJObject()
  add(query_580196, "driveId", newJString(driveId))
  add(query_580196, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "pageToken", newJString(pageToken))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580196, "userIp", newJString(userIp))
  add(query_580196, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580196, "teamDriveId", newJString(teamDriveId))
  add(query_580196, "corpus", newJString(corpus))
  add(query_580196, "orderBy", newJString(orderBy))
  add(query_580196, "q", newJString(q))
  add(query_580196, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580196, "key", newJString(key))
  add(query_580196, "spaces", newJString(spaces))
  add(query_580196, "pageSize", newJInt(pageSize))
  add(query_580196, "corpora", newJString(corpora))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  result = call_580195.call(nil, query_580196, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_580171(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_580172, base: "/drive/v3",
    url: url_DriveFilesList_580173, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_580218 = ref object of OpenApiRestCall_579424
proc url_DriveFilesGenerateIds_580220(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_580219(path: JsonNode; query: JsonNode;
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
  var valid_580221 = query.getOrDefault("fields")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "fields", valid_580221
  var valid_580222 = query.getOrDefault("quotaUser")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "quotaUser", valid_580222
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("oauth_token")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "oauth_token", valid_580224
  var valid_580225 = query.getOrDefault("space")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("drive"))
  if valid_580225 != nil:
    section.add "space", valid_580225
  var valid_580226 = query.getOrDefault("userIp")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "userIp", valid_580226
  var valid_580227 = query.getOrDefault("key")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "key", valid_580227
  var valid_580228 = query.getOrDefault("prettyPrint")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "prettyPrint", valid_580228
  var valid_580229 = query.getOrDefault("count")
  valid_580229 = validateParameter(valid_580229, JInt, required = false,
                                 default = newJInt(10))
  if valid_580229 != nil:
    section.add "count", valid_580229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580230: Call_DriveFilesGenerateIds_580218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  let valid = call_580230.validator(path, query, header, formData, body)
  let scheme = call_580230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580230.url(scheme.get, call_580230.host, call_580230.base,
                         call_580230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580230, url, valid)

proc call*(call_580231: Call_DriveFilesGenerateIds_580218; fields: string = "";
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
  var query_580232 = newJObject()
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(query_580232, "space", newJString(space))
  add(query_580232, "userIp", newJString(userIp))
  add(query_580232, "key", newJString(key))
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  add(query_580232, "count", newJInt(count))
  result = call_580231.call(nil, query_580232, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_580218(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_580219, base: "/drive/v3",
    url: url_DriveFilesGenerateIds_580220, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_580233 = ref object of OpenApiRestCall_579424
proc url_DriveFilesEmptyTrash_580235(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_580234(path: JsonNode; query: JsonNode;
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
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("userIp")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "userIp", valid_580240
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580243: Call_DriveFilesEmptyTrash_580233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_DriveFilesEmptyTrash_580233; fields: string = "";
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
  var query_580245 = newJObject()
  add(query_580245, "fields", newJString(fields))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "userIp", newJString(userIp))
  add(query_580245, "key", newJString(key))
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  result = call_580244.call(nil, query_580245, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_580233(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_580234, base: "/drive/v3",
    url: url_DriveFilesEmptyTrash_580235, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_580246 = ref object of OpenApiRestCall_579424
proc url_DriveFilesGet_580248(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesGet_580247(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580249 = path.getOrDefault("fileId")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fileId", valid_580249
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
  var valid_580250 = query.getOrDefault("supportsAllDrives")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(false))
  if valid_580250 != nil:
    section.add "supportsAllDrives", valid_580250
  var valid_580251 = query.getOrDefault("fields")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "fields", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("acknowledgeAbuse")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(false))
  if valid_580254 != nil:
    section.add "acknowledgeAbuse", valid_580254
  var valid_580255 = query.getOrDefault("oauth_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "oauth_token", valid_580255
  var valid_580256 = query.getOrDefault("userIp")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "userIp", valid_580256
  var valid_580257 = query.getOrDefault("supportsTeamDrives")
  valid_580257 = validateParameter(valid_580257, JBool, required = false,
                                 default = newJBool(false))
  if valid_580257 != nil:
    section.add "supportsTeamDrives", valid_580257
  var valid_580258 = query.getOrDefault("key")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "key", valid_580258
  var valid_580259 = query.getOrDefault("prettyPrint")
  valid_580259 = validateParameter(valid_580259, JBool, required = false,
                                 default = newJBool(true))
  if valid_580259 != nil:
    section.add "prettyPrint", valid_580259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580260: Call_DriveFilesGet_580246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata or content by ID.
  ## 
  let valid = call_580260.validator(path, query, header, formData, body)
  let scheme = call_580260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580260.url(scheme.get, call_580260.host, call_580260.base,
                         call_580260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580260, url, valid)

proc call*(call_580261: Call_DriveFilesGet_580246; fileId: string;
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
  var path_580262 = newJObject()
  var query_580263 = newJObject()
  add(query_580263, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580263, "fields", newJString(fields))
  add(query_580263, "quotaUser", newJString(quotaUser))
  add(path_580262, "fileId", newJString(fileId))
  add(query_580263, "alt", newJString(alt))
  add(query_580263, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580263, "oauth_token", newJString(oauthToken))
  add(query_580263, "userIp", newJString(userIp))
  add(query_580263, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580263, "key", newJString(key))
  add(query_580263, "prettyPrint", newJBool(prettyPrint))
  result = call_580261.call(path_580262, query_580263, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_580246(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_580247, base: "/drive/v3",
    url: url_DriveFilesGet_580248, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_580281 = ref object of OpenApiRestCall_579424
proc url_DriveFilesUpdate_580283(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUpdate_580282(path: JsonNode; query: JsonNode;
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
  var valid_580284 = path.getOrDefault("fileId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "fileId", valid_580284
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
  var valid_580285 = query.getOrDefault("supportsAllDrives")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(false))
  if valid_580285 != nil:
    section.add "supportsAllDrives", valid_580285
  var valid_580286 = query.getOrDefault("fields")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "fields", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("oauth_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "oauth_token", valid_580289
  var valid_580290 = query.getOrDefault("userIp")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "userIp", valid_580290
  var valid_580291 = query.getOrDefault("keepRevisionForever")
  valid_580291 = validateParameter(valid_580291, JBool, required = false,
                                 default = newJBool(false))
  if valid_580291 != nil:
    section.add "keepRevisionForever", valid_580291
  var valid_580292 = query.getOrDefault("supportsTeamDrives")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(false))
  if valid_580292 != nil:
    section.add "supportsTeamDrives", valid_580292
  var valid_580293 = query.getOrDefault("key")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "key", valid_580293
  var valid_580294 = query.getOrDefault("useContentAsIndexableText")
  valid_580294 = validateParameter(valid_580294, JBool, required = false,
                                 default = newJBool(false))
  if valid_580294 != nil:
    section.add "useContentAsIndexableText", valid_580294
  var valid_580295 = query.getOrDefault("addParents")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "addParents", valid_580295
  var valid_580296 = query.getOrDefault("prettyPrint")
  valid_580296 = validateParameter(valid_580296, JBool, required = false,
                                 default = newJBool(true))
  if valid_580296 != nil:
    section.add "prettyPrint", valid_580296
  var valid_580297 = query.getOrDefault("removeParents")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "removeParents", valid_580297
  var valid_580298 = query.getOrDefault("ocrLanguage")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "ocrLanguage", valid_580298
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

proc call*(call_580300: Call_DriveFilesUpdate_580281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_DriveFilesUpdate_580281; fileId: string;
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
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  var body_580304 = newJObject()
  add(query_580303, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(path_580302, "fileId", newJString(fileId))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "userIp", newJString(userIp))
  add(query_580303, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_580303, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580303, "key", newJString(key))
  add(query_580303, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580303, "addParents", newJString(addParents))
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  if body != nil:
    body_580304 = body
  add(query_580303, "removeParents", newJString(removeParents))
  add(query_580303, "ocrLanguage", newJString(ocrLanguage))
  result = call_580301.call(path_580302, query_580303, nil, nil, body_580304)

var driveFilesUpdate* = Call_DriveFilesUpdate_580281(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesUpdate_580282,
    base: "/drive/v3", url: url_DriveFilesUpdate_580283, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_580264 = ref object of OpenApiRestCall_579424
proc url_DriveFilesDelete_580266(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesDelete_580265(path: JsonNode; query: JsonNode;
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
  var valid_580267 = path.getOrDefault("fileId")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fileId", valid_580267
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
  var valid_580268 = query.getOrDefault("supportsAllDrives")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(false))
  if valid_580268 != nil:
    section.add "supportsAllDrives", valid_580268
  var valid_580269 = query.getOrDefault("fields")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "fields", valid_580269
  var valid_580270 = query.getOrDefault("quotaUser")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "quotaUser", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("oauth_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "oauth_token", valid_580272
  var valid_580273 = query.getOrDefault("userIp")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "userIp", valid_580273
  var valid_580274 = query.getOrDefault("supportsTeamDrives")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(false))
  if valid_580274 != nil:
    section.add "supportsTeamDrives", valid_580274
  var valid_580275 = query.getOrDefault("key")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "key", valid_580275
  var valid_580276 = query.getOrDefault("prettyPrint")
  valid_580276 = validateParameter(valid_580276, JBool, required = false,
                                 default = newJBool(true))
  if valid_580276 != nil:
    section.add "prettyPrint", valid_580276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580277: Call_DriveFilesDelete_580264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  let valid = call_580277.validator(path, query, header, formData, body)
  let scheme = call_580277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580277.url(scheme.get, call_580277.host, call_580277.base,
                         call_580277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580277, url, valid)

proc call*(call_580278: Call_DriveFilesDelete_580264; fileId: string;
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
  var path_580279 = newJObject()
  var query_580280 = newJObject()
  add(query_580280, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580280, "fields", newJString(fields))
  add(query_580280, "quotaUser", newJString(quotaUser))
  add(path_580279, "fileId", newJString(fileId))
  add(query_580280, "alt", newJString(alt))
  add(query_580280, "oauth_token", newJString(oauthToken))
  add(query_580280, "userIp", newJString(userIp))
  add(query_580280, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580280, "key", newJString(key))
  add(query_580280, "prettyPrint", newJBool(prettyPrint))
  result = call_580278.call(path_580279, query_580280, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_580264(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_580265,
    base: "/drive/v3", url: url_DriveFilesDelete_580266, schemes: {Scheme.Https})
type
  Call_DriveCommentsCreate_580324 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsCreate_580326(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsCreate_580325(path: JsonNode; query: JsonNode;
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
  var valid_580327 = path.getOrDefault("fileId")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "fileId", valid_580327
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
  var valid_580328 = query.getOrDefault("fields")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "fields", valid_580328
  var valid_580329 = query.getOrDefault("quotaUser")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "quotaUser", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("oauth_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "oauth_token", valid_580331
  var valid_580332 = query.getOrDefault("userIp")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "userIp", valid_580332
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
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

proc call*(call_580336: Call_DriveCommentsCreate_580324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on a file.
  ## 
  let valid = call_580336.validator(path, query, header, formData, body)
  let scheme = call_580336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580336.url(scheme.get, call_580336.host, call_580336.base,
                         call_580336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580336, url, valid)

proc call*(call_580337: Call_DriveCommentsCreate_580324; fileId: string;
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
  var path_580338 = newJObject()
  var query_580339 = newJObject()
  var body_580340 = newJObject()
  add(query_580339, "fields", newJString(fields))
  add(query_580339, "quotaUser", newJString(quotaUser))
  add(path_580338, "fileId", newJString(fileId))
  add(query_580339, "alt", newJString(alt))
  add(query_580339, "oauth_token", newJString(oauthToken))
  add(query_580339, "userIp", newJString(userIp))
  add(query_580339, "key", newJString(key))
  if body != nil:
    body_580340 = body
  add(query_580339, "prettyPrint", newJBool(prettyPrint))
  result = call_580337.call(path_580338, query_580339, nil, nil, body_580340)

var driveCommentsCreate* = Call_DriveCommentsCreate_580324(
    name: "driveCommentsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsCreate_580325, base: "/drive/v3",
    url: url_DriveCommentsCreate_580326, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_580305 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsList_580307(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsList_580306(path: JsonNode; query: JsonNode;
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
  var valid_580308 = path.getOrDefault("fileId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fileId", valid_580308
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
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("pageToken")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "pageToken", valid_580310
  var valid_580311 = query.getOrDefault("quotaUser")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "quotaUser", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("oauth_token")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "oauth_token", valid_580313
  var valid_580314 = query.getOrDefault("userIp")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "userIp", valid_580314
  var valid_580315 = query.getOrDefault("key")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "key", valid_580315
  var valid_580316 = query.getOrDefault("includeDeleted")
  valid_580316 = validateParameter(valid_580316, JBool, required = false,
                                 default = newJBool(false))
  if valid_580316 != nil:
    section.add "includeDeleted", valid_580316
  var valid_580317 = query.getOrDefault("pageSize")
  valid_580317 = validateParameter(valid_580317, JInt, required = false,
                                 default = newJInt(20))
  if valid_580317 != nil:
    section.add "pageSize", valid_580317
  var valid_580318 = query.getOrDefault("prettyPrint")
  valid_580318 = validateParameter(valid_580318, JBool, required = false,
                                 default = newJBool(true))
  if valid_580318 != nil:
    section.add "prettyPrint", valid_580318
  var valid_580319 = query.getOrDefault("startModifiedTime")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "startModifiedTime", valid_580319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580320: Call_DriveCommentsList_580305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_DriveCommentsList_580305; fileId: string;
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
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "pageToken", newJString(pageToken))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(path_580322, "fileId", newJString(fileId))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(query_580323, "userIp", newJString(userIp))
  add(query_580323, "key", newJString(key))
  add(query_580323, "includeDeleted", newJBool(includeDeleted))
  add(query_580323, "pageSize", newJInt(pageSize))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  add(query_580323, "startModifiedTime", newJString(startModifiedTime))
  result = call_580321.call(path_580322, query_580323, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_580305(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_580306,
    base: "/drive/v3", url: url_DriveCommentsList_580307, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_580341 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsGet_580343(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsGet_580342(path: JsonNode; query: JsonNode;
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
  var valid_580344 = path.getOrDefault("fileId")
  valid_580344 = validateParameter(valid_580344, JString, required = true,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fileId", valid_580344
  var valid_580345 = path.getOrDefault("commentId")
  valid_580345 = validateParameter(valid_580345, JString, required = true,
                                 default = nil)
  if valid_580345 != nil:
    section.add "commentId", valid_580345
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
  var valid_580346 = query.getOrDefault("fields")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "fields", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("alt")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("json"))
  if valid_580348 != nil:
    section.add "alt", valid_580348
  var valid_580349 = query.getOrDefault("oauth_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "oauth_token", valid_580349
  var valid_580350 = query.getOrDefault("userIp")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "userIp", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("includeDeleted")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(false))
  if valid_580352 != nil:
    section.add "includeDeleted", valid_580352
  var valid_580353 = query.getOrDefault("prettyPrint")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(true))
  if valid_580353 != nil:
    section.add "prettyPrint", valid_580353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580354: Call_DriveCommentsGet_580341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_DriveCommentsGet_580341; fileId: string;
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
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(path_580356, "fileId", newJString(fileId))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "userIp", newJString(userIp))
  add(query_580357, "key", newJString(key))
  add(path_580356, "commentId", newJString(commentId))
  add(query_580357, "includeDeleted", newJBool(includeDeleted))
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  result = call_580355.call(path_580356, query_580357, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_580341(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_580342, base: "/drive/v3",
    url: url_DriveCommentsGet_580343, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_580374 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsUpdate_580376(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsUpdate_580375(path: JsonNode; query: JsonNode;
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
  var valid_580377 = path.getOrDefault("fileId")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "fileId", valid_580377
  var valid_580378 = path.getOrDefault("commentId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "commentId", valid_580378
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
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("quotaUser")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "quotaUser", valid_580380
  var valid_580381 = query.getOrDefault("alt")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = newJString("json"))
  if valid_580381 != nil:
    section.add "alt", valid_580381
  var valid_580382 = query.getOrDefault("oauth_token")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "oauth_token", valid_580382
  var valid_580383 = query.getOrDefault("userIp")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "userIp", valid_580383
  var valid_580384 = query.getOrDefault("key")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "key", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
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

proc call*(call_580387: Call_DriveCommentsUpdate_580374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a comment with patch semantics.
  ## 
  let valid = call_580387.validator(path, query, header, formData, body)
  let scheme = call_580387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580387.url(scheme.get, call_580387.host, call_580387.base,
                         call_580387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580387, url, valid)

proc call*(call_580388: Call_DriveCommentsUpdate_580374; fileId: string;
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
  var path_580389 = newJObject()
  var query_580390 = newJObject()
  var body_580391 = newJObject()
  add(query_580390, "fields", newJString(fields))
  add(query_580390, "quotaUser", newJString(quotaUser))
  add(path_580389, "fileId", newJString(fileId))
  add(query_580390, "alt", newJString(alt))
  add(query_580390, "oauth_token", newJString(oauthToken))
  add(query_580390, "userIp", newJString(userIp))
  add(query_580390, "key", newJString(key))
  add(path_580389, "commentId", newJString(commentId))
  if body != nil:
    body_580391 = body
  add(query_580390, "prettyPrint", newJBool(prettyPrint))
  result = call_580388.call(path_580389, query_580390, nil, nil, body_580391)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_580374(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_580375, base: "/drive/v3",
    url: url_DriveCommentsUpdate_580376, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_580358 = ref object of OpenApiRestCall_579424
proc url_DriveCommentsDelete_580360(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsDelete_580359(path: JsonNode; query: JsonNode;
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
  var valid_580361 = path.getOrDefault("fileId")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fileId", valid_580361
  var valid_580362 = path.getOrDefault("commentId")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "commentId", valid_580362
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
  var valid_580363 = query.getOrDefault("fields")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "fields", valid_580363
  var valid_580364 = query.getOrDefault("quotaUser")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "quotaUser", valid_580364
  var valid_580365 = query.getOrDefault("alt")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("json"))
  if valid_580365 != nil:
    section.add "alt", valid_580365
  var valid_580366 = query.getOrDefault("oauth_token")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "oauth_token", valid_580366
  var valid_580367 = query.getOrDefault("userIp")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "userIp", valid_580367
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("prettyPrint")
  valid_580369 = validateParameter(valid_580369, JBool, required = false,
                                 default = newJBool(true))
  if valid_580369 != nil:
    section.add "prettyPrint", valid_580369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580370: Call_DriveCommentsDelete_580358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_580370.validator(path, query, header, formData, body)
  let scheme = call_580370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580370.url(scheme.get, call_580370.host, call_580370.base,
                         call_580370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580370, url, valid)

proc call*(call_580371: Call_DriveCommentsDelete_580358; fileId: string;
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
  var path_580372 = newJObject()
  var query_580373 = newJObject()
  add(query_580373, "fields", newJString(fields))
  add(query_580373, "quotaUser", newJString(quotaUser))
  add(path_580372, "fileId", newJString(fileId))
  add(query_580373, "alt", newJString(alt))
  add(query_580373, "oauth_token", newJString(oauthToken))
  add(query_580373, "userIp", newJString(userIp))
  add(query_580373, "key", newJString(key))
  add(path_580372, "commentId", newJString(commentId))
  add(query_580373, "prettyPrint", newJBool(prettyPrint))
  result = call_580371.call(path_580372, query_580373, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_580358(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_580359, base: "/drive/v3",
    url: url_DriveCommentsDelete_580360, schemes: {Scheme.Https})
type
  Call_DriveRepliesCreate_580411 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesCreate_580413(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesCreate_580412(path: JsonNode; query: JsonNode;
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
  var valid_580414 = path.getOrDefault("fileId")
  valid_580414 = validateParameter(valid_580414, JString, required = true,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fileId", valid_580414
  var valid_580415 = path.getOrDefault("commentId")
  valid_580415 = validateParameter(valid_580415, JString, required = true,
                                 default = nil)
  if valid_580415 != nil:
    section.add "commentId", valid_580415
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
  var valid_580416 = query.getOrDefault("fields")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "fields", valid_580416
  var valid_580417 = query.getOrDefault("quotaUser")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "quotaUser", valid_580417
  var valid_580418 = query.getOrDefault("alt")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("json"))
  if valid_580418 != nil:
    section.add "alt", valid_580418
  var valid_580419 = query.getOrDefault("oauth_token")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "oauth_token", valid_580419
  var valid_580420 = query.getOrDefault("userIp")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "userIp", valid_580420
  var valid_580421 = query.getOrDefault("key")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "key", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
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

proc call*(call_580424: Call_DriveRepliesCreate_580411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to a comment.
  ## 
  let valid = call_580424.validator(path, query, header, formData, body)
  let scheme = call_580424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580424.url(scheme.get, call_580424.host, call_580424.base,
                         call_580424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580424, url, valid)

proc call*(call_580425: Call_DriveRepliesCreate_580411; fileId: string;
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
  var path_580426 = newJObject()
  var query_580427 = newJObject()
  var body_580428 = newJObject()
  add(query_580427, "fields", newJString(fields))
  add(query_580427, "quotaUser", newJString(quotaUser))
  add(path_580426, "fileId", newJString(fileId))
  add(query_580427, "alt", newJString(alt))
  add(query_580427, "oauth_token", newJString(oauthToken))
  add(query_580427, "userIp", newJString(userIp))
  add(query_580427, "key", newJString(key))
  add(path_580426, "commentId", newJString(commentId))
  if body != nil:
    body_580428 = body
  add(query_580427, "prettyPrint", newJBool(prettyPrint))
  result = call_580425.call(path_580426, query_580427, nil, nil, body_580428)

var driveRepliesCreate* = Call_DriveRepliesCreate_580411(
    name: "driveRepliesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesCreate_580412, base: "/drive/v3",
    url: url_DriveRepliesCreate_580413, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_580392 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesList_580394(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesList_580393(path: JsonNode; query: JsonNode;
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
  var valid_580395 = path.getOrDefault("fileId")
  valid_580395 = validateParameter(valid_580395, JString, required = true,
                                 default = nil)
  if valid_580395 != nil:
    section.add "fileId", valid_580395
  var valid_580396 = path.getOrDefault("commentId")
  valid_580396 = validateParameter(valid_580396, JString, required = true,
                                 default = nil)
  if valid_580396 != nil:
    section.add "commentId", valid_580396
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
  var valid_580397 = query.getOrDefault("fields")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "fields", valid_580397
  var valid_580398 = query.getOrDefault("pageToken")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "pageToken", valid_580398
  var valid_580399 = query.getOrDefault("quotaUser")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "quotaUser", valid_580399
  var valid_580400 = query.getOrDefault("alt")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = newJString("json"))
  if valid_580400 != nil:
    section.add "alt", valid_580400
  var valid_580401 = query.getOrDefault("oauth_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "oauth_token", valid_580401
  var valid_580402 = query.getOrDefault("userIp")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "userIp", valid_580402
  var valid_580403 = query.getOrDefault("key")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "key", valid_580403
  var valid_580404 = query.getOrDefault("includeDeleted")
  valid_580404 = validateParameter(valid_580404, JBool, required = false,
                                 default = newJBool(false))
  if valid_580404 != nil:
    section.add "includeDeleted", valid_580404
  var valid_580405 = query.getOrDefault("pageSize")
  valid_580405 = validateParameter(valid_580405, JInt, required = false,
                                 default = newJInt(20))
  if valid_580405 != nil:
    section.add "pageSize", valid_580405
  var valid_580406 = query.getOrDefault("prettyPrint")
  valid_580406 = validateParameter(valid_580406, JBool, required = false,
                                 default = newJBool(true))
  if valid_580406 != nil:
    section.add "prettyPrint", valid_580406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580407: Call_DriveRepliesList_580392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a comment's replies.
  ## 
  let valid = call_580407.validator(path, query, header, formData, body)
  let scheme = call_580407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580407.url(scheme.get, call_580407.host, call_580407.base,
                         call_580407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580407, url, valid)

proc call*(call_580408: Call_DriveRepliesList_580392; fileId: string;
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
  var path_580409 = newJObject()
  var query_580410 = newJObject()
  add(query_580410, "fields", newJString(fields))
  add(query_580410, "pageToken", newJString(pageToken))
  add(query_580410, "quotaUser", newJString(quotaUser))
  add(path_580409, "fileId", newJString(fileId))
  add(query_580410, "alt", newJString(alt))
  add(query_580410, "oauth_token", newJString(oauthToken))
  add(query_580410, "userIp", newJString(userIp))
  add(query_580410, "key", newJString(key))
  add(path_580409, "commentId", newJString(commentId))
  add(query_580410, "includeDeleted", newJBool(includeDeleted))
  add(query_580410, "pageSize", newJInt(pageSize))
  add(query_580410, "prettyPrint", newJBool(prettyPrint))
  result = call_580408.call(path_580409, query_580410, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_580392(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_580393, base: "/drive/v3",
    url: url_DriveRepliesList_580394, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_580429 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesGet_580431(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesGet_580430(path: JsonNode; query: JsonNode;
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
  var valid_580432 = path.getOrDefault("fileId")
  valid_580432 = validateParameter(valid_580432, JString, required = true,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fileId", valid_580432
  var valid_580433 = path.getOrDefault("replyId")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "replyId", valid_580433
  var valid_580434 = path.getOrDefault("commentId")
  valid_580434 = validateParameter(valid_580434, JString, required = true,
                                 default = nil)
  if valid_580434 != nil:
    section.add "commentId", valid_580434
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
  var valid_580435 = query.getOrDefault("fields")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "fields", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("alt")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("json"))
  if valid_580437 != nil:
    section.add "alt", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("includeDeleted")
  valid_580441 = validateParameter(valid_580441, JBool, required = false,
                                 default = newJBool(false))
  if valid_580441 != nil:
    section.add "includeDeleted", valid_580441
  var valid_580442 = query.getOrDefault("prettyPrint")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "prettyPrint", valid_580442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580443: Call_DriveRepliesGet_580429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply by ID.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_DriveRepliesGet_580429; fileId: string; replyId: string;
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
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  add(query_580446, "fields", newJString(fields))
  add(query_580446, "quotaUser", newJString(quotaUser))
  add(path_580445, "fileId", newJString(fileId))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(query_580446, "userIp", newJString(userIp))
  add(query_580446, "key", newJString(key))
  add(path_580445, "replyId", newJString(replyId))
  add(path_580445, "commentId", newJString(commentId))
  add(query_580446, "includeDeleted", newJBool(includeDeleted))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  result = call_580444.call(path_580445, query_580446, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_580429(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_580430, base: "/drive/v3",
    url: url_DriveRepliesGet_580431, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_580464 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesUpdate_580466(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesUpdate_580465(path: JsonNode; query: JsonNode;
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
  var valid_580467 = path.getOrDefault("fileId")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "fileId", valid_580467
  var valid_580468 = path.getOrDefault("replyId")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "replyId", valid_580468
  var valid_580469 = path.getOrDefault("commentId")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "commentId", valid_580469
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
  var valid_580470 = query.getOrDefault("fields")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "fields", valid_580470
  var valid_580471 = query.getOrDefault("quotaUser")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "quotaUser", valid_580471
  var valid_580472 = query.getOrDefault("alt")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = newJString("json"))
  if valid_580472 != nil:
    section.add "alt", valid_580472
  var valid_580473 = query.getOrDefault("oauth_token")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "oauth_token", valid_580473
  var valid_580474 = query.getOrDefault("userIp")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "userIp", valid_580474
  var valid_580475 = query.getOrDefault("key")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "key", valid_580475
  var valid_580476 = query.getOrDefault("prettyPrint")
  valid_580476 = validateParameter(valid_580476, JBool, required = false,
                                 default = newJBool(true))
  if valid_580476 != nil:
    section.add "prettyPrint", valid_580476
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

proc call*(call_580478: Call_DriveRepliesUpdate_580464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a reply with patch semantics.
  ## 
  let valid = call_580478.validator(path, query, header, formData, body)
  let scheme = call_580478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580478.url(scheme.get, call_580478.host, call_580478.base,
                         call_580478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580478, url, valid)

proc call*(call_580479: Call_DriveRepliesUpdate_580464; fileId: string;
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
  var path_580480 = newJObject()
  var query_580481 = newJObject()
  var body_580482 = newJObject()
  add(query_580481, "fields", newJString(fields))
  add(query_580481, "quotaUser", newJString(quotaUser))
  add(path_580480, "fileId", newJString(fileId))
  add(query_580481, "alt", newJString(alt))
  add(query_580481, "oauth_token", newJString(oauthToken))
  add(query_580481, "userIp", newJString(userIp))
  add(query_580481, "key", newJString(key))
  add(path_580480, "replyId", newJString(replyId))
  add(path_580480, "commentId", newJString(commentId))
  if body != nil:
    body_580482 = body
  add(query_580481, "prettyPrint", newJBool(prettyPrint))
  result = call_580479.call(path_580480, query_580481, nil, nil, body_580482)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_580464(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_580465, base: "/drive/v3",
    url: url_DriveRepliesUpdate_580466, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_580447 = ref object of OpenApiRestCall_579424
proc url_DriveRepliesDelete_580449(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesDelete_580448(path: JsonNode; query: JsonNode;
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
  var valid_580450 = path.getOrDefault("fileId")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "fileId", valid_580450
  var valid_580451 = path.getOrDefault("replyId")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "replyId", valid_580451
  var valid_580452 = path.getOrDefault("commentId")
  valid_580452 = validateParameter(valid_580452, JString, required = true,
                                 default = nil)
  if valid_580452 != nil:
    section.add "commentId", valid_580452
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
  var valid_580453 = query.getOrDefault("fields")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "fields", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("alt")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = newJString("json"))
  if valid_580455 != nil:
    section.add "alt", valid_580455
  var valid_580456 = query.getOrDefault("oauth_token")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "oauth_token", valid_580456
  var valid_580457 = query.getOrDefault("userIp")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "userIp", valid_580457
  var valid_580458 = query.getOrDefault("key")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "key", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580460: Call_DriveRepliesDelete_580447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_580460.validator(path, query, header, formData, body)
  let scheme = call_580460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580460.url(scheme.get, call_580460.host, call_580460.base,
                         call_580460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580460, url, valid)

proc call*(call_580461: Call_DriveRepliesDelete_580447; fileId: string;
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
  var path_580462 = newJObject()
  var query_580463 = newJObject()
  add(query_580463, "fields", newJString(fields))
  add(query_580463, "quotaUser", newJString(quotaUser))
  add(path_580462, "fileId", newJString(fileId))
  add(query_580463, "alt", newJString(alt))
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "userIp", newJString(userIp))
  add(query_580463, "key", newJString(key))
  add(path_580462, "replyId", newJString(replyId))
  add(path_580462, "commentId", newJString(commentId))
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  result = call_580461.call(path_580462, query_580463, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_580447(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_580448, base: "/drive/v3",
    url: url_DriveRepliesDelete_580449, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_580483 = ref object of OpenApiRestCall_579424
proc url_DriveFilesCopy_580485(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesCopy_580484(path: JsonNode; query: JsonNode;
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
  var valid_580486 = path.getOrDefault("fileId")
  valid_580486 = validateParameter(valid_580486, JString, required = true,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fileId", valid_580486
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
  var valid_580487 = query.getOrDefault("supportsAllDrives")
  valid_580487 = validateParameter(valid_580487, JBool, required = false,
                                 default = newJBool(false))
  if valid_580487 != nil:
    section.add "supportsAllDrives", valid_580487
  var valid_580488 = query.getOrDefault("fields")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "fields", valid_580488
  var valid_580489 = query.getOrDefault("quotaUser")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "quotaUser", valid_580489
  var valid_580490 = query.getOrDefault("alt")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = newJString("json"))
  if valid_580490 != nil:
    section.add "alt", valid_580490
  var valid_580491 = query.getOrDefault("oauth_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "oauth_token", valid_580491
  var valid_580492 = query.getOrDefault("userIp")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "userIp", valid_580492
  var valid_580493 = query.getOrDefault("keepRevisionForever")
  valid_580493 = validateParameter(valid_580493, JBool, required = false,
                                 default = newJBool(false))
  if valid_580493 != nil:
    section.add "keepRevisionForever", valid_580493
  var valid_580494 = query.getOrDefault("supportsTeamDrives")
  valid_580494 = validateParameter(valid_580494, JBool, required = false,
                                 default = newJBool(false))
  if valid_580494 != nil:
    section.add "supportsTeamDrives", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("prettyPrint")
  valid_580496 = validateParameter(valid_580496, JBool, required = false,
                                 default = newJBool(true))
  if valid_580496 != nil:
    section.add "prettyPrint", valid_580496
  var valid_580497 = query.getOrDefault("ignoreDefaultVisibility")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(false))
  if valid_580497 != nil:
    section.add "ignoreDefaultVisibility", valid_580497
  var valid_580498 = query.getOrDefault("ocrLanguage")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "ocrLanguage", valid_580498
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

proc call*(call_580500: Call_DriveFilesCopy_580483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  let valid = call_580500.validator(path, query, header, formData, body)
  let scheme = call_580500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580500.url(scheme.get, call_580500.host, call_580500.base,
                         call_580500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580500, url, valid)

proc call*(call_580501: Call_DriveFilesCopy_580483; fileId: string;
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
  var path_580502 = newJObject()
  var query_580503 = newJObject()
  var body_580504 = newJObject()
  add(query_580503, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580503, "fields", newJString(fields))
  add(query_580503, "quotaUser", newJString(quotaUser))
  add(path_580502, "fileId", newJString(fileId))
  add(query_580503, "alt", newJString(alt))
  add(query_580503, "oauth_token", newJString(oauthToken))
  add(query_580503, "userIp", newJString(userIp))
  add(query_580503, "keepRevisionForever", newJBool(keepRevisionForever))
  add(query_580503, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580503, "key", newJString(key))
  if body != nil:
    body_580504 = body
  add(query_580503, "prettyPrint", newJBool(prettyPrint))
  add(query_580503, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_580503, "ocrLanguage", newJString(ocrLanguage))
  result = call_580501.call(path_580502, query_580503, nil, nil, body_580504)

var driveFilesCopy* = Call_DriveFilesCopy_580483(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_580484,
    base: "/drive/v3", url: url_DriveFilesCopy_580485, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_580505 = ref object of OpenApiRestCall_579424
proc url_DriveFilesExport_580507(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesExport_580506(path: JsonNode; query: JsonNode;
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
  var valid_580508 = path.getOrDefault("fileId")
  valid_580508 = validateParameter(valid_580508, JString, required = true,
                                 default = nil)
  if valid_580508 != nil:
    section.add "fileId", valid_580508
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
  var valid_580509 = query.getOrDefault("fields")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "fields", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("alt")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = newJString("json"))
  if valid_580511 != nil:
    section.add "alt", valid_580511
  var valid_580512 = query.getOrDefault("oauth_token")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "oauth_token", valid_580512
  var valid_580513 = query.getOrDefault("userIp")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "userIp", valid_580513
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_580514 = query.getOrDefault("mimeType")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "mimeType", valid_580514
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580517: Call_DriveFilesExport_580505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_580517.validator(path, query, header, formData, body)
  let scheme = call_580517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580517.url(scheme.get, call_580517.host, call_580517.base,
                         call_580517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580517, url, valid)

proc call*(call_580518: Call_DriveFilesExport_580505; fileId: string;
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
  var path_580519 = newJObject()
  var query_580520 = newJObject()
  add(query_580520, "fields", newJString(fields))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(path_580519, "fileId", newJString(fileId))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "mimeType", newJString(mimeType))
  add(query_580520, "key", newJString(key))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  result = call_580518.call(path_580519, query_580520, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_580505(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_580506,
    base: "/drive/v3", url: url_DriveFilesExport_580507, schemes: {Scheme.Https})
type
  Call_DrivePermissionsCreate_580541 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsCreate_580543(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsCreate_580542(path: JsonNode; query: JsonNode;
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
  var valid_580544 = path.getOrDefault("fileId")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "fileId", valid_580544
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
  var valid_580545 = query.getOrDefault("supportsAllDrives")
  valid_580545 = validateParameter(valid_580545, JBool, required = false,
                                 default = newJBool(false))
  if valid_580545 != nil:
    section.add "supportsAllDrives", valid_580545
  var valid_580546 = query.getOrDefault("fields")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "fields", valid_580546
  var valid_580547 = query.getOrDefault("quotaUser")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "quotaUser", valid_580547
  var valid_580548 = query.getOrDefault("alt")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("json"))
  if valid_580548 != nil:
    section.add "alt", valid_580548
  var valid_580549 = query.getOrDefault("sendNotificationEmail")
  valid_580549 = validateParameter(valid_580549, JBool, required = false, default = nil)
  if valid_580549 != nil:
    section.add "sendNotificationEmail", valid_580549
  var valid_580550 = query.getOrDefault("oauth_token")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "oauth_token", valid_580550
  var valid_580551 = query.getOrDefault("userIp")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "userIp", valid_580551
  var valid_580552 = query.getOrDefault("supportsTeamDrives")
  valid_580552 = validateParameter(valid_580552, JBool, required = false,
                                 default = newJBool(false))
  if valid_580552 != nil:
    section.add "supportsTeamDrives", valid_580552
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("useDomainAdminAccess")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(false))
  if valid_580554 != nil:
    section.add "useDomainAdminAccess", valid_580554
  var valid_580555 = query.getOrDefault("emailMessage")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "emailMessage", valid_580555
  var valid_580556 = query.getOrDefault("transferOwnership")
  valid_580556 = validateParameter(valid_580556, JBool, required = false,
                                 default = newJBool(false))
  if valid_580556 != nil:
    section.add "transferOwnership", valid_580556
  var valid_580557 = query.getOrDefault("prettyPrint")
  valid_580557 = validateParameter(valid_580557, JBool, required = false,
                                 default = newJBool(true))
  if valid_580557 != nil:
    section.add "prettyPrint", valid_580557
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

proc call*(call_580559: Call_DrivePermissionsCreate_580541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a permission for a file or shared drive.
  ## 
  let valid = call_580559.validator(path, query, header, formData, body)
  let scheme = call_580559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580559.url(scheme.get, call_580559.host, call_580559.base,
                         call_580559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580559, url, valid)

proc call*(call_580560: Call_DrivePermissionsCreate_580541; fileId: string;
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
  var path_580561 = newJObject()
  var query_580562 = newJObject()
  var body_580563 = newJObject()
  add(query_580562, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580562, "fields", newJString(fields))
  add(query_580562, "quotaUser", newJString(quotaUser))
  add(path_580561, "fileId", newJString(fileId))
  add(query_580562, "alt", newJString(alt))
  add(query_580562, "sendNotificationEmail", newJBool(sendNotificationEmail))
  add(query_580562, "oauth_token", newJString(oauthToken))
  add(query_580562, "userIp", newJString(userIp))
  add(query_580562, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580562, "key", newJString(key))
  add(query_580562, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580562, "emailMessage", newJString(emailMessage))
  add(query_580562, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_580563 = body
  add(query_580562, "prettyPrint", newJBool(prettyPrint))
  result = call_580560.call(path_580561, query_580562, nil, nil, body_580563)

var drivePermissionsCreate* = Call_DrivePermissionsCreate_580541(
    name: "drivePermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsCreate_580542, base: "/drive/v3",
    url: url_DrivePermissionsCreate_580543, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_580521 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsList_580523(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsList_580522(path: JsonNode; query: JsonNode;
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
  var valid_580524 = path.getOrDefault("fileId")
  valid_580524 = validateParameter(valid_580524, JString, required = true,
                                 default = nil)
  if valid_580524 != nil:
    section.add "fileId", valid_580524
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
  var valid_580525 = query.getOrDefault("supportsAllDrives")
  valid_580525 = validateParameter(valid_580525, JBool, required = false,
                                 default = newJBool(false))
  if valid_580525 != nil:
    section.add "supportsAllDrives", valid_580525
  var valid_580526 = query.getOrDefault("fields")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "fields", valid_580526
  var valid_580527 = query.getOrDefault("pageToken")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "pageToken", valid_580527
  var valid_580528 = query.getOrDefault("quotaUser")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "quotaUser", valid_580528
  var valid_580529 = query.getOrDefault("alt")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = newJString("json"))
  if valid_580529 != nil:
    section.add "alt", valid_580529
  var valid_580530 = query.getOrDefault("oauth_token")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "oauth_token", valid_580530
  var valid_580531 = query.getOrDefault("userIp")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "userIp", valid_580531
  var valid_580532 = query.getOrDefault("supportsTeamDrives")
  valid_580532 = validateParameter(valid_580532, JBool, required = false,
                                 default = newJBool(false))
  if valid_580532 != nil:
    section.add "supportsTeamDrives", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("useDomainAdminAccess")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(false))
  if valid_580534 != nil:
    section.add "useDomainAdminAccess", valid_580534
  var valid_580535 = query.getOrDefault("pageSize")
  valid_580535 = validateParameter(valid_580535, JInt, required = false, default = nil)
  if valid_580535 != nil:
    section.add "pageSize", valid_580535
  var valid_580536 = query.getOrDefault("prettyPrint")
  valid_580536 = validateParameter(valid_580536, JBool, required = false,
                                 default = newJBool(true))
  if valid_580536 != nil:
    section.add "prettyPrint", valid_580536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580537: Call_DrivePermissionsList_580521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_580537.validator(path, query, header, formData, body)
  let scheme = call_580537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580537.url(scheme.get, call_580537.host, call_580537.base,
                         call_580537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580537, url, valid)

proc call*(call_580538: Call_DrivePermissionsList_580521; fileId: string;
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
  var path_580539 = newJObject()
  var query_580540 = newJObject()
  add(query_580540, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580540, "fields", newJString(fields))
  add(query_580540, "pageToken", newJString(pageToken))
  add(query_580540, "quotaUser", newJString(quotaUser))
  add(path_580539, "fileId", newJString(fileId))
  add(query_580540, "alt", newJString(alt))
  add(query_580540, "oauth_token", newJString(oauthToken))
  add(query_580540, "userIp", newJString(userIp))
  add(query_580540, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580540, "key", newJString(key))
  add(query_580540, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580540, "pageSize", newJInt(pageSize))
  add(query_580540, "prettyPrint", newJBool(prettyPrint))
  result = call_580538.call(path_580539, query_580540, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_580521(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_580522, base: "/drive/v3",
    url: url_DrivePermissionsList_580523, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_580564 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsGet_580566(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsGet_580565(path: JsonNode; query: JsonNode;
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
  var valid_580567 = path.getOrDefault("fileId")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "fileId", valid_580567
  var valid_580568 = path.getOrDefault("permissionId")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "permissionId", valid_580568
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
  var valid_580569 = query.getOrDefault("supportsAllDrives")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(false))
  if valid_580569 != nil:
    section.add "supportsAllDrives", valid_580569
  var valid_580570 = query.getOrDefault("fields")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "fields", valid_580570
  var valid_580571 = query.getOrDefault("quotaUser")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "quotaUser", valid_580571
  var valid_580572 = query.getOrDefault("alt")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = newJString("json"))
  if valid_580572 != nil:
    section.add "alt", valid_580572
  var valid_580573 = query.getOrDefault("oauth_token")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "oauth_token", valid_580573
  var valid_580574 = query.getOrDefault("userIp")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "userIp", valid_580574
  var valid_580575 = query.getOrDefault("supportsTeamDrives")
  valid_580575 = validateParameter(valid_580575, JBool, required = false,
                                 default = newJBool(false))
  if valid_580575 != nil:
    section.add "supportsTeamDrives", valid_580575
  var valid_580576 = query.getOrDefault("key")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "key", valid_580576
  var valid_580577 = query.getOrDefault("useDomainAdminAccess")
  valid_580577 = validateParameter(valid_580577, JBool, required = false,
                                 default = newJBool(false))
  if valid_580577 != nil:
    section.add "useDomainAdminAccess", valid_580577
  var valid_580578 = query.getOrDefault("prettyPrint")
  valid_580578 = validateParameter(valid_580578, JBool, required = false,
                                 default = newJBool(true))
  if valid_580578 != nil:
    section.add "prettyPrint", valid_580578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580579: Call_DrivePermissionsGet_580564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_580579.validator(path, query, header, formData, body)
  let scheme = call_580579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580579.url(scheme.get, call_580579.host, call_580579.base,
                         call_580579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580579, url, valid)

proc call*(call_580580: Call_DrivePermissionsGet_580564; fileId: string;
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
  var path_580581 = newJObject()
  var query_580582 = newJObject()
  add(query_580582, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580582, "fields", newJString(fields))
  add(query_580582, "quotaUser", newJString(quotaUser))
  add(path_580581, "fileId", newJString(fileId))
  add(query_580582, "alt", newJString(alt))
  add(query_580582, "oauth_token", newJString(oauthToken))
  add(path_580581, "permissionId", newJString(permissionId))
  add(query_580582, "userIp", newJString(userIp))
  add(query_580582, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580582, "key", newJString(key))
  add(query_580582, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580582, "prettyPrint", newJBool(prettyPrint))
  result = call_580580.call(path_580581, query_580582, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_580564(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_580565, base: "/drive/v3",
    url: url_DrivePermissionsGet_580566, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_580602 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsUpdate_580604(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsUpdate_580603(path: JsonNode; query: JsonNode;
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
  var valid_580605 = path.getOrDefault("fileId")
  valid_580605 = validateParameter(valid_580605, JString, required = true,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fileId", valid_580605
  var valid_580606 = path.getOrDefault("permissionId")
  valid_580606 = validateParameter(valid_580606, JString, required = true,
                                 default = nil)
  if valid_580606 != nil:
    section.add "permissionId", valid_580606
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
  var valid_580607 = query.getOrDefault("supportsAllDrives")
  valid_580607 = validateParameter(valid_580607, JBool, required = false,
                                 default = newJBool(false))
  if valid_580607 != nil:
    section.add "supportsAllDrives", valid_580607
  var valid_580608 = query.getOrDefault("fields")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "fields", valid_580608
  var valid_580609 = query.getOrDefault("quotaUser")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "quotaUser", valid_580609
  var valid_580610 = query.getOrDefault("alt")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = newJString("json"))
  if valid_580610 != nil:
    section.add "alt", valid_580610
  var valid_580611 = query.getOrDefault("oauth_token")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "oauth_token", valid_580611
  var valid_580612 = query.getOrDefault("removeExpiration")
  valid_580612 = validateParameter(valid_580612, JBool, required = false,
                                 default = newJBool(false))
  if valid_580612 != nil:
    section.add "removeExpiration", valid_580612
  var valid_580613 = query.getOrDefault("userIp")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "userIp", valid_580613
  var valid_580614 = query.getOrDefault("supportsTeamDrives")
  valid_580614 = validateParameter(valid_580614, JBool, required = false,
                                 default = newJBool(false))
  if valid_580614 != nil:
    section.add "supportsTeamDrives", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("useDomainAdminAccess")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(false))
  if valid_580616 != nil:
    section.add "useDomainAdminAccess", valid_580616
  var valid_580617 = query.getOrDefault("transferOwnership")
  valid_580617 = validateParameter(valid_580617, JBool, required = false,
                                 default = newJBool(false))
  if valid_580617 != nil:
    section.add "transferOwnership", valid_580617
  var valid_580618 = query.getOrDefault("prettyPrint")
  valid_580618 = validateParameter(valid_580618, JBool, required = false,
                                 default = newJBool(true))
  if valid_580618 != nil:
    section.add "prettyPrint", valid_580618
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

proc call*(call_580620: Call_DrivePermissionsUpdate_580602; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission with patch semantics.
  ## 
  let valid = call_580620.validator(path, query, header, formData, body)
  let scheme = call_580620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580620.url(scheme.get, call_580620.host, call_580620.base,
                         call_580620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580620, url, valid)

proc call*(call_580621: Call_DrivePermissionsUpdate_580602; fileId: string;
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
  var path_580622 = newJObject()
  var query_580623 = newJObject()
  var body_580624 = newJObject()
  add(query_580623, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580623, "fields", newJString(fields))
  add(query_580623, "quotaUser", newJString(quotaUser))
  add(path_580622, "fileId", newJString(fileId))
  add(query_580623, "alt", newJString(alt))
  add(query_580623, "oauth_token", newJString(oauthToken))
  add(path_580622, "permissionId", newJString(permissionId))
  add(query_580623, "removeExpiration", newJBool(removeExpiration))
  add(query_580623, "userIp", newJString(userIp))
  add(query_580623, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580623, "key", newJString(key))
  add(query_580623, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580623, "transferOwnership", newJBool(transferOwnership))
  if body != nil:
    body_580624 = body
  add(query_580623, "prettyPrint", newJBool(prettyPrint))
  result = call_580621.call(path_580622, query_580623, nil, nil, body_580624)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_580602(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_580603, base: "/drive/v3",
    url: url_DrivePermissionsUpdate_580604, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_580583 = ref object of OpenApiRestCall_579424
proc url_DrivePermissionsDelete_580585(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsDelete_580584(path: JsonNode; query: JsonNode;
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
  var valid_580586 = path.getOrDefault("fileId")
  valid_580586 = validateParameter(valid_580586, JString, required = true,
                                 default = nil)
  if valid_580586 != nil:
    section.add "fileId", valid_580586
  var valid_580587 = path.getOrDefault("permissionId")
  valid_580587 = validateParameter(valid_580587, JString, required = true,
                                 default = nil)
  if valid_580587 != nil:
    section.add "permissionId", valid_580587
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
  var valid_580588 = query.getOrDefault("supportsAllDrives")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(false))
  if valid_580588 != nil:
    section.add "supportsAllDrives", valid_580588
  var valid_580589 = query.getOrDefault("fields")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "fields", valid_580589
  var valid_580590 = query.getOrDefault("quotaUser")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "quotaUser", valid_580590
  var valid_580591 = query.getOrDefault("alt")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = newJString("json"))
  if valid_580591 != nil:
    section.add "alt", valid_580591
  var valid_580592 = query.getOrDefault("oauth_token")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "oauth_token", valid_580592
  var valid_580593 = query.getOrDefault("userIp")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "userIp", valid_580593
  var valid_580594 = query.getOrDefault("supportsTeamDrives")
  valid_580594 = validateParameter(valid_580594, JBool, required = false,
                                 default = newJBool(false))
  if valid_580594 != nil:
    section.add "supportsTeamDrives", valid_580594
  var valid_580595 = query.getOrDefault("key")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "key", valid_580595
  var valid_580596 = query.getOrDefault("useDomainAdminAccess")
  valid_580596 = validateParameter(valid_580596, JBool, required = false,
                                 default = newJBool(false))
  if valid_580596 != nil:
    section.add "useDomainAdminAccess", valid_580596
  var valid_580597 = query.getOrDefault("prettyPrint")
  valid_580597 = validateParameter(valid_580597, JBool, required = false,
                                 default = newJBool(true))
  if valid_580597 != nil:
    section.add "prettyPrint", valid_580597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580598: Call_DrivePermissionsDelete_580583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission.
  ## 
  let valid = call_580598.validator(path, query, header, formData, body)
  let scheme = call_580598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580598.url(scheme.get, call_580598.host, call_580598.base,
                         call_580598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580598, url, valid)

proc call*(call_580599: Call_DrivePermissionsDelete_580583; fileId: string;
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
  var path_580600 = newJObject()
  var query_580601 = newJObject()
  add(query_580601, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580601, "fields", newJString(fields))
  add(query_580601, "quotaUser", newJString(quotaUser))
  add(path_580600, "fileId", newJString(fileId))
  add(query_580601, "alt", newJString(alt))
  add(query_580601, "oauth_token", newJString(oauthToken))
  add(path_580600, "permissionId", newJString(permissionId))
  add(query_580601, "userIp", newJString(userIp))
  add(query_580601, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580601, "key", newJString(key))
  add(query_580601, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580601, "prettyPrint", newJBool(prettyPrint))
  result = call_580599.call(path_580600, query_580601, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_580583(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_580584, base: "/drive/v3",
    url: url_DrivePermissionsDelete_580585, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_580625 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsList_580627(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsList_580626(path: JsonNode; query: JsonNode;
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
  var valid_580628 = path.getOrDefault("fileId")
  valid_580628 = validateParameter(valid_580628, JString, required = true,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fileId", valid_580628
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
  var valid_580629 = query.getOrDefault("fields")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "fields", valid_580629
  var valid_580630 = query.getOrDefault("pageToken")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "pageToken", valid_580630
  var valid_580631 = query.getOrDefault("quotaUser")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "quotaUser", valid_580631
  var valid_580632 = query.getOrDefault("alt")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = newJString("json"))
  if valid_580632 != nil:
    section.add "alt", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("userIp")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "userIp", valid_580634
  var valid_580635 = query.getOrDefault("key")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "key", valid_580635
  var valid_580636 = query.getOrDefault("pageSize")
  valid_580636 = validateParameter(valid_580636, JInt, required = false,
                                 default = newJInt(200))
  if valid_580636 != nil:
    section.add "pageSize", valid_580636
  var valid_580637 = query.getOrDefault("prettyPrint")
  valid_580637 = validateParameter(valid_580637, JBool, required = false,
                                 default = newJBool(true))
  if valid_580637 != nil:
    section.add "prettyPrint", valid_580637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580638: Call_DriveRevisionsList_580625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_580638.validator(path, query, header, formData, body)
  let scheme = call_580638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580638.url(scheme.get, call_580638.host, call_580638.base,
                         call_580638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580638, url, valid)

proc call*(call_580639: Call_DriveRevisionsList_580625; fileId: string;
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
  var path_580640 = newJObject()
  var query_580641 = newJObject()
  add(query_580641, "fields", newJString(fields))
  add(query_580641, "pageToken", newJString(pageToken))
  add(query_580641, "quotaUser", newJString(quotaUser))
  add(path_580640, "fileId", newJString(fileId))
  add(query_580641, "alt", newJString(alt))
  add(query_580641, "oauth_token", newJString(oauthToken))
  add(query_580641, "userIp", newJString(userIp))
  add(query_580641, "key", newJString(key))
  add(query_580641, "pageSize", newJInt(pageSize))
  add(query_580641, "prettyPrint", newJBool(prettyPrint))
  result = call_580639.call(path_580640, query_580641, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_580625(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_580626, base: "/drive/v3",
    url: url_DriveRevisionsList_580627, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_580642 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsGet_580644(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsGet_580643(path: JsonNode; query: JsonNode;
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
  var valid_580645 = path.getOrDefault("fileId")
  valid_580645 = validateParameter(valid_580645, JString, required = true,
                                 default = nil)
  if valid_580645 != nil:
    section.add "fileId", valid_580645
  var valid_580646 = path.getOrDefault("revisionId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "revisionId", valid_580646
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
  var valid_580647 = query.getOrDefault("fields")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "fields", valid_580647
  var valid_580648 = query.getOrDefault("quotaUser")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "quotaUser", valid_580648
  var valid_580649 = query.getOrDefault("alt")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("json"))
  if valid_580649 != nil:
    section.add "alt", valid_580649
  var valid_580650 = query.getOrDefault("acknowledgeAbuse")
  valid_580650 = validateParameter(valid_580650, JBool, required = false,
                                 default = newJBool(false))
  if valid_580650 != nil:
    section.add "acknowledgeAbuse", valid_580650
  var valid_580651 = query.getOrDefault("oauth_token")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "oauth_token", valid_580651
  var valid_580652 = query.getOrDefault("userIp")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "userIp", valid_580652
  var valid_580653 = query.getOrDefault("key")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "key", valid_580653
  var valid_580654 = query.getOrDefault("prettyPrint")
  valid_580654 = validateParameter(valid_580654, JBool, required = false,
                                 default = newJBool(true))
  if valid_580654 != nil:
    section.add "prettyPrint", valid_580654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580655: Call_DriveRevisionsGet_580642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a revision's metadata or content by ID.
  ## 
  let valid = call_580655.validator(path, query, header, formData, body)
  let scheme = call_580655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580655.url(scheme.get, call_580655.host, call_580655.base,
                         call_580655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580655, url, valid)

proc call*(call_580656: Call_DriveRevisionsGet_580642; fileId: string;
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
  var path_580657 = newJObject()
  var query_580658 = newJObject()
  add(query_580658, "fields", newJString(fields))
  add(query_580658, "quotaUser", newJString(quotaUser))
  add(path_580657, "fileId", newJString(fileId))
  add(query_580658, "alt", newJString(alt))
  add(query_580658, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580658, "oauth_token", newJString(oauthToken))
  add(path_580657, "revisionId", newJString(revisionId))
  add(query_580658, "userIp", newJString(userIp))
  add(query_580658, "key", newJString(key))
  add(query_580658, "prettyPrint", newJBool(prettyPrint))
  result = call_580656.call(path_580657, query_580658, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_580642(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_580643, base: "/drive/v3",
    url: url_DriveRevisionsGet_580644, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_580675 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsUpdate_580677(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsUpdate_580676(path: JsonNode; query: JsonNode;
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
  var valid_580678 = path.getOrDefault("fileId")
  valid_580678 = validateParameter(valid_580678, JString, required = true,
                                 default = nil)
  if valid_580678 != nil:
    section.add "fileId", valid_580678
  var valid_580679 = path.getOrDefault("revisionId")
  valid_580679 = validateParameter(valid_580679, JString, required = true,
                                 default = nil)
  if valid_580679 != nil:
    section.add "revisionId", valid_580679
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
  var valid_580680 = query.getOrDefault("fields")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "fields", valid_580680
  var valid_580681 = query.getOrDefault("quotaUser")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "quotaUser", valid_580681
  var valid_580682 = query.getOrDefault("alt")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = newJString("json"))
  if valid_580682 != nil:
    section.add "alt", valid_580682
  var valid_580683 = query.getOrDefault("oauth_token")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "oauth_token", valid_580683
  var valid_580684 = query.getOrDefault("userIp")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "userIp", valid_580684
  var valid_580685 = query.getOrDefault("key")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "key", valid_580685
  var valid_580686 = query.getOrDefault("prettyPrint")
  valid_580686 = validateParameter(valid_580686, JBool, required = false,
                                 default = newJBool(true))
  if valid_580686 != nil:
    section.add "prettyPrint", valid_580686
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

proc call*(call_580688: Call_DriveRevisionsUpdate_580675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision with patch semantics.
  ## 
  let valid = call_580688.validator(path, query, header, formData, body)
  let scheme = call_580688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580688.url(scheme.get, call_580688.host, call_580688.base,
                         call_580688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580688, url, valid)

proc call*(call_580689: Call_DriveRevisionsUpdate_580675; fileId: string;
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
  var path_580690 = newJObject()
  var query_580691 = newJObject()
  var body_580692 = newJObject()
  add(query_580691, "fields", newJString(fields))
  add(query_580691, "quotaUser", newJString(quotaUser))
  add(path_580690, "fileId", newJString(fileId))
  add(query_580691, "alt", newJString(alt))
  add(query_580691, "oauth_token", newJString(oauthToken))
  add(path_580690, "revisionId", newJString(revisionId))
  add(query_580691, "userIp", newJString(userIp))
  add(query_580691, "key", newJString(key))
  if body != nil:
    body_580692 = body
  add(query_580691, "prettyPrint", newJBool(prettyPrint))
  result = call_580689.call(path_580690, query_580691, nil, nil, body_580692)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_580675(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_580676, base: "/drive/v3",
    url: url_DriveRevisionsUpdate_580677, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_580659 = ref object of OpenApiRestCall_579424
proc url_DriveRevisionsDelete_580661(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsDelete_580660(path: JsonNode; query: JsonNode;
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
  var valid_580662 = path.getOrDefault("fileId")
  valid_580662 = validateParameter(valid_580662, JString, required = true,
                                 default = nil)
  if valid_580662 != nil:
    section.add "fileId", valid_580662
  var valid_580663 = path.getOrDefault("revisionId")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "revisionId", valid_580663
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
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("quotaUser")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "quotaUser", valid_580665
  var valid_580666 = query.getOrDefault("alt")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("json"))
  if valid_580666 != nil:
    section.add "alt", valid_580666
  var valid_580667 = query.getOrDefault("oauth_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "oauth_token", valid_580667
  var valid_580668 = query.getOrDefault("userIp")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "userIp", valid_580668
  var valid_580669 = query.getOrDefault("key")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "key", valid_580669
  var valid_580670 = query.getOrDefault("prettyPrint")
  valid_580670 = validateParameter(valid_580670, JBool, required = false,
                                 default = newJBool(true))
  if valid_580670 != nil:
    section.add "prettyPrint", valid_580670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580671: Call_DriveRevisionsDelete_580659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_580671.validator(path, query, header, formData, body)
  let scheme = call_580671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580671.url(scheme.get, call_580671.host, call_580671.base,
                         call_580671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580671, url, valid)

proc call*(call_580672: Call_DriveRevisionsDelete_580659; fileId: string;
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
  var path_580673 = newJObject()
  var query_580674 = newJObject()
  add(query_580674, "fields", newJString(fields))
  add(query_580674, "quotaUser", newJString(quotaUser))
  add(path_580673, "fileId", newJString(fileId))
  add(query_580674, "alt", newJString(alt))
  add(query_580674, "oauth_token", newJString(oauthToken))
  add(path_580673, "revisionId", newJString(revisionId))
  add(query_580674, "userIp", newJString(userIp))
  add(query_580674, "key", newJString(key))
  add(query_580674, "prettyPrint", newJBool(prettyPrint))
  result = call_580672.call(path_580673, query_580674, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_580659(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_580660, base: "/drive/v3",
    url: url_DriveRevisionsDelete_580661, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_580693 = ref object of OpenApiRestCall_579424
proc url_DriveFilesWatch_580695(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesWatch_580694(path: JsonNode; query: JsonNode;
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
  var valid_580696 = path.getOrDefault("fileId")
  valid_580696 = validateParameter(valid_580696, JString, required = true,
                                 default = nil)
  if valid_580696 != nil:
    section.add "fileId", valid_580696
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
  var valid_580697 = query.getOrDefault("supportsAllDrives")
  valid_580697 = validateParameter(valid_580697, JBool, required = false,
                                 default = newJBool(false))
  if valid_580697 != nil:
    section.add "supportsAllDrives", valid_580697
  var valid_580698 = query.getOrDefault("fields")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "fields", valid_580698
  var valid_580699 = query.getOrDefault("quotaUser")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "quotaUser", valid_580699
  var valid_580700 = query.getOrDefault("alt")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = newJString("json"))
  if valid_580700 != nil:
    section.add "alt", valid_580700
  var valid_580701 = query.getOrDefault("acknowledgeAbuse")
  valid_580701 = validateParameter(valid_580701, JBool, required = false,
                                 default = newJBool(false))
  if valid_580701 != nil:
    section.add "acknowledgeAbuse", valid_580701
  var valid_580702 = query.getOrDefault("oauth_token")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "oauth_token", valid_580702
  var valid_580703 = query.getOrDefault("userIp")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "userIp", valid_580703
  var valid_580704 = query.getOrDefault("supportsTeamDrives")
  valid_580704 = validateParameter(valid_580704, JBool, required = false,
                                 default = newJBool(false))
  if valid_580704 != nil:
    section.add "supportsTeamDrives", valid_580704
  var valid_580705 = query.getOrDefault("key")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "key", valid_580705
  var valid_580706 = query.getOrDefault("prettyPrint")
  valid_580706 = validateParameter(valid_580706, JBool, required = false,
                                 default = newJBool(true))
  if valid_580706 != nil:
    section.add "prettyPrint", valid_580706
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

proc call*(call_580708: Call_DriveFilesWatch_580693; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes to a file
  ## 
  let valid = call_580708.validator(path, query, header, formData, body)
  let scheme = call_580708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580708.url(scheme.get, call_580708.host, call_580708.base,
                         call_580708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580708, url, valid)

proc call*(call_580709: Call_DriveFilesWatch_580693; fileId: string;
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
  var path_580710 = newJObject()
  var query_580711 = newJObject()
  var body_580712 = newJObject()
  add(query_580711, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580711, "fields", newJString(fields))
  add(query_580711, "quotaUser", newJString(quotaUser))
  add(path_580710, "fileId", newJString(fileId))
  add(query_580711, "alt", newJString(alt))
  add(query_580711, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580711, "oauth_token", newJString(oauthToken))
  add(query_580711, "userIp", newJString(userIp))
  add(query_580711, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580711, "key", newJString(key))
  if resource != nil:
    body_580712 = resource
  add(query_580711, "prettyPrint", newJBool(prettyPrint))
  result = call_580709.call(path_580710, query_580711, nil, nil, body_580712)

var driveFilesWatch* = Call_DriveFilesWatch_580693(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_580694,
    base: "/drive/v3", url: url_DriveFilesWatch_580695, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesCreate_580730 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesCreate_580732(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesCreate_580731(path: JsonNode; query: JsonNode;
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
  var valid_580733 = query.getOrDefault("fields")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "fields", valid_580733
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580734 = query.getOrDefault("requestId")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "requestId", valid_580734
  var valid_580735 = query.getOrDefault("quotaUser")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "quotaUser", valid_580735
  var valid_580736 = query.getOrDefault("alt")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = newJString("json"))
  if valid_580736 != nil:
    section.add "alt", valid_580736
  var valid_580737 = query.getOrDefault("oauth_token")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "oauth_token", valid_580737
  var valid_580738 = query.getOrDefault("userIp")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "userIp", valid_580738
  var valid_580739 = query.getOrDefault("key")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "key", valid_580739
  var valid_580740 = query.getOrDefault("prettyPrint")
  valid_580740 = validateParameter(valid_580740, JBool, required = false,
                                 default = newJBool(true))
  if valid_580740 != nil:
    section.add "prettyPrint", valid_580740
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

proc call*(call_580742: Call_DriveTeamdrivesCreate_580730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.create instead.
  ## 
  let valid = call_580742.validator(path, query, header, formData, body)
  let scheme = call_580742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580742.url(scheme.get, call_580742.host, call_580742.base,
                         call_580742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580742, url, valid)

proc call*(call_580743: Call_DriveTeamdrivesCreate_580730; requestId: string;
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
  var query_580744 = newJObject()
  var body_580745 = newJObject()
  add(query_580744, "fields", newJString(fields))
  add(query_580744, "requestId", newJString(requestId))
  add(query_580744, "quotaUser", newJString(quotaUser))
  add(query_580744, "alt", newJString(alt))
  add(query_580744, "oauth_token", newJString(oauthToken))
  add(query_580744, "userIp", newJString(userIp))
  add(query_580744, "key", newJString(key))
  if body != nil:
    body_580745 = body
  add(query_580744, "prettyPrint", newJBool(prettyPrint))
  result = call_580743.call(nil, query_580744, nil, nil, body_580745)

var driveTeamdrivesCreate* = Call_DriveTeamdrivesCreate_580730(
    name: "driveTeamdrivesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesCreate_580731, base: "/drive/v3",
    url: url_DriveTeamdrivesCreate_580732, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_580713 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesList_580715(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_580714(path: JsonNode; query: JsonNode;
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
  var valid_580716 = query.getOrDefault("fields")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "fields", valid_580716
  var valid_580717 = query.getOrDefault("pageToken")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "pageToken", valid_580717
  var valid_580718 = query.getOrDefault("quotaUser")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "quotaUser", valid_580718
  var valid_580719 = query.getOrDefault("alt")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = newJString("json"))
  if valid_580719 != nil:
    section.add "alt", valid_580719
  var valid_580720 = query.getOrDefault("oauth_token")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "oauth_token", valid_580720
  var valid_580721 = query.getOrDefault("userIp")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "userIp", valid_580721
  var valid_580722 = query.getOrDefault("q")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "q", valid_580722
  var valid_580723 = query.getOrDefault("key")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "key", valid_580723
  var valid_580724 = query.getOrDefault("useDomainAdminAccess")
  valid_580724 = validateParameter(valid_580724, JBool, required = false,
                                 default = newJBool(false))
  if valid_580724 != nil:
    section.add "useDomainAdminAccess", valid_580724
  var valid_580725 = query.getOrDefault("pageSize")
  valid_580725 = validateParameter(valid_580725, JInt, required = false,
                                 default = newJInt(10))
  if valid_580725 != nil:
    section.add "pageSize", valid_580725
  var valid_580726 = query.getOrDefault("prettyPrint")
  valid_580726 = validateParameter(valid_580726, JBool, required = false,
                                 default = newJBool(true))
  if valid_580726 != nil:
    section.add "prettyPrint", valid_580726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580727: Call_DriveTeamdrivesList_580713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_580727.validator(path, query, header, formData, body)
  let scheme = call_580727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580727.url(scheme.get, call_580727.host, call_580727.base,
                         call_580727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580727, url, valid)

proc call*(call_580728: Call_DriveTeamdrivesList_580713; fields: string = "";
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
  var query_580729 = newJObject()
  add(query_580729, "fields", newJString(fields))
  add(query_580729, "pageToken", newJString(pageToken))
  add(query_580729, "quotaUser", newJString(quotaUser))
  add(query_580729, "alt", newJString(alt))
  add(query_580729, "oauth_token", newJString(oauthToken))
  add(query_580729, "userIp", newJString(userIp))
  add(query_580729, "q", newJString(q))
  add(query_580729, "key", newJString(key))
  add(query_580729, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580729, "pageSize", newJInt(pageSize))
  add(query_580729, "prettyPrint", newJBool(prettyPrint))
  result = call_580728.call(nil, query_580729, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_580713(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_580714, base: "/drive/v3",
    url: url_DriveTeamdrivesList_580715, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_580746 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesGet_580748(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesGet_580747(path: JsonNode; query: JsonNode;
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
  var valid_580749 = path.getOrDefault("teamDriveId")
  valid_580749 = validateParameter(valid_580749, JString, required = true,
                                 default = nil)
  if valid_580749 != nil:
    section.add "teamDriveId", valid_580749
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
  var valid_580750 = query.getOrDefault("fields")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "fields", valid_580750
  var valid_580751 = query.getOrDefault("quotaUser")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "quotaUser", valid_580751
  var valid_580752 = query.getOrDefault("alt")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = newJString("json"))
  if valid_580752 != nil:
    section.add "alt", valid_580752
  var valid_580753 = query.getOrDefault("oauth_token")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "oauth_token", valid_580753
  var valid_580754 = query.getOrDefault("userIp")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "userIp", valid_580754
  var valid_580755 = query.getOrDefault("key")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "key", valid_580755
  var valid_580756 = query.getOrDefault("useDomainAdminAccess")
  valid_580756 = validateParameter(valid_580756, JBool, required = false,
                                 default = newJBool(false))
  if valid_580756 != nil:
    section.add "useDomainAdminAccess", valid_580756
  var valid_580757 = query.getOrDefault("prettyPrint")
  valid_580757 = validateParameter(valid_580757, JBool, required = false,
                                 default = newJBool(true))
  if valid_580757 != nil:
    section.add "prettyPrint", valid_580757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580758: Call_DriveTeamdrivesGet_580746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_580758.validator(path, query, header, formData, body)
  let scheme = call_580758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580758.url(scheme.get, call_580758.host, call_580758.base,
                         call_580758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580758, url, valid)

proc call*(call_580759: Call_DriveTeamdrivesGet_580746; teamDriveId: string;
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
  var path_580760 = newJObject()
  var query_580761 = newJObject()
  add(path_580760, "teamDriveId", newJString(teamDriveId))
  add(query_580761, "fields", newJString(fields))
  add(query_580761, "quotaUser", newJString(quotaUser))
  add(query_580761, "alt", newJString(alt))
  add(query_580761, "oauth_token", newJString(oauthToken))
  add(query_580761, "userIp", newJString(userIp))
  add(query_580761, "key", newJString(key))
  add(query_580761, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580761, "prettyPrint", newJBool(prettyPrint))
  result = call_580759.call(path_580760, query_580761, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_580746(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_580747, base: "/drive/v3",
    url: url_DriveTeamdrivesGet_580748, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_580777 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesUpdate_580779(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesUpdate_580778(path: JsonNode; query: JsonNode;
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
  var valid_580780 = path.getOrDefault("teamDriveId")
  valid_580780 = validateParameter(valid_580780, JString, required = true,
                                 default = nil)
  if valid_580780 != nil:
    section.add "teamDriveId", valid_580780
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
  var valid_580781 = query.getOrDefault("fields")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "fields", valid_580781
  var valid_580782 = query.getOrDefault("quotaUser")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "quotaUser", valid_580782
  var valid_580783 = query.getOrDefault("alt")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = newJString("json"))
  if valid_580783 != nil:
    section.add "alt", valid_580783
  var valid_580784 = query.getOrDefault("oauth_token")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "oauth_token", valid_580784
  var valid_580785 = query.getOrDefault("userIp")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "userIp", valid_580785
  var valid_580786 = query.getOrDefault("key")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "key", valid_580786
  var valid_580787 = query.getOrDefault("useDomainAdminAccess")
  valid_580787 = validateParameter(valid_580787, JBool, required = false,
                                 default = newJBool(false))
  if valid_580787 != nil:
    section.add "useDomainAdminAccess", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
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

proc call*(call_580790: Call_DriveTeamdrivesUpdate_580777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead
  ## 
  let valid = call_580790.validator(path, query, header, formData, body)
  let scheme = call_580790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580790.url(scheme.get, call_580790.host, call_580790.base,
                         call_580790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580790, url, valid)

proc call*(call_580791: Call_DriveTeamdrivesUpdate_580777; teamDriveId: string;
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
  var path_580792 = newJObject()
  var query_580793 = newJObject()
  var body_580794 = newJObject()
  add(path_580792, "teamDriveId", newJString(teamDriveId))
  add(query_580793, "fields", newJString(fields))
  add(query_580793, "quotaUser", newJString(quotaUser))
  add(query_580793, "alt", newJString(alt))
  add(query_580793, "oauth_token", newJString(oauthToken))
  add(query_580793, "userIp", newJString(userIp))
  add(query_580793, "key", newJString(key))
  add(query_580793, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  if body != nil:
    body_580794 = body
  add(query_580793, "prettyPrint", newJBool(prettyPrint))
  result = call_580791.call(path_580792, query_580793, nil, nil, body_580794)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_580777(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_580778, base: "/drive/v3",
    url: url_DriveTeamdrivesUpdate_580779, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_580762 = ref object of OpenApiRestCall_579424
proc url_DriveTeamdrivesDelete_580764(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesDelete_580763(path: JsonNode; query: JsonNode;
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
  var valid_580765 = path.getOrDefault("teamDriveId")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "teamDriveId", valid_580765
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
  var valid_580766 = query.getOrDefault("fields")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "fields", valid_580766
  var valid_580767 = query.getOrDefault("quotaUser")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "quotaUser", valid_580767
  var valid_580768 = query.getOrDefault("alt")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = newJString("json"))
  if valid_580768 != nil:
    section.add "alt", valid_580768
  var valid_580769 = query.getOrDefault("oauth_token")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "oauth_token", valid_580769
  var valid_580770 = query.getOrDefault("userIp")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "userIp", valid_580770
  var valid_580771 = query.getOrDefault("key")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "key", valid_580771
  var valid_580772 = query.getOrDefault("prettyPrint")
  valid_580772 = validateParameter(valid_580772, JBool, required = false,
                                 default = newJBool(true))
  if valid_580772 != nil:
    section.add "prettyPrint", valid_580772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580773: Call_DriveTeamdrivesDelete_580762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_580773.validator(path, query, header, formData, body)
  let scheme = call_580773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580773.url(scheme.get, call_580773.host, call_580773.base,
                         call_580773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580773, url, valid)

proc call*(call_580774: Call_DriveTeamdrivesDelete_580762; teamDriveId: string;
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
  var path_580775 = newJObject()
  var query_580776 = newJObject()
  add(path_580775, "teamDriveId", newJString(teamDriveId))
  add(query_580776, "fields", newJString(fields))
  add(query_580776, "quotaUser", newJString(quotaUser))
  add(query_580776, "alt", newJString(alt))
  add(query_580776, "oauth_token", newJString(oauthToken))
  add(query_580776, "userIp", newJString(userIp))
  add(query_580776, "key", newJString(key))
  add(query_580776, "prettyPrint", newJBool(prettyPrint))
  result = call_580774.call(path_580775, query_580776, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_580762(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_580763, base: "/drive/v3",
    url: url_DriveTeamdrivesDelete_580764, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
