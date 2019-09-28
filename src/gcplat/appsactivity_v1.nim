
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "appsactivity"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsactivityActivitiesList_579692 = ref object of OpenApiRestCall_579424
proc url_AppsactivityActivitiesList_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppsactivityActivitiesList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579819 = query.getOrDefault("groupingStrategy")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("driveUi"))
  if valid_579819 != nil:
    section.add "groupingStrategy", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("pageToken")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "pageToken", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("drive.ancestorId")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "drive.ancestorId", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("userIp")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "userIp", valid_579826
  var valid_579827 = query.getOrDefault("source")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "source", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("drive.fileId")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "drive.fileId", valid_579829
  var valid_579831 = query.getOrDefault("pageSize")
  valid_579831 = validateParameter(valid_579831, JInt, required = false,
                                 default = newJInt(50))
  if valid_579831 != nil:
    section.add "pageSize", valid_579831
  var valid_579832 = query.getOrDefault("prettyPrint")
  valid_579832 = validateParameter(valid_579832, JBool, required = false,
                                 default = newJBool(true))
  if valid_579832 != nil:
    section.add "prettyPrint", valid_579832
  var valid_579833 = query.getOrDefault("userId")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = newJString("me"))
  if valid_579833 != nil:
    section.add "userId", valid_579833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579856: Call_AppsactivityActivitiesList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of activities visible to the current logged in user. Visible activities are determined by the visibility settings of the object that was acted on, e.g. Drive files a user can see. An activity is a record of past events. Multiple events may be merged if they are similar. A request is scoped to activities from a given Google service using the source parameter.
  ## 
  let valid = call_579856.validator(path, query, header, formData, body)
  let scheme = call_579856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579856.url(scheme.get, call_579856.host, call_579856.base,
                         call_579856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579856, url, valid)

proc call*(call_579927: Call_AppsactivityActivitiesList_579692;
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
  var query_579928 = newJObject()
  add(query_579928, "groupingStrategy", newJString(groupingStrategy))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "pageToken", newJString(pageToken))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "drive.ancestorId", newJString(driveAncestorId))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "userIp", newJString(userIp))
  add(query_579928, "source", newJString(source))
  add(query_579928, "key", newJString(key))
  add(query_579928, "drive.fileId", newJString(driveFileId))
  add(query_579928, "pageSize", newJInt(pageSize))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "userId", newJString(userId))
  result = call_579927.call(nil, query_579928, nil, nil, nil)

var appsactivityActivitiesList* = Call_AppsactivityActivitiesList_579692(
    name: "appsactivityActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_AppsactivityActivitiesList_579693,
    base: "/appsactivity/v1", url: url_AppsactivityActivitiesList_579694,
    schemes: {Scheme.Https})
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
