
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "drive"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_578625 = ref object of OpenApiRestCall_578355
proc url_DriveAboutGet_578627(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_578626(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578781: Call_DriveAboutGet_578625; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  let valid = call_578781.validator(path, query, header, formData, body)
  let scheme = call_578781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578781.url(scheme.get, call_578781.host, call_578781.base,
                         call_578781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578781, url, valid)

proc call*(call_578852: Call_DriveAboutGet_578625; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveAboutGet
  ## Gets information about the user, the user's Drive, and system capabilities.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578853 = newJObject()
  add(query_578853, "key", newJString(key))
  add(query_578853, "prettyPrint", newJBool(prettyPrint))
  add(query_578853, "oauth_token", newJString(oauthToken))
  add(query_578853, "alt", newJString(alt))
  add(query_578853, "userIp", newJString(userIp))
  add(query_578853, "quotaUser", newJString(quotaUser))
  add(query_578853, "fields", newJString(fields))
  result = call_578852.call(nil, query_578853, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_578625(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_578626, base: "/drive/v3",
    url: url_DriveAboutGet_578627, schemes: {Scheme.Https})
type
  Call_DriveChangesList_578893 = ref object of OpenApiRestCall_578355
proc url_DriveChangesList_578895(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_578894(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the changes for a user or shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   restrictToMyDrive: JBool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of changes to return per page.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: JString (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeRemoved: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_578896 = query.getOrDefault("key")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "key", valid_578896
  var valid_578897 = query.getOrDefault("prettyPrint")
  valid_578897 = validateParameter(valid_578897, JBool, required = false,
                                 default = newJBool(true))
  if valid_578897 != nil:
    section.add "prettyPrint", valid_578897
  var valid_578898 = query.getOrDefault("oauth_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "oauth_token", valid_578898
  var valid_578899 = query.getOrDefault("driveId")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "driveId", valid_578899
  var valid_578900 = query.getOrDefault("includeItemsFromAllDrives")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(false))
  if valid_578900 != nil:
    section.add "includeItemsFromAllDrives", valid_578900
  var valid_578901 = query.getOrDefault("restrictToMyDrive")
  valid_578901 = validateParameter(valid_578901, JBool, required = false,
                                 default = newJBool(false))
  if valid_578901 != nil:
    section.add "restrictToMyDrive", valid_578901
  var valid_578902 = query.getOrDefault("spaces")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("drive"))
  if valid_578902 != nil:
    section.add "spaces", valid_578902
  var valid_578904 = query.getOrDefault("pageSize")
  valid_578904 = validateParameter(valid_578904, JInt, required = false,
                                 default = newJInt(100))
  if valid_578904 != nil:
    section.add "pageSize", valid_578904
  var valid_578905 = query.getOrDefault("alt")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("json"))
  if valid_578905 != nil:
    section.add "alt", valid_578905
  var valid_578906 = query.getOrDefault("userIp")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "userIp", valid_578906
  var valid_578907 = query.getOrDefault("quotaUser")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "quotaUser", valid_578907
  var valid_578908 = query.getOrDefault("includeCorpusRemovals")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(false))
  if valid_578908 != nil:
    section.add "includeCorpusRemovals", valid_578908
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_578909 = query.getOrDefault("pageToken")
  valid_578909 = validateParameter(valid_578909, JString, required = true,
                                 default = nil)
  if valid_578909 != nil:
    section.add "pageToken", valid_578909
  var valid_578910 = query.getOrDefault("supportsTeamDrives")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(false))
  if valid_578910 != nil:
    section.add "supportsTeamDrives", valid_578910
  var valid_578911 = query.getOrDefault("includeRemoved")
  valid_578911 = validateParameter(valid_578911, JBool, required = false,
                                 default = newJBool(true))
  if valid_578911 != nil:
    section.add "includeRemoved", valid_578911
  var valid_578912 = query.getOrDefault("supportsAllDrives")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(false))
  if valid_578912 != nil:
    section.add "supportsAllDrives", valid_578912
  var valid_578913 = query.getOrDefault("includeTeamDriveItems")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(false))
  if valid_578913 != nil:
    section.add "includeTeamDriveItems", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("teamDriveId")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "teamDriveId", valid_578915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578916: Call_DriveChangesList_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_578916.validator(path, query, header, formData, body)
  let scheme = call_578916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578916.url(scheme.get, call_578916.host, call_578916.base,
                         call_578916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578916, url, valid)

proc call*(call_578917: Call_DriveChangesList_578893; pageToken: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          driveId: string = ""; includeItemsFromAllDrives: bool = false;
          restrictToMyDrive: bool = false; spaces: string = "drive";
          pageSize: int = 100; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeCorpusRemovals: bool = false;
          supportsTeamDrives: bool = false; includeRemoved: bool = true;
          supportsAllDrives: bool = false; includeTeamDriveItems: bool = false;
          fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveChangesList
  ## Lists the changes for a user or shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   restrictToMyDrive: bool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of changes to return per page.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: string (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeRemoved: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "driveId", newJString(driveId))
  add(query_578918, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_578918, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_578918, "spaces", newJString(spaces))
  add(query_578918, "pageSize", newJInt(pageSize))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "userIp", newJString(userIp))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_578918, "pageToken", newJString(pageToken))
  add(query_578918, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_578918, "includeRemoved", newJBool(includeRemoved))
  add(query_578918, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_578918, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "teamDriveId", newJString(teamDriveId))
  result = call_578917.call(nil, query_578918, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_578893(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_578894, base: "/drive/v3",
    url: url_DriveChangesList_578895, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_578919 = ref object of OpenApiRestCall_578355
proc url_DriveChangesGetStartPageToken_578921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_578920(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the starting pageToken for listing future changes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   driveId: JString
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("driveId")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "driveId", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("userIp")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "userIp", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("supportsTeamDrives")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(false))
  if valid_578929 != nil:
    section.add "supportsTeamDrives", valid_578929
  var valid_578930 = query.getOrDefault("supportsAllDrives")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(false))
  if valid_578930 != nil:
    section.add "supportsAllDrives", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("teamDriveId")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "teamDriveId", valid_578932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578933: Call_DriveChangesGetStartPageToken_578919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_578933.validator(path, query, header, formData, body)
  let scheme = call_578933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578933.url(scheme.get, call_578933.host, call_578933.base,
                         call_578933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578933, url, valid)

proc call*(call_578934: Call_DriveChangesGetStartPageToken_578919;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          driveId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveChangesGetStartPageToken
  ## Gets the starting pageToken for listing future changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_578935 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "driveId", newJString(driveId))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "userIp", newJString(userIp))
  add(query_578935, "quotaUser", newJString(quotaUser))
  add(query_578935, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_578935, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_578935, "fields", newJString(fields))
  add(query_578935, "teamDriveId", newJString(teamDriveId))
  result = call_578934.call(nil, query_578935, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_578919(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_578920, base: "/drive/v3",
    url: url_DriveChangesGetStartPageToken_578921, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_578936 = ref object of OpenApiRestCall_578355
proc url_DriveChangesWatch_578938(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_578937(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Subscribes to changes for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   restrictToMyDrive: JBool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of changes to return per page.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: JString (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeRemoved: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_578939 = query.getOrDefault("key")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "key", valid_578939
  var valid_578940 = query.getOrDefault("prettyPrint")
  valid_578940 = validateParameter(valid_578940, JBool, required = false,
                                 default = newJBool(true))
  if valid_578940 != nil:
    section.add "prettyPrint", valid_578940
  var valid_578941 = query.getOrDefault("oauth_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "oauth_token", valid_578941
  var valid_578942 = query.getOrDefault("driveId")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "driveId", valid_578942
  var valid_578943 = query.getOrDefault("includeItemsFromAllDrives")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(false))
  if valid_578943 != nil:
    section.add "includeItemsFromAllDrives", valid_578943
  var valid_578944 = query.getOrDefault("restrictToMyDrive")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(false))
  if valid_578944 != nil:
    section.add "restrictToMyDrive", valid_578944
  var valid_578945 = query.getOrDefault("spaces")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("drive"))
  if valid_578945 != nil:
    section.add "spaces", valid_578945
  var valid_578946 = query.getOrDefault("pageSize")
  valid_578946 = validateParameter(valid_578946, JInt, required = false,
                                 default = newJInt(100))
  if valid_578946 != nil:
    section.add "pageSize", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("userIp")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "userIp", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("includeCorpusRemovals")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(false))
  if valid_578950 != nil:
    section.add "includeCorpusRemovals", valid_578950
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_578951 = query.getOrDefault("pageToken")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "pageToken", valid_578951
  var valid_578952 = query.getOrDefault("supportsTeamDrives")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(false))
  if valid_578952 != nil:
    section.add "supportsTeamDrives", valid_578952
  var valid_578953 = query.getOrDefault("includeRemoved")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "includeRemoved", valid_578953
  var valid_578954 = query.getOrDefault("supportsAllDrives")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(false))
  if valid_578954 != nil:
    section.add "supportsAllDrives", valid_578954
  var valid_578955 = query.getOrDefault("includeTeamDriveItems")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(false))
  if valid_578955 != nil:
    section.add "includeTeamDriveItems", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("teamDriveId")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "teamDriveId", valid_578957
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

proc call*(call_578959: Call_DriveChangesWatch_578936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes for a user.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_DriveChangesWatch_578936; pageToken: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          driveId: string = ""; includeItemsFromAllDrives: bool = false;
          restrictToMyDrive: bool = false; spaces: string = "drive";
          pageSize: int = 100; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeCorpusRemovals: bool = false;
          supportsTeamDrives: bool = false; includeRemoved: bool = true;
          supportsAllDrives: bool = false; includeTeamDriveItems: bool = false;
          resource: JsonNode = nil; fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveChangesWatch
  ## Subscribes to changes for a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   restrictToMyDrive: bool
  ##                    : Whether to restrict the results to changes inside the My Drive hierarchy. This omits changes to files such as those in the Application Data folder or shared files which have not been added to My Drive.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the user corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of changes to return per page.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: string (required)
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeRemoved: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_578961 = newJObject()
  var body_578962 = newJObject()
  add(query_578961, "key", newJString(key))
  add(query_578961, "prettyPrint", newJBool(prettyPrint))
  add(query_578961, "oauth_token", newJString(oauthToken))
  add(query_578961, "driveId", newJString(driveId))
  add(query_578961, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_578961, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_578961, "spaces", newJString(spaces))
  add(query_578961, "pageSize", newJInt(pageSize))
  add(query_578961, "alt", newJString(alt))
  add(query_578961, "userIp", newJString(userIp))
  add(query_578961, "quotaUser", newJString(quotaUser))
  add(query_578961, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_578961, "pageToken", newJString(pageToken))
  add(query_578961, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_578961, "includeRemoved", newJBool(includeRemoved))
  add(query_578961, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_578961, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  if resource != nil:
    body_578962 = resource
  add(query_578961, "fields", newJString(fields))
  add(query_578961, "teamDriveId", newJString(teamDriveId))
  result = call_578960.call(nil, query_578961, nil, nil, body_578962)

var driveChangesWatch* = Call_DriveChangesWatch_578936(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_578937, base: "/drive/v3",
    url: url_DriveChangesWatch_578938, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_578963 = ref object of OpenApiRestCall_578355
proc url_DriveChannelsStop_578965(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_578964(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("userIp")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "userIp", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
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

proc call*(call_578974: Call_DriveChannelsStop_578963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_DriveChannelsStop_578963; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## driveChannelsStop
  ## Stop watching resources through this channel
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578976 = newJObject()
  var body_578977 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "userIp", newJString(userIp))
  add(query_578976, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_578977 = resource
  add(query_578976, "fields", newJString(fields))
  result = call_578975.call(nil, query_578976, nil, nil, body_578977)

var driveChannelsStop* = Call_DriveChannelsStop_578963(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_578964, base: "/drive/v3",
    url: url_DriveChannelsStop_578965, schemes: {Scheme.Https})
type
  Call_DriveDrivesCreate_578995 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesCreate_578997(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesCreate_578996(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new shared drive.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("userIp")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "userIp", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_579004 = query.getOrDefault("requestId")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "requestId", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
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

proc call*(call_579007: Call_DriveDrivesCreate_578995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_DriveDrivesCreate_578995; requestId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveDrivesCreate
  ## Creates a new shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579009 = newJObject()
  var body_579010 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "userIp", newJString(userIp))
  add(query_579009, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579010 = body
  add(query_579009, "requestId", newJString(requestId))
  add(query_579009, "fields", newJString(fields))
  result = call_579008.call(nil, query_579009, nil, nil, body_579010)

var driveDrivesCreate* = Call_DriveDrivesCreate_578995(name: "driveDrivesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesCreate_578996, base: "/drive/v3",
    url: url_DriveDrivesCreate_578997, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_578978 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesList_578980(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_578979(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the user's shared drives.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   q: JString
  ##    : Query string for searching shared drives.
  ##   pageSize: JInt
  ##           : Maximum number of shared drives to return.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token for shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("useDomainAdminAccess")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(false))
  if valid_578984 != nil:
    section.add "useDomainAdminAccess", valid_578984
  var valid_578985 = query.getOrDefault("q")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "q", valid_578985
  var valid_578986 = query.getOrDefault("pageSize")
  valid_578986 = validateParameter(valid_578986, JInt, required = false,
                                 default = newJInt(10))
  if valid_578986 != nil:
    section.add "pageSize", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("userIp")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "userIp", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("pageToken")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "pageToken", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_DriveDrivesList_578978; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_DriveDrivesList_578978; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; q: string = ""; pageSize: int = 10;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## driveDrivesList
  ## Lists the user's shared drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   q: string
  ##    : Query string for searching shared drives.
  ##   pageSize: int
  ##           : Maximum number of shared drives to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token for shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578994 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_578994, "q", newJString(q))
  add(query_578994, "pageSize", newJInt(pageSize))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "userIp", newJString(userIp))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "pageToken", newJString(pageToken))
  add(query_578994, "fields", newJString(fields))
  result = call_578993.call(nil, query_578994, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_578978(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_578979, base: "/drive/v3",
    url: url_DriveDrivesList_578980, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_579011 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesGet_579013(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesGet_579012(path: JsonNode; query: JsonNode;
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
  var valid_579028 = path.getOrDefault("driveId")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "driveId", valid_579028
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("useDomainAdminAccess")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(false))
  if valid_579032 != nil:
    section.add "useDomainAdminAccess", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("userIp")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "userIp", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_DriveDrivesGet_579011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_DriveDrivesGet_579011; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveDrivesGet
  ## Gets a shared drive's metadata by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(query_579040, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "userIp", newJString(userIp))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(path_579039, "driveId", newJString(driveId))
  add(query_579040, "fields", newJString(fields))
  result = call_579038.call(path_579039, query_579040, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_579011(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_579012,
    base: "/drive/v3", url: url_DriveDrivesGet_579013, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_579056 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesUpdate_579058(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUpdate_579057(path: JsonNode; query: JsonNode;
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
  var valid_579059 = path.getOrDefault("driveId")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "driveId", valid_579059
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("useDomainAdminAccess")
  valid_579063 = validateParameter(valid_579063, JBool, required = false,
                                 default = newJBool(false))
  if valid_579063 != nil:
    section.add "useDomainAdminAccess", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("userIp")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "userIp", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("fields")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fields", valid_579067
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

proc call*(call_579069: Call_DriveDrivesUpdate_579056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadate for a shared drive.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_DriveDrivesUpdate_579056; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveDrivesUpdate
  ## Updates the metadate for a shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  var body_579073 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "userIp", newJString(userIp))
  add(query_579072, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579073 = body
  add(path_579071, "driveId", newJString(driveId))
  add(query_579072, "fields", newJString(fields))
  result = call_579070.call(path_579071, query_579072, nil, nil, body_579073)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_579056(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_579057,
    base: "/drive/v3", url: url_DriveDrivesUpdate_579058, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_579041 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesDelete_579043(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesDelete_579042(path: JsonNode; query: JsonNode;
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
  var valid_579044 = path.getOrDefault("driveId")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "driveId", valid_579044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("prettyPrint")
  valid_579046 = validateParameter(valid_579046, JBool, required = false,
                                 default = newJBool(true))
  if valid_579046 != nil:
    section.add "prettyPrint", valid_579046
  var valid_579047 = query.getOrDefault("oauth_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "oauth_token", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("userIp")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userIp", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_DriveDrivesDelete_579041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_DriveDrivesDelete_579041; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesDelete
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579054 = newJObject()
  var query_579055 = newJObject()
  add(query_579055, "key", newJString(key))
  add(query_579055, "prettyPrint", newJBool(prettyPrint))
  add(query_579055, "oauth_token", newJString(oauthToken))
  add(query_579055, "alt", newJString(alt))
  add(query_579055, "userIp", newJString(userIp))
  add(query_579055, "quotaUser", newJString(quotaUser))
  add(path_579054, "driveId", newJString(driveId))
  add(query_579055, "fields", newJString(fields))
  result = call_579053.call(path_579054, query_579055, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_579041(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_579042,
    base: "/drive/v3", url: url_DriveDrivesDelete_579043, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_579074 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesHide_579076(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesHide_579075(path: JsonNode; query: JsonNode;
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
  var valid_579077 = path.getOrDefault("driveId")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "driveId", valid_579077
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("alt")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("json"))
  if valid_579081 != nil:
    section.add "alt", valid_579081
  var valid_579082 = query.getOrDefault("userIp")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "userIp", valid_579082
  var valid_579083 = query.getOrDefault("quotaUser")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "quotaUser", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579085: Call_DriveDrivesHide_579074; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_DriveDrivesHide_579074; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesHide
  ## Hides a shared drive from the default view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "userIp", newJString(userIp))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(path_579087, "driveId", newJString(driveId))
  add(query_579088, "fields", newJString(fields))
  result = call_579086.call(path_579087, query_579088, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_579074(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_579075,
    base: "/drive/v3", url: url_DriveDrivesHide_579076, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_579089 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesUnhide_579091(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUnhide_579090(path: JsonNode; query: JsonNode;
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
  var valid_579092 = path.getOrDefault("driveId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "driveId", valid_579092
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("userIp")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "userIp", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579100: Call_DriveDrivesUnhide_579089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_DriveDrivesUnhide_579089; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesUnhide
  ## Restores a shared drive to the default view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "userIp", newJString(userIp))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(path_579102, "driveId", newJString(driveId))
  add(query_579103, "fields", newJString(fields))
  result = call_579101.call(path_579102, query_579103, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_579089(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_579090,
    base: "/drive/v3", url: url_DriveDrivesUnhide_579091, schemes: {Scheme.Https})
type
  Call_DriveFilesCreate_579130 = ref object of OpenApiRestCall_578355
proc url_DriveFilesCreate_579132(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesCreate_579131(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ignoreDefaultVisibility: JBool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("useContentAsIndexableText")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(false))
  if valid_579134 != nil:
    section.add "useContentAsIndexableText", valid_579134
  var valid_579135 = query.getOrDefault("prettyPrint")
  valid_579135 = validateParameter(valid_579135, JBool, required = false,
                                 default = newJBool(true))
  if valid_579135 != nil:
    section.add "prettyPrint", valid_579135
  var valid_579136 = query.getOrDefault("oauth_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "oauth_token", valid_579136
  var valid_579137 = query.getOrDefault("ignoreDefaultVisibility")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(false))
  if valid_579137 != nil:
    section.add "ignoreDefaultVisibility", valid_579137
  var valid_579138 = query.getOrDefault("ocrLanguage")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "ocrLanguage", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("userIp")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "userIp", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("supportsTeamDrives")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(false))
  if valid_579142 != nil:
    section.add "supportsTeamDrives", valid_579142
  var valid_579143 = query.getOrDefault("supportsAllDrives")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(false))
  if valid_579143 != nil:
    section.add "supportsAllDrives", valid_579143
  var valid_579144 = query.getOrDefault("keepRevisionForever")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(false))
  if valid_579144 != nil:
    section.add "keepRevisionForever", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
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

proc call*(call_579147: Call_DriveFilesCreate_579130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new file.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_DriveFilesCreate_579130; key: string = "";
          useContentAsIndexableText: bool = false; prettyPrint: bool = true;
          oauthToken: string = ""; ignoreDefaultVisibility: bool = false;
          ocrLanguage: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; keepRevisionForever: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveFilesCreate
  ## Creates a new file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ignoreDefaultVisibility: bool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579149 = newJObject()
  var body_579150 = newJObject()
  add(query_579149, "key", newJString(key))
  add(query_579149, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_579149, "prettyPrint", newJBool(prettyPrint))
  add(query_579149, "oauth_token", newJString(oauthToken))
  add(query_579149, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_579149, "ocrLanguage", newJString(ocrLanguage))
  add(query_579149, "alt", newJString(alt))
  add(query_579149, "userIp", newJString(userIp))
  add(query_579149, "quotaUser", newJString(quotaUser))
  add(query_579149, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579149, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579149, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_579150 = body
  add(query_579149, "fields", newJString(fields))
  result = call_579148.call(nil, query_579149, nil, nil, body_579150)

var driveFilesCreate* = Call_DriveFilesCreate_579130(name: "driveFilesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesCreate_579131, base: "/drive/v3",
    url: url_DriveFilesCreate_579132, schemes: {Scheme.Https})
type
  Call_DriveFilesList_579104 = ref object of OpenApiRestCall_578355
proc url_DriveFilesList_579106(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_579105(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists or searches files.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   driveId: JString
  ##          : ID of the shared drive to search.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   q: JString
  ##    : A query for filtering the file results. See the "Search for Files" guide for supported syntax.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query within the corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: JInt
  ##           : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedTime desc,name. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   corpus: JString
  ##         : The source of files to list. Deprecated: use 'corpora' instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   corpora: JString
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'user', 'domain', 'drive' and 'allDrives'. Prefer 'user' or 'drive' to 'allDrives' for efficiency.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("driveId")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "driveId", valid_579110
  var valid_579111 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579111 = validateParameter(valid_579111, JBool, required = false,
                                 default = newJBool(false))
  if valid_579111 != nil:
    section.add "includeItemsFromAllDrives", valid_579111
  var valid_579112 = query.getOrDefault("q")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "q", valid_579112
  var valid_579113 = query.getOrDefault("spaces")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = newJString("drive"))
  if valid_579113 != nil:
    section.add "spaces", valid_579113
  var valid_579114 = query.getOrDefault("pageSize")
  valid_579114 = validateParameter(valid_579114, JInt, required = false,
                                 default = newJInt(100))
  if valid_579114 != nil:
    section.add "pageSize", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("userIp")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "userIp", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("orderBy")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "orderBy", valid_579118
  var valid_579119 = query.getOrDefault("pageToken")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "pageToken", valid_579119
  var valid_579120 = query.getOrDefault("supportsTeamDrives")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(false))
  if valid_579120 != nil:
    section.add "supportsTeamDrives", valid_579120
  var valid_579121 = query.getOrDefault("supportsAllDrives")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(false))
  if valid_579121 != nil:
    section.add "supportsAllDrives", valid_579121
  var valid_579122 = query.getOrDefault("corpus")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("domain"))
  if valid_579122 != nil:
    section.add "corpus", valid_579122
  var valid_579123 = query.getOrDefault("includeTeamDriveItems")
  valid_579123 = validateParameter(valid_579123, JBool, required = false,
                                 default = newJBool(false))
  if valid_579123 != nil:
    section.add "includeTeamDriveItems", valid_579123
  var valid_579124 = query.getOrDefault("corpora")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "corpora", valid_579124
  var valid_579125 = query.getOrDefault("fields")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "fields", valid_579125
  var valid_579126 = query.getOrDefault("teamDriveId")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "teamDriveId", valid_579126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579127: Call_DriveFilesList_579104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists or searches files.
  ## 
  let valid = call_579127.validator(path, query, header, formData, body)
  let scheme = call_579127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579127.url(scheme.get, call_579127.host, call_579127.base,
                         call_579127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579127, url, valid)

proc call*(call_579128: Call_DriveFilesList_579104; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; driveId: string = "";
          includeItemsFromAllDrives: bool = false; q: string = "";
          spaces: string = "drive"; pageSize: int = 100; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          pageToken: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; corpus: string = "domain";
          includeTeamDriveItems: bool = false; corpora: string = "";
          fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveFilesList
  ## Lists or searches files.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : ID of the shared drive to search.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   q: string
  ##    : A query for filtering the file results. See the "Search for Files" guide for supported syntax.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query within the corpus. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   pageSize: int
  ##           : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedTime desc,name. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   corpus: string
  ##         : The source of files to list. Deprecated: use 'corpora' instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   corpora: string
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'user', 'domain', 'drive' and 'allDrives'. Prefer 'user' or 'drive' to 'allDrives' for efficiency.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_579129 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "driveId", newJString(driveId))
  add(query_579129, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579129, "q", newJString(q))
  add(query_579129, "spaces", newJString(spaces))
  add(query_579129, "pageSize", newJInt(pageSize))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "userIp", newJString(userIp))
  add(query_579129, "quotaUser", newJString(quotaUser))
  add(query_579129, "orderBy", newJString(orderBy))
  add(query_579129, "pageToken", newJString(pageToken))
  add(query_579129, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579129, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579129, "corpus", newJString(corpus))
  add(query_579129, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_579129, "corpora", newJString(corpora))
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "teamDriveId", newJString(teamDriveId))
  result = call_579128.call(nil, query_579129, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_579104(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_579105, base: "/drive/v3",
    url: url_DriveFilesList_579106, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_579151 = ref object of OpenApiRestCall_578355
proc url_DriveFilesGenerateIds_579153(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_579152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   count: JInt
  ##        : The number of IDs to return.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   space: JString
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579154 = query.getOrDefault("key")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "key", valid_579154
  var valid_579155 = query.getOrDefault("prettyPrint")
  valid_579155 = validateParameter(valid_579155, JBool, required = false,
                                 default = newJBool(true))
  if valid_579155 != nil:
    section.add "prettyPrint", valid_579155
  var valid_579156 = query.getOrDefault("oauth_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "oauth_token", valid_579156
  var valid_579157 = query.getOrDefault("count")
  valid_579157 = validateParameter(valid_579157, JInt, required = false,
                                 default = newJInt(10))
  if valid_579157 != nil:
    section.add "count", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("userIp")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "userIp", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("space")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("drive"))
  if valid_579161 != nil:
    section.add "space", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579163: Call_DriveFilesGenerateIds_579151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  let valid = call_579163.validator(path, query, header, formData, body)
  let scheme = call_579163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579163.url(scheme.get, call_579163.host, call_579163.base,
                         call_579163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579163, url, valid)

proc call*(call_579164: Call_DriveFilesGenerateIds_579151; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; count: int = 10;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          space: string = "drive"; fields: string = ""): Recallable =
  ## driveFilesGenerateIds
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   count: int
  ##        : The number of IDs to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   space: string
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579165 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "count", newJInt(count))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "userIp", newJString(userIp))
  add(query_579165, "quotaUser", newJString(quotaUser))
  add(query_579165, "space", newJString(space))
  add(query_579165, "fields", newJString(fields))
  result = call_579164.call(nil, query_579165, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_579151(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_579152, base: "/drive/v3",
    url: url_DriveFilesGenerateIds_579153, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_579166 = ref object of OpenApiRestCall_578355
proc url_DriveFilesEmptyTrash_579168(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_579167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes all of the user's trashed files.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579169 = query.getOrDefault("key")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "key", valid_579169
  var valid_579170 = query.getOrDefault("prettyPrint")
  valid_579170 = validateParameter(valid_579170, JBool, required = false,
                                 default = newJBool(true))
  if valid_579170 != nil:
    section.add "prettyPrint", valid_579170
  var valid_579171 = query.getOrDefault("oauth_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "oauth_token", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("userIp")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "userIp", valid_579173
  var valid_579174 = query.getOrDefault("quotaUser")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "quotaUser", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579176: Call_DriveFilesEmptyTrash_579166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_579176.validator(path, query, header, formData, body)
  let scheme = call_579176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579176.url(scheme.get, call_579176.host, call_579176.base,
                         call_579176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579176, url, valid)

proc call*(call_579177: Call_DriveFilesEmptyTrash_579166; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveFilesEmptyTrash
  ## Permanently deletes all of the user's trashed files.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579178 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "userIp", newJString(userIp))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(query_579178, "fields", newJString(fields))
  result = call_579177.call(nil, query_579178, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_579166(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_579167, base: "/drive/v3",
    url: url_DriveFilesEmptyTrash_579168, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_579179 = ref object of OpenApiRestCall_578355
proc url_DriveFilesGet_579181(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesGet_579180(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579182 = path.getOrDefault("fileId")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "fileId", valid_579182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579183 = query.getOrDefault("key")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "key", valid_579183
  var valid_579184 = query.getOrDefault("prettyPrint")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(true))
  if valid_579184 != nil:
    section.add "prettyPrint", valid_579184
  var valid_579185 = query.getOrDefault("oauth_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "oauth_token", valid_579185
  var valid_579186 = query.getOrDefault("alt")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("json"))
  if valid_579186 != nil:
    section.add "alt", valid_579186
  var valid_579187 = query.getOrDefault("userIp")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "userIp", valid_579187
  var valid_579188 = query.getOrDefault("quotaUser")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "quotaUser", valid_579188
  var valid_579189 = query.getOrDefault("supportsTeamDrives")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(false))
  if valid_579189 != nil:
    section.add "supportsTeamDrives", valid_579189
  var valid_579190 = query.getOrDefault("acknowledgeAbuse")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(false))
  if valid_579190 != nil:
    section.add "acknowledgeAbuse", valid_579190
  var valid_579191 = query.getOrDefault("supportsAllDrives")
  valid_579191 = validateParameter(valid_579191, JBool, required = false,
                                 default = newJBool(false))
  if valid_579191 != nil:
    section.add "supportsAllDrives", valid_579191
  var valid_579192 = query.getOrDefault("fields")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "fields", valid_579192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579193: Call_DriveFilesGet_579179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata or content by ID.
  ## 
  let valid = call_579193.validator(path, query, header, formData, body)
  let scheme = call_579193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579193.url(scheme.get, call_579193.host, call_579193.base,
                         call_579193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579193, url, valid)

proc call*(call_579194: Call_DriveFilesGet_579179; fileId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; supportsTeamDrives: bool = false;
          acknowledgeAbuse: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesGet
  ## Gets a file's metadata or content by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579195 = newJObject()
  var query_579196 = newJObject()
  add(query_579196, "key", newJString(key))
  add(query_579196, "prettyPrint", newJBool(prettyPrint))
  add(query_579196, "oauth_token", newJString(oauthToken))
  add(query_579196, "alt", newJString(alt))
  add(query_579196, "userIp", newJString(userIp))
  add(query_579196, "quotaUser", newJString(quotaUser))
  add(path_579195, "fileId", newJString(fileId))
  add(query_579196, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579196, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_579196, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579196, "fields", newJString(fields))
  result = call_579194.call(path_579195, query_579196, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_579179(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_579180, base: "/drive/v3",
    url: url_DriveFilesGet_579181, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_579214 = ref object of OpenApiRestCall_578355
proc url_DriveFilesUpdate_579216(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUpdate_579215(path: JsonNode; query: JsonNode;
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
  var valid_579217 = path.getOrDefault("fileId")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fileId", valid_579217
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   addParents: JString
  ##             : A comma-separated list of parent IDs to add.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   removeParents: JString
  ##                : A comma-separated list of parent IDs to remove.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579218 = query.getOrDefault("key")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "key", valid_579218
  var valid_579219 = query.getOrDefault("useContentAsIndexableText")
  valid_579219 = validateParameter(valid_579219, JBool, required = false,
                                 default = newJBool(false))
  if valid_579219 != nil:
    section.add "useContentAsIndexableText", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  var valid_579222 = query.getOrDefault("addParents")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "addParents", valid_579222
  var valid_579223 = query.getOrDefault("ocrLanguage")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "ocrLanguage", valid_579223
  var valid_579224 = query.getOrDefault("alt")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("json"))
  if valid_579224 != nil:
    section.add "alt", valid_579224
  var valid_579225 = query.getOrDefault("userIp")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "userIp", valid_579225
  var valid_579226 = query.getOrDefault("quotaUser")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "quotaUser", valid_579226
  var valid_579227 = query.getOrDefault("supportsTeamDrives")
  valid_579227 = validateParameter(valid_579227, JBool, required = false,
                                 default = newJBool(false))
  if valid_579227 != nil:
    section.add "supportsTeamDrives", valid_579227
  var valid_579228 = query.getOrDefault("supportsAllDrives")
  valid_579228 = validateParameter(valid_579228, JBool, required = false,
                                 default = newJBool(false))
  if valid_579228 != nil:
    section.add "supportsAllDrives", valid_579228
  var valid_579229 = query.getOrDefault("keepRevisionForever")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(false))
  if valid_579229 != nil:
    section.add "keepRevisionForever", valid_579229
  var valid_579230 = query.getOrDefault("removeParents")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "removeParents", valid_579230
  var valid_579231 = query.getOrDefault("fields")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "fields", valid_579231
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

proc call*(call_579233: Call_DriveFilesUpdate_579214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  let valid = call_579233.validator(path, query, header, formData, body)
  let scheme = call_579233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579233.url(scheme.get, call_579233.host, call_579233.base,
                         call_579233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579233, url, valid)

proc call*(call_579234: Call_DriveFilesUpdate_579214; fileId: string;
          key: string = ""; useContentAsIndexableText: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; addParents: string = "";
          ocrLanguage: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; keepRevisionForever: bool = false;
          body: JsonNode = nil; removeParents: string = ""; fields: string = ""): Recallable =
  ## driveFilesUpdate
  ## Updates a file's metadata and/or content with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the uploaded content as indexable text.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   addParents: string
  ##             : A comma-separated list of parent IDs to add.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   body: JObject
  ##   removeParents: string
  ##                : A comma-separated list of parent IDs to remove.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579235 = newJObject()
  var query_579236 = newJObject()
  var body_579237 = newJObject()
  add(query_579236, "key", newJString(key))
  add(query_579236, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_579236, "prettyPrint", newJBool(prettyPrint))
  add(query_579236, "oauth_token", newJString(oauthToken))
  add(query_579236, "addParents", newJString(addParents))
  add(query_579236, "ocrLanguage", newJString(ocrLanguage))
  add(query_579236, "alt", newJString(alt))
  add(query_579236, "userIp", newJString(userIp))
  add(query_579236, "quotaUser", newJString(quotaUser))
  add(path_579235, "fileId", newJString(fileId))
  add(query_579236, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579236, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579236, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_579237 = body
  add(query_579236, "removeParents", newJString(removeParents))
  add(query_579236, "fields", newJString(fields))
  result = call_579234.call(path_579235, query_579236, nil, nil, body_579237)

var driveFilesUpdate* = Call_DriveFilesUpdate_579214(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesUpdate_579215,
    base: "/drive/v3", url: url_DriveFilesUpdate_579216, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_579197 = ref object of OpenApiRestCall_578355
proc url_DriveFilesDelete_579199(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesDelete_579198(path: JsonNode; query: JsonNode;
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
  var valid_579200 = path.getOrDefault("fileId")
  valid_579200 = validateParameter(valid_579200, JString, required = true,
                                 default = nil)
  if valid_579200 != nil:
    section.add "fileId", valid_579200
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579201 = query.getOrDefault("key")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "key", valid_579201
  var valid_579202 = query.getOrDefault("prettyPrint")
  valid_579202 = validateParameter(valid_579202, JBool, required = false,
                                 default = newJBool(true))
  if valid_579202 != nil:
    section.add "prettyPrint", valid_579202
  var valid_579203 = query.getOrDefault("oauth_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "oauth_token", valid_579203
  var valid_579204 = query.getOrDefault("alt")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("json"))
  if valid_579204 != nil:
    section.add "alt", valid_579204
  var valid_579205 = query.getOrDefault("userIp")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "userIp", valid_579205
  var valid_579206 = query.getOrDefault("quotaUser")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "quotaUser", valid_579206
  var valid_579207 = query.getOrDefault("supportsTeamDrives")
  valid_579207 = validateParameter(valid_579207, JBool, required = false,
                                 default = newJBool(false))
  if valid_579207 != nil:
    section.add "supportsTeamDrives", valid_579207
  var valid_579208 = query.getOrDefault("supportsAllDrives")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(false))
  if valid_579208 != nil:
    section.add "supportsAllDrives", valid_579208
  var valid_579209 = query.getOrDefault("fields")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "fields", valid_579209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579210: Call_DriveFilesDelete_579197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  let valid = call_579210.validator(path, query, header, formData, body)
  let scheme = call_579210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579210.url(scheme.get, call_579210.host, call_579210.base,
                         call_579210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579210, url, valid)

proc call*(call_579211: Call_DriveFilesDelete_579197; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesDelete
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579212 = newJObject()
  var query_579213 = newJObject()
  add(query_579213, "key", newJString(key))
  add(query_579213, "prettyPrint", newJBool(prettyPrint))
  add(query_579213, "oauth_token", newJString(oauthToken))
  add(query_579213, "alt", newJString(alt))
  add(query_579213, "userIp", newJString(userIp))
  add(query_579213, "quotaUser", newJString(quotaUser))
  add(path_579212, "fileId", newJString(fileId))
  add(query_579213, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579213, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579213, "fields", newJString(fields))
  result = call_579211.call(path_579212, query_579213, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_579197(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_579198,
    base: "/drive/v3", url: url_DriveFilesDelete_579199, schemes: {Scheme.Https})
type
  Call_DriveCommentsCreate_579257 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsCreate_579259(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsCreate_579258(path: JsonNode; query: JsonNode;
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
  var valid_579260 = path.getOrDefault("fileId")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "fileId", valid_579260
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579261 = query.getOrDefault("key")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "key", valid_579261
  var valid_579262 = query.getOrDefault("prettyPrint")
  valid_579262 = validateParameter(valid_579262, JBool, required = false,
                                 default = newJBool(true))
  if valid_579262 != nil:
    section.add "prettyPrint", valid_579262
  var valid_579263 = query.getOrDefault("oauth_token")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "oauth_token", valid_579263
  var valid_579264 = query.getOrDefault("alt")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("json"))
  if valid_579264 != nil:
    section.add "alt", valid_579264
  var valid_579265 = query.getOrDefault("userIp")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "userIp", valid_579265
  var valid_579266 = query.getOrDefault("quotaUser")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "quotaUser", valid_579266
  var valid_579267 = query.getOrDefault("fields")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "fields", valid_579267
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

proc call*(call_579269: Call_DriveCommentsCreate_579257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on a file.
  ## 
  let valid = call_579269.validator(path, query, header, formData, body)
  let scheme = call_579269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579269.url(scheme.get, call_579269.host, call_579269.base,
                         call_579269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579269, url, valid)

proc call*(call_579270: Call_DriveCommentsCreate_579257; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsCreate
  ## Creates a new comment on a file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579271 = newJObject()
  var query_579272 = newJObject()
  var body_579273 = newJObject()
  add(query_579272, "key", newJString(key))
  add(query_579272, "prettyPrint", newJBool(prettyPrint))
  add(query_579272, "oauth_token", newJString(oauthToken))
  add(query_579272, "alt", newJString(alt))
  add(query_579272, "userIp", newJString(userIp))
  add(query_579272, "quotaUser", newJString(quotaUser))
  add(path_579271, "fileId", newJString(fileId))
  if body != nil:
    body_579273 = body
  add(query_579272, "fields", newJString(fields))
  result = call_579270.call(path_579271, query_579272, nil, nil, body_579273)

var driveCommentsCreate* = Call_DriveCommentsCreate_579257(
    name: "driveCommentsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsCreate_579258, base: "/drive/v3",
    url: url_DriveCommentsCreate_579259, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_579238 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsList_579240(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsList_579239(path: JsonNode; query: JsonNode;
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
  var valid_579241 = path.getOrDefault("fileId")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fileId", valid_579241
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of comments to return per page.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   includeDeleted: JBool
  ##                 : Whether to include deleted comments. Deleted comments will not include their original content.
  ##   startModifiedTime: JString
  ##                    : The minimum value of 'modifiedTime' for the result comments (RFC 3339 date-time).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579242 = query.getOrDefault("key")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "key", valid_579242
  var valid_579243 = query.getOrDefault("prettyPrint")
  valid_579243 = validateParameter(valid_579243, JBool, required = false,
                                 default = newJBool(true))
  if valid_579243 != nil:
    section.add "prettyPrint", valid_579243
  var valid_579244 = query.getOrDefault("oauth_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "oauth_token", valid_579244
  var valid_579245 = query.getOrDefault("pageSize")
  valid_579245 = validateParameter(valid_579245, JInt, required = false,
                                 default = newJInt(20))
  if valid_579245 != nil:
    section.add "pageSize", valid_579245
  var valid_579246 = query.getOrDefault("alt")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("json"))
  if valid_579246 != nil:
    section.add "alt", valid_579246
  var valid_579247 = query.getOrDefault("userIp")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "userIp", valid_579247
  var valid_579248 = query.getOrDefault("quotaUser")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "quotaUser", valid_579248
  var valid_579249 = query.getOrDefault("pageToken")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "pageToken", valid_579249
  var valid_579250 = query.getOrDefault("includeDeleted")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(false))
  if valid_579250 != nil:
    section.add "includeDeleted", valid_579250
  var valid_579251 = query.getOrDefault("startModifiedTime")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "startModifiedTime", valid_579251
  var valid_579252 = query.getOrDefault("fields")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "fields", valid_579252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579253: Call_DriveCommentsList_579238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_579253.validator(path, query, header, formData, body)
  let scheme = call_579253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579253.url(scheme.get, call_579253.host, call_579253.base,
                         call_579253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579253, url, valid)

proc call*(call_579254: Call_DriveCommentsList_579238; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          pageSize: int = 20; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; includeDeleted: bool = false;
          startModifiedTime: string = ""; fields: string = ""): Recallable =
  ## driveCommentsList
  ## Lists a file's comments.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   pageSize: int
  ##           : The maximum number of comments to return per page.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   includeDeleted: bool
  ##                 : Whether to include deleted comments. Deleted comments will not include their original content.
  ##   startModifiedTime: string
  ##                    : The minimum value of 'modifiedTime' for the result comments (RFC 3339 date-time).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579255 = newJObject()
  var query_579256 = newJObject()
  add(query_579256, "key", newJString(key))
  add(query_579256, "prettyPrint", newJBool(prettyPrint))
  add(query_579256, "oauth_token", newJString(oauthToken))
  add(query_579256, "pageSize", newJInt(pageSize))
  add(query_579256, "alt", newJString(alt))
  add(query_579256, "userIp", newJString(userIp))
  add(query_579256, "quotaUser", newJString(quotaUser))
  add(path_579255, "fileId", newJString(fileId))
  add(query_579256, "pageToken", newJString(pageToken))
  add(query_579256, "includeDeleted", newJBool(includeDeleted))
  add(query_579256, "startModifiedTime", newJString(startModifiedTime))
  add(query_579256, "fields", newJString(fields))
  result = call_579254.call(path_579255, query_579256, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_579238(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_579239,
    base: "/drive/v3", url: url_DriveCommentsList_579240, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_579274 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsGet_579276(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsGet_579275(path: JsonNode; query: JsonNode;
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
  var valid_579277 = path.getOrDefault("fileId")
  valid_579277 = validateParameter(valid_579277, JString, required = true,
                                 default = nil)
  if valid_579277 != nil:
    section.add "fileId", valid_579277
  var valid_579278 = path.getOrDefault("commentId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "commentId", valid_579278
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDeleted: JBool
  ##                 : Whether to return deleted comments. Deleted comments will not include their original content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579279 = query.getOrDefault("key")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "key", valid_579279
  var valid_579280 = query.getOrDefault("prettyPrint")
  valid_579280 = validateParameter(valid_579280, JBool, required = false,
                                 default = newJBool(true))
  if valid_579280 != nil:
    section.add "prettyPrint", valid_579280
  var valid_579281 = query.getOrDefault("oauth_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "oauth_token", valid_579281
  var valid_579282 = query.getOrDefault("alt")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = newJString("json"))
  if valid_579282 != nil:
    section.add "alt", valid_579282
  var valid_579283 = query.getOrDefault("userIp")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "userIp", valid_579283
  var valid_579284 = query.getOrDefault("quotaUser")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "quotaUser", valid_579284
  var valid_579285 = query.getOrDefault("includeDeleted")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(false))
  if valid_579285 != nil:
    section.add "includeDeleted", valid_579285
  var valid_579286 = query.getOrDefault("fields")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "fields", valid_579286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579287: Call_DriveCommentsGet_579274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_579287.validator(path, query, header, formData, body)
  let scheme = call_579287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579287.url(scheme.get, call_579287.host, call_579287.base,
                         call_579287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579287, url, valid)

proc call*(call_579288: Call_DriveCommentsGet_579274; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeDeleted: bool = false; fields: string = ""): Recallable =
  ## driveCommentsGet
  ## Gets a comment by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to return deleted comments. Deleted comments will not include their original content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579289 = newJObject()
  var query_579290 = newJObject()
  add(query_579290, "key", newJString(key))
  add(query_579290, "prettyPrint", newJBool(prettyPrint))
  add(query_579290, "oauth_token", newJString(oauthToken))
  add(query_579290, "alt", newJString(alt))
  add(query_579290, "userIp", newJString(userIp))
  add(query_579290, "quotaUser", newJString(quotaUser))
  add(path_579289, "fileId", newJString(fileId))
  add(path_579289, "commentId", newJString(commentId))
  add(query_579290, "includeDeleted", newJBool(includeDeleted))
  add(query_579290, "fields", newJString(fields))
  result = call_579288.call(path_579289, query_579290, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_579274(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_579275, base: "/drive/v3",
    url: url_DriveCommentsGet_579276, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_579307 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsUpdate_579309(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsUpdate_579308(path: JsonNode; query: JsonNode;
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
  var valid_579310 = path.getOrDefault("fileId")
  valid_579310 = validateParameter(valid_579310, JString, required = true,
                                 default = nil)
  if valid_579310 != nil:
    section.add "fileId", valid_579310
  var valid_579311 = path.getOrDefault("commentId")
  valid_579311 = validateParameter(valid_579311, JString, required = true,
                                 default = nil)
  if valid_579311 != nil:
    section.add "commentId", valid_579311
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579312 = query.getOrDefault("key")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "key", valid_579312
  var valid_579313 = query.getOrDefault("prettyPrint")
  valid_579313 = validateParameter(valid_579313, JBool, required = false,
                                 default = newJBool(true))
  if valid_579313 != nil:
    section.add "prettyPrint", valid_579313
  var valid_579314 = query.getOrDefault("oauth_token")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "oauth_token", valid_579314
  var valid_579315 = query.getOrDefault("alt")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = newJString("json"))
  if valid_579315 != nil:
    section.add "alt", valid_579315
  var valid_579316 = query.getOrDefault("userIp")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "userIp", valid_579316
  var valid_579317 = query.getOrDefault("quotaUser")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "quotaUser", valid_579317
  var valid_579318 = query.getOrDefault("fields")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "fields", valid_579318
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

proc call*(call_579320: Call_DriveCommentsUpdate_579307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a comment with patch semantics.
  ## 
  let valid = call_579320.validator(path, query, header, formData, body)
  let scheme = call_579320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579320.url(scheme.get, call_579320.host, call_579320.base,
                         call_579320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579320, url, valid)

proc call*(call_579321: Call_DriveCommentsUpdate_579307; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsUpdate
  ## Updates a comment with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579322 = newJObject()
  var query_579323 = newJObject()
  var body_579324 = newJObject()
  add(query_579323, "key", newJString(key))
  add(query_579323, "prettyPrint", newJBool(prettyPrint))
  add(query_579323, "oauth_token", newJString(oauthToken))
  add(query_579323, "alt", newJString(alt))
  add(query_579323, "userIp", newJString(userIp))
  add(query_579323, "quotaUser", newJString(quotaUser))
  add(path_579322, "fileId", newJString(fileId))
  add(path_579322, "commentId", newJString(commentId))
  if body != nil:
    body_579324 = body
  add(query_579323, "fields", newJString(fields))
  result = call_579321.call(path_579322, query_579323, nil, nil, body_579324)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_579307(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_579308, base: "/drive/v3",
    url: url_DriveCommentsUpdate_579309, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_579291 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsDelete_579293(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsDelete_579292(path: JsonNode; query: JsonNode;
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
  var valid_579294 = path.getOrDefault("fileId")
  valid_579294 = validateParameter(valid_579294, JString, required = true,
                                 default = nil)
  if valid_579294 != nil:
    section.add "fileId", valid_579294
  var valid_579295 = path.getOrDefault("commentId")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "commentId", valid_579295
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579296 = query.getOrDefault("key")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "key", valid_579296
  var valid_579297 = query.getOrDefault("prettyPrint")
  valid_579297 = validateParameter(valid_579297, JBool, required = false,
                                 default = newJBool(true))
  if valid_579297 != nil:
    section.add "prettyPrint", valid_579297
  var valid_579298 = query.getOrDefault("oauth_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "oauth_token", valid_579298
  var valid_579299 = query.getOrDefault("alt")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = newJString("json"))
  if valid_579299 != nil:
    section.add "alt", valid_579299
  var valid_579300 = query.getOrDefault("userIp")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "userIp", valid_579300
  var valid_579301 = query.getOrDefault("quotaUser")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "quotaUser", valid_579301
  var valid_579302 = query.getOrDefault("fields")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "fields", valid_579302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579303: Call_DriveCommentsDelete_579291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_DriveCommentsDelete_579291; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveCommentsDelete
  ## Deletes a comment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "userIp", newJString(userIp))
  add(query_579306, "quotaUser", newJString(quotaUser))
  add(path_579305, "fileId", newJString(fileId))
  add(path_579305, "commentId", newJString(commentId))
  add(query_579306, "fields", newJString(fields))
  result = call_579304.call(path_579305, query_579306, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_579291(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_579292, base: "/drive/v3",
    url: url_DriveCommentsDelete_579293, schemes: {Scheme.Https})
type
  Call_DriveRepliesCreate_579344 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesCreate_579346(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesCreate_579345(path: JsonNode; query: JsonNode;
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
  var valid_579347 = path.getOrDefault("fileId")
  valid_579347 = validateParameter(valid_579347, JString, required = true,
                                 default = nil)
  if valid_579347 != nil:
    section.add "fileId", valid_579347
  var valid_579348 = path.getOrDefault("commentId")
  valid_579348 = validateParameter(valid_579348, JString, required = true,
                                 default = nil)
  if valid_579348 != nil:
    section.add "commentId", valid_579348
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579349 = query.getOrDefault("key")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "key", valid_579349
  var valid_579350 = query.getOrDefault("prettyPrint")
  valid_579350 = validateParameter(valid_579350, JBool, required = false,
                                 default = newJBool(true))
  if valid_579350 != nil:
    section.add "prettyPrint", valid_579350
  var valid_579351 = query.getOrDefault("oauth_token")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "oauth_token", valid_579351
  var valid_579352 = query.getOrDefault("alt")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = newJString("json"))
  if valid_579352 != nil:
    section.add "alt", valid_579352
  var valid_579353 = query.getOrDefault("userIp")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "userIp", valid_579353
  var valid_579354 = query.getOrDefault("quotaUser")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "quotaUser", valid_579354
  var valid_579355 = query.getOrDefault("fields")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "fields", valid_579355
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

proc call*(call_579357: Call_DriveRepliesCreate_579344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to a comment.
  ## 
  let valid = call_579357.validator(path, query, header, formData, body)
  let scheme = call_579357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579357.url(scheme.get, call_579357.host, call_579357.base,
                         call_579357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579357, url, valid)

proc call*(call_579358: Call_DriveRepliesCreate_579344; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesCreate
  ## Creates a new reply to a comment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579359 = newJObject()
  var query_579360 = newJObject()
  var body_579361 = newJObject()
  add(query_579360, "key", newJString(key))
  add(query_579360, "prettyPrint", newJBool(prettyPrint))
  add(query_579360, "oauth_token", newJString(oauthToken))
  add(query_579360, "alt", newJString(alt))
  add(query_579360, "userIp", newJString(userIp))
  add(query_579360, "quotaUser", newJString(quotaUser))
  add(path_579359, "fileId", newJString(fileId))
  add(path_579359, "commentId", newJString(commentId))
  if body != nil:
    body_579361 = body
  add(query_579360, "fields", newJString(fields))
  result = call_579358.call(path_579359, query_579360, nil, nil, body_579361)

var driveRepliesCreate* = Call_DriveRepliesCreate_579344(
    name: "driveRepliesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesCreate_579345, base: "/drive/v3",
    url: url_DriveRepliesCreate_579346, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_579325 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesList_579327(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesList_579326(path: JsonNode; query: JsonNode;
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
  var valid_579328 = path.getOrDefault("fileId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "fileId", valid_579328
  var valid_579329 = path.getOrDefault("commentId")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "commentId", valid_579329
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of replies to return per page.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   includeDeleted: JBool
  ##                 : Whether to include deleted replies. Deleted replies will not include their original content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("pageSize")
  valid_579333 = validateParameter(valid_579333, JInt, required = false,
                                 default = newJInt(20))
  if valid_579333 != nil:
    section.add "pageSize", valid_579333
  var valid_579334 = query.getOrDefault("alt")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("json"))
  if valid_579334 != nil:
    section.add "alt", valid_579334
  var valid_579335 = query.getOrDefault("userIp")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "userIp", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  var valid_579337 = query.getOrDefault("pageToken")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "pageToken", valid_579337
  var valid_579338 = query.getOrDefault("includeDeleted")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(false))
  if valid_579338 != nil:
    section.add "includeDeleted", valid_579338
  var valid_579339 = query.getOrDefault("fields")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "fields", valid_579339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579340: Call_DriveRepliesList_579325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a comment's replies.
  ## 
  let valid = call_579340.validator(path, query, header, formData, body)
  let scheme = call_579340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579340.url(scheme.get, call_579340.host, call_579340.base,
                         call_579340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579340, url, valid)

proc call*(call_579341: Call_DriveRepliesList_579325; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; pageSize: int = 20; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeDeleted: bool = false; fields: string = ""): Recallable =
  ## driveRepliesList
  ## Lists a comment's replies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   pageSize: int
  ##           : The maximum number of replies to return per page.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to include deleted replies. Deleted replies will not include their original content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579342 = newJObject()
  var query_579343 = newJObject()
  add(query_579343, "key", newJString(key))
  add(query_579343, "prettyPrint", newJBool(prettyPrint))
  add(query_579343, "oauth_token", newJString(oauthToken))
  add(query_579343, "pageSize", newJInt(pageSize))
  add(query_579343, "alt", newJString(alt))
  add(query_579343, "userIp", newJString(userIp))
  add(query_579343, "quotaUser", newJString(quotaUser))
  add(path_579342, "fileId", newJString(fileId))
  add(query_579343, "pageToken", newJString(pageToken))
  add(path_579342, "commentId", newJString(commentId))
  add(query_579343, "includeDeleted", newJBool(includeDeleted))
  add(query_579343, "fields", newJString(fields))
  result = call_579341.call(path_579342, query_579343, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_579325(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_579326, base: "/drive/v3",
    url: url_DriveRepliesList_579327, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_579362 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesGet_579364(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesGet_579363(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a reply by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_579365 = path.getOrDefault("replyId")
  valid_579365 = validateParameter(valid_579365, JString, required = true,
                                 default = nil)
  if valid_579365 != nil:
    section.add "replyId", valid_579365
  var valid_579366 = path.getOrDefault("fileId")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "fileId", valid_579366
  var valid_579367 = path.getOrDefault("commentId")
  valid_579367 = validateParameter(valid_579367, JString, required = true,
                                 default = nil)
  if valid_579367 != nil:
    section.add "commentId", valid_579367
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDeleted: JBool
  ##                 : Whether to return deleted replies. Deleted replies will not include their original content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579368 = query.getOrDefault("key")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "key", valid_579368
  var valid_579369 = query.getOrDefault("prettyPrint")
  valid_579369 = validateParameter(valid_579369, JBool, required = false,
                                 default = newJBool(true))
  if valid_579369 != nil:
    section.add "prettyPrint", valid_579369
  var valid_579370 = query.getOrDefault("oauth_token")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "oauth_token", valid_579370
  var valid_579371 = query.getOrDefault("alt")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = newJString("json"))
  if valid_579371 != nil:
    section.add "alt", valid_579371
  var valid_579372 = query.getOrDefault("userIp")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "userIp", valid_579372
  var valid_579373 = query.getOrDefault("quotaUser")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "quotaUser", valid_579373
  var valid_579374 = query.getOrDefault("includeDeleted")
  valid_579374 = validateParameter(valid_579374, JBool, required = false,
                                 default = newJBool(false))
  if valid_579374 != nil:
    section.add "includeDeleted", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579376: Call_DriveRepliesGet_579362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply by ID.
  ## 
  let valid = call_579376.validator(path, query, header, formData, body)
  let scheme = call_579376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579376.url(scheme.get, call_579376.host, call_579376.base,
                         call_579376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579376, url, valid)

proc call*(call_579377: Call_DriveRepliesGet_579362; replyId: string; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeDeleted: bool = false; fields: string = ""): Recallable =
  ## driveRepliesGet
  ## Gets a reply by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : Whether to return deleted replies. Deleted replies will not include their original content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579378 = newJObject()
  var query_579379 = newJObject()
  add(query_579379, "key", newJString(key))
  add(query_579379, "prettyPrint", newJBool(prettyPrint))
  add(query_579379, "oauth_token", newJString(oauthToken))
  add(query_579379, "alt", newJString(alt))
  add(query_579379, "userIp", newJString(userIp))
  add(path_579378, "replyId", newJString(replyId))
  add(query_579379, "quotaUser", newJString(quotaUser))
  add(path_579378, "fileId", newJString(fileId))
  add(path_579378, "commentId", newJString(commentId))
  add(query_579379, "includeDeleted", newJBool(includeDeleted))
  add(query_579379, "fields", newJString(fields))
  result = call_579377.call(path_579378, query_579379, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_579362(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_579363, base: "/drive/v3",
    url: url_DriveRepliesGet_579364, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_579397 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesUpdate_579399(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesUpdate_579398(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a reply with patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_579400 = path.getOrDefault("replyId")
  valid_579400 = validateParameter(valid_579400, JString, required = true,
                                 default = nil)
  if valid_579400 != nil:
    section.add "replyId", valid_579400
  var valid_579401 = path.getOrDefault("fileId")
  valid_579401 = validateParameter(valid_579401, JString, required = true,
                                 default = nil)
  if valid_579401 != nil:
    section.add "fileId", valid_579401
  var valid_579402 = path.getOrDefault("commentId")
  valid_579402 = validateParameter(valid_579402, JString, required = true,
                                 default = nil)
  if valid_579402 != nil:
    section.add "commentId", valid_579402
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579403 = query.getOrDefault("key")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "key", valid_579403
  var valid_579404 = query.getOrDefault("prettyPrint")
  valid_579404 = validateParameter(valid_579404, JBool, required = false,
                                 default = newJBool(true))
  if valid_579404 != nil:
    section.add "prettyPrint", valid_579404
  var valid_579405 = query.getOrDefault("oauth_token")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "oauth_token", valid_579405
  var valid_579406 = query.getOrDefault("alt")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = newJString("json"))
  if valid_579406 != nil:
    section.add "alt", valid_579406
  var valid_579407 = query.getOrDefault("userIp")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "userIp", valid_579407
  var valid_579408 = query.getOrDefault("quotaUser")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "quotaUser", valid_579408
  var valid_579409 = query.getOrDefault("fields")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "fields", valid_579409
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

proc call*(call_579411: Call_DriveRepliesUpdate_579397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a reply with patch semantics.
  ## 
  let valid = call_579411.validator(path, query, header, formData, body)
  let scheme = call_579411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579411.url(scheme.get, call_579411.host, call_579411.base,
                         call_579411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579411, url, valid)

proc call*(call_579412: Call_DriveRepliesUpdate_579397; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesUpdate
  ## Updates a reply with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579413 = newJObject()
  var query_579414 = newJObject()
  var body_579415 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "userIp", newJString(userIp))
  add(path_579413, "replyId", newJString(replyId))
  add(query_579414, "quotaUser", newJString(quotaUser))
  add(path_579413, "fileId", newJString(fileId))
  add(path_579413, "commentId", newJString(commentId))
  if body != nil:
    body_579415 = body
  add(query_579414, "fields", newJString(fields))
  result = call_579412.call(path_579413, query_579414, nil, nil, body_579415)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_579397(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_579398, base: "/drive/v3",
    url: url_DriveRepliesUpdate_579399, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_579380 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesDelete_579382(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesDelete_579381(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_579383 = path.getOrDefault("replyId")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "replyId", valid_579383
  var valid_579384 = path.getOrDefault("fileId")
  valid_579384 = validateParameter(valid_579384, JString, required = true,
                                 default = nil)
  if valid_579384 != nil:
    section.add "fileId", valid_579384
  var valid_579385 = path.getOrDefault("commentId")
  valid_579385 = validateParameter(valid_579385, JString, required = true,
                                 default = nil)
  if valid_579385 != nil:
    section.add "commentId", valid_579385
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579386 = query.getOrDefault("key")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "key", valid_579386
  var valid_579387 = query.getOrDefault("prettyPrint")
  valid_579387 = validateParameter(valid_579387, JBool, required = false,
                                 default = newJBool(true))
  if valid_579387 != nil:
    section.add "prettyPrint", valid_579387
  var valid_579388 = query.getOrDefault("oauth_token")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "oauth_token", valid_579388
  var valid_579389 = query.getOrDefault("alt")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = newJString("json"))
  if valid_579389 != nil:
    section.add "alt", valid_579389
  var valid_579390 = query.getOrDefault("userIp")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "userIp", valid_579390
  var valid_579391 = query.getOrDefault("quotaUser")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "quotaUser", valid_579391
  var valid_579392 = query.getOrDefault("fields")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "fields", valid_579392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579393: Call_DriveRepliesDelete_579380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_579393.validator(path, query, header, formData, body)
  let scheme = call_579393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579393.url(scheme.get, call_579393.host, call_579393.base,
                         call_579393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579393, url, valid)

proc call*(call_579394: Call_DriveRepliesDelete_579380; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRepliesDelete
  ## Deletes a reply.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579395 = newJObject()
  var query_579396 = newJObject()
  add(query_579396, "key", newJString(key))
  add(query_579396, "prettyPrint", newJBool(prettyPrint))
  add(query_579396, "oauth_token", newJString(oauthToken))
  add(query_579396, "alt", newJString(alt))
  add(query_579396, "userIp", newJString(userIp))
  add(path_579395, "replyId", newJString(replyId))
  add(query_579396, "quotaUser", newJString(quotaUser))
  add(path_579395, "fileId", newJString(fileId))
  add(path_579395, "commentId", newJString(commentId))
  add(query_579396, "fields", newJString(fields))
  result = call_579394.call(path_579395, query_579396, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_579380(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_579381, base: "/drive/v3",
    url: url_DriveRepliesDelete_579382, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_579416 = ref object of OpenApiRestCall_578355
proc url_DriveFilesCopy_579418(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesCopy_579417(path: JsonNode; query: JsonNode;
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
  var valid_579419 = path.getOrDefault("fileId")
  valid_579419 = validateParameter(valid_579419, JString, required = true,
                                 default = nil)
  if valid_579419 != nil:
    section.add "fileId", valid_579419
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ignoreDefaultVisibility: JBool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: JString
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: JBool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579420 = query.getOrDefault("key")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "key", valid_579420
  var valid_579421 = query.getOrDefault("prettyPrint")
  valid_579421 = validateParameter(valid_579421, JBool, required = false,
                                 default = newJBool(true))
  if valid_579421 != nil:
    section.add "prettyPrint", valid_579421
  var valid_579422 = query.getOrDefault("oauth_token")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "oauth_token", valid_579422
  var valid_579423 = query.getOrDefault("ignoreDefaultVisibility")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(false))
  if valid_579423 != nil:
    section.add "ignoreDefaultVisibility", valid_579423
  var valid_579424 = query.getOrDefault("ocrLanguage")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "ocrLanguage", valid_579424
  var valid_579425 = query.getOrDefault("alt")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("json"))
  if valid_579425 != nil:
    section.add "alt", valid_579425
  var valid_579426 = query.getOrDefault("userIp")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "userIp", valid_579426
  var valid_579427 = query.getOrDefault("quotaUser")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "quotaUser", valid_579427
  var valid_579428 = query.getOrDefault("supportsTeamDrives")
  valid_579428 = validateParameter(valid_579428, JBool, required = false,
                                 default = newJBool(false))
  if valid_579428 != nil:
    section.add "supportsTeamDrives", valid_579428
  var valid_579429 = query.getOrDefault("supportsAllDrives")
  valid_579429 = validateParameter(valid_579429, JBool, required = false,
                                 default = newJBool(false))
  if valid_579429 != nil:
    section.add "supportsAllDrives", valid_579429
  var valid_579430 = query.getOrDefault("keepRevisionForever")
  valid_579430 = validateParameter(valid_579430, JBool, required = false,
                                 default = newJBool(false))
  if valid_579430 != nil:
    section.add "keepRevisionForever", valid_579430
  var valid_579431 = query.getOrDefault("fields")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "fields", valid_579431
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

proc call*(call_579433: Call_DriveFilesCopy_579416; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  let valid = call_579433.validator(path, query, header, formData, body)
  let scheme = call_579433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579433.url(scheme.get, call_579433.host, call_579433.base,
                         call_579433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579433, url, valid)

proc call*(call_579434: Call_DriveFilesCopy_579416; fileId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ignoreDefaultVisibility: bool = false; ocrLanguage: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          keepRevisionForever: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveFilesCopy
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ignoreDefaultVisibility: bool
  ##                          : Whether to ignore the domain's default visibility settings for the created file. Domain administrators can choose to make all uploaded files visible to the domain by default; this parameter bypasses that behavior for the request. Permissions are still inherited from parent folders.
  ##   ocrLanguage: string
  ##              : A language hint for OCR processing during image import (ISO 639-1 code).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   keepRevisionForever: bool
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579435 = newJObject()
  var query_579436 = newJObject()
  var body_579437 = newJObject()
  add(query_579436, "key", newJString(key))
  add(query_579436, "prettyPrint", newJBool(prettyPrint))
  add(query_579436, "oauth_token", newJString(oauthToken))
  add(query_579436, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_579436, "ocrLanguage", newJString(ocrLanguage))
  add(query_579436, "alt", newJString(alt))
  add(query_579436, "userIp", newJString(userIp))
  add(query_579436, "quotaUser", newJString(quotaUser))
  add(path_579435, "fileId", newJString(fileId))
  add(query_579436, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579436, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579436, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_579437 = body
  add(query_579436, "fields", newJString(fields))
  result = call_579434.call(path_579435, query_579436, nil, nil, body_579437)

var driveFilesCopy* = Call_DriveFilesCopy_579416(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_579417,
    base: "/drive/v3", url: url_DriveFilesCopy_579418, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_579438 = ref object of OpenApiRestCall_578355
proc url_DriveFilesExport_579440(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesExport_579439(path: JsonNode; query: JsonNode;
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
  var valid_579441 = path.getOrDefault("fileId")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "fileId", valid_579441
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   mimeType: JString (required)
  ##           : The MIME type of the format requested for this export.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579442 = query.getOrDefault("key")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "key", valid_579442
  var valid_579443 = query.getOrDefault("prettyPrint")
  valid_579443 = validateParameter(valid_579443, JBool, required = false,
                                 default = newJBool(true))
  if valid_579443 != nil:
    section.add "prettyPrint", valid_579443
  var valid_579444 = query.getOrDefault("oauth_token")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "oauth_token", valid_579444
  var valid_579445 = query.getOrDefault("alt")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = newJString("json"))
  if valid_579445 != nil:
    section.add "alt", valid_579445
  var valid_579446 = query.getOrDefault("userIp")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "userIp", valid_579446
  var valid_579447 = query.getOrDefault("quotaUser")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "quotaUser", valid_579447
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_579448 = query.getOrDefault("mimeType")
  valid_579448 = validateParameter(valid_579448, JString, required = true,
                                 default = nil)
  if valid_579448 != nil:
    section.add "mimeType", valid_579448
  var valid_579449 = query.getOrDefault("fields")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "fields", valid_579449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579450: Call_DriveFilesExport_579438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_579450.validator(path, query, header, formData, body)
  let scheme = call_579450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579450.url(scheme.get, call_579450.host, call_579450.base,
                         call_579450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579450, url, valid)

proc call*(call_579451: Call_DriveFilesExport_579438; fileId: string;
          mimeType: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveFilesExport
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   mimeType: string (required)
  ##           : The MIME type of the format requested for this export.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579452 = newJObject()
  var query_579453 = newJObject()
  add(query_579453, "key", newJString(key))
  add(query_579453, "prettyPrint", newJBool(prettyPrint))
  add(query_579453, "oauth_token", newJString(oauthToken))
  add(query_579453, "alt", newJString(alt))
  add(query_579453, "userIp", newJString(userIp))
  add(query_579453, "quotaUser", newJString(quotaUser))
  add(path_579452, "fileId", newJString(fileId))
  add(query_579453, "mimeType", newJString(mimeType))
  add(query_579453, "fields", newJString(fields))
  result = call_579451.call(path_579452, query_579453, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_579438(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_579439,
    base: "/drive/v3", url: url_DriveFilesExport_579440, schemes: {Scheme.Https})
type
  Call_DrivePermissionsCreate_579474 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsCreate_579476(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsCreate_579475(path: JsonNode; query: JsonNode;
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
  var valid_579477 = path.getOrDefault("fileId")
  valid_579477 = validateParameter(valid_579477, JString, required = true,
                                 default = nil)
  if valid_579477 != nil:
    section.add "fileId", valid_579477
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   sendNotificationEmail: JBool
  ##                        : Whether to send a notification email when sharing to users or groups. This defaults to true for users and groups, and is not allowed for other requests. It must not be disabled for ownership transfers.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   emailMessage: JString
  ##               : A plain text custom message to include in the notification email.
  ##   transferOwnership: JBool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579478 = query.getOrDefault("key")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "key", valid_579478
  var valid_579479 = query.getOrDefault("prettyPrint")
  valid_579479 = validateParameter(valid_579479, JBool, required = false,
                                 default = newJBool(true))
  if valid_579479 != nil:
    section.add "prettyPrint", valid_579479
  var valid_579480 = query.getOrDefault("oauth_token")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "oauth_token", valid_579480
  var valid_579481 = query.getOrDefault("useDomainAdminAccess")
  valid_579481 = validateParameter(valid_579481, JBool, required = false,
                                 default = newJBool(false))
  if valid_579481 != nil:
    section.add "useDomainAdminAccess", valid_579481
  var valid_579482 = query.getOrDefault("sendNotificationEmail")
  valid_579482 = validateParameter(valid_579482, JBool, required = false, default = nil)
  if valid_579482 != nil:
    section.add "sendNotificationEmail", valid_579482
  var valid_579483 = query.getOrDefault("alt")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = newJString("json"))
  if valid_579483 != nil:
    section.add "alt", valid_579483
  var valid_579484 = query.getOrDefault("userIp")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "userIp", valid_579484
  var valid_579485 = query.getOrDefault("quotaUser")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "quotaUser", valid_579485
  var valid_579486 = query.getOrDefault("supportsTeamDrives")
  valid_579486 = validateParameter(valid_579486, JBool, required = false,
                                 default = newJBool(false))
  if valid_579486 != nil:
    section.add "supportsTeamDrives", valid_579486
  var valid_579487 = query.getOrDefault("emailMessage")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "emailMessage", valid_579487
  var valid_579488 = query.getOrDefault("transferOwnership")
  valid_579488 = validateParameter(valid_579488, JBool, required = false,
                                 default = newJBool(false))
  if valid_579488 != nil:
    section.add "transferOwnership", valid_579488
  var valid_579489 = query.getOrDefault("supportsAllDrives")
  valid_579489 = validateParameter(valid_579489, JBool, required = false,
                                 default = newJBool(false))
  if valid_579489 != nil:
    section.add "supportsAllDrives", valid_579489
  var valid_579490 = query.getOrDefault("fields")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "fields", valid_579490
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

proc call*(call_579492: Call_DrivePermissionsCreate_579474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a permission for a file or shared drive.
  ## 
  let valid = call_579492.validator(path, query, header, formData, body)
  let scheme = call_579492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579492.url(scheme.get, call_579492.host, call_579492.base,
                         call_579492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579492, url, valid)

proc call*(call_579493: Call_DrivePermissionsCreate_579474; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; sendNotificationEmail: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; emailMessage: string = "";
          transferOwnership: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePermissionsCreate
  ## Creates a permission for a file or shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   sendNotificationEmail: bool
  ##                        : Whether to send a notification email when sharing to users or groups. This defaults to true for users and groups, and is not allowed for other requests. It must not be disabled for ownership transfers.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   emailMessage: string
  ##               : A plain text custom message to include in the notification email.
  ##   transferOwnership: bool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579494 = newJObject()
  var query_579495 = newJObject()
  var body_579496 = newJObject()
  add(query_579495, "key", newJString(key))
  add(query_579495, "prettyPrint", newJBool(prettyPrint))
  add(query_579495, "oauth_token", newJString(oauthToken))
  add(query_579495, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579495, "sendNotificationEmail", newJBool(sendNotificationEmail))
  add(query_579495, "alt", newJString(alt))
  add(query_579495, "userIp", newJString(userIp))
  add(query_579495, "quotaUser", newJString(quotaUser))
  add(path_579494, "fileId", newJString(fileId))
  add(query_579495, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579495, "emailMessage", newJString(emailMessage))
  add(query_579495, "transferOwnership", newJBool(transferOwnership))
  add(query_579495, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579496 = body
  add(query_579495, "fields", newJString(fields))
  result = call_579493.call(path_579494, query_579495, nil, nil, body_579496)

var drivePermissionsCreate* = Call_DrivePermissionsCreate_579474(
    name: "drivePermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsCreate_579475, base: "/drive/v3",
    url: url_DrivePermissionsCreate_579476, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_579454 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsList_579456(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsList_579455(path: JsonNode; query: JsonNode;
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
  var valid_579457 = path.getOrDefault("fileId")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "fileId", valid_579457
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   pageSize: JInt
  ##           : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579458 = query.getOrDefault("key")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "key", valid_579458
  var valid_579459 = query.getOrDefault("prettyPrint")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "prettyPrint", valid_579459
  var valid_579460 = query.getOrDefault("oauth_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "oauth_token", valid_579460
  var valid_579461 = query.getOrDefault("useDomainAdminAccess")
  valid_579461 = validateParameter(valid_579461, JBool, required = false,
                                 default = newJBool(false))
  if valid_579461 != nil:
    section.add "useDomainAdminAccess", valid_579461
  var valid_579462 = query.getOrDefault("pageSize")
  valid_579462 = validateParameter(valid_579462, JInt, required = false, default = nil)
  if valid_579462 != nil:
    section.add "pageSize", valid_579462
  var valid_579463 = query.getOrDefault("alt")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("json"))
  if valid_579463 != nil:
    section.add "alt", valid_579463
  var valid_579464 = query.getOrDefault("userIp")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "userIp", valid_579464
  var valid_579465 = query.getOrDefault("quotaUser")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "quotaUser", valid_579465
  var valid_579466 = query.getOrDefault("pageToken")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "pageToken", valid_579466
  var valid_579467 = query.getOrDefault("supportsTeamDrives")
  valid_579467 = validateParameter(valid_579467, JBool, required = false,
                                 default = newJBool(false))
  if valid_579467 != nil:
    section.add "supportsTeamDrives", valid_579467
  var valid_579468 = query.getOrDefault("supportsAllDrives")
  valid_579468 = validateParameter(valid_579468, JBool, required = false,
                                 default = newJBool(false))
  if valid_579468 != nil:
    section.add "supportsAllDrives", valid_579468
  var valid_579469 = query.getOrDefault("fields")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "fields", valid_579469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579470: Call_DrivePermissionsList_579454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_579470.validator(path, query, header, formData, body)
  let scheme = call_579470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579470.url(scheme.get, call_579470.host, call_579470.base,
                         call_579470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579470, url, valid)

proc call*(call_579471: Call_DrivePermissionsList_579454; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; pageSize: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## drivePermissionsList
  ## Lists a file's or shared drive's permissions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   pageSize: int
  ##           : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579472 = newJObject()
  var query_579473 = newJObject()
  add(query_579473, "key", newJString(key))
  add(query_579473, "prettyPrint", newJBool(prettyPrint))
  add(query_579473, "oauth_token", newJString(oauthToken))
  add(query_579473, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579473, "pageSize", newJInt(pageSize))
  add(query_579473, "alt", newJString(alt))
  add(query_579473, "userIp", newJString(userIp))
  add(query_579473, "quotaUser", newJString(quotaUser))
  add(path_579472, "fileId", newJString(fileId))
  add(query_579473, "pageToken", newJString(pageToken))
  add(query_579473, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579473, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579473, "fields", newJString(fields))
  result = call_579471.call(path_579472, query_579473, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_579454(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_579455, base: "/drive/v3",
    url: url_DrivePermissionsList_579456, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_579497 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsGet_579499(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsGet_579498(path: JsonNode; query: JsonNode;
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
  var valid_579500 = path.getOrDefault("fileId")
  valid_579500 = validateParameter(valid_579500, JString, required = true,
                                 default = nil)
  if valid_579500 != nil:
    section.add "fileId", valid_579500
  var valid_579501 = path.getOrDefault("permissionId")
  valid_579501 = validateParameter(valid_579501, JString, required = true,
                                 default = nil)
  if valid_579501 != nil:
    section.add "permissionId", valid_579501
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579502 = query.getOrDefault("key")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "key", valid_579502
  var valid_579503 = query.getOrDefault("prettyPrint")
  valid_579503 = validateParameter(valid_579503, JBool, required = false,
                                 default = newJBool(true))
  if valid_579503 != nil:
    section.add "prettyPrint", valid_579503
  var valid_579504 = query.getOrDefault("oauth_token")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "oauth_token", valid_579504
  var valid_579505 = query.getOrDefault("useDomainAdminAccess")
  valid_579505 = validateParameter(valid_579505, JBool, required = false,
                                 default = newJBool(false))
  if valid_579505 != nil:
    section.add "useDomainAdminAccess", valid_579505
  var valid_579506 = query.getOrDefault("alt")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = newJString("json"))
  if valid_579506 != nil:
    section.add "alt", valid_579506
  var valid_579507 = query.getOrDefault("userIp")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "userIp", valid_579507
  var valid_579508 = query.getOrDefault("quotaUser")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "quotaUser", valid_579508
  var valid_579509 = query.getOrDefault("supportsTeamDrives")
  valid_579509 = validateParameter(valid_579509, JBool, required = false,
                                 default = newJBool(false))
  if valid_579509 != nil:
    section.add "supportsTeamDrives", valid_579509
  var valid_579510 = query.getOrDefault("supportsAllDrives")
  valid_579510 = validateParameter(valid_579510, JBool, required = false,
                                 default = newJBool(false))
  if valid_579510 != nil:
    section.add "supportsAllDrives", valid_579510
  var valid_579511 = query.getOrDefault("fields")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "fields", valid_579511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579512: Call_DrivePermissionsGet_579497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_579512.validator(path, query, header, formData, body)
  let scheme = call_579512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579512.url(scheme.get, call_579512.host, call_579512.base,
                         call_579512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579512, url, valid)

proc call*(call_579513: Call_DrivePermissionsGet_579497; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## drivePermissionsGet
  ## Gets a permission by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  var path_579514 = newJObject()
  var query_579515 = newJObject()
  add(query_579515, "key", newJString(key))
  add(query_579515, "prettyPrint", newJBool(prettyPrint))
  add(query_579515, "oauth_token", newJString(oauthToken))
  add(query_579515, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579515, "alt", newJString(alt))
  add(query_579515, "userIp", newJString(userIp))
  add(query_579515, "quotaUser", newJString(quotaUser))
  add(path_579514, "fileId", newJString(fileId))
  add(query_579515, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579515, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579515, "fields", newJString(fields))
  add(path_579514, "permissionId", newJString(permissionId))
  result = call_579513.call(path_579514, query_579515, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_579497(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_579498, base: "/drive/v3",
    url: url_DrivePermissionsGet_579499, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_579535 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsUpdate_579537(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsUpdate_579536(path: JsonNode; query: JsonNode;
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
  var valid_579538 = path.getOrDefault("fileId")
  valid_579538 = validateParameter(valid_579538, JString, required = true,
                                 default = nil)
  if valid_579538 != nil:
    section.add "fileId", valid_579538
  var valid_579539 = path.getOrDefault("permissionId")
  valid_579539 = validateParameter(valid_579539, JString, required = true,
                                 default = nil)
  if valid_579539 != nil:
    section.add "permissionId", valid_579539
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: JBool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579540 = query.getOrDefault("key")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "key", valid_579540
  var valid_579541 = query.getOrDefault("prettyPrint")
  valid_579541 = validateParameter(valid_579541, JBool, required = false,
                                 default = newJBool(true))
  if valid_579541 != nil:
    section.add "prettyPrint", valid_579541
  var valid_579542 = query.getOrDefault("oauth_token")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "oauth_token", valid_579542
  var valid_579543 = query.getOrDefault("useDomainAdminAccess")
  valid_579543 = validateParameter(valid_579543, JBool, required = false,
                                 default = newJBool(false))
  if valid_579543 != nil:
    section.add "useDomainAdminAccess", valid_579543
  var valid_579544 = query.getOrDefault("removeExpiration")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(false))
  if valid_579544 != nil:
    section.add "removeExpiration", valid_579544
  var valid_579545 = query.getOrDefault("alt")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = newJString("json"))
  if valid_579545 != nil:
    section.add "alt", valid_579545
  var valid_579546 = query.getOrDefault("userIp")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "userIp", valid_579546
  var valid_579547 = query.getOrDefault("quotaUser")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "quotaUser", valid_579547
  var valid_579548 = query.getOrDefault("supportsTeamDrives")
  valid_579548 = validateParameter(valid_579548, JBool, required = false,
                                 default = newJBool(false))
  if valid_579548 != nil:
    section.add "supportsTeamDrives", valid_579548
  var valid_579549 = query.getOrDefault("transferOwnership")
  valid_579549 = validateParameter(valid_579549, JBool, required = false,
                                 default = newJBool(false))
  if valid_579549 != nil:
    section.add "transferOwnership", valid_579549
  var valid_579550 = query.getOrDefault("supportsAllDrives")
  valid_579550 = validateParameter(valid_579550, JBool, required = false,
                                 default = newJBool(false))
  if valid_579550 != nil:
    section.add "supportsAllDrives", valid_579550
  var valid_579551 = query.getOrDefault("fields")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "fields", valid_579551
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

proc call*(call_579553: Call_DrivePermissionsUpdate_579535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission with patch semantics.
  ## 
  let valid = call_579553.validator(path, query, header, formData, body)
  let scheme = call_579553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579553.url(scheme.get, call_579553.host, call_579553.base,
                         call_579553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579553, url, valid)

proc call*(call_579554: Call_DrivePermissionsUpdate_579535; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          removeExpiration: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          transferOwnership: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePermissionsUpdate
  ## Updates a permission with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: bool
  ##                    : Whether to transfer ownership to the specified user and downgrade the current owner to a writer. This parameter is required as an acknowledgement of the side effect.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  var path_579555 = newJObject()
  var query_579556 = newJObject()
  var body_579557 = newJObject()
  add(query_579556, "key", newJString(key))
  add(query_579556, "prettyPrint", newJBool(prettyPrint))
  add(query_579556, "oauth_token", newJString(oauthToken))
  add(query_579556, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579556, "removeExpiration", newJBool(removeExpiration))
  add(query_579556, "alt", newJString(alt))
  add(query_579556, "userIp", newJString(userIp))
  add(query_579556, "quotaUser", newJString(quotaUser))
  add(path_579555, "fileId", newJString(fileId))
  add(query_579556, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579556, "transferOwnership", newJBool(transferOwnership))
  add(query_579556, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579557 = body
  add(query_579556, "fields", newJString(fields))
  add(path_579555, "permissionId", newJString(permissionId))
  result = call_579554.call(path_579555, query_579556, nil, nil, body_579557)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_579535(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_579536, base: "/drive/v3",
    url: url_DrivePermissionsUpdate_579537, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_579516 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsDelete_579518(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsDelete_579517(path: JsonNode; query: JsonNode;
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
  var valid_579519 = path.getOrDefault("fileId")
  valid_579519 = validateParameter(valid_579519, JString, required = true,
                                 default = nil)
  if valid_579519 != nil:
    section.add "fileId", valid_579519
  var valid_579520 = path.getOrDefault("permissionId")
  valid_579520 = validateParameter(valid_579520, JString, required = true,
                                 default = nil)
  if valid_579520 != nil:
    section.add "permissionId", valid_579520
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579521 = query.getOrDefault("key")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "key", valid_579521
  var valid_579522 = query.getOrDefault("prettyPrint")
  valid_579522 = validateParameter(valid_579522, JBool, required = false,
                                 default = newJBool(true))
  if valid_579522 != nil:
    section.add "prettyPrint", valid_579522
  var valid_579523 = query.getOrDefault("oauth_token")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "oauth_token", valid_579523
  var valid_579524 = query.getOrDefault("useDomainAdminAccess")
  valid_579524 = validateParameter(valid_579524, JBool, required = false,
                                 default = newJBool(false))
  if valid_579524 != nil:
    section.add "useDomainAdminAccess", valid_579524
  var valid_579525 = query.getOrDefault("alt")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = newJString("json"))
  if valid_579525 != nil:
    section.add "alt", valid_579525
  var valid_579526 = query.getOrDefault("userIp")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "userIp", valid_579526
  var valid_579527 = query.getOrDefault("quotaUser")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "quotaUser", valid_579527
  var valid_579528 = query.getOrDefault("supportsTeamDrives")
  valid_579528 = validateParameter(valid_579528, JBool, required = false,
                                 default = newJBool(false))
  if valid_579528 != nil:
    section.add "supportsTeamDrives", valid_579528
  var valid_579529 = query.getOrDefault("supportsAllDrives")
  valid_579529 = validateParameter(valid_579529, JBool, required = false,
                                 default = newJBool(false))
  if valid_579529 != nil:
    section.add "supportsAllDrives", valid_579529
  var valid_579530 = query.getOrDefault("fields")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "fields", valid_579530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579531: Call_DrivePermissionsDelete_579516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission.
  ## 
  let valid = call_579531.validator(path, query, header, formData, body)
  let scheme = call_579531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579531.url(scheme.get, call_579531.host, call_579531.base,
                         call_579531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579531, url, valid)

proc call*(call_579532: Call_DrivePermissionsDelete_579516; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## drivePermissionsDelete
  ## Deletes a permission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  var path_579533 = newJObject()
  var query_579534 = newJObject()
  add(query_579534, "key", newJString(key))
  add(query_579534, "prettyPrint", newJBool(prettyPrint))
  add(query_579534, "oauth_token", newJString(oauthToken))
  add(query_579534, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579534, "alt", newJString(alt))
  add(query_579534, "userIp", newJString(userIp))
  add(query_579534, "quotaUser", newJString(quotaUser))
  add(path_579533, "fileId", newJString(fileId))
  add(query_579534, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579534, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579534, "fields", newJString(fields))
  add(path_579533, "permissionId", newJString(permissionId))
  result = call_579532.call(path_579533, query_579534, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_579516(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_579517, base: "/drive/v3",
    url: url_DrivePermissionsDelete_579518, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_579558 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsList_579560(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsList_579559(path: JsonNode; query: JsonNode;
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
  var valid_579561 = path.getOrDefault("fileId")
  valid_579561 = validateParameter(valid_579561, JString, required = true,
                                 default = nil)
  if valid_579561 != nil:
    section.add "fileId", valid_579561
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of revisions to return per page.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579562 = query.getOrDefault("key")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "key", valid_579562
  var valid_579563 = query.getOrDefault("prettyPrint")
  valid_579563 = validateParameter(valid_579563, JBool, required = false,
                                 default = newJBool(true))
  if valid_579563 != nil:
    section.add "prettyPrint", valid_579563
  var valid_579564 = query.getOrDefault("oauth_token")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "oauth_token", valid_579564
  var valid_579565 = query.getOrDefault("pageSize")
  valid_579565 = validateParameter(valid_579565, JInt, required = false,
                                 default = newJInt(200))
  if valid_579565 != nil:
    section.add "pageSize", valid_579565
  var valid_579566 = query.getOrDefault("alt")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = newJString("json"))
  if valid_579566 != nil:
    section.add "alt", valid_579566
  var valid_579567 = query.getOrDefault("userIp")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "userIp", valid_579567
  var valid_579568 = query.getOrDefault("quotaUser")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "quotaUser", valid_579568
  var valid_579569 = query.getOrDefault("pageToken")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "pageToken", valid_579569
  var valid_579570 = query.getOrDefault("fields")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "fields", valid_579570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579571: Call_DriveRevisionsList_579558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_579571.validator(path, query, header, formData, body)
  let scheme = call_579571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579571.url(scheme.get, call_579571.host, call_579571.base,
                         call_579571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579571, url, valid)

proc call*(call_579572: Call_DriveRevisionsList_579558; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          pageSize: int = 200; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = ""): Recallable =
  ## driveRevisionsList
  ## Lists a file's revisions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   pageSize: int
  ##           : The maximum number of revisions to return per page.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579573 = newJObject()
  var query_579574 = newJObject()
  add(query_579574, "key", newJString(key))
  add(query_579574, "prettyPrint", newJBool(prettyPrint))
  add(query_579574, "oauth_token", newJString(oauthToken))
  add(query_579574, "pageSize", newJInt(pageSize))
  add(query_579574, "alt", newJString(alt))
  add(query_579574, "userIp", newJString(userIp))
  add(query_579574, "quotaUser", newJString(quotaUser))
  add(path_579573, "fileId", newJString(fileId))
  add(query_579574, "pageToken", newJString(pageToken))
  add(query_579574, "fields", newJString(fields))
  result = call_579572.call(path_579573, query_579574, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_579558(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_579559, base: "/drive/v3",
    url: url_DriveRevisionsList_579560, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_579575 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsGet_579577(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsGet_579576(path: JsonNode; query: JsonNode;
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
  var valid_579578 = path.getOrDefault("fileId")
  valid_579578 = validateParameter(valid_579578, JString, required = true,
                                 default = nil)
  if valid_579578 != nil:
    section.add "fileId", valid_579578
  var valid_579579 = path.getOrDefault("revisionId")
  valid_579579 = validateParameter(valid_579579, JString, required = true,
                                 default = nil)
  if valid_579579 != nil:
    section.add "revisionId", valid_579579
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579580 = query.getOrDefault("key")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "key", valid_579580
  var valid_579581 = query.getOrDefault("prettyPrint")
  valid_579581 = validateParameter(valid_579581, JBool, required = false,
                                 default = newJBool(true))
  if valid_579581 != nil:
    section.add "prettyPrint", valid_579581
  var valid_579582 = query.getOrDefault("oauth_token")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "oauth_token", valid_579582
  var valid_579583 = query.getOrDefault("alt")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = newJString("json"))
  if valid_579583 != nil:
    section.add "alt", valid_579583
  var valid_579584 = query.getOrDefault("userIp")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "userIp", valid_579584
  var valid_579585 = query.getOrDefault("quotaUser")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "quotaUser", valid_579585
  var valid_579586 = query.getOrDefault("acknowledgeAbuse")
  valid_579586 = validateParameter(valid_579586, JBool, required = false,
                                 default = newJBool(false))
  if valid_579586 != nil:
    section.add "acknowledgeAbuse", valid_579586
  var valid_579587 = query.getOrDefault("fields")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "fields", valid_579587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579588: Call_DriveRevisionsGet_579575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a revision's metadata or content by ID.
  ## 
  let valid = call_579588.validator(path, query, header, formData, body)
  let scheme = call_579588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579588.url(scheme.get, call_579588.host, call_579588.base,
                         call_579588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579588, url, valid)

proc call*(call_579589: Call_DriveRevisionsGet_579575; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; acknowledgeAbuse: bool = false; fields: string = ""): Recallable =
  ## driveRevisionsGet
  ## Gets a revision's metadata or content by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579590 = newJObject()
  var query_579591 = newJObject()
  add(query_579591, "key", newJString(key))
  add(query_579591, "prettyPrint", newJBool(prettyPrint))
  add(query_579591, "oauth_token", newJString(oauthToken))
  add(query_579591, "alt", newJString(alt))
  add(query_579591, "userIp", newJString(userIp))
  add(query_579591, "quotaUser", newJString(quotaUser))
  add(path_579590, "fileId", newJString(fileId))
  add(query_579591, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(path_579590, "revisionId", newJString(revisionId))
  add(query_579591, "fields", newJString(fields))
  result = call_579589.call(path_579590, query_579591, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_579575(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_579576, base: "/drive/v3",
    url: url_DriveRevisionsGet_579577, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_579608 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsUpdate_579610(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsUpdate_579609(path: JsonNode; query: JsonNode;
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
  var valid_579611 = path.getOrDefault("fileId")
  valid_579611 = validateParameter(valid_579611, JString, required = true,
                                 default = nil)
  if valid_579611 != nil:
    section.add "fileId", valid_579611
  var valid_579612 = path.getOrDefault("revisionId")
  valid_579612 = validateParameter(valid_579612, JString, required = true,
                                 default = nil)
  if valid_579612 != nil:
    section.add "revisionId", valid_579612
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579613 = query.getOrDefault("key")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "key", valid_579613
  var valid_579614 = query.getOrDefault("prettyPrint")
  valid_579614 = validateParameter(valid_579614, JBool, required = false,
                                 default = newJBool(true))
  if valid_579614 != nil:
    section.add "prettyPrint", valid_579614
  var valid_579615 = query.getOrDefault("oauth_token")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "oauth_token", valid_579615
  var valid_579616 = query.getOrDefault("alt")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = newJString("json"))
  if valid_579616 != nil:
    section.add "alt", valid_579616
  var valid_579617 = query.getOrDefault("userIp")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "userIp", valid_579617
  var valid_579618 = query.getOrDefault("quotaUser")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "quotaUser", valid_579618
  var valid_579619 = query.getOrDefault("fields")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "fields", valid_579619
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

proc call*(call_579621: Call_DriveRevisionsUpdate_579608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision with patch semantics.
  ## 
  let valid = call_579621.validator(path, query, header, formData, body)
  let scheme = call_579621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579621.url(scheme.get, call_579621.host, call_579621.base,
                         call_579621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579621, url, valid)

proc call*(call_579622: Call_DriveRevisionsUpdate_579608; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRevisionsUpdate
  ## Updates a revision with patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   body: JObject
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579623 = newJObject()
  var query_579624 = newJObject()
  var body_579625 = newJObject()
  add(query_579624, "key", newJString(key))
  add(query_579624, "prettyPrint", newJBool(prettyPrint))
  add(query_579624, "oauth_token", newJString(oauthToken))
  add(query_579624, "alt", newJString(alt))
  add(query_579624, "userIp", newJString(userIp))
  add(query_579624, "quotaUser", newJString(quotaUser))
  add(path_579623, "fileId", newJString(fileId))
  if body != nil:
    body_579625 = body
  add(path_579623, "revisionId", newJString(revisionId))
  add(query_579624, "fields", newJString(fields))
  result = call_579622.call(path_579623, query_579624, nil, nil, body_579625)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_579608(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_579609, base: "/drive/v3",
    url: url_DriveRevisionsUpdate_579610, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_579592 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsDelete_579594(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsDelete_579593(path: JsonNode; query: JsonNode;
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
  var valid_579595 = path.getOrDefault("fileId")
  valid_579595 = validateParameter(valid_579595, JString, required = true,
                                 default = nil)
  if valid_579595 != nil:
    section.add "fileId", valid_579595
  var valid_579596 = path.getOrDefault("revisionId")
  valid_579596 = validateParameter(valid_579596, JString, required = true,
                                 default = nil)
  if valid_579596 != nil:
    section.add "revisionId", valid_579596
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579597 = query.getOrDefault("key")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "key", valid_579597
  var valid_579598 = query.getOrDefault("prettyPrint")
  valid_579598 = validateParameter(valid_579598, JBool, required = false,
                                 default = newJBool(true))
  if valid_579598 != nil:
    section.add "prettyPrint", valid_579598
  var valid_579599 = query.getOrDefault("oauth_token")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "oauth_token", valid_579599
  var valid_579600 = query.getOrDefault("alt")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = newJString("json"))
  if valid_579600 != nil:
    section.add "alt", valid_579600
  var valid_579601 = query.getOrDefault("userIp")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "userIp", valid_579601
  var valid_579602 = query.getOrDefault("quotaUser")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "quotaUser", valid_579602
  var valid_579603 = query.getOrDefault("fields")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "fields", valid_579603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579604: Call_DriveRevisionsDelete_579592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_579604.validator(path, query, header, formData, body)
  let scheme = call_579604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579604.url(scheme.get, call_579604.host, call_579604.base,
                         call_579604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579604, url, valid)

proc call*(call_579605: Call_DriveRevisionsDelete_579592; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRevisionsDelete
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579606 = newJObject()
  var query_579607 = newJObject()
  add(query_579607, "key", newJString(key))
  add(query_579607, "prettyPrint", newJBool(prettyPrint))
  add(query_579607, "oauth_token", newJString(oauthToken))
  add(query_579607, "alt", newJString(alt))
  add(query_579607, "userIp", newJString(userIp))
  add(query_579607, "quotaUser", newJString(quotaUser))
  add(path_579606, "fileId", newJString(fileId))
  add(path_579606, "revisionId", newJString(revisionId))
  add(query_579607, "fields", newJString(fields))
  result = call_579605.call(path_579606, query_579607, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_579592(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_579593, base: "/drive/v3",
    url: url_DriveRevisionsDelete_579594, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_579626 = ref object of OpenApiRestCall_578355
proc url_DriveFilesWatch_579628(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesWatch_579627(path: JsonNode; query: JsonNode;
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
  var valid_579629 = path.getOrDefault("fileId")
  valid_579629 = validateParameter(valid_579629, JString, required = true,
                                 default = nil)
  if valid_579629 != nil:
    section.add "fileId", valid_579629
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579630 = query.getOrDefault("key")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "key", valid_579630
  var valid_579631 = query.getOrDefault("prettyPrint")
  valid_579631 = validateParameter(valid_579631, JBool, required = false,
                                 default = newJBool(true))
  if valid_579631 != nil:
    section.add "prettyPrint", valid_579631
  var valid_579632 = query.getOrDefault("oauth_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "oauth_token", valid_579632
  var valid_579633 = query.getOrDefault("alt")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = newJString("json"))
  if valid_579633 != nil:
    section.add "alt", valid_579633
  var valid_579634 = query.getOrDefault("userIp")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "userIp", valid_579634
  var valid_579635 = query.getOrDefault("quotaUser")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "quotaUser", valid_579635
  var valid_579636 = query.getOrDefault("supportsTeamDrives")
  valid_579636 = validateParameter(valid_579636, JBool, required = false,
                                 default = newJBool(false))
  if valid_579636 != nil:
    section.add "supportsTeamDrives", valid_579636
  var valid_579637 = query.getOrDefault("acknowledgeAbuse")
  valid_579637 = validateParameter(valid_579637, JBool, required = false,
                                 default = newJBool(false))
  if valid_579637 != nil:
    section.add "acknowledgeAbuse", valid_579637
  var valid_579638 = query.getOrDefault("supportsAllDrives")
  valid_579638 = validateParameter(valid_579638, JBool, required = false,
                                 default = newJBool(false))
  if valid_579638 != nil:
    section.add "supportsAllDrives", valid_579638
  var valid_579639 = query.getOrDefault("fields")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "fields", valid_579639
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

proc call*(call_579641: Call_DriveFilesWatch_579626; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes to a file
  ## 
  let valid = call_579641.validator(path, query, header, formData, body)
  let scheme = call_579641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579641.url(scheme.get, call_579641.host, call_579641.base,
                         call_579641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579641, url, valid)

proc call*(call_579642: Call_DriveFilesWatch_579626; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; acknowledgeAbuse: bool = false;
          supportsAllDrives: bool = false; resource: JsonNode = nil; fields: string = ""): Recallable =
  ## driveFilesWatch
  ## Subscribes to changes to a file
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files. This is only applicable when alt=media.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579643 = newJObject()
  var query_579644 = newJObject()
  var body_579645 = newJObject()
  add(query_579644, "key", newJString(key))
  add(query_579644, "prettyPrint", newJBool(prettyPrint))
  add(query_579644, "oauth_token", newJString(oauthToken))
  add(query_579644, "alt", newJString(alt))
  add(query_579644, "userIp", newJString(userIp))
  add(query_579644, "quotaUser", newJString(quotaUser))
  add(path_579643, "fileId", newJString(fileId))
  add(query_579644, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579644, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_579644, "supportsAllDrives", newJBool(supportsAllDrives))
  if resource != nil:
    body_579645 = resource
  add(query_579644, "fields", newJString(fields))
  result = call_579642.call(path_579643, query_579644, nil, nil, body_579645)

var driveFilesWatch* = Call_DriveFilesWatch_579626(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_579627,
    base: "/drive/v3", url: url_DriveFilesWatch_579628, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesCreate_579663 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesCreate_579665(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesCreate_579664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.create instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579666 = query.getOrDefault("key")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "key", valid_579666
  var valid_579667 = query.getOrDefault("prettyPrint")
  valid_579667 = validateParameter(valid_579667, JBool, required = false,
                                 default = newJBool(true))
  if valid_579667 != nil:
    section.add "prettyPrint", valid_579667
  var valid_579668 = query.getOrDefault("oauth_token")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "oauth_token", valid_579668
  var valid_579669 = query.getOrDefault("alt")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = newJString("json"))
  if valid_579669 != nil:
    section.add "alt", valid_579669
  var valid_579670 = query.getOrDefault("userIp")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "userIp", valid_579670
  var valid_579671 = query.getOrDefault("quotaUser")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "quotaUser", valid_579671
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_579672 = query.getOrDefault("requestId")
  valid_579672 = validateParameter(valid_579672, JString, required = true,
                                 default = nil)
  if valid_579672 != nil:
    section.add "requestId", valid_579672
  var valid_579673 = query.getOrDefault("fields")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "fields", valid_579673
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

proc call*(call_579675: Call_DriveTeamdrivesCreate_579663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.create instead.
  ## 
  let valid = call_579675.validator(path, query, header, formData, body)
  let scheme = call_579675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579675.url(scheme.get, call_579675.host, call_579675.base,
                         call_579675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579675, url, valid)

proc call*(call_579676: Call_DriveTeamdrivesCreate_579663; requestId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveTeamdrivesCreate
  ## Deprecated use drives.create instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579677 = newJObject()
  var body_579678 = newJObject()
  add(query_579677, "key", newJString(key))
  add(query_579677, "prettyPrint", newJBool(prettyPrint))
  add(query_579677, "oauth_token", newJString(oauthToken))
  add(query_579677, "alt", newJString(alt))
  add(query_579677, "userIp", newJString(userIp))
  add(query_579677, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579678 = body
  add(query_579677, "requestId", newJString(requestId))
  add(query_579677, "fields", newJString(fields))
  result = call_579676.call(nil, query_579677, nil, nil, body_579678)

var driveTeamdrivesCreate* = Call_DriveTeamdrivesCreate_579663(
    name: "driveTeamdrivesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesCreate_579664, base: "/drive/v3",
    url: url_DriveTeamdrivesCreate_579665, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_579646 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesList_579648(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_579647(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated use drives.list instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   q: JString
  ##    : Query string for searching Team Drives.
  ##   pageSize: JInt
  ##           : Maximum number of Team Drives to return.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token for Team Drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579649 = query.getOrDefault("key")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "key", valid_579649
  var valid_579650 = query.getOrDefault("prettyPrint")
  valid_579650 = validateParameter(valid_579650, JBool, required = false,
                                 default = newJBool(true))
  if valid_579650 != nil:
    section.add "prettyPrint", valid_579650
  var valid_579651 = query.getOrDefault("oauth_token")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "oauth_token", valid_579651
  var valid_579652 = query.getOrDefault("useDomainAdminAccess")
  valid_579652 = validateParameter(valid_579652, JBool, required = false,
                                 default = newJBool(false))
  if valid_579652 != nil:
    section.add "useDomainAdminAccess", valid_579652
  var valid_579653 = query.getOrDefault("q")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "q", valid_579653
  var valid_579654 = query.getOrDefault("pageSize")
  valid_579654 = validateParameter(valid_579654, JInt, required = false,
                                 default = newJInt(10))
  if valid_579654 != nil:
    section.add "pageSize", valid_579654
  var valid_579655 = query.getOrDefault("alt")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = newJString("json"))
  if valid_579655 != nil:
    section.add "alt", valid_579655
  var valid_579656 = query.getOrDefault("userIp")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = nil)
  if valid_579656 != nil:
    section.add "userIp", valid_579656
  var valid_579657 = query.getOrDefault("quotaUser")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "quotaUser", valid_579657
  var valid_579658 = query.getOrDefault("pageToken")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = nil)
  if valid_579658 != nil:
    section.add "pageToken", valid_579658
  var valid_579659 = query.getOrDefault("fields")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "fields", valid_579659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579660: Call_DriveTeamdrivesList_579646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_579660.validator(path, query, header, formData, body)
  let scheme = call_579660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579660.url(scheme.get, call_579660.host, call_579660.base,
                         call_579660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579660, url, valid)

proc call*(call_579661: Call_DriveTeamdrivesList_579646; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; q: string = ""; pageSize: int = 10;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## driveTeamdrivesList
  ## Deprecated use drives.list instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   q: string
  ##    : Query string for searching Team Drives.
  ##   pageSize: int
  ##           : Maximum number of Team Drives to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token for Team Drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579662 = newJObject()
  add(query_579662, "key", newJString(key))
  add(query_579662, "prettyPrint", newJBool(prettyPrint))
  add(query_579662, "oauth_token", newJString(oauthToken))
  add(query_579662, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579662, "q", newJString(q))
  add(query_579662, "pageSize", newJInt(pageSize))
  add(query_579662, "alt", newJString(alt))
  add(query_579662, "userIp", newJString(userIp))
  add(query_579662, "quotaUser", newJString(quotaUser))
  add(query_579662, "pageToken", newJString(pageToken))
  add(query_579662, "fields", newJString(fields))
  result = call_579661.call(nil, query_579662, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_579646(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_579647, base: "/drive/v3",
    url: url_DriveTeamdrivesList_579648, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_579679 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesGet_579681(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesGet_579680(path: JsonNode; query: JsonNode;
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
  var valid_579682 = path.getOrDefault("teamDriveId")
  valid_579682 = validateParameter(valid_579682, JString, required = true,
                                 default = nil)
  if valid_579682 != nil:
    section.add "teamDriveId", valid_579682
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579683 = query.getOrDefault("key")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "key", valid_579683
  var valid_579684 = query.getOrDefault("prettyPrint")
  valid_579684 = validateParameter(valid_579684, JBool, required = false,
                                 default = newJBool(true))
  if valid_579684 != nil:
    section.add "prettyPrint", valid_579684
  var valid_579685 = query.getOrDefault("oauth_token")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "oauth_token", valid_579685
  var valid_579686 = query.getOrDefault("useDomainAdminAccess")
  valid_579686 = validateParameter(valid_579686, JBool, required = false,
                                 default = newJBool(false))
  if valid_579686 != nil:
    section.add "useDomainAdminAccess", valid_579686
  var valid_579687 = query.getOrDefault("alt")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = newJString("json"))
  if valid_579687 != nil:
    section.add "alt", valid_579687
  var valid_579688 = query.getOrDefault("userIp")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "userIp", valid_579688
  var valid_579689 = query.getOrDefault("quotaUser")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "quotaUser", valid_579689
  var valid_579690 = query.getOrDefault("fields")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "fields", valid_579690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579691: Call_DriveTeamdrivesGet_579679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_579691.validator(path, query, header, formData, body)
  let scheme = call_579691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579691.url(scheme.get, call_579691.host, call_579691.base,
                         call_579691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579691, url, valid)

proc call*(call_579692: Call_DriveTeamdrivesGet_579679; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveTeamdrivesGet
  ## Deprecated use drives.get instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579693 = newJObject()
  var query_579694 = newJObject()
  add(query_579694, "key", newJString(key))
  add(path_579693, "teamDriveId", newJString(teamDriveId))
  add(query_579694, "prettyPrint", newJBool(prettyPrint))
  add(query_579694, "oauth_token", newJString(oauthToken))
  add(query_579694, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579694, "alt", newJString(alt))
  add(query_579694, "userIp", newJString(userIp))
  add(query_579694, "quotaUser", newJString(quotaUser))
  add(query_579694, "fields", newJString(fields))
  result = call_579692.call(path_579693, query_579694, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_579679(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_579680, base: "/drive/v3",
    url: url_DriveTeamdrivesGet_579681, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_579710 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesUpdate_579712(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesUpdate_579711(path: JsonNode; query: JsonNode;
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
  var valid_579713 = path.getOrDefault("teamDriveId")
  valid_579713 = validateParameter(valid_579713, JString, required = true,
                                 default = nil)
  if valid_579713 != nil:
    section.add "teamDriveId", valid_579713
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579714 = query.getOrDefault("key")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "key", valid_579714
  var valid_579715 = query.getOrDefault("prettyPrint")
  valid_579715 = validateParameter(valid_579715, JBool, required = false,
                                 default = newJBool(true))
  if valid_579715 != nil:
    section.add "prettyPrint", valid_579715
  var valid_579716 = query.getOrDefault("oauth_token")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "oauth_token", valid_579716
  var valid_579717 = query.getOrDefault("useDomainAdminAccess")
  valid_579717 = validateParameter(valid_579717, JBool, required = false,
                                 default = newJBool(false))
  if valid_579717 != nil:
    section.add "useDomainAdminAccess", valid_579717
  var valid_579718 = query.getOrDefault("alt")
  valid_579718 = validateParameter(valid_579718, JString, required = false,
                                 default = newJString("json"))
  if valid_579718 != nil:
    section.add "alt", valid_579718
  var valid_579719 = query.getOrDefault("userIp")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "userIp", valid_579719
  var valid_579720 = query.getOrDefault("quotaUser")
  valid_579720 = validateParameter(valid_579720, JString, required = false,
                                 default = nil)
  if valid_579720 != nil:
    section.add "quotaUser", valid_579720
  var valid_579721 = query.getOrDefault("fields")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "fields", valid_579721
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

proc call*(call_579723: Call_DriveTeamdrivesUpdate_579710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead
  ## 
  let valid = call_579723.validator(path, query, header, formData, body)
  let scheme = call_579723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579723.url(scheme.get, call_579723.host, call_579723.base,
                         call_579723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579723, url, valid)

proc call*(call_579724: Call_DriveTeamdrivesUpdate_579710; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveTeamdrivesUpdate
  ## Deprecated use drives.update instead
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579725 = newJObject()
  var query_579726 = newJObject()
  var body_579727 = newJObject()
  add(query_579726, "key", newJString(key))
  add(path_579725, "teamDriveId", newJString(teamDriveId))
  add(query_579726, "prettyPrint", newJBool(prettyPrint))
  add(query_579726, "oauth_token", newJString(oauthToken))
  add(query_579726, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579726, "alt", newJString(alt))
  add(query_579726, "userIp", newJString(userIp))
  add(query_579726, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579727 = body
  add(query_579726, "fields", newJString(fields))
  result = call_579724.call(path_579725, query_579726, nil, nil, body_579727)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_579710(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_579711, base: "/drive/v3",
    url: url_DriveTeamdrivesUpdate_579712, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_579695 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesDelete_579697(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesDelete_579696(path: JsonNode; query: JsonNode;
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
  var valid_579698 = path.getOrDefault("teamDriveId")
  valid_579698 = validateParameter(valid_579698, JString, required = true,
                                 default = nil)
  if valid_579698 != nil:
    section.add "teamDriveId", valid_579698
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579699 = query.getOrDefault("key")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "key", valid_579699
  var valid_579700 = query.getOrDefault("prettyPrint")
  valid_579700 = validateParameter(valid_579700, JBool, required = false,
                                 default = newJBool(true))
  if valid_579700 != nil:
    section.add "prettyPrint", valid_579700
  var valid_579701 = query.getOrDefault("oauth_token")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "oauth_token", valid_579701
  var valid_579702 = query.getOrDefault("alt")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = newJString("json"))
  if valid_579702 != nil:
    section.add "alt", valid_579702
  var valid_579703 = query.getOrDefault("userIp")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "userIp", valid_579703
  var valid_579704 = query.getOrDefault("quotaUser")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "quotaUser", valid_579704
  var valid_579705 = query.getOrDefault("fields")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "fields", valid_579705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579706: Call_DriveTeamdrivesDelete_579695; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_579706.validator(path, query, header, formData, body)
  let scheme = call_579706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579706.url(scheme.get, call_579706.host, call_579706.base,
                         call_579706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579706, url, valid)

proc call*(call_579707: Call_DriveTeamdrivesDelete_579695; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveTeamdrivesDelete
  ## Deprecated use drives.delete instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579708 = newJObject()
  var query_579709 = newJObject()
  add(query_579709, "key", newJString(key))
  add(path_579708, "teamDriveId", newJString(teamDriveId))
  add(query_579709, "prettyPrint", newJBool(prettyPrint))
  add(query_579709, "oauth_token", newJString(oauthToken))
  add(query_579709, "alt", newJString(alt))
  add(query_579709, "userIp", newJString(userIp))
  add(query_579709, "quotaUser", newJString(quotaUser))
  add(query_579709, "fields", newJString(fields))
  result = call_579707.call(path_579708, query_579709, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_579695(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_579696, base: "/drive/v3",
    url: url_DriveTeamdrivesDelete_579697, schemes: {Scheme.Https})
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
