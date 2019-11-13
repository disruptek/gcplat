
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
  Call_DriveAboutGet_579650 = ref object of OpenApiRestCall_579380
proc url_DriveAboutGet_579652(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveAboutGet_579651(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("alt")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("json"))
  if valid_579780 != nil:
    section.add "alt", valid_579780
  var valid_579781 = query.getOrDefault("userIp")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userIp", valid_579781
  var valid_579782 = query.getOrDefault("quotaUser")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "quotaUser", valid_579782
  var valid_579783 = query.getOrDefault("fields")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "fields", valid_579783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579806: Call_DriveAboutGet_579650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the user, the user's Drive, and system capabilities.
  ## 
  let valid = call_579806.validator(path, query, header, formData, body)
  let scheme = call_579806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579806.url(scheme.get, call_579806.host, call_579806.base,
                         call_579806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579806, url, valid)

proc call*(call_579877: Call_DriveAboutGet_579650; key: string = "";
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
  var query_579878 = newJObject()
  add(query_579878, "key", newJString(key))
  add(query_579878, "prettyPrint", newJBool(prettyPrint))
  add(query_579878, "oauth_token", newJString(oauthToken))
  add(query_579878, "alt", newJString(alt))
  add(query_579878, "userIp", newJString(userIp))
  add(query_579878, "quotaUser", newJString(quotaUser))
  add(query_579878, "fields", newJString(fields))
  result = call_579877.call(nil, query_579878, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_579650(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_579651, base: "/drive/v3",
    url: url_DriveAboutGet_579652, schemes: {Scheme.Https})
type
  Call_DriveChangesList_579918 = ref object of OpenApiRestCall_579380
proc url_DriveChangesList_579920(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveChangesList_579919(path: JsonNode; query: JsonNode;
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
  var valid_579921 = query.getOrDefault("key")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "key", valid_579921
  var valid_579922 = query.getOrDefault("prettyPrint")
  valid_579922 = validateParameter(valid_579922, JBool, required = false,
                                 default = newJBool(true))
  if valid_579922 != nil:
    section.add "prettyPrint", valid_579922
  var valid_579923 = query.getOrDefault("oauth_token")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "oauth_token", valid_579923
  var valid_579924 = query.getOrDefault("driveId")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "driveId", valid_579924
  var valid_579925 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579925 = validateParameter(valid_579925, JBool, required = false,
                                 default = newJBool(false))
  if valid_579925 != nil:
    section.add "includeItemsFromAllDrives", valid_579925
  var valid_579926 = query.getOrDefault("restrictToMyDrive")
  valid_579926 = validateParameter(valid_579926, JBool, required = false,
                                 default = newJBool(false))
  if valid_579926 != nil:
    section.add "restrictToMyDrive", valid_579926
  var valid_579927 = query.getOrDefault("spaces")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("drive"))
  if valid_579927 != nil:
    section.add "spaces", valid_579927
  var valid_579929 = query.getOrDefault("pageSize")
  valid_579929 = validateParameter(valid_579929, JInt, required = false,
                                 default = newJInt(100))
  if valid_579929 != nil:
    section.add "pageSize", valid_579929
  var valid_579930 = query.getOrDefault("alt")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("json"))
  if valid_579930 != nil:
    section.add "alt", valid_579930
  var valid_579931 = query.getOrDefault("userIp")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "userIp", valid_579931
  var valid_579932 = query.getOrDefault("quotaUser")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "quotaUser", valid_579932
  var valid_579933 = query.getOrDefault("includeCorpusRemovals")
  valid_579933 = validateParameter(valid_579933, JBool, required = false,
                                 default = newJBool(false))
  if valid_579933 != nil:
    section.add "includeCorpusRemovals", valid_579933
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_579934 = query.getOrDefault("pageToken")
  valid_579934 = validateParameter(valid_579934, JString, required = true,
                                 default = nil)
  if valid_579934 != nil:
    section.add "pageToken", valid_579934
  var valid_579935 = query.getOrDefault("supportsTeamDrives")
  valid_579935 = validateParameter(valid_579935, JBool, required = false,
                                 default = newJBool(false))
  if valid_579935 != nil:
    section.add "supportsTeamDrives", valid_579935
  var valid_579936 = query.getOrDefault("includeRemoved")
  valid_579936 = validateParameter(valid_579936, JBool, required = false,
                                 default = newJBool(true))
  if valid_579936 != nil:
    section.add "includeRemoved", valid_579936
  var valid_579937 = query.getOrDefault("supportsAllDrives")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(false))
  if valid_579937 != nil:
    section.add "supportsAllDrives", valid_579937
  var valid_579938 = query.getOrDefault("includeTeamDriveItems")
  valid_579938 = validateParameter(valid_579938, JBool, required = false,
                                 default = newJBool(false))
  if valid_579938 != nil:
    section.add "includeTeamDriveItems", valid_579938
  var valid_579939 = query.getOrDefault("fields")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "fields", valid_579939
  var valid_579940 = query.getOrDefault("teamDriveId")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "teamDriveId", valid_579940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579941: Call_DriveChangesList_579918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_579941.validator(path, query, header, formData, body)
  let scheme = call_579941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579941.url(scheme.get, call_579941.host, call_579941.base,
                         call_579941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579941, url, valid)

proc call*(call_579942: Call_DriveChangesList_579918; pageToken: string;
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
  var query_579943 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "driveId", newJString(driveId))
  add(query_579943, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579943, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_579943, "spaces", newJString(spaces))
  add(query_579943, "pageSize", newJInt(pageSize))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "userIp", newJString(userIp))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(query_579943, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_579943, "pageToken", newJString(pageToken))
  add(query_579943, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579943, "includeRemoved", newJBool(includeRemoved))
  add(query_579943, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579943, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "teamDriveId", newJString(teamDriveId))
  result = call_579942.call(nil, query_579943, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_579918(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_579919, base: "/drive/v3",
    url: url_DriveChangesList_579920, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_579944 = ref object of OpenApiRestCall_579380
proc url_DriveChangesGetStartPageToken_579946(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveChangesGetStartPageToken_579945(path: JsonNode; query: JsonNode;
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
  var valid_579947 = query.getOrDefault("key")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "key", valid_579947
  var valid_579948 = query.getOrDefault("prettyPrint")
  valid_579948 = validateParameter(valid_579948, JBool, required = false,
                                 default = newJBool(true))
  if valid_579948 != nil:
    section.add "prettyPrint", valid_579948
  var valid_579949 = query.getOrDefault("oauth_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "oauth_token", valid_579949
  var valid_579950 = query.getOrDefault("driveId")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "driveId", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("supportsTeamDrives")
  valid_579954 = validateParameter(valid_579954, JBool, required = false,
                                 default = newJBool(false))
  if valid_579954 != nil:
    section.add "supportsTeamDrives", valid_579954
  var valid_579955 = query.getOrDefault("supportsAllDrives")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(false))
  if valid_579955 != nil:
    section.add "supportsAllDrives", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("teamDriveId")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "teamDriveId", valid_579957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579958: Call_DriveChangesGetStartPageToken_579944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_DriveChangesGetStartPageToken_579944;
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
  var query_579960 = newJObject()
  add(query_579960, "key", newJString(key))
  add(query_579960, "prettyPrint", newJBool(prettyPrint))
  add(query_579960, "oauth_token", newJString(oauthToken))
  add(query_579960, "driveId", newJString(driveId))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "userIp", newJString(userIp))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(query_579960, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579960, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579960, "fields", newJString(fields))
  add(query_579960, "teamDriveId", newJString(teamDriveId))
  result = call_579959.call(nil, query_579960, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_579944(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_579945, base: "/drive/v3",
    url: url_DriveChangesGetStartPageToken_579946, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_579961 = ref object of OpenApiRestCall_579380
proc url_DriveChangesWatch_579963(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveChangesWatch_579962(path: JsonNode; query: JsonNode;
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
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("driveId")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "driveId", valid_579967
  var valid_579968 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(false))
  if valid_579968 != nil:
    section.add "includeItemsFromAllDrives", valid_579968
  var valid_579969 = query.getOrDefault("restrictToMyDrive")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(false))
  if valid_579969 != nil:
    section.add "restrictToMyDrive", valid_579969
  var valid_579970 = query.getOrDefault("spaces")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("drive"))
  if valid_579970 != nil:
    section.add "spaces", valid_579970
  var valid_579971 = query.getOrDefault("pageSize")
  valid_579971 = validateParameter(valid_579971, JInt, required = false,
                                 default = newJInt(100))
  if valid_579971 != nil:
    section.add "pageSize", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("userIp")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "userIp", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("includeCorpusRemovals")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(false))
  if valid_579975 != nil:
    section.add "includeCorpusRemovals", valid_579975
  assert query != nil,
        "query argument is necessary due to required `pageToken` field"
  var valid_579976 = query.getOrDefault("pageToken")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "pageToken", valid_579976
  var valid_579977 = query.getOrDefault("supportsTeamDrives")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(false))
  if valid_579977 != nil:
    section.add "supportsTeamDrives", valid_579977
  var valid_579978 = query.getOrDefault("includeRemoved")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "includeRemoved", valid_579978
  var valid_579979 = query.getOrDefault("supportsAllDrives")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(false))
  if valid_579979 != nil:
    section.add "supportsAllDrives", valid_579979
  var valid_579980 = query.getOrDefault("includeTeamDriveItems")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(false))
  if valid_579980 != nil:
    section.add "includeTeamDriveItems", valid_579980
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  var valid_579982 = query.getOrDefault("teamDriveId")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "teamDriveId", valid_579982
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

proc call*(call_579984: Call_DriveChangesWatch_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes for a user.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_DriveChangesWatch_579961; pageToken: string;
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
  var query_579986 = newJObject()
  var body_579987 = newJObject()
  add(query_579986, "key", newJString(key))
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "driveId", newJString(driveId))
  add(query_579986, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579986, "restrictToMyDrive", newJBool(restrictToMyDrive))
  add(query_579986, "spaces", newJString(spaces))
  add(query_579986, "pageSize", newJInt(pageSize))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "userIp", newJString(userIp))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_579986, "pageToken", newJString(pageToken))
  add(query_579986, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579986, "includeRemoved", newJBool(includeRemoved))
  add(query_579986, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579986, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  if resource != nil:
    body_579987 = resource
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "teamDriveId", newJString(teamDriveId))
  result = call_579985.call(nil, query_579986, nil, nil, body_579987)

var driveChangesWatch* = Call_DriveChangesWatch_579961(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_579962, base: "/drive/v3",
    url: url_DriveChangesWatch_579963, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_579988 = ref object of OpenApiRestCall_579380
proc url_DriveChannelsStop_579990(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveChannelsStop_579989(path: JsonNode; query: JsonNode;
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
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
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

proc call*(call_579999: Call_DriveChannelsStop_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_DriveChannelsStop_579988; key: string = "";
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
  var query_580001 = newJObject()
  var body_580002 = newJObject()
  add(query_580001, "key", newJString(key))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "userIp", newJString(userIp))
  add(query_580001, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580002 = resource
  add(query_580001, "fields", newJString(fields))
  result = call_580000.call(nil, query_580001, nil, nil, body_580002)

var driveChannelsStop* = Call_DriveChannelsStop_579988(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_579989, base: "/drive/v3",
    url: url_DriveChannelsStop_579990, schemes: {Scheme.Https})
type
  Call_DriveDrivesCreate_580020 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesCreate_580022(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveDrivesCreate_580021(path: JsonNode; query: JsonNode;
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
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580029 = query.getOrDefault("requestId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "requestId", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
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

proc call*(call_580032: Call_DriveDrivesCreate_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_DriveDrivesCreate_580020; requestId: string;
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
  var query_580034 = newJObject()
  var body_580035 = newJObject()
  add(query_580034, "key", newJString(key))
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "userIp", newJString(userIp))
  add(query_580034, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580035 = body
  add(query_580034, "requestId", newJString(requestId))
  add(query_580034, "fields", newJString(fields))
  result = call_580033.call(nil, query_580034, nil, nil, body_580035)

var driveDrivesCreate* = Call_DriveDrivesCreate_580020(name: "driveDrivesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesCreate_580021, base: "/drive/v3",
    url: url_DriveDrivesCreate_580022, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_580003 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesList_580005(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveDrivesList_580004(path: JsonNode; query: JsonNode;
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
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("useDomainAdminAccess")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(false))
  if valid_580009 != nil:
    section.add "useDomainAdminAccess", valid_580009
  var valid_580010 = query.getOrDefault("q")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "q", valid_580010
  var valid_580011 = query.getOrDefault("pageSize")
  valid_580011 = validateParameter(valid_580011, JInt, required = false,
                                 default = newJInt(10))
  if valid_580011 != nil:
    section.add "pageSize", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("userIp")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "userIp", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("pageToken")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "pageToken", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_DriveDrivesList_580003; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_DriveDrivesList_580003; key: string = "";
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
  var query_580019 = newJObject()
  add(query_580019, "key", newJString(key))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580019, "q", newJString(q))
  add(query_580019, "pageSize", newJInt(pageSize))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "pageToken", newJString(pageToken))
  add(query_580019, "fields", newJString(fields))
  result = call_580018.call(nil, query_580019, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_580003(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_580004, base: "/drive/v3",
    url: url_DriveDrivesList_580005, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_580036 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesGet_580038(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesGet_580037(path: JsonNode; query: JsonNode;
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
  var valid_580053 = path.getOrDefault("driveId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "driveId", valid_580053
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
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("useDomainAdminAccess")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(false))
  if valid_580057 != nil:
    section.add "useDomainAdminAccess", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("userIp")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "userIp", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580062: Call_DriveDrivesGet_580036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_DriveDrivesGet_580036; driveId: string;
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
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  add(query_580065, "key", newJString(key))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(path_580064, "driveId", newJString(driveId))
  add(query_580065, "fields", newJString(fields))
  result = call_580063.call(path_580064, query_580065, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_580036(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_580037,
    base: "/drive/v3", url: url_DriveDrivesGet_580038, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_580081 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesUpdate_580083(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_580082(path: JsonNode; query: JsonNode;
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
  var valid_580084 = path.getOrDefault("driveId")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "driveId", valid_580084
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
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  var valid_580088 = query.getOrDefault("useDomainAdminAccess")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(false))
  if valid_580088 != nil:
    section.add "useDomainAdminAccess", valid_580088
  var valid_580089 = query.getOrDefault("alt")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("json"))
  if valid_580089 != nil:
    section.add "alt", valid_580089
  var valid_580090 = query.getOrDefault("userIp")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "userIp", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
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

proc call*(call_580094: Call_DriveDrivesUpdate_580081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadate for a shared drive.
  ## 
  let valid = call_580094.validator(path, query, header, formData, body)
  let scheme = call_580094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580094.url(scheme.get, call_580094.host, call_580094.base,
                         call_580094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580094, url, valid)

proc call*(call_580095: Call_DriveDrivesUpdate_580081; driveId: string;
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
  var path_580096 = newJObject()
  var query_580097 = newJObject()
  var body_580098 = newJObject()
  add(query_580097, "key", newJString(key))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "userIp", newJString(userIp))
  add(query_580097, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580098 = body
  add(path_580096, "driveId", newJString(driveId))
  add(query_580097, "fields", newJString(fields))
  result = call_580095.call(path_580096, query_580097, nil, nil, body_580098)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_580081(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_580082,
    base: "/drive/v3", url: url_DriveDrivesUpdate_580083, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_580066 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesDelete_580068(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesDelete_580067(path: JsonNode; query: JsonNode;
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
  var valid_580069 = path.getOrDefault("driveId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "driveId", valid_580069
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
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("prettyPrint")
  valid_580071 = validateParameter(valid_580071, JBool, required = false,
                                 default = newJBool(true))
  if valid_580071 != nil:
    section.add "prettyPrint", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_DriveDrivesDelete_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_DriveDrivesDelete_580066; driveId: string;
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
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  add(query_580080, "key", newJString(key))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "userIp", newJString(userIp))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(path_580079, "driveId", newJString(driveId))
  add(query_580080, "fields", newJString(fields))
  result = call_580078.call(path_580079, query_580080, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_580066(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_580067,
    base: "/drive/v3", url: url_DriveDrivesDelete_580068, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_580099 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesHide_580101(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesHide_580100(path: JsonNode; query: JsonNode;
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
  var valid_580102 = path.getOrDefault("driveId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "driveId", valid_580102
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
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
  var valid_580107 = query.getOrDefault("userIp")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "userIp", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_DriveDrivesHide_580099; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_DriveDrivesHide_580099; driveId: string;
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
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  add(query_580113, "key", newJString(key))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "userIp", newJString(userIp))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(path_580112, "driveId", newJString(driveId))
  add(query_580113, "fields", newJString(fields))
  result = call_580111.call(path_580112, query_580113, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_580099(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_580100,
    base: "/drive/v3", url: url_DriveDrivesHide_580101, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_580114 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesUnhide_580116(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesUnhide_580115(path: JsonNode; query: JsonNode;
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
  var valid_580117 = path.getOrDefault("driveId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "driveId", valid_580117
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
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("userIp")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "userIp", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580125: Call_DriveDrivesUnhide_580114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_DriveDrivesUnhide_580114; driveId: string;
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
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  add(query_580128, "key", newJString(key))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "userIp", newJString(userIp))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(path_580127, "driveId", newJString(driveId))
  add(query_580128, "fields", newJString(fields))
  result = call_580126.call(path_580127, query_580128, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_580114(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_580115,
    base: "/drive/v3", url: url_DriveDrivesUnhide_580116, schemes: {Scheme.Https})
type
  Call_DriveFilesCreate_580155 = ref object of OpenApiRestCall_579380
proc url_DriveFilesCreate_580157(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveFilesCreate_580156(path: JsonNode; query: JsonNode;
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("useContentAsIndexableText")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(false))
  if valid_580159 != nil:
    section.add "useContentAsIndexableText", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("ignoreDefaultVisibility")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(false))
  if valid_580162 != nil:
    section.add "ignoreDefaultVisibility", valid_580162
  var valid_580163 = query.getOrDefault("ocrLanguage")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "ocrLanguage", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("userIp")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "userIp", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("supportsTeamDrives")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(false))
  if valid_580167 != nil:
    section.add "supportsTeamDrives", valid_580167
  var valid_580168 = query.getOrDefault("supportsAllDrives")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(false))
  if valid_580168 != nil:
    section.add "supportsAllDrives", valid_580168
  var valid_580169 = query.getOrDefault("keepRevisionForever")
  valid_580169 = validateParameter(valid_580169, JBool, required = false,
                                 default = newJBool(false))
  if valid_580169 != nil:
    section.add "keepRevisionForever", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
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

proc call*(call_580172: Call_DriveFilesCreate_580155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new file.
  ## 
  let valid = call_580172.validator(path, query, header, formData, body)
  let scheme = call_580172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580172.url(scheme.get, call_580172.host, call_580172.base,
                         call_580172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580172, url, valid)

proc call*(call_580173: Call_DriveFilesCreate_580155; key: string = "";
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580174 = newJObject()
  var body_580175 = newJObject()
  add(query_580174, "key", newJString(key))
  add(query_580174, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580174, "prettyPrint", newJBool(prettyPrint))
  add(query_580174, "oauth_token", newJString(oauthToken))
  add(query_580174, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_580174, "ocrLanguage", newJString(ocrLanguage))
  add(query_580174, "alt", newJString(alt))
  add(query_580174, "userIp", newJString(userIp))
  add(query_580174, "quotaUser", newJString(quotaUser))
  add(query_580174, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580174, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580174, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_580175 = body
  add(query_580174, "fields", newJString(fields))
  result = call_580173.call(nil, query_580174, nil, nil, body_580175)

var driveFilesCreate* = Call_DriveFilesCreate_580155(name: "driveFilesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesCreate_580156, base: "/drive/v3",
    url: url_DriveFilesCreate_580157, schemes: {Scheme.Https})
type
  Call_DriveFilesList_580129 = ref object of OpenApiRestCall_579380
proc url_DriveFilesList_580131(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveFilesList_580130(path: JsonNode; query: JsonNode;
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
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("driveId")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "driveId", valid_580135
  var valid_580136 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(false))
  if valid_580136 != nil:
    section.add "includeItemsFromAllDrives", valid_580136
  var valid_580137 = query.getOrDefault("q")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "q", valid_580137
  var valid_580138 = query.getOrDefault("spaces")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("drive"))
  if valid_580138 != nil:
    section.add "spaces", valid_580138
  var valid_580139 = query.getOrDefault("pageSize")
  valid_580139 = validateParameter(valid_580139, JInt, required = false,
                                 default = newJInt(100))
  if valid_580139 != nil:
    section.add "pageSize", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("userIp")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "userIp", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("orderBy")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "orderBy", valid_580143
  var valid_580144 = query.getOrDefault("pageToken")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "pageToken", valid_580144
  var valid_580145 = query.getOrDefault("supportsTeamDrives")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(false))
  if valid_580145 != nil:
    section.add "supportsTeamDrives", valid_580145
  var valid_580146 = query.getOrDefault("supportsAllDrives")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(false))
  if valid_580146 != nil:
    section.add "supportsAllDrives", valid_580146
  var valid_580147 = query.getOrDefault("corpus")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("domain"))
  if valid_580147 != nil:
    section.add "corpus", valid_580147
  var valid_580148 = query.getOrDefault("includeTeamDriveItems")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(false))
  if valid_580148 != nil:
    section.add "includeTeamDriveItems", valid_580148
  var valid_580149 = query.getOrDefault("corpora")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "corpora", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("teamDriveId")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "teamDriveId", valid_580151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580152: Call_DriveFilesList_580129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists or searches files.
  ## 
  let valid = call_580152.validator(path, query, header, formData, body)
  let scheme = call_580152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580152.url(scheme.get, call_580152.host, call_580152.base,
                         call_580152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580152, url, valid)

proc call*(call_580153: Call_DriveFilesList_580129; key: string = "";
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
  var query_580154 = newJObject()
  add(query_580154, "key", newJString(key))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "driveId", newJString(driveId))
  add(query_580154, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580154, "q", newJString(q))
  add(query_580154, "spaces", newJString(spaces))
  add(query_580154, "pageSize", newJInt(pageSize))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "userIp", newJString(userIp))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(query_580154, "orderBy", newJString(orderBy))
  add(query_580154, "pageToken", newJString(pageToken))
  add(query_580154, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580154, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580154, "corpus", newJString(corpus))
  add(query_580154, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580154, "corpora", newJString(corpora))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "teamDriveId", newJString(teamDriveId))
  result = call_580153.call(nil, query_580154, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_580129(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_580130, base: "/drive/v3",
    url: url_DriveFilesList_580131, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_580176 = ref object of OpenApiRestCall_579380
proc url_DriveFilesGenerateIds_580178(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveFilesGenerateIds_580177(path: JsonNode; query: JsonNode;
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
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("count")
  valid_580182 = validateParameter(valid_580182, JInt, required = false,
                                 default = newJInt(10))
  if valid_580182 != nil:
    section.add "count", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("userIp")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "userIp", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("space")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("drive"))
  if valid_580186 != nil:
    section.add "space", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580188: Call_DriveFilesGenerateIds_580176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in create or copy requests.
  ## 
  let valid = call_580188.validator(path, query, header, formData, body)
  let scheme = call_580188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580188.url(scheme.get, call_580188.host, call_580188.base,
                         call_580188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580188, url, valid)

proc call*(call_580189: Call_DriveFilesGenerateIds_580176; key: string = "";
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
  var query_580190 = newJObject()
  add(query_580190, "key", newJString(key))
  add(query_580190, "prettyPrint", newJBool(prettyPrint))
  add(query_580190, "oauth_token", newJString(oauthToken))
  add(query_580190, "count", newJInt(count))
  add(query_580190, "alt", newJString(alt))
  add(query_580190, "userIp", newJString(userIp))
  add(query_580190, "quotaUser", newJString(quotaUser))
  add(query_580190, "space", newJString(space))
  add(query_580190, "fields", newJString(fields))
  result = call_580189.call(nil, query_580190, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_580176(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_580177, base: "/drive/v3",
    url: url_DriveFilesGenerateIds_580178, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_580191 = ref object of OpenApiRestCall_579380
proc url_DriveFilesEmptyTrash_580193(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveFilesEmptyTrash_580192(path: JsonNode; query: JsonNode;
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
  var valid_580194 = query.getOrDefault("key")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "key", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
  var valid_580196 = query.getOrDefault("oauth_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "oauth_token", valid_580196
  var valid_580197 = query.getOrDefault("alt")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("json"))
  if valid_580197 != nil:
    section.add "alt", valid_580197
  var valid_580198 = query.getOrDefault("userIp")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "userIp", valid_580198
  var valid_580199 = query.getOrDefault("quotaUser")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "quotaUser", valid_580199
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580201: Call_DriveFilesEmptyTrash_580191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_DriveFilesEmptyTrash_580191; key: string = "";
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
  var query_580203 = newJObject()
  add(query_580203, "key", newJString(key))
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "userIp", newJString(userIp))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "fields", newJString(fields))
  result = call_580202.call(nil, query_580203, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_580191(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_580192, base: "/drive/v3",
    url: url_DriveFilesEmptyTrash_580193, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_580204 = ref object of OpenApiRestCall_579380
proc url_DriveFilesGet_580206(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesGet_580205(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580207 = path.getOrDefault("fileId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fileId", valid_580207
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
  var valid_580208 = query.getOrDefault("key")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "key", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
  var valid_580210 = query.getOrDefault("oauth_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "oauth_token", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("userIp")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "userIp", valid_580212
  var valid_580213 = query.getOrDefault("quotaUser")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "quotaUser", valid_580213
  var valid_580214 = query.getOrDefault("supportsTeamDrives")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(false))
  if valid_580214 != nil:
    section.add "supportsTeamDrives", valid_580214
  var valid_580215 = query.getOrDefault("acknowledgeAbuse")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(false))
  if valid_580215 != nil:
    section.add "acknowledgeAbuse", valid_580215
  var valid_580216 = query.getOrDefault("supportsAllDrives")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(false))
  if valid_580216 != nil:
    section.add "supportsAllDrives", valid_580216
  var valid_580217 = query.getOrDefault("fields")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "fields", valid_580217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580218: Call_DriveFilesGet_580204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata or content by ID.
  ## 
  let valid = call_580218.validator(path, query, header, formData, body)
  let scheme = call_580218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580218.url(scheme.get, call_580218.host, call_580218.base,
                         call_580218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580218, url, valid)

proc call*(call_580219: Call_DriveFilesGet_580204; fileId: string; key: string = "";
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
  var path_580220 = newJObject()
  var query_580221 = newJObject()
  add(query_580221, "key", newJString(key))
  add(query_580221, "prettyPrint", newJBool(prettyPrint))
  add(query_580221, "oauth_token", newJString(oauthToken))
  add(query_580221, "alt", newJString(alt))
  add(query_580221, "userIp", newJString(userIp))
  add(query_580221, "quotaUser", newJString(quotaUser))
  add(path_580220, "fileId", newJString(fileId))
  add(query_580221, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580221, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580221, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580221, "fields", newJString(fields))
  result = call_580219.call(path_580220, query_580221, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_580204(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_580205, base: "/drive/v3",
    url: url_DriveFilesGet_580206, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_580239 = ref object of OpenApiRestCall_579380
proc url_DriveFilesUpdate_580241(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesUpdate_580240(path: JsonNode; query: JsonNode;
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
  var valid_580242 = path.getOrDefault("fileId")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fileId", valid_580242
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   removeParents: JString
  ##                : A comma-separated list of parent IDs to remove.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("useContentAsIndexableText")
  valid_580244 = validateParameter(valid_580244, JBool, required = false,
                                 default = newJBool(false))
  if valid_580244 != nil:
    section.add "useContentAsIndexableText", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  var valid_580246 = query.getOrDefault("oauth_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "oauth_token", valid_580246
  var valid_580247 = query.getOrDefault("addParents")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "addParents", valid_580247
  var valid_580248 = query.getOrDefault("ocrLanguage")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "ocrLanguage", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("userIp")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userIp", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("supportsTeamDrives")
  valid_580252 = validateParameter(valid_580252, JBool, required = false,
                                 default = newJBool(false))
  if valid_580252 != nil:
    section.add "supportsTeamDrives", valid_580252
  var valid_580253 = query.getOrDefault("supportsAllDrives")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(false))
  if valid_580253 != nil:
    section.add "supportsAllDrives", valid_580253
  var valid_580254 = query.getOrDefault("keepRevisionForever")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(false))
  if valid_580254 != nil:
    section.add "keepRevisionForever", valid_580254
  var valid_580255 = query.getOrDefault("removeParents")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "removeParents", valid_580255
  var valid_580256 = query.getOrDefault("fields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "fields", valid_580256
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

proc call*(call_580258: Call_DriveFilesUpdate_580239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a file's metadata and/or content with patch semantics.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_DriveFilesUpdate_580239; fileId: string;
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   body: JObject
  ##   removeParents: string
  ##                : A comma-separated list of parent IDs to remove.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "key", newJString(key))
  add(query_580261, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "addParents", newJString(addParents))
  add(query_580261, "ocrLanguage", newJString(ocrLanguage))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "userIp", newJString(userIp))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(path_580260, "fileId", newJString(fileId))
  add(query_580261, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580261, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580261, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_580262 = body
  add(query_580261, "removeParents", newJString(removeParents))
  add(query_580261, "fields", newJString(fields))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var driveFilesUpdate* = Call_DriveFilesUpdate_580239(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesUpdate_580240,
    base: "/drive/v3", url: url_DriveFilesUpdate_580241, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_580222 = ref object of OpenApiRestCall_579380
proc url_DriveFilesDelete_580224(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesDelete_580223(path: JsonNode; query: JsonNode;
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
  var valid_580225 = path.getOrDefault("fileId")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fileId", valid_580225
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
  var valid_580226 = query.getOrDefault("key")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "key", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("alt")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("json"))
  if valid_580229 != nil:
    section.add "alt", valid_580229
  var valid_580230 = query.getOrDefault("userIp")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "userIp", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("supportsTeamDrives")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(false))
  if valid_580232 != nil:
    section.add "supportsTeamDrives", valid_580232
  var valid_580233 = query.getOrDefault("supportsAllDrives")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(false))
  if valid_580233 != nil:
    section.add "supportsAllDrives", valid_580233
  var valid_580234 = query.getOrDefault("fields")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "fields", valid_580234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580235: Call_DriveFilesDelete_580222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
  ## 
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_DriveFilesDelete_580222; fileId: string;
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
  var path_580237 = newJObject()
  var query_580238 = newJObject()
  add(query_580238, "key", newJString(key))
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "userIp", newJString(userIp))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(path_580237, "fileId", newJString(fileId))
  add(query_580238, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580238, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580238, "fields", newJString(fields))
  result = call_580236.call(path_580237, query_580238, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_580222(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_580223,
    base: "/drive/v3", url: url_DriveFilesDelete_580224, schemes: {Scheme.Https})
type
  Call_DriveCommentsCreate_580282 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsCreate_580284(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsCreate_580283(path: JsonNode; query: JsonNode;
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
  var valid_580285 = path.getOrDefault("fileId")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fileId", valid_580285
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
  var valid_580286 = query.getOrDefault("key")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "key", valid_580286
  var valid_580287 = query.getOrDefault("prettyPrint")
  valid_580287 = validateParameter(valid_580287, JBool, required = false,
                                 default = newJBool(true))
  if valid_580287 != nil:
    section.add "prettyPrint", valid_580287
  var valid_580288 = query.getOrDefault("oauth_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "oauth_token", valid_580288
  var valid_580289 = query.getOrDefault("alt")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("json"))
  if valid_580289 != nil:
    section.add "alt", valid_580289
  var valid_580290 = query.getOrDefault("userIp")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "userIp", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("fields")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "fields", valid_580292
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

proc call*(call_580294: Call_DriveCommentsCreate_580282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on a file.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_DriveCommentsCreate_580282; fileId: string;
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
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  var body_580298 = newJObject()
  add(query_580297, "key", newJString(key))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(query_580297, "alt", newJString(alt))
  add(query_580297, "userIp", newJString(userIp))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(path_580296, "fileId", newJString(fileId))
  if body != nil:
    body_580298 = body
  add(query_580297, "fields", newJString(fields))
  result = call_580295.call(path_580296, query_580297, nil, nil, body_580298)

var driveCommentsCreate* = Call_DriveCommentsCreate_580282(
    name: "driveCommentsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsCreate_580283, base: "/drive/v3",
    url: url_DriveCommentsCreate_580284, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_580263 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsList_580265(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsList_580264(path: JsonNode; query: JsonNode;
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
  var valid_580266 = path.getOrDefault("fileId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fileId", valid_580266
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
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("pageSize")
  valid_580270 = validateParameter(valid_580270, JInt, required = false,
                                 default = newJInt(20))
  if valid_580270 != nil:
    section.add "pageSize", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("userIp")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "userIp", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("pageToken")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "pageToken", valid_580274
  var valid_580275 = query.getOrDefault("includeDeleted")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(false))
  if valid_580275 != nil:
    section.add "includeDeleted", valid_580275
  var valid_580276 = query.getOrDefault("startModifiedTime")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "startModifiedTime", valid_580276
  var valid_580277 = query.getOrDefault("fields")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "fields", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_DriveCommentsList_580263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_DriveCommentsList_580263; fileId: string;
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
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  add(query_580281, "key", newJString(key))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "pageSize", newJInt(pageSize))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "userIp", newJString(userIp))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(path_580280, "fileId", newJString(fileId))
  add(query_580281, "pageToken", newJString(pageToken))
  add(query_580281, "includeDeleted", newJBool(includeDeleted))
  add(query_580281, "startModifiedTime", newJString(startModifiedTime))
  add(query_580281, "fields", newJString(fields))
  result = call_580279.call(path_580280, query_580281, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_580263(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_580264,
    base: "/drive/v3", url: url_DriveCommentsList_580265, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_580299 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsGet_580301(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsGet_580300(path: JsonNode; query: JsonNode;
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
  var valid_580302 = path.getOrDefault("fileId")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fileId", valid_580302
  var valid_580303 = path.getOrDefault("commentId")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "commentId", valid_580303
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
  var valid_580304 = query.getOrDefault("key")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "key", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  var valid_580306 = query.getOrDefault("oauth_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "oauth_token", valid_580306
  var valid_580307 = query.getOrDefault("alt")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("json"))
  if valid_580307 != nil:
    section.add "alt", valid_580307
  var valid_580308 = query.getOrDefault("userIp")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "userIp", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("includeDeleted")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(false))
  if valid_580310 != nil:
    section.add "includeDeleted", valid_580310
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580312: Call_DriveCommentsGet_580299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_DriveCommentsGet_580299; fileId: string;
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
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  add(query_580315, "key", newJString(key))
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "userIp", newJString(userIp))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(path_580314, "fileId", newJString(fileId))
  add(path_580314, "commentId", newJString(commentId))
  add(query_580315, "includeDeleted", newJBool(includeDeleted))
  add(query_580315, "fields", newJString(fields))
  result = call_580313.call(path_580314, query_580315, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_580299(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_580300, base: "/drive/v3",
    url: url_DriveCommentsGet_580301, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_580332 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsUpdate_580334(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsUpdate_580333(path: JsonNode; query: JsonNode;
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
  var valid_580335 = path.getOrDefault("fileId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "fileId", valid_580335
  var valid_580336 = path.getOrDefault("commentId")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "commentId", valid_580336
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
  var valid_580337 = query.getOrDefault("key")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "key", valid_580337
  var valid_580338 = query.getOrDefault("prettyPrint")
  valid_580338 = validateParameter(valid_580338, JBool, required = false,
                                 default = newJBool(true))
  if valid_580338 != nil:
    section.add "prettyPrint", valid_580338
  var valid_580339 = query.getOrDefault("oauth_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "oauth_token", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("userIp")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "userIp", valid_580341
  var valid_580342 = query.getOrDefault("quotaUser")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "quotaUser", valid_580342
  var valid_580343 = query.getOrDefault("fields")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "fields", valid_580343
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

proc call*(call_580345: Call_DriveCommentsUpdate_580332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a comment with patch semantics.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_DriveCommentsUpdate_580332; fileId: string;
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
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  var body_580349 = newJObject()
  add(query_580348, "key", newJString(key))
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "alt", newJString(alt))
  add(query_580348, "userIp", newJString(userIp))
  add(query_580348, "quotaUser", newJString(quotaUser))
  add(path_580347, "fileId", newJString(fileId))
  add(path_580347, "commentId", newJString(commentId))
  if body != nil:
    body_580349 = body
  add(query_580348, "fields", newJString(fields))
  result = call_580346.call(path_580347, query_580348, nil, nil, body_580349)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_580332(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_580333, base: "/drive/v3",
    url: url_DriveCommentsUpdate_580334, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_580316 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsDelete_580318(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsDelete_580317(path: JsonNode; query: JsonNode;
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
  var valid_580319 = path.getOrDefault("fileId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "fileId", valid_580319
  var valid_580320 = path.getOrDefault("commentId")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "commentId", valid_580320
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
  var valid_580321 = query.getOrDefault("key")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "key", valid_580321
  var valid_580322 = query.getOrDefault("prettyPrint")
  valid_580322 = validateParameter(valid_580322, JBool, required = false,
                                 default = newJBool(true))
  if valid_580322 != nil:
    section.add "prettyPrint", valid_580322
  var valid_580323 = query.getOrDefault("oauth_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "oauth_token", valid_580323
  var valid_580324 = query.getOrDefault("alt")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("json"))
  if valid_580324 != nil:
    section.add "alt", valid_580324
  var valid_580325 = query.getOrDefault("userIp")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "userIp", valid_580325
  var valid_580326 = query.getOrDefault("quotaUser")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "quotaUser", valid_580326
  var valid_580327 = query.getOrDefault("fields")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "fields", valid_580327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580328: Call_DriveCommentsDelete_580316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_DriveCommentsDelete_580316; fileId: string;
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
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  add(query_580331, "key", newJString(key))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "userIp", newJString(userIp))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(path_580330, "fileId", newJString(fileId))
  add(path_580330, "commentId", newJString(commentId))
  add(query_580331, "fields", newJString(fields))
  result = call_580329.call(path_580330, query_580331, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_580316(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_580317, base: "/drive/v3",
    url: url_DriveCommentsDelete_580318, schemes: {Scheme.Https})
type
  Call_DriveRepliesCreate_580369 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesCreate_580371(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesCreate_580370(path: JsonNode; query: JsonNode;
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
  var valid_580372 = path.getOrDefault("fileId")
  valid_580372 = validateParameter(valid_580372, JString, required = true,
                                 default = nil)
  if valid_580372 != nil:
    section.add "fileId", valid_580372
  var valid_580373 = path.getOrDefault("commentId")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "commentId", valid_580373
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
  var valid_580374 = query.getOrDefault("key")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "key", valid_580374
  var valid_580375 = query.getOrDefault("prettyPrint")
  valid_580375 = validateParameter(valid_580375, JBool, required = false,
                                 default = newJBool(true))
  if valid_580375 != nil:
    section.add "prettyPrint", valid_580375
  var valid_580376 = query.getOrDefault("oauth_token")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "oauth_token", valid_580376
  var valid_580377 = query.getOrDefault("alt")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = newJString("json"))
  if valid_580377 != nil:
    section.add "alt", valid_580377
  var valid_580378 = query.getOrDefault("userIp")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "userIp", valid_580378
  var valid_580379 = query.getOrDefault("quotaUser")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "quotaUser", valid_580379
  var valid_580380 = query.getOrDefault("fields")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "fields", valid_580380
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

proc call*(call_580382: Call_DriveRepliesCreate_580369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to a comment.
  ## 
  let valid = call_580382.validator(path, query, header, formData, body)
  let scheme = call_580382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580382.url(scheme.get, call_580382.host, call_580382.base,
                         call_580382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580382, url, valid)

proc call*(call_580383: Call_DriveRepliesCreate_580369; fileId: string;
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
  var path_580384 = newJObject()
  var query_580385 = newJObject()
  var body_580386 = newJObject()
  add(query_580385, "key", newJString(key))
  add(query_580385, "prettyPrint", newJBool(prettyPrint))
  add(query_580385, "oauth_token", newJString(oauthToken))
  add(query_580385, "alt", newJString(alt))
  add(query_580385, "userIp", newJString(userIp))
  add(query_580385, "quotaUser", newJString(quotaUser))
  add(path_580384, "fileId", newJString(fileId))
  add(path_580384, "commentId", newJString(commentId))
  if body != nil:
    body_580386 = body
  add(query_580385, "fields", newJString(fields))
  result = call_580383.call(path_580384, query_580385, nil, nil, body_580386)

var driveRepliesCreate* = Call_DriveRepliesCreate_580369(
    name: "driveRepliesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesCreate_580370, base: "/drive/v3",
    url: url_DriveRepliesCreate_580371, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_580350 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesList_580352(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesList_580351(path: JsonNode; query: JsonNode;
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
  var valid_580353 = path.getOrDefault("fileId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "fileId", valid_580353
  var valid_580354 = path.getOrDefault("commentId")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "commentId", valid_580354
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
  var valid_580355 = query.getOrDefault("key")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "key", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("pageSize")
  valid_580358 = validateParameter(valid_580358, JInt, required = false,
                                 default = newJInt(20))
  if valid_580358 != nil:
    section.add "pageSize", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("userIp")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "userIp", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("pageToken")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "pageToken", valid_580362
  var valid_580363 = query.getOrDefault("includeDeleted")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(false))
  if valid_580363 != nil:
    section.add "includeDeleted", valid_580363
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580365: Call_DriveRepliesList_580350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a comment's replies.
  ## 
  let valid = call_580365.validator(path, query, header, formData, body)
  let scheme = call_580365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580365.url(scheme.get, call_580365.host, call_580365.base,
                         call_580365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580365, url, valid)

proc call*(call_580366: Call_DriveRepliesList_580350; fileId: string;
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
  var path_580367 = newJObject()
  var query_580368 = newJObject()
  add(query_580368, "key", newJString(key))
  add(query_580368, "prettyPrint", newJBool(prettyPrint))
  add(query_580368, "oauth_token", newJString(oauthToken))
  add(query_580368, "pageSize", newJInt(pageSize))
  add(query_580368, "alt", newJString(alt))
  add(query_580368, "userIp", newJString(userIp))
  add(query_580368, "quotaUser", newJString(quotaUser))
  add(path_580367, "fileId", newJString(fileId))
  add(query_580368, "pageToken", newJString(pageToken))
  add(path_580367, "commentId", newJString(commentId))
  add(query_580368, "includeDeleted", newJBool(includeDeleted))
  add(query_580368, "fields", newJString(fields))
  result = call_580366.call(path_580367, query_580368, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_580350(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_580351, base: "/drive/v3",
    url: url_DriveRepliesList_580352, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_580387 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesGet_580389(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesGet_580388(path: JsonNode; query: JsonNode;
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
  var valid_580390 = path.getOrDefault("replyId")
  valid_580390 = validateParameter(valid_580390, JString, required = true,
                                 default = nil)
  if valid_580390 != nil:
    section.add "replyId", valid_580390
  var valid_580391 = path.getOrDefault("fileId")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "fileId", valid_580391
  var valid_580392 = path.getOrDefault("commentId")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "commentId", valid_580392
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
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("prettyPrint")
  valid_580394 = validateParameter(valid_580394, JBool, required = false,
                                 default = newJBool(true))
  if valid_580394 != nil:
    section.add "prettyPrint", valid_580394
  var valid_580395 = query.getOrDefault("oauth_token")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "oauth_token", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("userIp")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "userIp", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("includeDeleted")
  valid_580399 = validateParameter(valid_580399, JBool, required = false,
                                 default = newJBool(false))
  if valid_580399 != nil:
    section.add "includeDeleted", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580401: Call_DriveRepliesGet_580387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply by ID.
  ## 
  let valid = call_580401.validator(path, query, header, formData, body)
  let scheme = call_580401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580401.url(scheme.get, call_580401.host, call_580401.base,
                         call_580401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580401, url, valid)

proc call*(call_580402: Call_DriveRepliesGet_580387; replyId: string; fileId: string;
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
  var path_580403 = newJObject()
  var query_580404 = newJObject()
  add(query_580404, "key", newJString(key))
  add(query_580404, "prettyPrint", newJBool(prettyPrint))
  add(query_580404, "oauth_token", newJString(oauthToken))
  add(query_580404, "alt", newJString(alt))
  add(query_580404, "userIp", newJString(userIp))
  add(path_580403, "replyId", newJString(replyId))
  add(query_580404, "quotaUser", newJString(quotaUser))
  add(path_580403, "fileId", newJString(fileId))
  add(path_580403, "commentId", newJString(commentId))
  add(query_580404, "includeDeleted", newJBool(includeDeleted))
  add(query_580404, "fields", newJString(fields))
  result = call_580402.call(path_580403, query_580404, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_580387(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_580388, base: "/drive/v3",
    url: url_DriveRepliesGet_580389, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_580422 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesUpdate_580424(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesUpdate_580423(path: JsonNode; query: JsonNode;
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
  var valid_580425 = path.getOrDefault("replyId")
  valid_580425 = validateParameter(valid_580425, JString, required = true,
                                 default = nil)
  if valid_580425 != nil:
    section.add "replyId", valid_580425
  var valid_580426 = path.getOrDefault("fileId")
  valid_580426 = validateParameter(valid_580426, JString, required = true,
                                 default = nil)
  if valid_580426 != nil:
    section.add "fileId", valid_580426
  var valid_580427 = path.getOrDefault("commentId")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "commentId", valid_580427
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
  var valid_580428 = query.getOrDefault("key")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "key", valid_580428
  var valid_580429 = query.getOrDefault("prettyPrint")
  valid_580429 = validateParameter(valid_580429, JBool, required = false,
                                 default = newJBool(true))
  if valid_580429 != nil:
    section.add "prettyPrint", valid_580429
  var valid_580430 = query.getOrDefault("oauth_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "oauth_token", valid_580430
  var valid_580431 = query.getOrDefault("alt")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = newJString("json"))
  if valid_580431 != nil:
    section.add "alt", valid_580431
  var valid_580432 = query.getOrDefault("userIp")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "userIp", valid_580432
  var valid_580433 = query.getOrDefault("quotaUser")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "quotaUser", valid_580433
  var valid_580434 = query.getOrDefault("fields")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "fields", valid_580434
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

proc call*(call_580436: Call_DriveRepliesUpdate_580422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a reply with patch semantics.
  ## 
  let valid = call_580436.validator(path, query, header, formData, body)
  let scheme = call_580436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580436.url(scheme.get, call_580436.host, call_580436.base,
                         call_580436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580436, url, valid)

proc call*(call_580437: Call_DriveRepliesUpdate_580422; replyId: string;
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
  var path_580438 = newJObject()
  var query_580439 = newJObject()
  var body_580440 = newJObject()
  add(query_580439, "key", newJString(key))
  add(query_580439, "prettyPrint", newJBool(prettyPrint))
  add(query_580439, "oauth_token", newJString(oauthToken))
  add(query_580439, "alt", newJString(alt))
  add(query_580439, "userIp", newJString(userIp))
  add(path_580438, "replyId", newJString(replyId))
  add(query_580439, "quotaUser", newJString(quotaUser))
  add(path_580438, "fileId", newJString(fileId))
  add(path_580438, "commentId", newJString(commentId))
  if body != nil:
    body_580440 = body
  add(query_580439, "fields", newJString(fields))
  result = call_580437.call(path_580438, query_580439, nil, nil, body_580440)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_580422(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_580423, base: "/drive/v3",
    url: url_DriveRepliesUpdate_580424, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_580405 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesDelete_580407(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesDelete_580406(path: JsonNode; query: JsonNode;
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
  var valid_580408 = path.getOrDefault("replyId")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "replyId", valid_580408
  var valid_580409 = path.getOrDefault("fileId")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "fileId", valid_580409
  var valid_580410 = path.getOrDefault("commentId")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "commentId", valid_580410
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
  var valid_580411 = query.getOrDefault("key")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "key", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("alt")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = newJString("json"))
  if valid_580414 != nil:
    section.add "alt", valid_580414
  var valid_580415 = query.getOrDefault("userIp")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "userIp", valid_580415
  var valid_580416 = query.getOrDefault("quotaUser")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "quotaUser", valid_580416
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580418: Call_DriveRepliesDelete_580405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_580418.validator(path, query, header, formData, body)
  let scheme = call_580418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580418.url(scheme.get, call_580418.host, call_580418.base,
                         call_580418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580418, url, valid)

proc call*(call_580419: Call_DriveRepliesDelete_580405; replyId: string;
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
  var path_580420 = newJObject()
  var query_580421 = newJObject()
  add(query_580421, "key", newJString(key))
  add(query_580421, "prettyPrint", newJBool(prettyPrint))
  add(query_580421, "oauth_token", newJString(oauthToken))
  add(query_580421, "alt", newJString(alt))
  add(query_580421, "userIp", newJString(userIp))
  add(path_580420, "replyId", newJString(replyId))
  add(query_580421, "quotaUser", newJString(quotaUser))
  add(path_580420, "fileId", newJString(fileId))
  add(path_580420, "commentId", newJString(commentId))
  add(query_580421, "fields", newJString(fields))
  result = call_580419.call(path_580420, query_580421, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_580405(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_580406, base: "/drive/v3",
    url: url_DriveRepliesDelete_580407, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_580441 = ref object of OpenApiRestCall_579380
proc url_DriveFilesCopy_580443(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesCopy_580442(path: JsonNode; query: JsonNode;
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
  var valid_580444 = path.getOrDefault("fileId")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "fileId", valid_580444
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580445 = query.getOrDefault("key")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "key", valid_580445
  var valid_580446 = query.getOrDefault("prettyPrint")
  valid_580446 = validateParameter(valid_580446, JBool, required = false,
                                 default = newJBool(true))
  if valid_580446 != nil:
    section.add "prettyPrint", valid_580446
  var valid_580447 = query.getOrDefault("oauth_token")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "oauth_token", valid_580447
  var valid_580448 = query.getOrDefault("ignoreDefaultVisibility")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(false))
  if valid_580448 != nil:
    section.add "ignoreDefaultVisibility", valid_580448
  var valid_580449 = query.getOrDefault("ocrLanguage")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "ocrLanguage", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("userIp")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "userIp", valid_580451
  var valid_580452 = query.getOrDefault("quotaUser")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "quotaUser", valid_580452
  var valid_580453 = query.getOrDefault("supportsTeamDrives")
  valid_580453 = validateParameter(valid_580453, JBool, required = false,
                                 default = newJBool(false))
  if valid_580453 != nil:
    section.add "supportsTeamDrives", valid_580453
  var valid_580454 = query.getOrDefault("supportsAllDrives")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(false))
  if valid_580454 != nil:
    section.add "supportsAllDrives", valid_580454
  var valid_580455 = query.getOrDefault("keepRevisionForever")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(false))
  if valid_580455 != nil:
    section.add "keepRevisionForever", valid_580455
  var valid_580456 = query.getOrDefault("fields")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "fields", valid_580456
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

proc call*(call_580458: Call_DriveFilesCopy_580441; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of a file and applies any requested updates with patch semantics.
  ## 
  let valid = call_580458.validator(path, query, header, formData, body)
  let scheme = call_580458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580458.url(scheme.get, call_580458.host, call_580458.base,
                         call_580458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580458, url, valid)

proc call*(call_580459: Call_DriveFilesCopy_580441; fileId: string; key: string = "";
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
  ##                      : Whether to set the 'keepForever' field in the new head revision. This is only applicable to files with binary content in Google Drive. Only 200 revisions for the file can be kept forever. If the limit is reached, try deleting pinned revisions.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580460 = newJObject()
  var query_580461 = newJObject()
  var body_580462 = newJObject()
  add(query_580461, "key", newJString(key))
  add(query_580461, "prettyPrint", newJBool(prettyPrint))
  add(query_580461, "oauth_token", newJString(oauthToken))
  add(query_580461, "ignoreDefaultVisibility", newJBool(ignoreDefaultVisibility))
  add(query_580461, "ocrLanguage", newJString(ocrLanguage))
  add(query_580461, "alt", newJString(alt))
  add(query_580461, "userIp", newJString(userIp))
  add(query_580461, "quotaUser", newJString(quotaUser))
  add(path_580460, "fileId", newJString(fileId))
  add(query_580461, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580461, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580461, "keepRevisionForever", newJBool(keepRevisionForever))
  if body != nil:
    body_580462 = body
  add(query_580461, "fields", newJString(fields))
  result = call_580459.call(path_580460, query_580461, nil, nil, body_580462)

var driveFilesCopy* = Call_DriveFilesCopy_580441(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_580442,
    base: "/drive/v3", url: url_DriveFilesCopy_580443, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_580463 = ref object of OpenApiRestCall_579380
proc url_DriveFilesExport_580465(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesExport_580464(path: JsonNode; query: JsonNode;
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
  var valid_580466 = path.getOrDefault("fileId")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "fileId", valid_580466
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
  var valid_580467 = query.getOrDefault("key")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "key", valid_580467
  var valid_580468 = query.getOrDefault("prettyPrint")
  valid_580468 = validateParameter(valid_580468, JBool, required = false,
                                 default = newJBool(true))
  if valid_580468 != nil:
    section.add "prettyPrint", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("alt")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("json"))
  if valid_580470 != nil:
    section.add "alt", valid_580470
  var valid_580471 = query.getOrDefault("userIp")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "userIp", valid_580471
  var valid_580472 = query.getOrDefault("quotaUser")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "quotaUser", valid_580472
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_580473 = query.getOrDefault("mimeType")
  valid_580473 = validateParameter(valid_580473, JString, required = true,
                                 default = nil)
  if valid_580473 != nil:
    section.add "mimeType", valid_580473
  var valid_580474 = query.getOrDefault("fields")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "fields", valid_580474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580475: Call_DriveFilesExport_580463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_580475.validator(path, query, header, formData, body)
  let scheme = call_580475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580475.url(scheme.get, call_580475.host, call_580475.base,
                         call_580475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580475, url, valid)

proc call*(call_580476: Call_DriveFilesExport_580463; fileId: string;
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
  var path_580477 = newJObject()
  var query_580478 = newJObject()
  add(query_580478, "key", newJString(key))
  add(query_580478, "prettyPrint", newJBool(prettyPrint))
  add(query_580478, "oauth_token", newJString(oauthToken))
  add(query_580478, "alt", newJString(alt))
  add(query_580478, "userIp", newJString(userIp))
  add(query_580478, "quotaUser", newJString(quotaUser))
  add(path_580477, "fileId", newJString(fileId))
  add(query_580478, "mimeType", newJString(mimeType))
  add(query_580478, "fields", newJString(fields))
  result = call_580476.call(path_580477, query_580478, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_580463(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_580464,
    base: "/drive/v3", url: url_DriveFilesExport_580465, schemes: {Scheme.Https})
type
  Call_DrivePermissionsCreate_580499 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsCreate_580501(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsCreate_580500(path: JsonNode; query: JsonNode;
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
  var valid_580502 = path.getOrDefault("fileId")
  valid_580502 = validateParameter(valid_580502, JString, required = true,
                                 default = nil)
  if valid_580502 != nil:
    section.add "fileId", valid_580502
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
  var valid_580503 = query.getOrDefault("key")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "key", valid_580503
  var valid_580504 = query.getOrDefault("prettyPrint")
  valid_580504 = validateParameter(valid_580504, JBool, required = false,
                                 default = newJBool(true))
  if valid_580504 != nil:
    section.add "prettyPrint", valid_580504
  var valid_580505 = query.getOrDefault("oauth_token")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "oauth_token", valid_580505
  var valid_580506 = query.getOrDefault("useDomainAdminAccess")
  valid_580506 = validateParameter(valid_580506, JBool, required = false,
                                 default = newJBool(false))
  if valid_580506 != nil:
    section.add "useDomainAdminAccess", valid_580506
  var valid_580507 = query.getOrDefault("sendNotificationEmail")
  valid_580507 = validateParameter(valid_580507, JBool, required = false, default = nil)
  if valid_580507 != nil:
    section.add "sendNotificationEmail", valid_580507
  var valid_580508 = query.getOrDefault("alt")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = newJString("json"))
  if valid_580508 != nil:
    section.add "alt", valid_580508
  var valid_580509 = query.getOrDefault("userIp")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "userIp", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("supportsTeamDrives")
  valid_580511 = validateParameter(valid_580511, JBool, required = false,
                                 default = newJBool(false))
  if valid_580511 != nil:
    section.add "supportsTeamDrives", valid_580511
  var valid_580512 = query.getOrDefault("emailMessage")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "emailMessage", valid_580512
  var valid_580513 = query.getOrDefault("transferOwnership")
  valid_580513 = validateParameter(valid_580513, JBool, required = false,
                                 default = newJBool(false))
  if valid_580513 != nil:
    section.add "transferOwnership", valid_580513
  var valid_580514 = query.getOrDefault("supportsAllDrives")
  valid_580514 = validateParameter(valid_580514, JBool, required = false,
                                 default = newJBool(false))
  if valid_580514 != nil:
    section.add "supportsAllDrives", valid_580514
  var valid_580515 = query.getOrDefault("fields")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "fields", valid_580515
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

proc call*(call_580517: Call_DrivePermissionsCreate_580499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a permission for a file or shared drive.
  ## 
  let valid = call_580517.validator(path, query, header, formData, body)
  let scheme = call_580517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580517.url(scheme.get, call_580517.host, call_580517.base,
                         call_580517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580517, url, valid)

proc call*(call_580518: Call_DrivePermissionsCreate_580499; fileId: string;
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
  var path_580519 = newJObject()
  var query_580520 = newJObject()
  var body_580521 = newJObject()
  add(query_580520, "key", newJString(key))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580520, "sendNotificationEmail", newJBool(sendNotificationEmail))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(path_580519, "fileId", newJString(fileId))
  add(query_580520, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580520, "emailMessage", newJString(emailMessage))
  add(query_580520, "transferOwnership", newJBool(transferOwnership))
  add(query_580520, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580521 = body
  add(query_580520, "fields", newJString(fields))
  result = call_580518.call(path_580519, query_580520, nil, nil, body_580521)

var drivePermissionsCreate* = Call_DrivePermissionsCreate_580499(
    name: "drivePermissionsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsCreate_580500, base: "/drive/v3",
    url: url_DrivePermissionsCreate_580501, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_580479 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsList_580481(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsList_580480(path: JsonNode; query: JsonNode;
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
  var valid_580482 = path.getOrDefault("fileId")
  valid_580482 = validateParameter(valid_580482, JString, required = true,
                                 default = nil)
  if valid_580482 != nil:
    section.add "fileId", valid_580482
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
  var valid_580483 = query.getOrDefault("key")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "key", valid_580483
  var valid_580484 = query.getOrDefault("prettyPrint")
  valid_580484 = validateParameter(valid_580484, JBool, required = false,
                                 default = newJBool(true))
  if valid_580484 != nil:
    section.add "prettyPrint", valid_580484
  var valid_580485 = query.getOrDefault("oauth_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "oauth_token", valid_580485
  var valid_580486 = query.getOrDefault("useDomainAdminAccess")
  valid_580486 = validateParameter(valid_580486, JBool, required = false,
                                 default = newJBool(false))
  if valid_580486 != nil:
    section.add "useDomainAdminAccess", valid_580486
  var valid_580487 = query.getOrDefault("pageSize")
  valid_580487 = validateParameter(valid_580487, JInt, required = false, default = nil)
  if valid_580487 != nil:
    section.add "pageSize", valid_580487
  var valid_580488 = query.getOrDefault("alt")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = newJString("json"))
  if valid_580488 != nil:
    section.add "alt", valid_580488
  var valid_580489 = query.getOrDefault("userIp")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "userIp", valid_580489
  var valid_580490 = query.getOrDefault("quotaUser")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "quotaUser", valid_580490
  var valid_580491 = query.getOrDefault("pageToken")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "pageToken", valid_580491
  var valid_580492 = query.getOrDefault("supportsTeamDrives")
  valid_580492 = validateParameter(valid_580492, JBool, required = false,
                                 default = newJBool(false))
  if valid_580492 != nil:
    section.add "supportsTeamDrives", valid_580492
  var valid_580493 = query.getOrDefault("supportsAllDrives")
  valid_580493 = validateParameter(valid_580493, JBool, required = false,
                                 default = newJBool(false))
  if valid_580493 != nil:
    section.add "supportsAllDrives", valid_580493
  var valid_580494 = query.getOrDefault("fields")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "fields", valid_580494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580495: Call_DrivePermissionsList_580479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_580495.validator(path, query, header, formData, body)
  let scheme = call_580495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580495.url(scheme.get, call_580495.host, call_580495.base,
                         call_580495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580495, url, valid)

proc call*(call_580496: Call_DrivePermissionsList_580479; fileId: string;
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
  var path_580497 = newJObject()
  var query_580498 = newJObject()
  add(query_580498, "key", newJString(key))
  add(query_580498, "prettyPrint", newJBool(prettyPrint))
  add(query_580498, "oauth_token", newJString(oauthToken))
  add(query_580498, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580498, "pageSize", newJInt(pageSize))
  add(query_580498, "alt", newJString(alt))
  add(query_580498, "userIp", newJString(userIp))
  add(query_580498, "quotaUser", newJString(quotaUser))
  add(path_580497, "fileId", newJString(fileId))
  add(query_580498, "pageToken", newJString(pageToken))
  add(query_580498, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580498, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580498, "fields", newJString(fields))
  result = call_580496.call(path_580497, query_580498, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_580479(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_580480, base: "/drive/v3",
    url: url_DrivePermissionsList_580481, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_580522 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsGet_580524(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsGet_580523(path: JsonNode; query: JsonNode;
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
  var valid_580525 = path.getOrDefault("fileId")
  valid_580525 = validateParameter(valid_580525, JString, required = true,
                                 default = nil)
  if valid_580525 != nil:
    section.add "fileId", valid_580525
  var valid_580526 = path.getOrDefault("permissionId")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "permissionId", valid_580526
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
  var valid_580527 = query.getOrDefault("key")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "key", valid_580527
  var valid_580528 = query.getOrDefault("prettyPrint")
  valid_580528 = validateParameter(valid_580528, JBool, required = false,
                                 default = newJBool(true))
  if valid_580528 != nil:
    section.add "prettyPrint", valid_580528
  var valid_580529 = query.getOrDefault("oauth_token")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "oauth_token", valid_580529
  var valid_580530 = query.getOrDefault("useDomainAdminAccess")
  valid_580530 = validateParameter(valid_580530, JBool, required = false,
                                 default = newJBool(false))
  if valid_580530 != nil:
    section.add "useDomainAdminAccess", valid_580530
  var valid_580531 = query.getOrDefault("alt")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("json"))
  if valid_580531 != nil:
    section.add "alt", valid_580531
  var valid_580532 = query.getOrDefault("userIp")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "userIp", valid_580532
  var valid_580533 = query.getOrDefault("quotaUser")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "quotaUser", valid_580533
  var valid_580534 = query.getOrDefault("supportsTeamDrives")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(false))
  if valid_580534 != nil:
    section.add "supportsTeamDrives", valid_580534
  var valid_580535 = query.getOrDefault("supportsAllDrives")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(false))
  if valid_580535 != nil:
    section.add "supportsAllDrives", valid_580535
  var valid_580536 = query.getOrDefault("fields")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "fields", valid_580536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580537: Call_DrivePermissionsGet_580522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_580537.validator(path, query, header, formData, body)
  let scheme = call_580537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580537.url(scheme.get, call_580537.host, call_580537.base,
                         call_580537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580537, url, valid)

proc call*(call_580538: Call_DrivePermissionsGet_580522; fileId: string;
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
  var path_580539 = newJObject()
  var query_580540 = newJObject()
  add(query_580540, "key", newJString(key))
  add(query_580540, "prettyPrint", newJBool(prettyPrint))
  add(query_580540, "oauth_token", newJString(oauthToken))
  add(query_580540, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580540, "alt", newJString(alt))
  add(query_580540, "userIp", newJString(userIp))
  add(query_580540, "quotaUser", newJString(quotaUser))
  add(path_580539, "fileId", newJString(fileId))
  add(query_580540, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580540, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580540, "fields", newJString(fields))
  add(path_580539, "permissionId", newJString(permissionId))
  result = call_580538.call(path_580539, query_580540, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_580522(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_580523, base: "/drive/v3",
    url: url_DrivePermissionsGet_580524, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_580560 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsUpdate_580562(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsUpdate_580561(path: JsonNode; query: JsonNode;
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
  var valid_580563 = path.getOrDefault("fileId")
  valid_580563 = validateParameter(valid_580563, JString, required = true,
                                 default = nil)
  if valid_580563 != nil:
    section.add "fileId", valid_580563
  var valid_580564 = path.getOrDefault("permissionId")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "permissionId", valid_580564
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
  var valid_580565 = query.getOrDefault("key")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "key", valid_580565
  var valid_580566 = query.getOrDefault("prettyPrint")
  valid_580566 = validateParameter(valid_580566, JBool, required = false,
                                 default = newJBool(true))
  if valid_580566 != nil:
    section.add "prettyPrint", valid_580566
  var valid_580567 = query.getOrDefault("oauth_token")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "oauth_token", valid_580567
  var valid_580568 = query.getOrDefault("useDomainAdminAccess")
  valid_580568 = validateParameter(valid_580568, JBool, required = false,
                                 default = newJBool(false))
  if valid_580568 != nil:
    section.add "useDomainAdminAccess", valid_580568
  var valid_580569 = query.getOrDefault("removeExpiration")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(false))
  if valid_580569 != nil:
    section.add "removeExpiration", valid_580569
  var valid_580570 = query.getOrDefault("alt")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = newJString("json"))
  if valid_580570 != nil:
    section.add "alt", valid_580570
  var valid_580571 = query.getOrDefault("userIp")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "userIp", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("supportsTeamDrives")
  valid_580573 = validateParameter(valid_580573, JBool, required = false,
                                 default = newJBool(false))
  if valid_580573 != nil:
    section.add "supportsTeamDrives", valid_580573
  var valid_580574 = query.getOrDefault("transferOwnership")
  valid_580574 = validateParameter(valid_580574, JBool, required = false,
                                 default = newJBool(false))
  if valid_580574 != nil:
    section.add "transferOwnership", valid_580574
  var valid_580575 = query.getOrDefault("supportsAllDrives")
  valid_580575 = validateParameter(valid_580575, JBool, required = false,
                                 default = newJBool(false))
  if valid_580575 != nil:
    section.add "supportsAllDrives", valid_580575
  var valid_580576 = query.getOrDefault("fields")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "fields", valid_580576
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

proc call*(call_580578: Call_DrivePermissionsUpdate_580560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission with patch semantics.
  ## 
  let valid = call_580578.validator(path, query, header, formData, body)
  let scheme = call_580578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580578.url(scheme.get, call_580578.host, call_580578.base,
                         call_580578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580578, url, valid)

proc call*(call_580579: Call_DrivePermissionsUpdate_580560; fileId: string;
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
  var path_580580 = newJObject()
  var query_580581 = newJObject()
  var body_580582 = newJObject()
  add(query_580581, "key", newJString(key))
  add(query_580581, "prettyPrint", newJBool(prettyPrint))
  add(query_580581, "oauth_token", newJString(oauthToken))
  add(query_580581, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580581, "removeExpiration", newJBool(removeExpiration))
  add(query_580581, "alt", newJString(alt))
  add(query_580581, "userIp", newJString(userIp))
  add(query_580581, "quotaUser", newJString(quotaUser))
  add(path_580580, "fileId", newJString(fileId))
  add(query_580581, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580581, "transferOwnership", newJBool(transferOwnership))
  add(query_580581, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580582 = body
  add(query_580581, "fields", newJString(fields))
  add(path_580580, "permissionId", newJString(permissionId))
  result = call_580579.call(path_580580, query_580581, nil, nil, body_580582)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_580560(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_580561, base: "/drive/v3",
    url: url_DrivePermissionsUpdate_580562, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_580541 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsDelete_580543(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsDelete_580542(path: JsonNode; query: JsonNode;
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
  var valid_580544 = path.getOrDefault("fileId")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "fileId", valid_580544
  var valid_580545 = path.getOrDefault("permissionId")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = nil)
  if valid_580545 != nil:
    section.add "permissionId", valid_580545
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
  var valid_580546 = query.getOrDefault("key")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "key", valid_580546
  var valid_580547 = query.getOrDefault("prettyPrint")
  valid_580547 = validateParameter(valid_580547, JBool, required = false,
                                 default = newJBool(true))
  if valid_580547 != nil:
    section.add "prettyPrint", valid_580547
  var valid_580548 = query.getOrDefault("oauth_token")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "oauth_token", valid_580548
  var valid_580549 = query.getOrDefault("useDomainAdminAccess")
  valid_580549 = validateParameter(valid_580549, JBool, required = false,
                                 default = newJBool(false))
  if valid_580549 != nil:
    section.add "useDomainAdminAccess", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("userIp")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "userIp", valid_580551
  var valid_580552 = query.getOrDefault("quotaUser")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "quotaUser", valid_580552
  var valid_580553 = query.getOrDefault("supportsTeamDrives")
  valid_580553 = validateParameter(valid_580553, JBool, required = false,
                                 default = newJBool(false))
  if valid_580553 != nil:
    section.add "supportsTeamDrives", valid_580553
  var valid_580554 = query.getOrDefault("supportsAllDrives")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(false))
  if valid_580554 != nil:
    section.add "supportsAllDrives", valid_580554
  var valid_580555 = query.getOrDefault("fields")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "fields", valid_580555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580556: Call_DrivePermissionsDelete_580541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission.
  ## 
  let valid = call_580556.validator(path, query, header, formData, body)
  let scheme = call_580556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580556.url(scheme.get, call_580556.host, call_580556.base,
                         call_580556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580556, url, valid)

proc call*(call_580557: Call_DrivePermissionsDelete_580541; fileId: string;
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
  var path_580558 = newJObject()
  var query_580559 = newJObject()
  add(query_580559, "key", newJString(key))
  add(query_580559, "prettyPrint", newJBool(prettyPrint))
  add(query_580559, "oauth_token", newJString(oauthToken))
  add(query_580559, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580559, "alt", newJString(alt))
  add(query_580559, "userIp", newJString(userIp))
  add(query_580559, "quotaUser", newJString(quotaUser))
  add(path_580558, "fileId", newJString(fileId))
  add(query_580559, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580559, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580559, "fields", newJString(fields))
  add(path_580558, "permissionId", newJString(permissionId))
  result = call_580557.call(path_580558, query_580559, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_580541(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_580542, base: "/drive/v3",
    url: url_DrivePermissionsDelete_580543, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_580583 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsList_580585(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsList_580584(path: JsonNode; query: JsonNode;
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
  var valid_580586 = path.getOrDefault("fileId")
  valid_580586 = validateParameter(valid_580586, JString, required = true,
                                 default = nil)
  if valid_580586 != nil:
    section.add "fileId", valid_580586
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
  var valid_580587 = query.getOrDefault("key")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "key", valid_580587
  var valid_580588 = query.getOrDefault("prettyPrint")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(true))
  if valid_580588 != nil:
    section.add "prettyPrint", valid_580588
  var valid_580589 = query.getOrDefault("oauth_token")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "oauth_token", valid_580589
  var valid_580590 = query.getOrDefault("pageSize")
  valid_580590 = validateParameter(valid_580590, JInt, required = false,
                                 default = newJInt(200))
  if valid_580590 != nil:
    section.add "pageSize", valid_580590
  var valid_580591 = query.getOrDefault("alt")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = newJString("json"))
  if valid_580591 != nil:
    section.add "alt", valid_580591
  var valid_580592 = query.getOrDefault("userIp")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "userIp", valid_580592
  var valid_580593 = query.getOrDefault("quotaUser")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "quotaUser", valid_580593
  var valid_580594 = query.getOrDefault("pageToken")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "pageToken", valid_580594
  var valid_580595 = query.getOrDefault("fields")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "fields", valid_580595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580596: Call_DriveRevisionsList_580583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_580596.validator(path, query, header, formData, body)
  let scheme = call_580596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580596.url(scheme.get, call_580596.host, call_580596.base,
                         call_580596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580596, url, valid)

proc call*(call_580597: Call_DriveRevisionsList_580583; fileId: string;
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
  var path_580598 = newJObject()
  var query_580599 = newJObject()
  add(query_580599, "key", newJString(key))
  add(query_580599, "prettyPrint", newJBool(prettyPrint))
  add(query_580599, "oauth_token", newJString(oauthToken))
  add(query_580599, "pageSize", newJInt(pageSize))
  add(query_580599, "alt", newJString(alt))
  add(query_580599, "userIp", newJString(userIp))
  add(query_580599, "quotaUser", newJString(quotaUser))
  add(path_580598, "fileId", newJString(fileId))
  add(query_580599, "pageToken", newJString(pageToken))
  add(query_580599, "fields", newJString(fields))
  result = call_580597.call(path_580598, query_580599, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_580583(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_580584, base: "/drive/v3",
    url: url_DriveRevisionsList_580585, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_580600 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsGet_580602(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsGet_580601(path: JsonNode; query: JsonNode;
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
  var valid_580603 = path.getOrDefault("fileId")
  valid_580603 = validateParameter(valid_580603, JString, required = true,
                                 default = nil)
  if valid_580603 != nil:
    section.add "fileId", valid_580603
  var valid_580604 = path.getOrDefault("revisionId")
  valid_580604 = validateParameter(valid_580604, JString, required = true,
                                 default = nil)
  if valid_580604 != nil:
    section.add "revisionId", valid_580604
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
  var valid_580605 = query.getOrDefault("key")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "key", valid_580605
  var valid_580606 = query.getOrDefault("prettyPrint")
  valid_580606 = validateParameter(valid_580606, JBool, required = false,
                                 default = newJBool(true))
  if valid_580606 != nil:
    section.add "prettyPrint", valid_580606
  var valid_580607 = query.getOrDefault("oauth_token")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "oauth_token", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("userIp")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "userIp", valid_580609
  var valid_580610 = query.getOrDefault("quotaUser")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "quotaUser", valid_580610
  var valid_580611 = query.getOrDefault("acknowledgeAbuse")
  valid_580611 = validateParameter(valid_580611, JBool, required = false,
                                 default = newJBool(false))
  if valid_580611 != nil:
    section.add "acknowledgeAbuse", valid_580611
  var valid_580612 = query.getOrDefault("fields")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "fields", valid_580612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580613: Call_DriveRevisionsGet_580600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a revision's metadata or content by ID.
  ## 
  let valid = call_580613.validator(path, query, header, formData, body)
  let scheme = call_580613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580613.url(scheme.get, call_580613.host, call_580613.base,
                         call_580613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580613, url, valid)

proc call*(call_580614: Call_DriveRevisionsGet_580600; fileId: string;
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
  var path_580615 = newJObject()
  var query_580616 = newJObject()
  add(query_580616, "key", newJString(key))
  add(query_580616, "prettyPrint", newJBool(prettyPrint))
  add(query_580616, "oauth_token", newJString(oauthToken))
  add(query_580616, "alt", newJString(alt))
  add(query_580616, "userIp", newJString(userIp))
  add(query_580616, "quotaUser", newJString(quotaUser))
  add(path_580615, "fileId", newJString(fileId))
  add(query_580616, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(path_580615, "revisionId", newJString(revisionId))
  add(query_580616, "fields", newJString(fields))
  result = call_580614.call(path_580615, query_580616, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_580600(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_580601, base: "/drive/v3",
    url: url_DriveRevisionsGet_580602, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_580633 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsUpdate_580635(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsUpdate_580634(path: JsonNode; query: JsonNode;
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
  var valid_580636 = path.getOrDefault("fileId")
  valid_580636 = validateParameter(valid_580636, JString, required = true,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fileId", valid_580636
  var valid_580637 = path.getOrDefault("revisionId")
  valid_580637 = validateParameter(valid_580637, JString, required = true,
                                 default = nil)
  if valid_580637 != nil:
    section.add "revisionId", valid_580637
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
  var valid_580638 = query.getOrDefault("key")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "key", valid_580638
  var valid_580639 = query.getOrDefault("prettyPrint")
  valid_580639 = validateParameter(valid_580639, JBool, required = false,
                                 default = newJBool(true))
  if valid_580639 != nil:
    section.add "prettyPrint", valid_580639
  var valid_580640 = query.getOrDefault("oauth_token")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "oauth_token", valid_580640
  var valid_580641 = query.getOrDefault("alt")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = newJString("json"))
  if valid_580641 != nil:
    section.add "alt", valid_580641
  var valid_580642 = query.getOrDefault("userIp")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "userIp", valid_580642
  var valid_580643 = query.getOrDefault("quotaUser")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "quotaUser", valid_580643
  var valid_580644 = query.getOrDefault("fields")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "fields", valid_580644
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

proc call*(call_580646: Call_DriveRevisionsUpdate_580633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision with patch semantics.
  ## 
  let valid = call_580646.validator(path, query, header, formData, body)
  let scheme = call_580646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580646.url(scheme.get, call_580646.host, call_580646.base,
                         call_580646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580646, url, valid)

proc call*(call_580647: Call_DriveRevisionsUpdate_580633; fileId: string;
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
  var path_580648 = newJObject()
  var query_580649 = newJObject()
  var body_580650 = newJObject()
  add(query_580649, "key", newJString(key))
  add(query_580649, "prettyPrint", newJBool(prettyPrint))
  add(query_580649, "oauth_token", newJString(oauthToken))
  add(query_580649, "alt", newJString(alt))
  add(query_580649, "userIp", newJString(userIp))
  add(query_580649, "quotaUser", newJString(quotaUser))
  add(path_580648, "fileId", newJString(fileId))
  if body != nil:
    body_580650 = body
  add(path_580648, "revisionId", newJString(revisionId))
  add(query_580649, "fields", newJString(fields))
  result = call_580647.call(path_580648, query_580649, nil, nil, body_580650)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_580633(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_580634, base: "/drive/v3",
    url: url_DriveRevisionsUpdate_580635, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_580617 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsDelete_580619(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsDelete_580618(path: JsonNode; query: JsonNode;
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
  var valid_580620 = path.getOrDefault("fileId")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "fileId", valid_580620
  var valid_580621 = path.getOrDefault("revisionId")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "revisionId", valid_580621
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
  var valid_580622 = query.getOrDefault("key")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "key", valid_580622
  var valid_580623 = query.getOrDefault("prettyPrint")
  valid_580623 = validateParameter(valid_580623, JBool, required = false,
                                 default = newJBool(true))
  if valid_580623 != nil:
    section.add "prettyPrint", valid_580623
  var valid_580624 = query.getOrDefault("oauth_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "oauth_token", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("userIp")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "userIp", valid_580626
  var valid_580627 = query.getOrDefault("quotaUser")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "quotaUser", valid_580627
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580629: Call_DriveRevisionsDelete_580617; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_580629.validator(path, query, header, formData, body)
  let scheme = call_580629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580629.url(scheme.get, call_580629.host, call_580629.base,
                         call_580629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580629, url, valid)

proc call*(call_580630: Call_DriveRevisionsDelete_580617; fileId: string;
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
  var path_580631 = newJObject()
  var query_580632 = newJObject()
  add(query_580632, "key", newJString(key))
  add(query_580632, "prettyPrint", newJBool(prettyPrint))
  add(query_580632, "oauth_token", newJString(oauthToken))
  add(query_580632, "alt", newJString(alt))
  add(query_580632, "userIp", newJString(userIp))
  add(query_580632, "quotaUser", newJString(quotaUser))
  add(path_580631, "fileId", newJString(fileId))
  add(path_580631, "revisionId", newJString(revisionId))
  add(query_580632, "fields", newJString(fields))
  result = call_580630.call(path_580631, query_580632, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_580617(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_580618, base: "/drive/v3",
    url: url_DriveRevisionsDelete_580619, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_580651 = ref object of OpenApiRestCall_579380
proc url_DriveFilesWatch_580653(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesWatch_580652(path: JsonNode; query: JsonNode;
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
  var valid_580654 = path.getOrDefault("fileId")
  valid_580654 = validateParameter(valid_580654, JString, required = true,
                                 default = nil)
  if valid_580654 != nil:
    section.add "fileId", valid_580654
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
  var valid_580655 = query.getOrDefault("key")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "key", valid_580655
  var valid_580656 = query.getOrDefault("prettyPrint")
  valid_580656 = validateParameter(valid_580656, JBool, required = false,
                                 default = newJBool(true))
  if valid_580656 != nil:
    section.add "prettyPrint", valid_580656
  var valid_580657 = query.getOrDefault("oauth_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "oauth_token", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("userIp")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "userIp", valid_580659
  var valid_580660 = query.getOrDefault("quotaUser")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "quotaUser", valid_580660
  var valid_580661 = query.getOrDefault("supportsTeamDrives")
  valid_580661 = validateParameter(valid_580661, JBool, required = false,
                                 default = newJBool(false))
  if valid_580661 != nil:
    section.add "supportsTeamDrives", valid_580661
  var valid_580662 = query.getOrDefault("acknowledgeAbuse")
  valid_580662 = validateParameter(valid_580662, JBool, required = false,
                                 default = newJBool(false))
  if valid_580662 != nil:
    section.add "acknowledgeAbuse", valid_580662
  var valid_580663 = query.getOrDefault("supportsAllDrives")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(false))
  if valid_580663 != nil:
    section.add "supportsAllDrives", valid_580663
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
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

proc call*(call_580666: Call_DriveFilesWatch_580651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribes to changes to a file
  ## 
  let valid = call_580666.validator(path, query, header, formData, body)
  let scheme = call_580666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580666.url(scheme.get, call_580666.host, call_580666.base,
                         call_580666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580666, url, valid)

proc call*(call_580667: Call_DriveFilesWatch_580651; fileId: string;
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
  var path_580668 = newJObject()
  var query_580669 = newJObject()
  var body_580670 = newJObject()
  add(query_580669, "key", newJString(key))
  add(query_580669, "prettyPrint", newJBool(prettyPrint))
  add(query_580669, "oauth_token", newJString(oauthToken))
  add(query_580669, "alt", newJString(alt))
  add(query_580669, "userIp", newJString(userIp))
  add(query_580669, "quotaUser", newJString(quotaUser))
  add(path_580668, "fileId", newJString(fileId))
  add(query_580669, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580669, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580669, "supportsAllDrives", newJBool(supportsAllDrives))
  if resource != nil:
    body_580670 = resource
  add(query_580669, "fields", newJString(fields))
  result = call_580667.call(path_580668, query_580669, nil, nil, body_580670)

var driveFilesWatch* = Call_DriveFilesWatch_580651(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_580652,
    base: "/drive/v3", url: url_DriveFilesWatch_580653, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesCreate_580688 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesCreate_580690(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveTeamdrivesCreate_580689(path: JsonNode; query: JsonNode;
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
  var valid_580691 = query.getOrDefault("key")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "key", valid_580691
  var valid_580692 = query.getOrDefault("prettyPrint")
  valid_580692 = validateParameter(valid_580692, JBool, required = false,
                                 default = newJBool(true))
  if valid_580692 != nil:
    section.add "prettyPrint", valid_580692
  var valid_580693 = query.getOrDefault("oauth_token")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "oauth_token", valid_580693
  var valid_580694 = query.getOrDefault("alt")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = newJString("json"))
  if valid_580694 != nil:
    section.add "alt", valid_580694
  var valid_580695 = query.getOrDefault("userIp")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "userIp", valid_580695
  var valid_580696 = query.getOrDefault("quotaUser")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "quotaUser", valid_580696
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580697 = query.getOrDefault("requestId")
  valid_580697 = validateParameter(valid_580697, JString, required = true,
                                 default = nil)
  if valid_580697 != nil:
    section.add "requestId", valid_580697
  var valid_580698 = query.getOrDefault("fields")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "fields", valid_580698
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

proc call*(call_580700: Call_DriveTeamdrivesCreate_580688; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.create instead.
  ## 
  let valid = call_580700.validator(path, query, header, formData, body)
  let scheme = call_580700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580700.url(scheme.get, call_580700.host, call_580700.base,
                         call_580700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580700, url, valid)

proc call*(call_580701: Call_DriveTeamdrivesCreate_580688; requestId: string;
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
  var query_580702 = newJObject()
  var body_580703 = newJObject()
  add(query_580702, "key", newJString(key))
  add(query_580702, "prettyPrint", newJBool(prettyPrint))
  add(query_580702, "oauth_token", newJString(oauthToken))
  add(query_580702, "alt", newJString(alt))
  add(query_580702, "userIp", newJString(userIp))
  add(query_580702, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580703 = body
  add(query_580702, "requestId", newJString(requestId))
  add(query_580702, "fields", newJString(fields))
  result = call_580701.call(nil, query_580702, nil, nil, body_580703)

var driveTeamdrivesCreate* = Call_DriveTeamdrivesCreate_580688(
    name: "driveTeamdrivesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesCreate_580689, base: "/drive/v3",
    url: url_DriveTeamdrivesCreate_580690, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_580671 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesList_580673(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DriveTeamdrivesList_580672(path: JsonNode; query: JsonNode;
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
  var valid_580674 = query.getOrDefault("key")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "key", valid_580674
  var valid_580675 = query.getOrDefault("prettyPrint")
  valid_580675 = validateParameter(valid_580675, JBool, required = false,
                                 default = newJBool(true))
  if valid_580675 != nil:
    section.add "prettyPrint", valid_580675
  var valid_580676 = query.getOrDefault("oauth_token")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "oauth_token", valid_580676
  var valid_580677 = query.getOrDefault("useDomainAdminAccess")
  valid_580677 = validateParameter(valid_580677, JBool, required = false,
                                 default = newJBool(false))
  if valid_580677 != nil:
    section.add "useDomainAdminAccess", valid_580677
  var valid_580678 = query.getOrDefault("q")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "q", valid_580678
  var valid_580679 = query.getOrDefault("pageSize")
  valid_580679 = validateParameter(valid_580679, JInt, required = false,
                                 default = newJInt(10))
  if valid_580679 != nil:
    section.add "pageSize", valid_580679
  var valid_580680 = query.getOrDefault("alt")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = newJString("json"))
  if valid_580680 != nil:
    section.add "alt", valid_580680
  var valid_580681 = query.getOrDefault("userIp")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "userIp", valid_580681
  var valid_580682 = query.getOrDefault("quotaUser")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "quotaUser", valid_580682
  var valid_580683 = query.getOrDefault("pageToken")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "pageToken", valid_580683
  var valid_580684 = query.getOrDefault("fields")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "fields", valid_580684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580685: Call_DriveTeamdrivesList_580671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_580685.validator(path, query, header, formData, body)
  let scheme = call_580685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580685.url(scheme.get, call_580685.host, call_580685.base,
                         call_580685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580685, url, valid)

proc call*(call_580686: Call_DriveTeamdrivesList_580671; key: string = "";
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
  var query_580687 = newJObject()
  add(query_580687, "key", newJString(key))
  add(query_580687, "prettyPrint", newJBool(prettyPrint))
  add(query_580687, "oauth_token", newJString(oauthToken))
  add(query_580687, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580687, "q", newJString(q))
  add(query_580687, "pageSize", newJInt(pageSize))
  add(query_580687, "alt", newJString(alt))
  add(query_580687, "userIp", newJString(userIp))
  add(query_580687, "quotaUser", newJString(quotaUser))
  add(query_580687, "pageToken", newJString(pageToken))
  add(query_580687, "fields", newJString(fields))
  result = call_580686.call(nil, query_580687, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_580671(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_580672, base: "/drive/v3",
    url: url_DriveTeamdrivesList_580673, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_580704 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesGet_580706(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_580705(path: JsonNode; query: JsonNode;
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
  var valid_580707 = path.getOrDefault("teamDriveId")
  valid_580707 = validateParameter(valid_580707, JString, required = true,
                                 default = nil)
  if valid_580707 != nil:
    section.add "teamDriveId", valid_580707
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
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("prettyPrint")
  valid_580709 = validateParameter(valid_580709, JBool, required = false,
                                 default = newJBool(true))
  if valid_580709 != nil:
    section.add "prettyPrint", valid_580709
  var valid_580710 = query.getOrDefault("oauth_token")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "oauth_token", valid_580710
  var valid_580711 = query.getOrDefault("useDomainAdminAccess")
  valid_580711 = validateParameter(valid_580711, JBool, required = false,
                                 default = newJBool(false))
  if valid_580711 != nil:
    section.add "useDomainAdminAccess", valid_580711
  var valid_580712 = query.getOrDefault("alt")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = newJString("json"))
  if valid_580712 != nil:
    section.add "alt", valid_580712
  var valid_580713 = query.getOrDefault("userIp")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "userIp", valid_580713
  var valid_580714 = query.getOrDefault("quotaUser")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "quotaUser", valid_580714
  var valid_580715 = query.getOrDefault("fields")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fields", valid_580715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580716: Call_DriveTeamdrivesGet_580704; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_580716.validator(path, query, header, formData, body)
  let scheme = call_580716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580716.url(scheme.get, call_580716.host, call_580716.base,
                         call_580716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580716, url, valid)

proc call*(call_580717: Call_DriveTeamdrivesGet_580704; teamDriveId: string;
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
  var path_580718 = newJObject()
  var query_580719 = newJObject()
  add(query_580719, "key", newJString(key))
  add(path_580718, "teamDriveId", newJString(teamDriveId))
  add(query_580719, "prettyPrint", newJBool(prettyPrint))
  add(query_580719, "oauth_token", newJString(oauthToken))
  add(query_580719, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580719, "alt", newJString(alt))
  add(query_580719, "userIp", newJString(userIp))
  add(query_580719, "quotaUser", newJString(quotaUser))
  add(query_580719, "fields", newJString(fields))
  result = call_580717.call(path_580718, query_580719, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_580704(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_580705, base: "/drive/v3",
    url: url_DriveTeamdrivesGet_580706, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_580735 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesUpdate_580737(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_580736(path: JsonNode; query: JsonNode;
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
  var valid_580738 = path.getOrDefault("teamDriveId")
  valid_580738 = validateParameter(valid_580738, JString, required = true,
                                 default = nil)
  if valid_580738 != nil:
    section.add "teamDriveId", valid_580738
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
  var valid_580741 = query.getOrDefault("oauth_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "oauth_token", valid_580741
  var valid_580742 = query.getOrDefault("useDomainAdminAccess")
  valid_580742 = validateParameter(valid_580742, JBool, required = false,
                                 default = newJBool(false))
  if valid_580742 != nil:
    section.add "useDomainAdminAccess", valid_580742
  var valid_580743 = query.getOrDefault("alt")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = newJString("json"))
  if valid_580743 != nil:
    section.add "alt", valid_580743
  var valid_580744 = query.getOrDefault("userIp")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "userIp", valid_580744
  var valid_580745 = query.getOrDefault("quotaUser")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "quotaUser", valid_580745
  var valid_580746 = query.getOrDefault("fields")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "fields", valid_580746
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

proc call*(call_580748: Call_DriveTeamdrivesUpdate_580735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead
  ## 
  let valid = call_580748.validator(path, query, header, formData, body)
  let scheme = call_580748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580748.url(scheme.get, call_580748.host, call_580748.base,
                         call_580748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580748, url, valid)

proc call*(call_580749: Call_DriveTeamdrivesUpdate_580735; teamDriveId: string;
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
  var path_580750 = newJObject()
  var query_580751 = newJObject()
  var body_580752 = newJObject()
  add(query_580751, "key", newJString(key))
  add(path_580750, "teamDriveId", newJString(teamDriveId))
  add(query_580751, "prettyPrint", newJBool(prettyPrint))
  add(query_580751, "oauth_token", newJString(oauthToken))
  add(query_580751, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580751, "alt", newJString(alt))
  add(query_580751, "userIp", newJString(userIp))
  add(query_580751, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580752 = body
  add(query_580751, "fields", newJString(fields))
  result = call_580749.call(path_580750, query_580751, nil, nil, body_580752)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_580735(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_580736, base: "/drive/v3",
    url: url_DriveTeamdrivesUpdate_580737, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_580720 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesDelete_580722(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_580721(path: JsonNode; query: JsonNode;
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
  var valid_580723 = path.getOrDefault("teamDriveId")
  valid_580723 = validateParameter(valid_580723, JString, required = true,
                                 default = nil)
  if valid_580723 != nil:
    section.add "teamDriveId", valid_580723
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
  var valid_580724 = query.getOrDefault("key")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "key", valid_580724
  var valid_580725 = query.getOrDefault("prettyPrint")
  valid_580725 = validateParameter(valid_580725, JBool, required = false,
                                 default = newJBool(true))
  if valid_580725 != nil:
    section.add "prettyPrint", valid_580725
  var valid_580726 = query.getOrDefault("oauth_token")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "oauth_token", valid_580726
  var valid_580727 = query.getOrDefault("alt")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = newJString("json"))
  if valid_580727 != nil:
    section.add "alt", valid_580727
  var valid_580728 = query.getOrDefault("userIp")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "userIp", valid_580728
  var valid_580729 = query.getOrDefault("quotaUser")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "quotaUser", valid_580729
  var valid_580730 = query.getOrDefault("fields")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "fields", valid_580730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580731: Call_DriveTeamdrivesDelete_580720; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_580731.validator(path, query, header, formData, body)
  let scheme = call_580731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580731.url(scheme.get, call_580731.host, call_580731.base,
                         call_580731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580731, url, valid)

proc call*(call_580732: Call_DriveTeamdrivesDelete_580720; teamDriveId: string;
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
  var path_580733 = newJObject()
  var query_580734 = newJObject()
  add(query_580734, "key", newJString(key))
  add(path_580733, "teamDriveId", newJString(teamDriveId))
  add(query_580734, "prettyPrint", newJBool(prettyPrint))
  add(query_580734, "oauth_token", newJString(oauthToken))
  add(query_580734, "alt", newJString(alt))
  add(query_580734, "userIp", newJString(userIp))
  add(query_580734, "quotaUser", newJString(quotaUser))
  add(query_580734, "fields", newJString(fields))
  result = call_580732.call(path_580733, query_580734, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_580720(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_580721, base: "/drive/v3",
    url: url_DriveTeamdrivesDelete_580722, schemes: {Scheme.Https})
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
