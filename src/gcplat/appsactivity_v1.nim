
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Drive Activity
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides a historical view of activity.
## 
## https://developers.google.com/google-apps/activity/
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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
  gcpServiceName = "appsactivity"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsactivityActivitiesList_597692 = ref object of OpenApiRestCall_597424
proc url_AppsactivityActivitiesList_597694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsactivityActivitiesList_597693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of activities visible to the current logged in user. Visible activities are determined by the visibility settings of the object that was acted on, e.g. Drive files a user can see. An activity is a record of past events. Multiple events may be merged if they are similar. A request is scoped to activities from a given Google service using the source parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   groupingStrategy: JString
  ##                   : Indicates the strategy to use when grouping singleEvents items in the associated combinedEvent object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token to retrieve a specific page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   drive.ancestorId: JString
  ##                   : Identifies the Drive folder containing the items for which to return activities.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: JString
  ##         : The Google service from which to return activities. Possible values of source are: 
  ## - drive.google.com
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   drive.fileId: JString
  ##               : Identifies the Drive item to return activities for.
  ##   pageSize: JInt
  ##           : The maximum number of events to return on a page. The response includes a continuation token if there are more events.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   userId: JString
  ##         : The ID used for ACL checks (does not filter the resulting event list by the assigned value). Use the special value me to indicate the currently authenticated user.
  section = newJObject()
  var valid_597819 = query.getOrDefault("groupingStrategy")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = newJString("driveUi"))
  if valid_597819 != nil:
    section.add "groupingStrategy", valid_597819
  var valid_597820 = query.getOrDefault("fields")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "fields", valid_597820
  var valid_597821 = query.getOrDefault("pageToken")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "pageToken", valid_597821
  var valid_597822 = query.getOrDefault("quotaUser")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "quotaUser", valid_597822
  var valid_597823 = query.getOrDefault("alt")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("json"))
  if valid_597823 != nil:
    section.add "alt", valid_597823
  var valid_597824 = query.getOrDefault("drive.ancestorId")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "drive.ancestorId", valid_597824
  var valid_597825 = query.getOrDefault("oauth_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "oauth_token", valid_597825
  var valid_597826 = query.getOrDefault("userIp")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "userIp", valid_597826
  var valid_597827 = query.getOrDefault("source")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "source", valid_597827
  var valid_597828 = query.getOrDefault("key")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "key", valid_597828
  var valid_597829 = query.getOrDefault("drive.fileId")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = nil)
  if valid_597829 != nil:
    section.add "drive.fileId", valid_597829
  var valid_597831 = query.getOrDefault("pageSize")
  valid_597831 = validateParameter(valid_597831, JInt, required = false,
                                 default = newJInt(50))
  if valid_597831 != nil:
    section.add "pageSize", valid_597831
  var valid_597832 = query.getOrDefault("prettyPrint")
  valid_597832 = validateParameter(valid_597832, JBool, required = false,
                                 default = newJBool(true))
  if valid_597832 != nil:
    section.add "prettyPrint", valid_597832
  var valid_597833 = query.getOrDefault("userId")
  valid_597833 = validateParameter(valid_597833, JString, required = false,
                                 default = newJString("me"))
  if valid_597833 != nil:
    section.add "userId", valid_597833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597856: Call_AppsactivityActivitiesList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of activities visible to the current logged in user. Visible activities are determined by the visibility settings of the object that was acted on, e.g. Drive files a user can see. An activity is a record of past events. Multiple events may be merged if they are similar. A request is scoped to activities from a given Google service using the source parameter.
  ## 
  let valid = call_597856.validator(path, query, header, formData, body)
  let scheme = call_597856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597856.url(scheme.get, call_597856.host, call_597856.base,
                         call_597856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597856, url, valid)

proc call*(call_597927: Call_AppsactivityActivitiesList_597692;
          groupingStrategy: string = "driveUi"; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          driveAncestorId: string = ""; oauthToken: string = ""; userIp: string = "";
          source: string = ""; key: string = ""; driveFileId: string = "";
          pageSize: int = 50; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## appsactivityActivitiesList
  ## Returns a list of activities visible to the current logged in user. Visible activities are determined by the visibility settings of the object that was acted on, e.g. Drive files a user can see. An activity is a record of past events. Multiple events may be merged if they are similar. A request is scoped to activities from a given Google service using the source parameter.
  ##   groupingStrategy: string
  ##                   : Indicates the strategy to use when grouping singleEvents items in the associated combinedEvent object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token to retrieve a specific page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   driveAncestorId: string
  ##                  : Identifies the Drive folder containing the items for which to return activities.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   source: string
  ##         : The Google service from which to return activities. Possible values of source are: 
  ## - drive.google.com
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   driveFileId: string
  ##              : Identifies the Drive item to return activities for.
  ##   pageSize: int
  ##           : The maximum number of events to return on a page. The response includes a continuation token if there are more events.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string
  ##         : The ID used for ACL checks (does not filter the resulting event list by the assigned value). Use the special value me to indicate the currently authenticated user.
  var query_597928 = newJObject()
  add(query_597928, "groupingStrategy", newJString(groupingStrategy))
  add(query_597928, "fields", newJString(fields))
  add(query_597928, "pageToken", newJString(pageToken))
  add(query_597928, "quotaUser", newJString(quotaUser))
  add(query_597928, "alt", newJString(alt))
  add(query_597928, "drive.ancestorId", newJString(driveAncestorId))
  add(query_597928, "oauth_token", newJString(oauthToken))
  add(query_597928, "userIp", newJString(userIp))
  add(query_597928, "source", newJString(source))
  add(query_597928, "key", newJString(key))
  add(query_597928, "drive.fileId", newJString(driveFileId))
  add(query_597928, "pageSize", newJInt(pageSize))
  add(query_597928, "prettyPrint", newJBool(prettyPrint))
  add(query_597928, "userId", newJString(userId))
  result = call_597927.call(nil, query_597928, nil, nil, nil)

var appsactivityActivitiesList* = Call_AppsactivityActivitiesList_597692(
    name: "appsactivityActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_AppsactivityActivitiesList_597693,
    base: "/appsactivity/v1", url: url_AppsactivityActivitiesList_597694,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)