
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Gmail
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Access Gmail mailboxes including sending user email.
## 
## https://developers.google.com/gmail/api/
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
  gcpServiceName = "gmail"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GmailUsersDraftsCreate_579981 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsCreate_579983(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsCreate_579982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new draft with the DRAFT label.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579984 = path.getOrDefault("userId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = newJString("me"))
  if valid_579984 != nil:
    section.add "userId", valid_579984
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
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
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

proc call*(call_579993: Call_GmailUsersDraftsCreate_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new draft with the DRAFT label.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_GmailUsersDraftsCreate_579981; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersDraftsCreate
  ## Creates a new draft with the DRAFT label.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  var body_579997 = newJObject()
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "key", newJString(key))
  if body != nil:
    body_579997 = body
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  add(path_579995, "userId", newJString(userId))
  result = call_579994.call(path_579995, query_579996, nil, nil, body_579997)

var gmailUsersDraftsCreate* = Call_GmailUsersDraftsCreate_579981(
    name: "gmailUsersDraftsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsCreate_579982, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsCreate_579983, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsList_579692 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsList_579694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsList_579693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the drafts in the user's mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579833 = path.getOrDefault("userId")
  valid_579833 = validateParameter(valid_579833, JString, required = true,
                                 default = newJString("me"))
  if valid_579833 != nil:
    section.add "userId", valid_579833
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of drafts to return.
  ##   includeSpamTrash: JBool
  ##                   : Include drafts from SPAM and TRASH in the results.
  ##   q: JString
  ##    : Only return draft messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread".
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579834 = query.getOrDefault("fields")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "fields", valid_579834
  var valid_579835 = query.getOrDefault("pageToken")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "pageToken", valid_579835
  var valid_579836 = query.getOrDefault("quotaUser")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "quotaUser", valid_579836
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579841 = query.getOrDefault("maxResults")
  valid_579841 = validateParameter(valid_579841, JInt, required = false,
                                 default = newJInt(100))
  if valid_579841 != nil:
    section.add "maxResults", valid_579841
  var valid_579842 = query.getOrDefault("includeSpamTrash")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(false))
  if valid_579842 != nil:
    section.add "includeSpamTrash", valid_579842
  var valid_579843 = query.getOrDefault("q")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "q", valid_579843
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("prettyPrint")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "prettyPrint", valid_579845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579868: Call_GmailUsersDraftsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the drafts in the user's mailbox.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_GmailUsersDraftsList_579692; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 100;
          includeSpamTrash: bool = false; q: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersDraftsList
  ## Lists the drafts in the user's mailbox.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of drafts to return.
  ##   includeSpamTrash: bool
  ##                   : Include drafts from SPAM and TRASH in the results.
  ##   q: string
  ##    : Only return draft messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "maxResults", newJInt(maxResults))
  add(query_579942, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_579942, "q", newJString(q))
  add(query_579942, "key", newJString(key))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(path_579940, "userId", newJString(userId))
  result = call_579939.call(path_579940, query_579942, nil, nil, nil)

var gmailUsersDraftsList* = Call_GmailUsersDraftsList_579692(
    name: "gmailUsersDraftsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsList_579693, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsList_579694, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsSend_579998 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsSend_580000(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts/send")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsSend_579999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580001 = path.getOrDefault("userId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = newJString("me"))
  if valid_580001 != nil:
    section.add "userId", valid_580001
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
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("userIp")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "userIp", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
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

proc call*(call_580010: Call_GmailUsersDraftsSend_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_GmailUsersDraftsSend_579998; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersDraftsSend
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  var body_580014 = newJObject()
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(query_580013, "userIp", newJString(userIp))
  add(query_580013, "key", newJString(key))
  if body != nil:
    body_580014 = body
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(path_580012, "userId", newJString(userId))
  result = call_580011.call(path_580012, query_580013, nil, nil, body_580014)

var gmailUsersDraftsSend* = Call_GmailUsersDraftsSend_579998(
    name: "gmailUsersDraftsSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts/send",
    validator: validate_GmailUsersDraftsSend_579999, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsSend_580000, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsUpdate_580032 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsUpdate_580034(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsUpdate_580033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces a draft's content.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the draft to update.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580035 = path.getOrDefault("id")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "id", valid_580035
  var valid_580036 = path.getOrDefault("userId")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = newJString("me"))
  if valid_580036 != nil:
    section.add "userId", valid_580036
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
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
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

proc call*(call_580045: Call_GmailUsersDraftsUpdate_580032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces a draft's content.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_GmailUsersDraftsUpdate_580032; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersDraftsUpdate
  ## Replaces a draft's content.
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
  ##   id: string (required)
  ##     : The ID of the draft to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "userIp", newJString(userIp))
  add(path_580047, "id", newJString(id))
  add(query_580048, "key", newJString(key))
  if body != nil:
    body_580049 = body
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(path_580047, "userId", newJString(userId))
  result = call_580046.call(path_580047, query_580048, nil, nil, body_580049)

var gmailUsersDraftsUpdate* = Call_GmailUsersDraftsUpdate_580032(
    name: "gmailUsersDraftsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsUpdate_580033, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsUpdate_580034, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsGet_580015 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsGet_580017(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsGet_580016(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified draft.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the draft to retrieve.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580018 = path.getOrDefault("id")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "id", valid_580018
  var valid_580019 = path.getOrDefault("userId")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = newJString("me"))
  if valid_580019 != nil:
    section.add "userId", valid_580019
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
  ##   format: JString
  ##         : The format to return the draft in.
  section = newJObject()
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("userIp")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "userIp", valid_580024
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  var valid_580027 = query.getOrDefault("format")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("full"))
  if valid_580027 != nil:
    section.add "format", valid_580027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_GmailUsersDraftsGet_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified draft.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_GmailUsersDraftsGet_580015; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; format: string = "full"; userId: string = "me"): Recallable =
  ## gmailUsersDraftsGet
  ## Gets the specified draft.
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
  ##   id: string (required)
  ##     : The ID of the draft to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The format to return the draft in.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "userIp", newJString(userIp))
  add(path_580030, "id", newJString(id))
  add(query_580031, "key", newJString(key))
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  add(query_580031, "format", newJString(format))
  add(path_580030, "userId", newJString(userId))
  result = call_580029.call(path_580030, query_580031, nil, nil, nil)

var gmailUsersDraftsGet* = Call_GmailUsersDraftsGet_580015(
    name: "gmailUsersDraftsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsGet_580016, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsGet_580017, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsDelete_580050 = ref object of OpenApiRestCall_579424
proc url_GmailUsersDraftsDelete_580052(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/drafts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersDraftsDelete_580051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the draft to delete.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580053 = path.getOrDefault("id")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "id", valid_580053
  var valid_580054 = path.getOrDefault("userId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = newJString("me"))
  if valid_580054 != nil:
    section.add "userId", valid_580054
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
  var valid_580055 = query.getOrDefault("fields")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "fields", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("userIp")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "userIp", valid_580059
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580062: Call_GmailUsersDraftsDelete_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_GmailUsersDraftsDelete_580050; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersDraftsDelete
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
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
  ##   id: string (required)
  ##     : The ID of the draft to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "userIp", newJString(userIp))
  add(path_580064, "id", newJString(id))
  add(query_580065, "key", newJString(key))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(path_580064, "userId", newJString(userId))
  result = call_580063.call(path_580064, query_580065, nil, nil, nil)

var gmailUsersDraftsDelete* = Call_GmailUsersDraftsDelete_580050(
    name: "gmailUsersDraftsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsDelete_580051, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsDelete_580052, schemes: {Scheme.Https})
type
  Call_GmailUsersHistoryList_580066 = ref object of OpenApiRestCall_579424
proc url_GmailUsersHistoryList_580068(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersHistoryList_580067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580069 = path.getOrDefault("userId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = newJString("me"))
  if valid_580069 != nil:
    section.add "userId", valid_580069
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   labelId: JString
  ##          : Only return messages with a label matching the ID.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   historyTypes: JArray
  ##               : History types to be returned by the function
  ##   startHistoryId: JString
  ##                 : Required. Returns history records after the specified startHistoryId. The supplied startHistoryId should be obtained from the historyId of a message, thread, or previous list response. History IDs increase chronologically but are not contiguous with random gaps in between valid IDs. Supplying an invalid or out of date startHistoryId typically returns an HTTP 404 error code. A historyId is typically valid for at least a week, but in some rare circumstances may be valid for only a few hours. If you receive an HTTP 404 error response, your application should perform a full sync. If you receive no nextPageToken in the response, there are no updates to retrieve and you can store the returned historyId for a future request.
  ##   maxResults: JInt
  ##             : The maximum number of history records to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("pageToken")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "pageToken", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("labelId")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "labelId", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("userIp")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userIp", valid_580076
  var valid_580077 = query.getOrDefault("historyTypes")
  valid_580077 = validateParameter(valid_580077, JArray, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "historyTypes", valid_580077
  var valid_580078 = query.getOrDefault("startHistoryId")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "startHistoryId", valid_580078
  var valid_580079 = query.getOrDefault("maxResults")
  valid_580079 = validateParameter(valid_580079, JInt, required = false,
                                 default = newJInt(100))
  if valid_580079 != nil:
    section.add "maxResults", valid_580079
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580082: Call_GmailUsersHistoryList_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ## 
  let valid = call_580082.validator(path, query, header, formData, body)
  let scheme = call_580082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580082.url(scheme.get, call_580082.host, call_580082.base,
                         call_580082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580082, url, valid)

proc call*(call_580083: Call_GmailUsersHistoryList_580066; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          labelId: string = ""; oauthToken: string = ""; userIp: string = "";
          historyTypes: JsonNode = nil; startHistoryId: string = "";
          maxResults: int = 100; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersHistoryList
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   labelId: string
  ##          : Only return messages with a label matching the ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   historyTypes: JArray
  ##               : History types to be returned by the function
  ##   startHistoryId: string
  ##                 : Required. Returns history records after the specified startHistoryId. The supplied startHistoryId should be obtained from the historyId of a message, thread, or previous list response. History IDs increase chronologically but are not contiguous with random gaps in between valid IDs. Supplying an invalid or out of date startHistoryId typically returns an HTTP 404 error code. A historyId is typically valid for at least a week, but in some rare circumstances may be valid for only a few hours. If you receive an HTTP 404 error response, your application should perform a full sync. If you receive no nextPageToken in the response, there are no updates to retrieve and you can store the returned historyId for a future request.
  ##   maxResults: int
  ##             : The maximum number of history records to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580084 = newJObject()
  var query_580085 = newJObject()
  add(query_580085, "fields", newJString(fields))
  add(query_580085, "pageToken", newJString(pageToken))
  add(query_580085, "quotaUser", newJString(quotaUser))
  add(query_580085, "alt", newJString(alt))
  add(query_580085, "labelId", newJString(labelId))
  add(query_580085, "oauth_token", newJString(oauthToken))
  add(query_580085, "userIp", newJString(userIp))
  if historyTypes != nil:
    query_580085.add "historyTypes", historyTypes
  add(query_580085, "startHistoryId", newJString(startHistoryId))
  add(query_580085, "maxResults", newJInt(maxResults))
  add(query_580085, "key", newJString(key))
  add(query_580085, "prettyPrint", newJBool(prettyPrint))
  add(path_580084, "userId", newJString(userId))
  result = call_580083.call(path_580084, query_580085, nil, nil, nil)

var gmailUsersHistoryList* = Call_GmailUsersHistoryList_580066(
    name: "gmailUsersHistoryList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/history",
    validator: validate_GmailUsersHistoryList_580067, base: "/gmail/v1/users",
    url: url_GmailUsersHistoryList_580068, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsCreate_580101 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsCreate_580103(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsCreate_580102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new label.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580104 = path.getOrDefault("userId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = newJString("me"))
  if valid_580104 != nil:
    section.add "userId", valid_580104
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
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("userIp")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "userIp", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
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

proc call*(call_580113: Call_GmailUsersLabelsCreate_580101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new label.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_GmailUsersLabelsCreate_580101; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersLabelsCreate
  ## Creates a new label.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  var body_580117 = newJObject()
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "userIp", newJString(userIp))
  add(query_580116, "key", newJString(key))
  if body != nil:
    body_580117 = body
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(path_580115, "userId", newJString(userId))
  result = call_580114.call(path_580115, query_580116, nil, nil, body_580117)

var gmailUsersLabelsCreate* = Call_GmailUsersLabelsCreate_580101(
    name: "gmailUsersLabelsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsCreate_580102, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsCreate_580103, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsList_580086 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsList_580088(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsList_580087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all labels in the user's mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580089 = path.getOrDefault("userId")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = newJString("me"))
  if valid_580089 != nil:
    section.add "userId", valid_580089
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
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580097: Call_GmailUsersLabelsList_580086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all labels in the user's mailbox.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_GmailUsersLabelsList_580086; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersLabelsList
  ## Lists all labels in the user's mailbox.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "userIp", newJString(userIp))
  add(query_580100, "key", newJString(key))
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  add(path_580099, "userId", newJString(userId))
  result = call_580098.call(path_580099, query_580100, nil, nil, nil)

var gmailUsersLabelsList* = Call_GmailUsersLabelsList_580086(
    name: "gmailUsersLabelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsList_580087, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsList_580088, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsUpdate_580134 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsUpdate_580136(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsUpdate_580135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified label.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the label to update.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580137 = path.getOrDefault("id")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "id", valid_580137
  var valid_580138 = path.getOrDefault("userId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = newJString("me"))
  if valid_580138 != nil:
    section.add "userId", valid_580138
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
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
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

proc call*(call_580147: Call_GmailUsersLabelsUpdate_580134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_GmailUsersLabelsUpdate_580134; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersLabelsUpdate
  ## Updates the specified label.
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
  ##   id: string (required)
  ##     : The ID of the label to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "userIp", newJString(userIp))
  add(path_580149, "id", newJString(id))
  add(query_580150, "key", newJString(key))
  if body != nil:
    body_580151 = body
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  add(path_580149, "userId", newJString(userId))
  result = call_580148.call(path_580149, query_580150, nil, nil, body_580151)

var gmailUsersLabelsUpdate* = Call_GmailUsersLabelsUpdate_580134(
    name: "gmailUsersLabelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsUpdate_580135, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsUpdate_580136, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsGet_580118 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsGet_580120(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsGet_580119(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified label.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the label to retrieve.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580121 = path.getOrDefault("id")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "id", valid_580121
  var valid_580122 = path.getOrDefault("userId")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = newJString("me"))
  if valid_580122 != nil:
    section.add "userId", valid_580122
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
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("userIp")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "userIp", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580130: Call_GmailUsersLabelsGet_580118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified label.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_GmailUsersLabelsGet_580118; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersLabelsGet
  ## Gets the specified label.
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
  ##   id: string (required)
  ##     : The ID of the label to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "userIp", newJString(userIp))
  add(path_580132, "id", newJString(id))
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(path_580132, "userId", newJString(userId))
  result = call_580131.call(path_580132, query_580133, nil, nil, nil)

var gmailUsersLabelsGet* = Call_GmailUsersLabelsGet_580118(
    name: "gmailUsersLabelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsGet_580119, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsGet_580120, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsPatch_580168 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsPatch_580170(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsPatch_580169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified label. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the label to update.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580171 = path.getOrDefault("id")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "id", valid_580171
  var valid_580172 = path.getOrDefault("userId")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = newJString("me"))
  if valid_580172 != nil:
    section.add "userId", valid_580172
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
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  var valid_580174 = query.getOrDefault("quotaUser")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "quotaUser", valid_580174
  var valid_580175 = query.getOrDefault("alt")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("json"))
  if valid_580175 != nil:
    section.add "alt", valid_580175
  var valid_580176 = query.getOrDefault("oauth_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "oauth_token", valid_580176
  var valid_580177 = query.getOrDefault("userIp")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "userIp", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
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

proc call*(call_580181: Call_GmailUsersLabelsPatch_580168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label. This method supports patch semantics.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_GmailUsersLabelsPatch_580168; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersLabelsPatch
  ## Updates the specified label. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The ID of the label to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  var body_580185 = newJObject()
  add(query_580184, "fields", newJString(fields))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "alt", newJString(alt))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "userIp", newJString(userIp))
  add(path_580183, "id", newJString(id))
  add(query_580184, "key", newJString(key))
  if body != nil:
    body_580185 = body
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  add(path_580183, "userId", newJString(userId))
  result = call_580182.call(path_580183, query_580184, nil, nil, body_580185)

var gmailUsersLabelsPatch* = Call_GmailUsersLabelsPatch_580168(
    name: "gmailUsersLabelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsPatch_580169, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsPatch_580170, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsDelete_580152 = ref object of OpenApiRestCall_579424
proc url_GmailUsersLabelsDelete_580154(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/labels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersLabelsDelete_580153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the label to delete.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580155 = path.getOrDefault("id")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "id", valid_580155
  var valid_580156 = path.getOrDefault("userId")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = newJString("me"))
  if valid_580156 != nil:
    section.add "userId", valid_580156
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
  var valid_580157 = query.getOrDefault("fields")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "fields", valid_580157
  var valid_580158 = query.getOrDefault("quotaUser")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "quotaUser", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("userIp")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "userIp", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580164: Call_GmailUsersLabelsDelete_580152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_GmailUsersLabelsDelete_580152; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersLabelsDelete
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
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
  ##   id: string (required)
  ##     : The ID of the label to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  add(query_580167, "fields", newJString(fields))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(query_580167, "alt", newJString(alt))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "userIp", newJString(userIp))
  add(path_580166, "id", newJString(id))
  add(query_580167, "key", newJString(key))
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  add(path_580166, "userId", newJString(userId))
  result = call_580165.call(path_580166, query_580167, nil, nil, nil)

var gmailUsersLabelsDelete* = Call_GmailUsersLabelsDelete_580152(
    name: "gmailUsersLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsDelete_580153, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsDelete_580154, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesInsert_580206 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesInsert_580208(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesInsert_580207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580209 = path.getOrDefault("userId")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = newJString("me"))
  if valid_580209 != nil:
    section.add "userId", valid_580209
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   internalDateSource: JString
  ##                     : Source for Gmail's internal date of the message.
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
  ##   deleted: JBool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  section = newJObject()
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("internalDateSource")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("receivedTime"))
  if valid_580211 != nil:
    section.add "internalDateSource", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("userIp")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "userIp", valid_580215
  var valid_580216 = query.getOrDefault("key")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "key", valid_580216
  var valid_580217 = query.getOrDefault("prettyPrint")
  valid_580217 = validateParameter(valid_580217, JBool, required = false,
                                 default = newJBool(true))
  if valid_580217 != nil:
    section.add "prettyPrint", valid_580217
  var valid_580218 = query.getOrDefault("deleted")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(false))
  if valid_580218 != nil:
    section.add "deleted", valid_580218
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

proc call*(call_580220: Call_GmailUsersMessagesInsert_580206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ## 
  let valid = call_580220.validator(path, query, header, formData, body)
  let scheme = call_580220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580220.url(scheme.get, call_580220.host, call_580220.base,
                         call_580220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580220, url, valid)

proc call*(call_580221: Call_GmailUsersMessagesInsert_580206; fields: string = "";
          internalDateSource: string = "receivedTime"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          deleted: bool = false; userId: string = "me"): Recallable =
  ## gmailUsersMessagesInsert
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   internalDateSource: string
  ##                     : Source for Gmail's internal date of the message.
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
  ##   deleted: bool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580222 = newJObject()
  var query_580223 = newJObject()
  var body_580224 = newJObject()
  add(query_580223, "fields", newJString(fields))
  add(query_580223, "internalDateSource", newJString(internalDateSource))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(query_580223, "userIp", newJString(userIp))
  add(query_580223, "key", newJString(key))
  if body != nil:
    body_580224 = body
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  add(query_580223, "deleted", newJBool(deleted))
  add(path_580222, "userId", newJString(userId))
  result = call_580221.call(path_580222, query_580223, nil, nil, body_580224)

var gmailUsersMessagesInsert* = Call_GmailUsersMessagesInsert_580206(
    name: "gmailUsersMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesInsert_580207, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesInsert_580208, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesList_580186 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesList_580188(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesList_580187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the messages in the user's mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580189 = path.getOrDefault("userId")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = newJString("me"))
  if valid_580189 != nil:
    section.add "userId", valid_580189
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of messages to return.
  ##   includeSpamTrash: JBool
  ##                   : Include messages from SPAM and TRASH in the results.
  ##   q: JString
  ##    : Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid:<somemsgid@example.com> is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   labelIds: JArray
  ##           : Only return messages with labels that match all of the specified label IDs.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("pageToken")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "pageToken", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("userIp")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "userIp", valid_580195
  var valid_580196 = query.getOrDefault("maxResults")
  valid_580196 = validateParameter(valid_580196, JInt, required = false,
                                 default = newJInt(100))
  if valid_580196 != nil:
    section.add "maxResults", valid_580196
  var valid_580197 = query.getOrDefault("includeSpamTrash")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(false))
  if valid_580197 != nil:
    section.add "includeSpamTrash", valid_580197
  var valid_580198 = query.getOrDefault("q")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "q", valid_580198
  var valid_580199 = query.getOrDefault("labelIds")
  valid_580199 = validateParameter(valid_580199, JArray, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "labelIds", valid_580199
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580202: Call_GmailUsersMessagesList_580186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the messages in the user's mailbox.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_GmailUsersMessagesList_580186; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 100;
          includeSpamTrash: bool = false; q: string = ""; labelIds: JsonNode = nil;
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesList
  ## Lists the messages in the user's mailbox.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of messages to return.
  ##   includeSpamTrash: bool
  ##                   : Include messages from SPAM and TRASH in the results.
  ##   q: string
  ##    : Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid:<somemsgid@example.com> is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   labelIds: JArray
  ##           : Only return messages with labels that match all of the specified label IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "pageToken", newJString(pageToken))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "userIp", newJString(userIp))
  add(query_580205, "maxResults", newJInt(maxResults))
  add(query_580205, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_580205, "q", newJString(q))
  if labelIds != nil:
    query_580205.add "labelIds", labelIds
  add(query_580205, "key", newJString(key))
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  add(path_580204, "userId", newJString(userId))
  result = call_580203.call(path_580204, query_580205, nil, nil, nil)

var gmailUsersMessagesList* = Call_GmailUsersMessagesList_580186(
    name: "gmailUsersMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesList_580187, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesList_580188, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchDelete_580225 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesBatchDelete_580227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesBatchDelete_580226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580228 = path.getOrDefault("userId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = newJString("me"))
  if valid_580228 != nil:
    section.add "userId", valid_580228
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
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("userIp")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "userIp", valid_580233
  var valid_580234 = query.getOrDefault("key")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "key", valid_580234
  var valid_580235 = query.getOrDefault("prettyPrint")
  valid_580235 = validateParameter(valid_580235, JBool, required = false,
                                 default = newJBool(true))
  if valid_580235 != nil:
    section.add "prettyPrint", valid_580235
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

proc call*(call_580237: Call_GmailUsersMessagesBatchDelete_580225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_GmailUsersMessagesBatchDelete_580225;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesBatchDelete
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  var body_580241 = newJObject()
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "userIp", newJString(userIp))
  add(query_580240, "key", newJString(key))
  if body != nil:
    body_580241 = body
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(path_580239, "userId", newJString(userId))
  result = call_580238.call(path_580239, query_580240, nil, nil, body_580241)

var gmailUsersMessagesBatchDelete* = Call_GmailUsersMessagesBatchDelete_580225(
    name: "gmailUsersMessagesBatchDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchDelete",
    validator: validate_GmailUsersMessagesBatchDelete_580226,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchDelete_580227,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchModify_580242 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesBatchModify_580244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/batchModify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesBatchModify_580243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the labels on the specified messages.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580245 = path.getOrDefault("userId")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = newJString("me"))
  if valid_580245 != nil:
    section.add "userId", valid_580245
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
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("userIp")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userIp", valid_580250
  var valid_580251 = query.getOrDefault("key")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "key", valid_580251
  var valid_580252 = query.getOrDefault("prettyPrint")
  valid_580252 = validateParameter(valid_580252, JBool, required = false,
                                 default = newJBool(true))
  if valid_580252 != nil:
    section.add "prettyPrint", valid_580252
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

proc call*(call_580254: Call_GmailUsersMessagesBatchModify_580242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified messages.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_GmailUsersMessagesBatchModify_580242;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesBatchModify
  ## Modifies the labels on the specified messages.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  var body_580258 = newJObject()
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "userIp", newJString(userIp))
  add(query_580257, "key", newJString(key))
  if body != nil:
    body_580258 = body
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  add(path_580256, "userId", newJString(userId))
  result = call_580255.call(path_580256, query_580257, nil, nil, body_580258)

var gmailUsersMessagesBatchModify* = Call_GmailUsersMessagesBatchModify_580242(
    name: "gmailUsersMessagesBatchModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchModify",
    validator: validate_GmailUsersMessagesBatchModify_580243,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchModify_580244,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesImport_580259 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesImport_580261(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesImport_580260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580262 = path.getOrDefault("userId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = newJString("me"))
  if valid_580262 != nil:
    section.add "userId", valid_580262
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   internalDateSource: JString
  ##                     : Source for Gmail's internal date of the message.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   neverMarkSpam: JBool
  ##                : Ignore the Gmail spam classifier decision and never mark this email as SPAM in the mailbox.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   processForCalendar: JBool
  ##                     : Process calendar invites in the email and add any extracted meetings to the Google Calendar for this user.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   deleted: JBool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  section = newJObject()
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("internalDateSource")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("dateHeader"))
  if valid_580264 != nil:
    section.add "internalDateSource", valid_580264
  var valid_580265 = query.getOrDefault("quotaUser")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "quotaUser", valid_580265
  var valid_580266 = query.getOrDefault("alt")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("json"))
  if valid_580266 != nil:
    section.add "alt", valid_580266
  var valid_580267 = query.getOrDefault("oauth_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "oauth_token", valid_580267
  var valid_580268 = query.getOrDefault("userIp")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "userIp", valid_580268
  var valid_580269 = query.getOrDefault("neverMarkSpam")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(false))
  if valid_580269 != nil:
    section.add "neverMarkSpam", valid_580269
  var valid_580270 = query.getOrDefault("key")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "key", valid_580270
  var valid_580271 = query.getOrDefault("processForCalendar")
  valid_580271 = validateParameter(valid_580271, JBool, required = false,
                                 default = newJBool(false))
  if valid_580271 != nil:
    section.add "processForCalendar", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  var valid_580273 = query.getOrDefault("deleted")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(false))
  if valid_580273 != nil:
    section.add "deleted", valid_580273
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

proc call*(call_580275: Call_GmailUsersMessagesImport_580259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ## 
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_GmailUsersMessagesImport_580259; fields: string = "";
          internalDateSource: string = "dateHeader"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          neverMarkSpam: bool = false; key: string = "";
          processForCalendar: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true; deleted: bool = false; userId: string = "me"): Recallable =
  ## gmailUsersMessagesImport
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   internalDateSource: string
  ##                     : Source for Gmail's internal date of the message.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   neverMarkSpam: bool
  ##                : Ignore the Gmail spam classifier decision and never mark this email as SPAM in the mailbox.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   processForCalendar: bool
  ##                     : Process calendar invites in the email and add any extracted meetings to the Google Calendar for this user.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   deleted: bool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  var body_580279 = newJObject()
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "internalDateSource", newJString(internalDateSource))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(query_580278, "userIp", newJString(userIp))
  add(query_580278, "neverMarkSpam", newJBool(neverMarkSpam))
  add(query_580278, "key", newJString(key))
  add(query_580278, "processForCalendar", newJBool(processForCalendar))
  if body != nil:
    body_580279 = body
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(query_580278, "deleted", newJBool(deleted))
  add(path_580277, "userId", newJString(userId))
  result = call_580276.call(path_580277, query_580278, nil, nil, body_580279)

var gmailUsersMessagesImport* = Call_GmailUsersMessagesImport_580259(
    name: "gmailUsersMessagesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/import",
    validator: validate_GmailUsersMessagesImport_580260, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesImport_580261, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesSend_580280 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesSend_580282(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/send")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesSend_580281(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580283 = path.getOrDefault("userId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = newJString("me"))
  if valid_580283 != nil:
    section.add "userId", valid_580283
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
  var valid_580284 = query.getOrDefault("fields")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "fields", valid_580284
  var valid_580285 = query.getOrDefault("quotaUser")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "quotaUser", valid_580285
  var valid_580286 = query.getOrDefault("alt")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("json"))
  if valid_580286 != nil:
    section.add "alt", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("userIp")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "userIp", valid_580288
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
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

proc call*(call_580292: Call_GmailUsersMessagesSend_580280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_GmailUsersMessagesSend_580280; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesSend
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  var body_580296 = newJObject()
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "userIp", newJString(userIp))
  add(query_580295, "key", newJString(key))
  if body != nil:
    body_580296 = body
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(path_580294, "userId", newJString(userId))
  result = call_580293.call(path_580294, query_580295, nil, nil, body_580296)

var gmailUsersMessagesSend* = Call_GmailUsersMessagesSend_580280(
    name: "gmailUsersMessagesSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/send",
    validator: validate_GmailUsersMessagesSend_580281, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesSend_580282, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesGet_580297 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesGet_580299(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesGet_580298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the message to retrieve.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580300 = path.getOrDefault("id")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "id", valid_580300
  var valid_580301 = path.getOrDefault("userId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = newJString("me"))
  if valid_580301 != nil:
    section.add "userId", valid_580301
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
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : The format to return the message in.
  section = newJObject()
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("userIp")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userIp", valid_580306
  var valid_580307 = query.getOrDefault("metadataHeaders")
  valid_580307 = validateParameter(valid_580307, JArray, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "metadataHeaders", valid_580307
  var valid_580308 = query.getOrDefault("key")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "key", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
  var valid_580310 = query.getOrDefault("format")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("full"))
  if valid_580310 != nil:
    section.add "format", valid_580310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580311: Call_GmailUsersMessagesGet_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified message.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_GmailUsersMessagesGet_580297; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; metadataHeaders: JsonNode = nil;
          key: string = ""; prettyPrint: bool = true; format: string = "full";
          userId: string = "me"): Recallable =
  ## gmailUsersMessagesGet
  ## Gets the specified message.
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
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   id: string (required)
  ##     : The ID of the message to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The format to return the message in.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  add(query_580314, "fields", newJString(fields))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(query_580314, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_580314.add "metadataHeaders", metadataHeaders
  add(path_580313, "id", newJString(id))
  add(query_580314, "key", newJString(key))
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  add(query_580314, "format", newJString(format))
  add(path_580313, "userId", newJString(userId))
  result = call_580312.call(path_580313, query_580314, nil, nil, nil)

var gmailUsersMessagesGet* = Call_GmailUsersMessagesGet_580297(
    name: "gmailUsersMessagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesGet_580298, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesGet_580299, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesDelete_580315 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesDelete_580317(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesDelete_580316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the message to delete.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580318 = path.getOrDefault("id")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "id", valid_580318
  var valid_580319 = path.getOrDefault("userId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = newJString("me"))
  if valid_580319 != nil:
    section.add "userId", valid_580319
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
  var valid_580320 = query.getOrDefault("fields")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "fields", valid_580320
  var valid_580321 = query.getOrDefault("quotaUser")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "quotaUser", valid_580321
  var valid_580322 = query.getOrDefault("alt")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("json"))
  if valid_580322 != nil:
    section.add "alt", valid_580322
  var valid_580323 = query.getOrDefault("oauth_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "oauth_token", valid_580323
  var valid_580324 = query.getOrDefault("userIp")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "userIp", valid_580324
  var valid_580325 = query.getOrDefault("key")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "key", valid_580325
  var valid_580326 = query.getOrDefault("prettyPrint")
  valid_580326 = validateParameter(valid_580326, JBool, required = false,
                                 default = newJBool(true))
  if valid_580326 != nil:
    section.add "prettyPrint", valid_580326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580327: Call_GmailUsersMessagesDelete_580315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ## 
  let valid = call_580327.validator(path, query, header, formData, body)
  let scheme = call_580327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580327.url(scheme.get, call_580327.host, call_580327.base,
                         call_580327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580327, url, valid)

proc call*(call_580328: Call_GmailUsersMessagesDelete_580315; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesDelete
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
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
  ##   id: string (required)
  ##     : The ID of the message to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580329 = newJObject()
  var query_580330 = newJObject()
  add(query_580330, "fields", newJString(fields))
  add(query_580330, "quotaUser", newJString(quotaUser))
  add(query_580330, "alt", newJString(alt))
  add(query_580330, "oauth_token", newJString(oauthToken))
  add(query_580330, "userIp", newJString(userIp))
  add(path_580329, "id", newJString(id))
  add(query_580330, "key", newJString(key))
  add(query_580330, "prettyPrint", newJBool(prettyPrint))
  add(path_580329, "userId", newJString(userId))
  result = call_580328.call(path_580329, query_580330, nil, nil, nil)

var gmailUsersMessagesDelete* = Call_GmailUsersMessagesDelete_580315(
    name: "gmailUsersMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesDelete_580316, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesDelete_580317, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesModify_580331 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesModify_580333(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/modify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesModify_580332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the labels on the specified message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the message to modify.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580334 = path.getOrDefault("id")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "id", valid_580334
  var valid_580335 = path.getOrDefault("userId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = newJString("me"))
  if valid_580335 != nil:
    section.add "userId", valid_580335
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
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("oauth_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "oauth_token", valid_580339
  var valid_580340 = query.getOrDefault("userIp")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "userIp", valid_580340
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("prettyPrint")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "prettyPrint", valid_580342
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

proc call*(call_580344: Call_GmailUsersMessagesModify_580331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified message.
  ## 
  let valid = call_580344.validator(path, query, header, formData, body)
  let scheme = call_580344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580344.url(scheme.get, call_580344.host, call_580344.base,
                         call_580344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580344, url, valid)

proc call*(call_580345: Call_GmailUsersMessagesModify_580331; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesModify
  ## Modifies the labels on the specified message.
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
  ##   id: string (required)
  ##     : The ID of the message to modify.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580346 = newJObject()
  var query_580347 = newJObject()
  var body_580348 = newJObject()
  add(query_580347, "fields", newJString(fields))
  add(query_580347, "quotaUser", newJString(quotaUser))
  add(query_580347, "alt", newJString(alt))
  add(query_580347, "oauth_token", newJString(oauthToken))
  add(query_580347, "userIp", newJString(userIp))
  add(path_580346, "id", newJString(id))
  add(query_580347, "key", newJString(key))
  if body != nil:
    body_580348 = body
  add(query_580347, "prettyPrint", newJBool(prettyPrint))
  add(path_580346, "userId", newJString(userId))
  result = call_580345.call(path_580346, query_580347, nil, nil, body_580348)

var gmailUsersMessagesModify* = Call_GmailUsersMessagesModify_580331(
    name: "gmailUsersMessagesModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/modify",
    validator: validate_GmailUsersMessagesModify_580332, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesModify_580333, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesTrash_580349 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesTrash_580351(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/trash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesTrash_580350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves the specified message to the trash.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the message to Trash.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580352 = path.getOrDefault("id")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "id", valid_580352
  var valid_580353 = path.getOrDefault("userId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = newJString("me"))
  if valid_580353 != nil:
    section.add "userId", valid_580353
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
  var valid_580354 = query.getOrDefault("fields")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "fields", valid_580354
  var valid_580355 = query.getOrDefault("quotaUser")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "quotaUser", valid_580355
  var valid_580356 = query.getOrDefault("alt")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("json"))
  if valid_580356 != nil:
    section.add "alt", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("userIp")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "userIp", valid_580358
  var valid_580359 = query.getOrDefault("key")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "key", valid_580359
  var valid_580360 = query.getOrDefault("prettyPrint")
  valid_580360 = validateParameter(valid_580360, JBool, required = false,
                                 default = newJBool(true))
  if valid_580360 != nil:
    section.add "prettyPrint", valid_580360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580361: Call_GmailUsersMessagesTrash_580349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified message to the trash.
  ## 
  let valid = call_580361.validator(path, query, header, formData, body)
  let scheme = call_580361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580361.url(scheme.get, call_580361.host, call_580361.base,
                         call_580361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580361, url, valid)

proc call*(call_580362: Call_GmailUsersMessagesTrash_580349; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesTrash
  ## Moves the specified message to the trash.
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
  ##   id: string (required)
  ##     : The ID of the message to Trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580363 = newJObject()
  var query_580364 = newJObject()
  add(query_580364, "fields", newJString(fields))
  add(query_580364, "quotaUser", newJString(quotaUser))
  add(query_580364, "alt", newJString(alt))
  add(query_580364, "oauth_token", newJString(oauthToken))
  add(query_580364, "userIp", newJString(userIp))
  add(path_580363, "id", newJString(id))
  add(query_580364, "key", newJString(key))
  add(query_580364, "prettyPrint", newJBool(prettyPrint))
  add(path_580363, "userId", newJString(userId))
  result = call_580362.call(path_580363, query_580364, nil, nil, nil)

var gmailUsersMessagesTrash* = Call_GmailUsersMessagesTrash_580349(
    name: "gmailUsersMessagesTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/trash",
    validator: validate_GmailUsersMessagesTrash_580350, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesTrash_580351, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesUntrash_580365 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesUntrash_580367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/untrash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesUntrash_580366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the specified message from the trash.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the message to remove from Trash.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580368 = path.getOrDefault("id")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "id", valid_580368
  var valid_580369 = path.getOrDefault("userId")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = newJString("me"))
  if valid_580369 != nil:
    section.add "userId", valid_580369
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
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("quotaUser")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "quotaUser", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("oauth_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "oauth_token", valid_580373
  var valid_580374 = query.getOrDefault("userIp")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "userIp", valid_580374
  var valid_580375 = query.getOrDefault("key")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "key", valid_580375
  var valid_580376 = query.getOrDefault("prettyPrint")
  valid_580376 = validateParameter(valid_580376, JBool, required = false,
                                 default = newJBool(true))
  if valid_580376 != nil:
    section.add "prettyPrint", valid_580376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580377: Call_GmailUsersMessagesUntrash_580365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified message from the trash.
  ## 
  let valid = call_580377.validator(path, query, header, formData, body)
  let scheme = call_580377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580377.url(scheme.get, call_580377.host, call_580377.base,
                         call_580377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580377, url, valid)

proc call*(call_580378: Call_GmailUsersMessagesUntrash_580365; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesUntrash
  ## Removes the specified message from the trash.
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
  ##   id: string (required)
  ##     : The ID of the message to remove from Trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580379 = newJObject()
  var query_580380 = newJObject()
  add(query_580380, "fields", newJString(fields))
  add(query_580380, "quotaUser", newJString(quotaUser))
  add(query_580380, "alt", newJString(alt))
  add(query_580380, "oauth_token", newJString(oauthToken))
  add(query_580380, "userIp", newJString(userIp))
  add(path_580379, "id", newJString(id))
  add(query_580380, "key", newJString(key))
  add(query_580380, "prettyPrint", newJBool(prettyPrint))
  add(path_580379, "userId", newJString(userId))
  result = call_580378.call(path_580379, query_580380, nil, nil, nil)

var gmailUsersMessagesUntrash* = Call_GmailUsersMessagesUntrash_580365(
    name: "gmailUsersMessagesUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/untrash",
    validator: validate_GmailUsersMessagesUntrash_580366, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesUntrash_580367, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesAttachmentsGet_580381 = ref object of OpenApiRestCall_579424
proc url_GmailUsersMessagesAttachmentsGet_580383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "messageId" in path, "`messageId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/messages/"),
               (kind: VariableSegment, value: "messageId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersMessagesAttachmentsGet_580382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified message attachment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   messageId: JString (required)
  ##            : The ID of the message containing the attachment.
  ##   id: JString (required)
  ##     : The ID of the attachment.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `messageId` field"
  var valid_580384 = path.getOrDefault("messageId")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "messageId", valid_580384
  var valid_580385 = path.getOrDefault("id")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "id", valid_580385
  var valid_580386 = path.getOrDefault("userId")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = newJString("me"))
  if valid_580386 != nil:
    section.add "userId", valid_580386
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
  var valid_580387 = query.getOrDefault("fields")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "fields", valid_580387
  var valid_580388 = query.getOrDefault("quotaUser")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "quotaUser", valid_580388
  var valid_580389 = query.getOrDefault("alt")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = newJString("json"))
  if valid_580389 != nil:
    section.add "alt", valid_580389
  var valid_580390 = query.getOrDefault("oauth_token")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "oauth_token", valid_580390
  var valid_580391 = query.getOrDefault("userIp")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "userIp", valid_580391
  var valid_580392 = query.getOrDefault("key")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "key", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(true))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580394: Call_GmailUsersMessagesAttachmentsGet_580381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified message attachment.
  ## 
  let valid = call_580394.validator(path, query, header, formData, body)
  let scheme = call_580394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580394.url(scheme.get, call_580394.host, call_580394.base,
                         call_580394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580394, url, valid)

proc call*(call_580395: Call_GmailUsersMessagesAttachmentsGet_580381;
          messageId: string; id: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersMessagesAttachmentsGet
  ## Gets the specified message attachment.
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
  ##   messageId: string (required)
  ##            : The ID of the message containing the attachment.
  ##   id: string (required)
  ##     : The ID of the attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580396 = newJObject()
  var query_580397 = newJObject()
  add(query_580397, "fields", newJString(fields))
  add(query_580397, "quotaUser", newJString(quotaUser))
  add(query_580397, "alt", newJString(alt))
  add(query_580397, "oauth_token", newJString(oauthToken))
  add(query_580397, "userIp", newJString(userIp))
  add(path_580396, "messageId", newJString(messageId))
  add(path_580396, "id", newJString(id))
  add(query_580397, "key", newJString(key))
  add(query_580397, "prettyPrint", newJBool(prettyPrint))
  add(path_580396, "userId", newJString(userId))
  result = call_580395.call(path_580396, query_580397, nil, nil, nil)

var gmailUsersMessagesAttachmentsGet* = Call_GmailUsersMessagesAttachmentsGet_580381(
    name: "gmailUsersMessagesAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/messages/{messageId}/attachments/{id}",
    validator: validate_GmailUsersMessagesAttachmentsGet_580382,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesAttachmentsGet_580383,
    schemes: {Scheme.Https})
type
  Call_GmailUsersGetProfile_580398 = ref object of OpenApiRestCall_579424
proc url_GmailUsersGetProfile_580400(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/profile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersGetProfile_580399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current user's Gmail profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580401 = path.getOrDefault("userId")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = newJString("me"))
  if valid_580401 != nil:
    section.add "userId", valid_580401
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
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("userIp")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "userIp", valid_580406
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580409: Call_GmailUsersGetProfile_580398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current user's Gmail profile.
  ## 
  let valid = call_580409.validator(path, query, header, formData, body)
  let scheme = call_580409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580409.url(scheme.get, call_580409.host, call_580409.base,
                         call_580409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580409, url, valid)

proc call*(call_580410: Call_GmailUsersGetProfile_580398; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersGetProfile
  ## Gets the current user's Gmail profile.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580411 = newJObject()
  var query_580412 = newJObject()
  add(query_580412, "fields", newJString(fields))
  add(query_580412, "quotaUser", newJString(quotaUser))
  add(query_580412, "alt", newJString(alt))
  add(query_580412, "oauth_token", newJString(oauthToken))
  add(query_580412, "userIp", newJString(userIp))
  add(query_580412, "key", newJString(key))
  add(query_580412, "prettyPrint", newJBool(prettyPrint))
  add(path_580411, "userId", newJString(userId))
  result = call_580410.call(path_580411, query_580412, nil, nil, nil)

var gmailUsersGetProfile* = Call_GmailUsersGetProfile_580398(
    name: "gmailUsersGetProfile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/profile",
    validator: validate_GmailUsersGetProfile_580399, base: "/gmail/v1/users",
    url: url_GmailUsersGetProfile_580400, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateAutoForwarding_580428 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsUpdateAutoForwarding_580430(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/autoForwarding")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsUpdateAutoForwarding_580429(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580431 = path.getOrDefault("userId")
  valid_580431 = validateParameter(valid_580431, JString, required = true,
                                 default = newJString("me"))
  if valid_580431 != nil:
    section.add "userId", valid_580431
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
  var valid_580432 = query.getOrDefault("fields")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fields", valid_580432
  var valid_580433 = query.getOrDefault("quotaUser")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "quotaUser", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("userIp")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "userIp", valid_580436
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
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

proc call*(call_580440: Call_GmailUsersSettingsUpdateAutoForwarding_580428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580440.validator(path, query, header, formData, body)
  let scheme = call_580440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580440.url(scheme.get, call_580440.host, call_580440.base,
                         call_580440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580440, url, valid)

proc call*(call_580441: Call_GmailUsersSettingsUpdateAutoForwarding_580428;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsUpdateAutoForwarding
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580442 = newJObject()
  var query_580443 = newJObject()
  var body_580444 = newJObject()
  add(query_580443, "fields", newJString(fields))
  add(query_580443, "quotaUser", newJString(quotaUser))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(query_580443, "userIp", newJString(userIp))
  add(query_580443, "key", newJString(key))
  if body != nil:
    body_580444 = body
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  add(path_580442, "userId", newJString(userId))
  result = call_580441.call(path_580442, query_580443, nil, nil, body_580444)

var gmailUsersSettingsUpdateAutoForwarding* = Call_GmailUsersSettingsUpdateAutoForwarding_580428(
    name: "gmailUsersSettingsUpdateAutoForwarding", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsUpdateAutoForwarding_580429,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateAutoForwarding_580430,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetAutoForwarding_580413 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsGetAutoForwarding_580415(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/autoForwarding")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsGetAutoForwarding_580414(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the auto-forwarding setting for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580416 = path.getOrDefault("userId")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = newJString("me"))
  if valid_580416 != nil:
    section.add "userId", valid_580416
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
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("oauth_token")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "oauth_token", valid_580420
  var valid_580421 = query.getOrDefault("userIp")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "userIp", valid_580421
  var valid_580422 = query.getOrDefault("key")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "key", valid_580422
  var valid_580423 = query.getOrDefault("prettyPrint")
  valid_580423 = validateParameter(valid_580423, JBool, required = false,
                                 default = newJBool(true))
  if valid_580423 != nil:
    section.add "prettyPrint", valid_580423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580424: Call_GmailUsersSettingsGetAutoForwarding_580413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the auto-forwarding setting for the specified account.
  ## 
  let valid = call_580424.validator(path, query, header, formData, body)
  let scheme = call_580424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580424.url(scheme.get, call_580424.host, call_580424.base,
                         call_580424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580424, url, valid)

proc call*(call_580425: Call_GmailUsersSettingsGetAutoForwarding_580413;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsGetAutoForwarding
  ## Gets the auto-forwarding setting for the specified account.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580426 = newJObject()
  var query_580427 = newJObject()
  add(query_580427, "fields", newJString(fields))
  add(query_580427, "quotaUser", newJString(quotaUser))
  add(query_580427, "alt", newJString(alt))
  add(query_580427, "oauth_token", newJString(oauthToken))
  add(query_580427, "userIp", newJString(userIp))
  add(query_580427, "key", newJString(key))
  add(query_580427, "prettyPrint", newJBool(prettyPrint))
  add(path_580426, "userId", newJString(userId))
  result = call_580425.call(path_580426, query_580427, nil, nil, nil)

var gmailUsersSettingsGetAutoForwarding* = Call_GmailUsersSettingsGetAutoForwarding_580413(
    name: "gmailUsersSettingsGetAutoForwarding", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsGetAutoForwarding_580414,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetAutoForwarding_580415,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesCreate_580460 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsDelegatesCreate_580462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/delegates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsDelegatesCreate_580461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a delegate with its verification status set directly to accepted, without sending any verification email. The delegate user must be a member of the same G Suite organization as the delegator user.
  ## 
  ## Gmail imposes limtations on the number of delegates and delegators each user in a G Suite organization can have. These limits depend on your organization, but in general each user can have up to 25 delegates and up to 10 delegators.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## Also note that when a new delegate is created, there may be up to a one minute delay before the new delegate is available for use.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580463 = path.getOrDefault("userId")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = newJString("me"))
  if valid_580463 != nil:
    section.add "userId", valid_580463
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
  var valid_580464 = query.getOrDefault("fields")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fields", valid_580464
  var valid_580465 = query.getOrDefault("quotaUser")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "quotaUser", valid_580465
  var valid_580466 = query.getOrDefault("alt")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = newJString("json"))
  if valid_580466 != nil:
    section.add "alt", valid_580466
  var valid_580467 = query.getOrDefault("oauth_token")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "oauth_token", valid_580467
  var valid_580468 = query.getOrDefault("userIp")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "userIp", valid_580468
  var valid_580469 = query.getOrDefault("key")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "key", valid_580469
  var valid_580470 = query.getOrDefault("prettyPrint")
  valid_580470 = validateParameter(valid_580470, JBool, required = false,
                                 default = newJBool(true))
  if valid_580470 != nil:
    section.add "prettyPrint", valid_580470
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

proc call*(call_580472: Call_GmailUsersSettingsDelegatesCreate_580460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a delegate with its verification status set directly to accepted, without sending any verification email. The delegate user must be a member of the same G Suite organization as the delegator user.
  ## 
  ## Gmail imposes limtations on the number of delegates and delegators each user in a G Suite organization can have. These limits depend on your organization, but in general each user can have up to 25 delegates and up to 10 delegators.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## Also note that when a new delegate is created, there may be up to a one minute delay before the new delegate is available for use.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580472.validator(path, query, header, formData, body)
  let scheme = call_580472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580472.url(scheme.get, call_580472.host, call_580472.base,
                         call_580472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580472, url, valid)

proc call*(call_580473: Call_GmailUsersSettingsDelegatesCreate_580460;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsDelegatesCreate
  ## Adds a delegate with its verification status set directly to accepted, without sending any verification email. The delegate user must be a member of the same G Suite organization as the delegator user.
  ## 
  ## Gmail imposes limtations on the number of delegates and delegators each user in a G Suite organization can have. These limits depend on your organization, but in general each user can have up to 25 delegates and up to 10 delegators.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## Also note that when a new delegate is created, there may be up to a one minute delay before the new delegate is available for use.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580474 = newJObject()
  var query_580475 = newJObject()
  var body_580476 = newJObject()
  add(query_580475, "fields", newJString(fields))
  add(query_580475, "quotaUser", newJString(quotaUser))
  add(query_580475, "alt", newJString(alt))
  add(query_580475, "oauth_token", newJString(oauthToken))
  add(query_580475, "userIp", newJString(userIp))
  add(query_580475, "key", newJString(key))
  if body != nil:
    body_580476 = body
  add(query_580475, "prettyPrint", newJBool(prettyPrint))
  add(path_580474, "userId", newJString(userId))
  result = call_580473.call(path_580474, query_580475, nil, nil, body_580476)

var gmailUsersSettingsDelegatesCreate* = Call_GmailUsersSettingsDelegatesCreate_580460(
    name: "gmailUsersSettingsDelegatesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesCreate_580461,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesCreate_580462,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesList_580445 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsDelegatesList_580447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/delegates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsDelegatesList_580446(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580448 = path.getOrDefault("userId")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = newJString("me"))
  if valid_580448 != nil:
    section.add "userId", valid_580448
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
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("key")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "key", valid_580454
  var valid_580455 = query.getOrDefault("prettyPrint")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(true))
  if valid_580455 != nil:
    section.add "prettyPrint", valid_580455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580456: Call_GmailUsersSettingsDelegatesList_580445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580456.validator(path, query, header, formData, body)
  let scheme = call_580456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580456.url(scheme.get, call_580456.host, call_580456.base,
                         call_580456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580456, url, valid)

proc call*(call_580457: Call_GmailUsersSettingsDelegatesList_580445;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsDelegatesList
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580458 = newJObject()
  var query_580459 = newJObject()
  add(query_580459, "fields", newJString(fields))
  add(query_580459, "quotaUser", newJString(quotaUser))
  add(query_580459, "alt", newJString(alt))
  add(query_580459, "oauth_token", newJString(oauthToken))
  add(query_580459, "userIp", newJString(userIp))
  add(query_580459, "key", newJString(key))
  add(query_580459, "prettyPrint", newJBool(prettyPrint))
  add(path_580458, "userId", newJString(userId))
  result = call_580457.call(path_580458, query_580459, nil, nil, nil)

var gmailUsersSettingsDelegatesList* = Call_GmailUsersSettingsDelegatesList_580445(
    name: "gmailUsersSettingsDelegatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesList_580446,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesList_580447,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesGet_580477 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsDelegatesGet_580479(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "delegateEmail" in path, "`delegateEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/delegates/"),
               (kind: VariableSegment, value: "delegateEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsDelegatesGet_580478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   delegateEmail: JString (required)
  ##                : The email address of the user whose delegate relationship is to be retrieved.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `delegateEmail` field"
  var valid_580480 = path.getOrDefault("delegateEmail")
  valid_580480 = validateParameter(valid_580480, JString, required = true,
                                 default = nil)
  if valid_580480 != nil:
    section.add "delegateEmail", valid_580480
  var valid_580481 = path.getOrDefault("userId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = newJString("me"))
  if valid_580481 != nil:
    section.add "userId", valid_580481
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
  var valid_580482 = query.getOrDefault("fields")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "fields", valid_580482
  var valid_580483 = query.getOrDefault("quotaUser")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "quotaUser", valid_580483
  var valid_580484 = query.getOrDefault("alt")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = newJString("json"))
  if valid_580484 != nil:
    section.add "alt", valid_580484
  var valid_580485 = query.getOrDefault("oauth_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "oauth_token", valid_580485
  var valid_580486 = query.getOrDefault("userIp")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "userIp", valid_580486
  var valid_580487 = query.getOrDefault("key")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "key", valid_580487
  var valid_580488 = query.getOrDefault("prettyPrint")
  valid_580488 = validateParameter(valid_580488, JBool, required = false,
                                 default = newJBool(true))
  if valid_580488 != nil:
    section.add "prettyPrint", valid_580488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580489: Call_GmailUsersSettingsDelegatesGet_580477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580489.validator(path, query, header, formData, body)
  let scheme = call_580489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580489.url(scheme.get, call_580489.host, call_580489.base,
                         call_580489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580489, url, valid)

proc call*(call_580490: Call_GmailUsersSettingsDelegatesGet_580477;
          delegateEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsDelegatesGet
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   delegateEmail: string (required)
  ##                : The email address of the user whose delegate relationship is to be retrieved.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580491 = newJObject()
  var query_580492 = newJObject()
  add(query_580492, "fields", newJString(fields))
  add(query_580492, "quotaUser", newJString(quotaUser))
  add(query_580492, "alt", newJString(alt))
  add(path_580491, "delegateEmail", newJString(delegateEmail))
  add(query_580492, "oauth_token", newJString(oauthToken))
  add(query_580492, "userIp", newJString(userIp))
  add(query_580492, "key", newJString(key))
  add(query_580492, "prettyPrint", newJBool(prettyPrint))
  add(path_580491, "userId", newJString(userId))
  result = call_580490.call(path_580491, query_580492, nil, nil, nil)

var gmailUsersSettingsDelegatesGet* = Call_GmailUsersSettingsDelegatesGet_580477(
    name: "gmailUsersSettingsDelegatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesGet_580478,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesGet_580479,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesDelete_580493 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsDelegatesDelete_580495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "delegateEmail" in path, "`delegateEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/delegates/"),
               (kind: VariableSegment, value: "delegateEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsDelegatesDelete_580494(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   delegateEmail: JString (required)
  ##                : The email address of the user to be removed as a delegate.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `delegateEmail` field"
  var valid_580496 = path.getOrDefault("delegateEmail")
  valid_580496 = validateParameter(valid_580496, JString, required = true,
                                 default = nil)
  if valid_580496 != nil:
    section.add "delegateEmail", valid_580496
  var valid_580497 = path.getOrDefault("userId")
  valid_580497 = validateParameter(valid_580497, JString, required = true,
                                 default = newJString("me"))
  if valid_580497 != nil:
    section.add "userId", valid_580497
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
  var valid_580498 = query.getOrDefault("fields")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "fields", valid_580498
  var valid_580499 = query.getOrDefault("quotaUser")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "quotaUser", valid_580499
  var valid_580500 = query.getOrDefault("alt")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = newJString("json"))
  if valid_580500 != nil:
    section.add "alt", valid_580500
  var valid_580501 = query.getOrDefault("oauth_token")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "oauth_token", valid_580501
  var valid_580502 = query.getOrDefault("userIp")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "userIp", valid_580502
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580505: Call_GmailUsersSettingsDelegatesDelete_580493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_GmailUsersSettingsDelegatesDelete_580493;
          delegateEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsDelegatesDelete
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   delegateEmail: string (required)
  ##                : The email address of the user to be removed as a delegate.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580507 = newJObject()
  var query_580508 = newJObject()
  add(query_580508, "fields", newJString(fields))
  add(query_580508, "quotaUser", newJString(quotaUser))
  add(query_580508, "alt", newJString(alt))
  add(path_580507, "delegateEmail", newJString(delegateEmail))
  add(query_580508, "oauth_token", newJString(oauthToken))
  add(query_580508, "userIp", newJString(userIp))
  add(query_580508, "key", newJString(key))
  add(query_580508, "prettyPrint", newJBool(prettyPrint))
  add(path_580507, "userId", newJString(userId))
  result = call_580506.call(path_580507, query_580508, nil, nil, nil)

var gmailUsersSettingsDelegatesDelete* = Call_GmailUsersSettingsDelegatesDelete_580493(
    name: "gmailUsersSettingsDelegatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesDelete_580494,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesDelete_580495,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersCreate_580524 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsFiltersCreate_580526(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsFiltersCreate_580525(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580527 = path.getOrDefault("userId")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = newJString("me"))
  if valid_580527 != nil:
    section.add "userId", valid_580527
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
  var valid_580528 = query.getOrDefault("fields")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "fields", valid_580528
  var valid_580529 = query.getOrDefault("quotaUser")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "quotaUser", valid_580529
  var valid_580530 = query.getOrDefault("alt")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = newJString("json"))
  if valid_580530 != nil:
    section.add "alt", valid_580530
  var valid_580531 = query.getOrDefault("oauth_token")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "oauth_token", valid_580531
  var valid_580532 = query.getOrDefault("userIp")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "userIp", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("prettyPrint")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(true))
  if valid_580534 != nil:
    section.add "prettyPrint", valid_580534
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

proc call*(call_580536: Call_GmailUsersSettingsFiltersCreate_580524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a filter.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_GmailUsersSettingsFiltersCreate_580524;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsFiltersCreate
  ## Creates a filter.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  var body_580540 = newJObject()
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "key", newJString(key))
  if body != nil:
    body_580540 = body
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  add(path_580538, "userId", newJString(userId))
  result = call_580537.call(path_580538, query_580539, nil, nil, body_580540)

var gmailUsersSettingsFiltersCreate* = Call_GmailUsersSettingsFiltersCreate_580524(
    name: "gmailUsersSettingsFiltersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersCreate_580525,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersCreate_580526,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersList_580509 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsFiltersList_580511(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsFiltersList_580510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the message filters of a Gmail user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580512 = path.getOrDefault("userId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = newJString("me"))
  if valid_580512 != nil:
    section.add "userId", valid_580512
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
  var valid_580513 = query.getOrDefault("fields")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "fields", valid_580513
  var valid_580514 = query.getOrDefault("quotaUser")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "quotaUser", valid_580514
  var valid_580515 = query.getOrDefault("alt")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = newJString("json"))
  if valid_580515 != nil:
    section.add "alt", valid_580515
  var valid_580516 = query.getOrDefault("oauth_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "oauth_token", valid_580516
  var valid_580517 = query.getOrDefault("userIp")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "userIp", valid_580517
  var valid_580518 = query.getOrDefault("key")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "key", valid_580518
  var valid_580519 = query.getOrDefault("prettyPrint")
  valid_580519 = validateParameter(valid_580519, JBool, required = false,
                                 default = newJBool(true))
  if valid_580519 != nil:
    section.add "prettyPrint", valid_580519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580520: Call_GmailUsersSettingsFiltersList_580509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the message filters of a Gmail user.
  ## 
  let valid = call_580520.validator(path, query, header, formData, body)
  let scheme = call_580520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580520.url(scheme.get, call_580520.host, call_580520.base,
                         call_580520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580520, url, valid)

proc call*(call_580521: Call_GmailUsersSettingsFiltersList_580509;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsFiltersList
  ## Lists the message filters of a Gmail user.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580522 = newJObject()
  var query_580523 = newJObject()
  add(query_580523, "fields", newJString(fields))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "userIp", newJString(userIp))
  add(query_580523, "key", newJString(key))
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  add(path_580522, "userId", newJString(userId))
  result = call_580521.call(path_580522, query_580523, nil, nil, nil)

var gmailUsersSettingsFiltersList* = Call_GmailUsersSettingsFiltersList_580509(
    name: "gmailUsersSettingsFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersList_580510,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersList_580511,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersGet_580541 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsFiltersGet_580543(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/filters/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsFiltersGet_580542(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the filter to be fetched.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580544 = path.getOrDefault("id")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "id", valid_580544
  var valid_580545 = path.getOrDefault("userId")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = newJString("me"))
  if valid_580545 != nil:
    section.add "userId", valid_580545
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
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  var valid_580550 = query.getOrDefault("userIp")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "userIp", valid_580550
  var valid_580551 = query.getOrDefault("key")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "key", valid_580551
  var valid_580552 = query.getOrDefault("prettyPrint")
  valid_580552 = validateParameter(valid_580552, JBool, required = false,
                                 default = newJBool(true))
  if valid_580552 != nil:
    section.add "prettyPrint", valid_580552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580553: Call_GmailUsersSettingsFiltersGet_580541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a filter.
  ## 
  let valid = call_580553.validator(path, query, header, formData, body)
  let scheme = call_580553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580553.url(scheme.get, call_580553.host, call_580553.base,
                         call_580553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580553, url, valid)

proc call*(call_580554: Call_GmailUsersSettingsFiltersGet_580541; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsFiltersGet
  ## Gets a filter.
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
  ##   id: string (required)
  ##     : The ID of the filter to be fetched.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580555 = newJObject()
  var query_580556 = newJObject()
  add(query_580556, "fields", newJString(fields))
  add(query_580556, "quotaUser", newJString(quotaUser))
  add(query_580556, "alt", newJString(alt))
  add(query_580556, "oauth_token", newJString(oauthToken))
  add(query_580556, "userIp", newJString(userIp))
  add(path_580555, "id", newJString(id))
  add(query_580556, "key", newJString(key))
  add(query_580556, "prettyPrint", newJBool(prettyPrint))
  add(path_580555, "userId", newJString(userId))
  result = call_580554.call(path_580555, query_580556, nil, nil, nil)

var gmailUsersSettingsFiltersGet* = Call_GmailUsersSettingsFiltersGet_580541(
    name: "gmailUsersSettingsFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersGet_580542,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersGet_580543,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersDelete_580557 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsFiltersDelete_580559(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/filters/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsFiltersDelete_580558(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the filter to be deleted.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580560 = path.getOrDefault("id")
  valid_580560 = validateParameter(valid_580560, JString, required = true,
                                 default = nil)
  if valid_580560 != nil:
    section.add "id", valid_580560
  var valid_580561 = path.getOrDefault("userId")
  valid_580561 = validateParameter(valid_580561, JString, required = true,
                                 default = newJString("me"))
  if valid_580561 != nil:
    section.add "userId", valid_580561
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
  var valid_580562 = query.getOrDefault("fields")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "fields", valid_580562
  var valid_580563 = query.getOrDefault("quotaUser")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "quotaUser", valid_580563
  var valid_580564 = query.getOrDefault("alt")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = newJString("json"))
  if valid_580564 != nil:
    section.add "alt", valid_580564
  var valid_580565 = query.getOrDefault("oauth_token")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "oauth_token", valid_580565
  var valid_580566 = query.getOrDefault("userIp")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "userIp", valid_580566
  var valid_580567 = query.getOrDefault("key")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "key", valid_580567
  var valid_580568 = query.getOrDefault("prettyPrint")
  valid_580568 = validateParameter(valid_580568, JBool, required = false,
                                 default = newJBool(true))
  if valid_580568 != nil:
    section.add "prettyPrint", valid_580568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580569: Call_GmailUsersSettingsFiltersDelete_580557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a filter.
  ## 
  let valid = call_580569.validator(path, query, header, formData, body)
  let scheme = call_580569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580569.url(scheme.get, call_580569.host, call_580569.base,
                         call_580569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580569, url, valid)

proc call*(call_580570: Call_GmailUsersSettingsFiltersDelete_580557; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsFiltersDelete
  ## Deletes a filter.
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
  ##   id: string (required)
  ##     : The ID of the filter to be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580571 = newJObject()
  var query_580572 = newJObject()
  add(query_580572, "fields", newJString(fields))
  add(query_580572, "quotaUser", newJString(quotaUser))
  add(query_580572, "alt", newJString(alt))
  add(query_580572, "oauth_token", newJString(oauthToken))
  add(query_580572, "userIp", newJString(userIp))
  add(path_580571, "id", newJString(id))
  add(query_580572, "key", newJString(key))
  add(query_580572, "prettyPrint", newJBool(prettyPrint))
  add(path_580571, "userId", newJString(userId))
  result = call_580570.call(path_580571, query_580572, nil, nil, nil)

var gmailUsersSettingsFiltersDelete* = Call_GmailUsersSettingsFiltersDelete_580557(
    name: "gmailUsersSettingsFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersDelete_580558,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersDelete_580559,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesCreate_580588 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsForwardingAddressesCreate_580590(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/forwardingAddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsForwardingAddressesCreate_580589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580591 = path.getOrDefault("userId")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = newJString("me"))
  if valid_580591 != nil:
    section.add "userId", valid_580591
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
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  var valid_580593 = query.getOrDefault("quotaUser")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "quotaUser", valid_580593
  var valid_580594 = query.getOrDefault("alt")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = newJString("json"))
  if valid_580594 != nil:
    section.add "alt", valid_580594
  var valid_580595 = query.getOrDefault("oauth_token")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "oauth_token", valid_580595
  var valid_580596 = query.getOrDefault("userIp")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "userIp", valid_580596
  var valid_580597 = query.getOrDefault("key")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "key", valid_580597
  var valid_580598 = query.getOrDefault("prettyPrint")
  valid_580598 = validateParameter(valid_580598, JBool, required = false,
                                 default = newJBool(true))
  if valid_580598 != nil:
    section.add "prettyPrint", valid_580598
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

proc call*(call_580600: Call_GmailUsersSettingsForwardingAddressesCreate_580588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580600.validator(path, query, header, formData, body)
  let scheme = call_580600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580600.url(scheme.get, call_580600.host, call_580600.base,
                         call_580600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580600, url, valid)

proc call*(call_580601: Call_GmailUsersSettingsForwardingAddressesCreate_580588;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsForwardingAddressesCreate
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580602 = newJObject()
  var query_580603 = newJObject()
  var body_580604 = newJObject()
  add(query_580603, "fields", newJString(fields))
  add(query_580603, "quotaUser", newJString(quotaUser))
  add(query_580603, "alt", newJString(alt))
  add(query_580603, "oauth_token", newJString(oauthToken))
  add(query_580603, "userIp", newJString(userIp))
  add(query_580603, "key", newJString(key))
  if body != nil:
    body_580604 = body
  add(query_580603, "prettyPrint", newJBool(prettyPrint))
  add(path_580602, "userId", newJString(userId))
  result = call_580601.call(path_580602, query_580603, nil, nil, body_580604)

var gmailUsersSettingsForwardingAddressesCreate* = Call_GmailUsersSettingsForwardingAddressesCreate_580588(
    name: "gmailUsersSettingsForwardingAddressesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesCreate_580589,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesCreate_580590,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesList_580573 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsForwardingAddressesList_580575(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/forwardingAddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsForwardingAddressesList_580574(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the forwarding addresses for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580576 = path.getOrDefault("userId")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = newJString("me"))
  if valid_580576 != nil:
    section.add "userId", valid_580576
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
  var valid_580577 = query.getOrDefault("fields")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "fields", valid_580577
  var valid_580578 = query.getOrDefault("quotaUser")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "quotaUser", valid_580578
  var valid_580579 = query.getOrDefault("alt")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = newJString("json"))
  if valid_580579 != nil:
    section.add "alt", valid_580579
  var valid_580580 = query.getOrDefault("oauth_token")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "oauth_token", valid_580580
  var valid_580581 = query.getOrDefault("userIp")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "userIp", valid_580581
  var valid_580582 = query.getOrDefault("key")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "key", valid_580582
  var valid_580583 = query.getOrDefault("prettyPrint")
  valid_580583 = validateParameter(valid_580583, JBool, required = false,
                                 default = newJBool(true))
  if valid_580583 != nil:
    section.add "prettyPrint", valid_580583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580584: Call_GmailUsersSettingsForwardingAddressesList_580573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the forwarding addresses for the specified account.
  ## 
  let valid = call_580584.validator(path, query, header, formData, body)
  let scheme = call_580584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580584.url(scheme.get, call_580584.host, call_580584.base,
                         call_580584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580584, url, valid)

proc call*(call_580585: Call_GmailUsersSettingsForwardingAddressesList_580573;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsForwardingAddressesList
  ## Lists the forwarding addresses for the specified account.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580586 = newJObject()
  var query_580587 = newJObject()
  add(query_580587, "fields", newJString(fields))
  add(query_580587, "quotaUser", newJString(quotaUser))
  add(query_580587, "alt", newJString(alt))
  add(query_580587, "oauth_token", newJString(oauthToken))
  add(query_580587, "userIp", newJString(userIp))
  add(query_580587, "key", newJString(key))
  add(query_580587, "prettyPrint", newJBool(prettyPrint))
  add(path_580586, "userId", newJString(userId))
  result = call_580585.call(path_580586, query_580587, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesList* = Call_GmailUsersSettingsForwardingAddressesList_580573(
    name: "gmailUsersSettingsForwardingAddressesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesList_580574,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesList_580575,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesGet_580605 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsForwardingAddressesGet_580607(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "forwardingEmail" in path, "`forwardingEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/settings/forwardingAddresses/"),
               (kind: VariableSegment, value: "forwardingEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsForwardingAddressesGet_580606(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified forwarding address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   forwardingEmail: JString (required)
  ##                  : The forwarding address to be retrieved.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `forwardingEmail` field"
  var valid_580608 = path.getOrDefault("forwardingEmail")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "forwardingEmail", valid_580608
  var valid_580609 = path.getOrDefault("userId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = newJString("me"))
  if valid_580609 != nil:
    section.add "userId", valid_580609
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
  var valid_580610 = query.getOrDefault("fields")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fields", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("oauth_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "oauth_token", valid_580613
  var valid_580614 = query.getOrDefault("userIp")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "userIp", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580617: Call_GmailUsersSettingsForwardingAddressesGet_580605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified forwarding address.
  ## 
  let valid = call_580617.validator(path, query, header, formData, body)
  let scheme = call_580617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580617.url(scheme.get, call_580617.host, call_580617.base,
                         call_580617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580617, url, valid)

proc call*(call_580618: Call_GmailUsersSettingsForwardingAddressesGet_580605;
          forwardingEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsForwardingAddressesGet
  ## Gets the specified forwarding address.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   forwardingEmail: string (required)
  ##                  : The forwarding address to be retrieved.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580619 = newJObject()
  var query_580620 = newJObject()
  add(query_580620, "fields", newJString(fields))
  add(query_580620, "quotaUser", newJString(quotaUser))
  add(query_580620, "alt", newJString(alt))
  add(path_580619, "forwardingEmail", newJString(forwardingEmail))
  add(query_580620, "oauth_token", newJString(oauthToken))
  add(query_580620, "userIp", newJString(userIp))
  add(query_580620, "key", newJString(key))
  add(query_580620, "prettyPrint", newJBool(prettyPrint))
  add(path_580619, "userId", newJString(userId))
  result = call_580618.call(path_580619, query_580620, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesGet* = Call_GmailUsersSettingsForwardingAddressesGet_580605(
    name: "gmailUsersSettingsForwardingAddressesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesGet_580606,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesGet_580607,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesDelete_580621 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsForwardingAddressesDelete_580623(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "forwardingEmail" in path, "`forwardingEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/settings/forwardingAddresses/"),
               (kind: VariableSegment, value: "forwardingEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsForwardingAddressesDelete_580622(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   forwardingEmail: JString (required)
  ##                  : The forwarding address to be deleted.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `forwardingEmail` field"
  var valid_580624 = path.getOrDefault("forwardingEmail")
  valid_580624 = validateParameter(valid_580624, JString, required = true,
                                 default = nil)
  if valid_580624 != nil:
    section.add "forwardingEmail", valid_580624
  var valid_580625 = path.getOrDefault("userId")
  valid_580625 = validateParameter(valid_580625, JString, required = true,
                                 default = newJString("me"))
  if valid_580625 != nil:
    section.add "userId", valid_580625
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
  var valid_580626 = query.getOrDefault("fields")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "fields", valid_580626
  var valid_580627 = query.getOrDefault("quotaUser")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "quotaUser", valid_580627
  var valid_580628 = query.getOrDefault("alt")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = newJString("json"))
  if valid_580628 != nil:
    section.add "alt", valid_580628
  var valid_580629 = query.getOrDefault("oauth_token")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "oauth_token", valid_580629
  var valid_580630 = query.getOrDefault("userIp")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "userIp", valid_580630
  var valid_580631 = query.getOrDefault("key")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "key", valid_580631
  var valid_580632 = query.getOrDefault("prettyPrint")
  valid_580632 = validateParameter(valid_580632, JBool, required = false,
                                 default = newJBool(true))
  if valid_580632 != nil:
    section.add "prettyPrint", valid_580632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580633: Call_GmailUsersSettingsForwardingAddressesDelete_580621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_GmailUsersSettingsForwardingAddressesDelete_580621;
          forwardingEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsForwardingAddressesDelete
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   forwardingEmail: string (required)
  ##                  : The forwarding address to be deleted.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  add(query_580636, "fields", newJString(fields))
  add(query_580636, "quotaUser", newJString(quotaUser))
  add(query_580636, "alt", newJString(alt))
  add(path_580635, "forwardingEmail", newJString(forwardingEmail))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "userIp", newJString(userIp))
  add(query_580636, "key", newJString(key))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  add(path_580635, "userId", newJString(userId))
  result = call_580634.call(path_580635, query_580636, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesDelete* = Call_GmailUsersSettingsForwardingAddressesDelete_580621(
    name: "gmailUsersSettingsForwardingAddressesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesDelete_580622,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesDelete_580623,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateImap_580652 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsUpdateImap_580654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/imap")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsUpdateImap_580653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates IMAP settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580655 = path.getOrDefault("userId")
  valid_580655 = validateParameter(valid_580655, JString, required = true,
                                 default = newJString("me"))
  if valid_580655 != nil:
    section.add "userId", valid_580655
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
  var valid_580656 = query.getOrDefault("fields")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "fields", valid_580656
  var valid_580657 = query.getOrDefault("quotaUser")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "quotaUser", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("oauth_token")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "oauth_token", valid_580659
  var valid_580660 = query.getOrDefault("userIp")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "userIp", valid_580660
  var valid_580661 = query.getOrDefault("key")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "key", valid_580661
  var valid_580662 = query.getOrDefault("prettyPrint")
  valid_580662 = validateParameter(valid_580662, JBool, required = false,
                                 default = newJBool(true))
  if valid_580662 != nil:
    section.add "prettyPrint", valid_580662
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

proc call*(call_580664: Call_GmailUsersSettingsUpdateImap_580652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates IMAP settings.
  ## 
  let valid = call_580664.validator(path, query, header, formData, body)
  let scheme = call_580664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580664.url(scheme.get, call_580664.host, call_580664.base,
                         call_580664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580664, url, valid)

proc call*(call_580665: Call_GmailUsersSettingsUpdateImap_580652;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsUpdateImap
  ## Updates IMAP settings.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580666 = newJObject()
  var query_580667 = newJObject()
  var body_580668 = newJObject()
  add(query_580667, "fields", newJString(fields))
  add(query_580667, "quotaUser", newJString(quotaUser))
  add(query_580667, "alt", newJString(alt))
  add(query_580667, "oauth_token", newJString(oauthToken))
  add(query_580667, "userIp", newJString(userIp))
  add(query_580667, "key", newJString(key))
  if body != nil:
    body_580668 = body
  add(query_580667, "prettyPrint", newJBool(prettyPrint))
  add(path_580666, "userId", newJString(userId))
  result = call_580665.call(path_580666, query_580667, nil, nil, body_580668)

var gmailUsersSettingsUpdateImap* = Call_GmailUsersSettingsUpdateImap_580652(
    name: "gmailUsersSettingsUpdateImap", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsUpdateImap_580653,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateImap_580654,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetImap_580637 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsGetImap_580639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/imap")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsGetImap_580638(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets IMAP settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580640 = path.getOrDefault("userId")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = newJString("me"))
  if valid_580640 != nil:
    section.add "userId", valid_580640
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
  var valid_580641 = query.getOrDefault("fields")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "fields", valid_580641
  var valid_580642 = query.getOrDefault("quotaUser")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "quotaUser", valid_580642
  var valid_580643 = query.getOrDefault("alt")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = newJString("json"))
  if valid_580643 != nil:
    section.add "alt", valid_580643
  var valid_580644 = query.getOrDefault("oauth_token")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "oauth_token", valid_580644
  var valid_580645 = query.getOrDefault("userIp")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "userIp", valid_580645
  var valid_580646 = query.getOrDefault("key")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "key", valid_580646
  var valid_580647 = query.getOrDefault("prettyPrint")
  valid_580647 = validateParameter(valid_580647, JBool, required = false,
                                 default = newJBool(true))
  if valid_580647 != nil:
    section.add "prettyPrint", valid_580647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580648: Call_GmailUsersSettingsGetImap_580637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets IMAP settings.
  ## 
  let valid = call_580648.validator(path, query, header, formData, body)
  let scheme = call_580648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580648.url(scheme.get, call_580648.host, call_580648.base,
                         call_580648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580648, url, valid)

proc call*(call_580649: Call_GmailUsersSettingsGetImap_580637; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersSettingsGetImap
  ## Gets IMAP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580650 = newJObject()
  var query_580651 = newJObject()
  add(query_580651, "fields", newJString(fields))
  add(query_580651, "quotaUser", newJString(quotaUser))
  add(query_580651, "alt", newJString(alt))
  add(query_580651, "oauth_token", newJString(oauthToken))
  add(query_580651, "userIp", newJString(userIp))
  add(query_580651, "key", newJString(key))
  add(query_580651, "prettyPrint", newJBool(prettyPrint))
  add(path_580650, "userId", newJString(userId))
  result = call_580649.call(path_580650, query_580651, nil, nil, nil)

var gmailUsersSettingsGetImap* = Call_GmailUsersSettingsGetImap_580637(
    name: "gmailUsersSettingsGetImap", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsGetImap_580638, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetImap_580639, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateLanguage_580684 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsUpdateLanguage_580686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsUpdateLanguage_580685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580687 = path.getOrDefault("userId")
  valid_580687 = validateParameter(valid_580687, JString, required = true,
                                 default = newJString("me"))
  if valid_580687 != nil:
    section.add "userId", valid_580687
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
  var valid_580688 = query.getOrDefault("fields")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "fields", valid_580688
  var valid_580689 = query.getOrDefault("quotaUser")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "quotaUser", valid_580689
  var valid_580690 = query.getOrDefault("alt")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = newJString("json"))
  if valid_580690 != nil:
    section.add "alt", valid_580690
  var valid_580691 = query.getOrDefault("oauth_token")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "oauth_token", valid_580691
  var valid_580692 = query.getOrDefault("userIp")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "userIp", valid_580692
  var valid_580693 = query.getOrDefault("key")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "key", valid_580693
  var valid_580694 = query.getOrDefault("prettyPrint")
  valid_580694 = validateParameter(valid_580694, JBool, required = false,
                                 default = newJBool(true))
  if valid_580694 != nil:
    section.add "prettyPrint", valid_580694
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

proc call*(call_580696: Call_GmailUsersSettingsUpdateLanguage_580684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
  ## 
  let valid = call_580696.validator(path, query, header, formData, body)
  let scheme = call_580696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580696.url(scheme.get, call_580696.host, call_580696.base,
                         call_580696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580696, url, valid)

proc call*(call_580697: Call_GmailUsersSettingsUpdateLanguage_580684;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsUpdateLanguage
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580698 = newJObject()
  var query_580699 = newJObject()
  var body_580700 = newJObject()
  add(query_580699, "fields", newJString(fields))
  add(query_580699, "quotaUser", newJString(quotaUser))
  add(query_580699, "alt", newJString(alt))
  add(query_580699, "oauth_token", newJString(oauthToken))
  add(query_580699, "userIp", newJString(userIp))
  add(query_580699, "key", newJString(key))
  if body != nil:
    body_580700 = body
  add(query_580699, "prettyPrint", newJBool(prettyPrint))
  add(path_580698, "userId", newJString(userId))
  result = call_580697.call(path_580698, query_580699, nil, nil, body_580700)

var gmailUsersSettingsUpdateLanguage* = Call_GmailUsersSettingsUpdateLanguage_580684(
    name: "gmailUsersSettingsUpdateLanguage", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsUpdateLanguage_580685,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateLanguage_580686,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetLanguage_580669 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsGetLanguage_580671(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsGetLanguage_580670(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets language settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580672 = path.getOrDefault("userId")
  valid_580672 = validateParameter(valid_580672, JString, required = true,
                                 default = newJString("me"))
  if valid_580672 != nil:
    section.add "userId", valid_580672
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
  var valid_580673 = query.getOrDefault("fields")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "fields", valid_580673
  var valid_580674 = query.getOrDefault("quotaUser")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "quotaUser", valid_580674
  var valid_580675 = query.getOrDefault("alt")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = newJString("json"))
  if valid_580675 != nil:
    section.add "alt", valid_580675
  var valid_580676 = query.getOrDefault("oauth_token")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "oauth_token", valid_580676
  var valid_580677 = query.getOrDefault("userIp")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "userIp", valid_580677
  var valid_580678 = query.getOrDefault("key")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "key", valid_580678
  var valid_580679 = query.getOrDefault("prettyPrint")
  valid_580679 = validateParameter(valid_580679, JBool, required = false,
                                 default = newJBool(true))
  if valid_580679 != nil:
    section.add "prettyPrint", valid_580679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580680: Call_GmailUsersSettingsGetLanguage_580669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets language settings.
  ## 
  let valid = call_580680.validator(path, query, header, formData, body)
  let scheme = call_580680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580680.url(scheme.get, call_580680.host, call_580680.base,
                         call_580680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580680, url, valid)

proc call*(call_580681: Call_GmailUsersSettingsGetLanguage_580669;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsGetLanguage
  ## Gets language settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580682 = newJObject()
  var query_580683 = newJObject()
  add(query_580683, "fields", newJString(fields))
  add(query_580683, "quotaUser", newJString(quotaUser))
  add(query_580683, "alt", newJString(alt))
  add(query_580683, "oauth_token", newJString(oauthToken))
  add(query_580683, "userIp", newJString(userIp))
  add(query_580683, "key", newJString(key))
  add(query_580683, "prettyPrint", newJBool(prettyPrint))
  add(path_580682, "userId", newJString(userId))
  result = call_580681.call(path_580682, query_580683, nil, nil, nil)

var gmailUsersSettingsGetLanguage* = Call_GmailUsersSettingsGetLanguage_580669(
    name: "gmailUsersSettingsGetLanguage", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsGetLanguage_580670,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetLanguage_580671,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdatePop_580716 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsUpdatePop_580718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/pop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsUpdatePop_580717(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates POP settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580719 = path.getOrDefault("userId")
  valid_580719 = validateParameter(valid_580719, JString, required = true,
                                 default = newJString("me"))
  if valid_580719 != nil:
    section.add "userId", valid_580719
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
  var valid_580720 = query.getOrDefault("fields")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "fields", valid_580720
  var valid_580721 = query.getOrDefault("quotaUser")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "quotaUser", valid_580721
  var valid_580722 = query.getOrDefault("alt")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = newJString("json"))
  if valid_580722 != nil:
    section.add "alt", valid_580722
  var valid_580723 = query.getOrDefault("oauth_token")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "oauth_token", valid_580723
  var valid_580724 = query.getOrDefault("userIp")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "userIp", valid_580724
  var valid_580725 = query.getOrDefault("key")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "key", valid_580725
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580728: Call_GmailUsersSettingsUpdatePop_580716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates POP settings.
  ## 
  let valid = call_580728.validator(path, query, header, formData, body)
  let scheme = call_580728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580728.url(scheme.get, call_580728.host, call_580728.base,
                         call_580728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580728, url, valid)

proc call*(call_580729: Call_GmailUsersSettingsUpdatePop_580716;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsUpdatePop
  ## Updates POP settings.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580730 = newJObject()
  var query_580731 = newJObject()
  var body_580732 = newJObject()
  add(query_580731, "fields", newJString(fields))
  add(query_580731, "quotaUser", newJString(quotaUser))
  add(query_580731, "alt", newJString(alt))
  add(query_580731, "oauth_token", newJString(oauthToken))
  add(query_580731, "userIp", newJString(userIp))
  add(query_580731, "key", newJString(key))
  if body != nil:
    body_580732 = body
  add(query_580731, "prettyPrint", newJBool(prettyPrint))
  add(path_580730, "userId", newJString(userId))
  result = call_580729.call(path_580730, query_580731, nil, nil, body_580732)

var gmailUsersSettingsUpdatePop* = Call_GmailUsersSettingsUpdatePop_580716(
    name: "gmailUsersSettingsUpdatePop", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsUpdatePop_580717,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdatePop_580718,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetPop_580701 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsGetPop_580703(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/pop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsGetPop_580702(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets POP settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580704 = path.getOrDefault("userId")
  valid_580704 = validateParameter(valid_580704, JString, required = true,
                                 default = newJString("me"))
  if valid_580704 != nil:
    section.add "userId", valid_580704
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
  var valid_580705 = query.getOrDefault("fields")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "fields", valid_580705
  var valid_580706 = query.getOrDefault("quotaUser")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "quotaUser", valid_580706
  var valid_580707 = query.getOrDefault("alt")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = newJString("json"))
  if valid_580707 != nil:
    section.add "alt", valid_580707
  var valid_580708 = query.getOrDefault("oauth_token")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "oauth_token", valid_580708
  var valid_580709 = query.getOrDefault("userIp")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "userIp", valid_580709
  var valid_580710 = query.getOrDefault("key")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "key", valid_580710
  var valid_580711 = query.getOrDefault("prettyPrint")
  valid_580711 = validateParameter(valid_580711, JBool, required = false,
                                 default = newJBool(true))
  if valid_580711 != nil:
    section.add "prettyPrint", valid_580711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580712: Call_GmailUsersSettingsGetPop_580701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets POP settings.
  ## 
  let valid = call_580712.validator(path, query, header, formData, body)
  let scheme = call_580712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580712.url(scheme.get, call_580712.host, call_580712.base,
                         call_580712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580712, url, valid)

proc call*(call_580713: Call_GmailUsersSettingsGetPop_580701; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersSettingsGetPop
  ## Gets POP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580714 = newJObject()
  var query_580715 = newJObject()
  add(query_580715, "fields", newJString(fields))
  add(query_580715, "quotaUser", newJString(quotaUser))
  add(query_580715, "alt", newJString(alt))
  add(query_580715, "oauth_token", newJString(oauthToken))
  add(query_580715, "userIp", newJString(userIp))
  add(query_580715, "key", newJString(key))
  add(query_580715, "prettyPrint", newJBool(prettyPrint))
  add(path_580714, "userId", newJString(userId))
  result = call_580713.call(path_580714, query_580715, nil, nil, nil)

var gmailUsersSettingsGetPop* = Call_GmailUsersSettingsGetPop_580701(
    name: "gmailUsersSettingsGetPop", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsGetPop_580702, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetPop_580703, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsCreate_580748 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsCreate_580750(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsCreate_580749(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580751 = path.getOrDefault("userId")
  valid_580751 = validateParameter(valid_580751, JString, required = true,
                                 default = newJString("me"))
  if valid_580751 != nil:
    section.add "userId", valid_580751
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
  var valid_580752 = query.getOrDefault("fields")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "fields", valid_580752
  var valid_580753 = query.getOrDefault("quotaUser")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "quotaUser", valid_580753
  var valid_580754 = query.getOrDefault("alt")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = newJString("json"))
  if valid_580754 != nil:
    section.add "alt", valid_580754
  var valid_580755 = query.getOrDefault("oauth_token")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "oauth_token", valid_580755
  var valid_580756 = query.getOrDefault("userIp")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "userIp", valid_580756
  var valid_580757 = query.getOrDefault("key")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "key", valid_580757
  var valid_580758 = query.getOrDefault("prettyPrint")
  valid_580758 = validateParameter(valid_580758, JBool, required = false,
                                 default = newJBool(true))
  if valid_580758 != nil:
    section.add "prettyPrint", valid_580758
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

proc call*(call_580760: Call_GmailUsersSettingsSendAsCreate_580748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580760.validator(path, query, header, formData, body)
  let scheme = call_580760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580760.url(scheme.get, call_580760.host, call_580760.base,
                         call_580760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580760, url, valid)

proc call*(call_580761: Call_GmailUsersSettingsSendAsCreate_580748;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsCreate
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580762 = newJObject()
  var query_580763 = newJObject()
  var body_580764 = newJObject()
  add(query_580763, "fields", newJString(fields))
  add(query_580763, "quotaUser", newJString(quotaUser))
  add(query_580763, "alt", newJString(alt))
  add(query_580763, "oauth_token", newJString(oauthToken))
  add(query_580763, "userIp", newJString(userIp))
  add(query_580763, "key", newJString(key))
  if body != nil:
    body_580764 = body
  add(query_580763, "prettyPrint", newJBool(prettyPrint))
  add(path_580762, "userId", newJString(userId))
  result = call_580761.call(path_580762, query_580763, nil, nil, body_580764)

var gmailUsersSettingsSendAsCreate* = Call_GmailUsersSettingsSendAsCreate_580748(
    name: "gmailUsersSettingsSendAsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsCreate_580749,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsCreate_580750,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsList_580733 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsList_580735(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsList_580734(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580736 = path.getOrDefault("userId")
  valid_580736 = validateParameter(valid_580736, JString, required = true,
                                 default = newJString("me"))
  if valid_580736 != nil:
    section.add "userId", valid_580736
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
  var valid_580737 = query.getOrDefault("fields")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "fields", valid_580737
  var valid_580738 = query.getOrDefault("quotaUser")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "quotaUser", valid_580738
  var valid_580739 = query.getOrDefault("alt")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = newJString("json"))
  if valid_580739 != nil:
    section.add "alt", valid_580739
  var valid_580740 = query.getOrDefault("oauth_token")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "oauth_token", valid_580740
  var valid_580741 = query.getOrDefault("userIp")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "userIp", valid_580741
  var valid_580742 = query.getOrDefault("key")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "key", valid_580742
  var valid_580743 = query.getOrDefault("prettyPrint")
  valid_580743 = validateParameter(valid_580743, JBool, required = false,
                                 default = newJBool(true))
  if valid_580743 != nil:
    section.add "prettyPrint", valid_580743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580744: Call_GmailUsersSettingsSendAsList_580733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
  ## 
  let valid = call_580744.validator(path, query, header, formData, body)
  let scheme = call_580744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580744.url(scheme.get, call_580744.host, call_580744.base,
                         call_580744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580744, url, valid)

proc call*(call_580745: Call_GmailUsersSettingsSendAsList_580733;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsList
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580746 = newJObject()
  var query_580747 = newJObject()
  add(query_580747, "fields", newJString(fields))
  add(query_580747, "quotaUser", newJString(quotaUser))
  add(query_580747, "alt", newJString(alt))
  add(query_580747, "oauth_token", newJString(oauthToken))
  add(query_580747, "userIp", newJString(userIp))
  add(query_580747, "key", newJString(key))
  add(query_580747, "prettyPrint", newJBool(prettyPrint))
  add(path_580746, "userId", newJString(userId))
  result = call_580745.call(path_580746, query_580747, nil, nil, nil)

var gmailUsersSettingsSendAsList* = Call_GmailUsersSettingsSendAsList_580733(
    name: "gmailUsersSettingsSendAsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsList_580734,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsList_580735,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsUpdate_580781 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsUpdate_580783(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsUpdate_580782(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be updated.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580784 = path.getOrDefault("sendAsEmail")
  valid_580784 = validateParameter(valid_580784, JString, required = true,
                                 default = nil)
  if valid_580784 != nil:
    section.add "sendAsEmail", valid_580784
  var valid_580785 = path.getOrDefault("userId")
  valid_580785 = validateParameter(valid_580785, JString, required = true,
                                 default = newJString("me"))
  if valid_580785 != nil:
    section.add "userId", valid_580785
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
  var valid_580786 = query.getOrDefault("fields")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "fields", valid_580786
  var valid_580787 = query.getOrDefault("quotaUser")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "quotaUser", valid_580787
  var valid_580788 = query.getOrDefault("alt")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = newJString("json"))
  if valid_580788 != nil:
    section.add "alt", valid_580788
  var valid_580789 = query.getOrDefault("oauth_token")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "oauth_token", valid_580789
  var valid_580790 = query.getOrDefault("userIp")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "userIp", valid_580790
  var valid_580791 = query.getOrDefault("key")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "key", valid_580791
  var valid_580792 = query.getOrDefault("prettyPrint")
  valid_580792 = validateParameter(valid_580792, JBool, required = false,
                                 default = newJBool(true))
  if valid_580792 != nil:
    section.add "prettyPrint", valid_580792
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

proc call*(call_580794: Call_GmailUsersSettingsSendAsUpdate_580781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580794.validator(path, query, header, formData, body)
  let scheme = call_580794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580794.url(scheme.get, call_580794.host, call_580794.base,
                         call_580794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580794, url, valid)

proc call*(call_580795: Call_GmailUsersSettingsSendAsUpdate_580781;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsUpdate
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be updated.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580796 = newJObject()
  var query_580797 = newJObject()
  var body_580798 = newJObject()
  add(query_580797, "fields", newJString(fields))
  add(query_580797, "quotaUser", newJString(quotaUser))
  add(query_580797, "alt", newJString(alt))
  add(path_580796, "sendAsEmail", newJString(sendAsEmail))
  add(query_580797, "oauth_token", newJString(oauthToken))
  add(query_580797, "userIp", newJString(userIp))
  add(query_580797, "key", newJString(key))
  if body != nil:
    body_580798 = body
  add(query_580797, "prettyPrint", newJBool(prettyPrint))
  add(path_580796, "userId", newJString(userId))
  result = call_580795.call(path_580796, query_580797, nil, nil, body_580798)

var gmailUsersSettingsSendAsUpdate* = Call_GmailUsersSettingsSendAsUpdate_580781(
    name: "gmailUsersSettingsSendAsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsUpdate_580782,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsUpdate_580783,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsGet_580765 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsGet_580767(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsGet_580766(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be retrieved.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580768 = path.getOrDefault("sendAsEmail")
  valid_580768 = validateParameter(valid_580768, JString, required = true,
                                 default = nil)
  if valid_580768 != nil:
    section.add "sendAsEmail", valid_580768
  var valid_580769 = path.getOrDefault("userId")
  valid_580769 = validateParameter(valid_580769, JString, required = true,
                                 default = newJString("me"))
  if valid_580769 != nil:
    section.add "userId", valid_580769
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
  var valid_580770 = query.getOrDefault("fields")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "fields", valid_580770
  var valid_580771 = query.getOrDefault("quotaUser")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "quotaUser", valid_580771
  var valid_580772 = query.getOrDefault("alt")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = newJString("json"))
  if valid_580772 != nil:
    section.add "alt", valid_580772
  var valid_580773 = query.getOrDefault("oauth_token")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "oauth_token", valid_580773
  var valid_580774 = query.getOrDefault("userIp")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "userIp", valid_580774
  var valid_580775 = query.getOrDefault("key")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "key", valid_580775
  var valid_580776 = query.getOrDefault("prettyPrint")
  valid_580776 = validateParameter(valid_580776, JBool, required = false,
                                 default = newJBool(true))
  if valid_580776 != nil:
    section.add "prettyPrint", valid_580776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580777: Call_GmailUsersSettingsSendAsGet_580765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  let valid = call_580777.validator(path, query, header, formData, body)
  let scheme = call_580777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580777.url(scheme.get, call_580777.host, call_580777.base,
                         call_580777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580777, url, valid)

proc call*(call_580778: Call_GmailUsersSettingsSendAsGet_580765;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsGet
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be retrieved.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580779 = newJObject()
  var query_580780 = newJObject()
  add(query_580780, "fields", newJString(fields))
  add(query_580780, "quotaUser", newJString(quotaUser))
  add(query_580780, "alt", newJString(alt))
  add(path_580779, "sendAsEmail", newJString(sendAsEmail))
  add(query_580780, "oauth_token", newJString(oauthToken))
  add(query_580780, "userIp", newJString(userIp))
  add(query_580780, "key", newJString(key))
  add(query_580780, "prettyPrint", newJBool(prettyPrint))
  add(path_580779, "userId", newJString(userId))
  result = call_580778.call(path_580779, query_580780, nil, nil, nil)

var gmailUsersSettingsSendAsGet* = Call_GmailUsersSettingsSendAsGet_580765(
    name: "gmailUsersSettingsSendAsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsGet_580766,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsGet_580767,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsPatch_580815 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsPatch_580817(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsPatch_580816(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be updated.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580818 = path.getOrDefault("sendAsEmail")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "sendAsEmail", valid_580818
  var valid_580819 = path.getOrDefault("userId")
  valid_580819 = validateParameter(valid_580819, JString, required = true,
                                 default = newJString("me"))
  if valid_580819 != nil:
    section.add "userId", valid_580819
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
  var valid_580820 = query.getOrDefault("fields")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "fields", valid_580820
  var valid_580821 = query.getOrDefault("quotaUser")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "quotaUser", valid_580821
  var valid_580822 = query.getOrDefault("alt")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = newJString("json"))
  if valid_580822 != nil:
    section.add "alt", valid_580822
  var valid_580823 = query.getOrDefault("oauth_token")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "oauth_token", valid_580823
  var valid_580824 = query.getOrDefault("userIp")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "userIp", valid_580824
  var valid_580825 = query.getOrDefault("key")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "key", valid_580825
  var valid_580826 = query.getOrDefault("prettyPrint")
  valid_580826 = validateParameter(valid_580826, JBool, required = false,
                                 default = newJBool(true))
  if valid_580826 != nil:
    section.add "prettyPrint", valid_580826
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

proc call*(call_580828: Call_GmailUsersSettingsSendAsPatch_580815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  let valid = call_580828.validator(path, query, header, formData, body)
  let scheme = call_580828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580828.url(scheme.get, call_580828.host, call_580828.base,
                         call_580828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580828, url, valid)

proc call*(call_580829: Call_GmailUsersSettingsSendAsPatch_580815;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsPatch
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be updated.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580830 = newJObject()
  var query_580831 = newJObject()
  var body_580832 = newJObject()
  add(query_580831, "fields", newJString(fields))
  add(query_580831, "quotaUser", newJString(quotaUser))
  add(query_580831, "alt", newJString(alt))
  add(path_580830, "sendAsEmail", newJString(sendAsEmail))
  add(query_580831, "oauth_token", newJString(oauthToken))
  add(query_580831, "userIp", newJString(userIp))
  add(query_580831, "key", newJString(key))
  if body != nil:
    body_580832 = body
  add(query_580831, "prettyPrint", newJBool(prettyPrint))
  add(path_580830, "userId", newJString(userId))
  result = call_580829.call(path_580830, query_580831, nil, nil, body_580832)

var gmailUsersSettingsSendAsPatch* = Call_GmailUsersSettingsSendAsPatch_580815(
    name: "gmailUsersSettingsSendAsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsPatch_580816,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsPatch_580817,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsDelete_580799 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsDelete_580801(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsDelete_580800(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be deleted.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580802 = path.getOrDefault("sendAsEmail")
  valid_580802 = validateParameter(valid_580802, JString, required = true,
                                 default = nil)
  if valid_580802 != nil:
    section.add "sendAsEmail", valid_580802
  var valid_580803 = path.getOrDefault("userId")
  valid_580803 = validateParameter(valid_580803, JString, required = true,
                                 default = newJString("me"))
  if valid_580803 != nil:
    section.add "userId", valid_580803
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
  var valid_580804 = query.getOrDefault("fields")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "fields", valid_580804
  var valid_580805 = query.getOrDefault("quotaUser")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "quotaUser", valid_580805
  var valid_580806 = query.getOrDefault("alt")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = newJString("json"))
  if valid_580806 != nil:
    section.add "alt", valid_580806
  var valid_580807 = query.getOrDefault("oauth_token")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "oauth_token", valid_580807
  var valid_580808 = query.getOrDefault("userIp")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = nil)
  if valid_580808 != nil:
    section.add "userIp", valid_580808
  var valid_580809 = query.getOrDefault("key")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "key", valid_580809
  var valid_580810 = query.getOrDefault("prettyPrint")
  valid_580810 = validateParameter(valid_580810, JBool, required = false,
                                 default = newJBool(true))
  if valid_580810 != nil:
    section.add "prettyPrint", valid_580810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580811: Call_GmailUsersSettingsSendAsDelete_580799; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580811.validator(path, query, header, formData, body)
  let scheme = call_580811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580811.url(scheme.get, call_580811.host, call_580811.base,
                         call_580811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580811, url, valid)

proc call*(call_580812: Call_GmailUsersSettingsSendAsDelete_580799;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsDelete
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be deleted.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580813 = newJObject()
  var query_580814 = newJObject()
  add(query_580814, "fields", newJString(fields))
  add(query_580814, "quotaUser", newJString(quotaUser))
  add(query_580814, "alt", newJString(alt))
  add(path_580813, "sendAsEmail", newJString(sendAsEmail))
  add(query_580814, "oauth_token", newJString(oauthToken))
  add(query_580814, "userIp", newJString(userIp))
  add(query_580814, "key", newJString(key))
  add(query_580814, "prettyPrint", newJBool(prettyPrint))
  add(path_580813, "userId", newJString(userId))
  result = call_580812.call(path_580813, query_580814, nil, nil, nil)

var gmailUsersSettingsSendAsDelete* = Call_GmailUsersSettingsSendAsDelete_580799(
    name: "gmailUsersSettingsSendAsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsDelete_580800,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsDelete_580801,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoInsert_580849 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsSmimeInfoInsert_580851(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/smimeInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsSmimeInfoInsert_580850(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580852 = path.getOrDefault("sendAsEmail")
  valid_580852 = validateParameter(valid_580852, JString, required = true,
                                 default = nil)
  if valid_580852 != nil:
    section.add "sendAsEmail", valid_580852
  var valid_580853 = path.getOrDefault("userId")
  valid_580853 = validateParameter(valid_580853, JString, required = true,
                                 default = newJString("me"))
  if valid_580853 != nil:
    section.add "userId", valid_580853
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
  var valid_580854 = query.getOrDefault("fields")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "fields", valid_580854
  var valid_580855 = query.getOrDefault("quotaUser")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "quotaUser", valid_580855
  var valid_580856 = query.getOrDefault("alt")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = newJString("json"))
  if valid_580856 != nil:
    section.add "alt", valid_580856
  var valid_580857 = query.getOrDefault("oauth_token")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "oauth_token", valid_580857
  var valid_580858 = query.getOrDefault("userIp")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "userIp", valid_580858
  var valid_580859 = query.getOrDefault("key")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "key", valid_580859
  var valid_580860 = query.getOrDefault("prettyPrint")
  valid_580860 = validateParameter(valid_580860, JBool, required = false,
                                 default = newJBool(true))
  if valid_580860 != nil:
    section.add "prettyPrint", valid_580860
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

proc call*(call_580862: Call_GmailUsersSettingsSendAsSmimeInfoInsert_580849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  let valid = call_580862.validator(path, query, header, formData, body)
  let scheme = call_580862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580862.url(scheme.get, call_580862.host, call_580862.base,
                         call_580862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580862, url, valid)

proc call*(call_580863: Call_GmailUsersSettingsSendAsSmimeInfoInsert_580849;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoInsert
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580864 = newJObject()
  var query_580865 = newJObject()
  var body_580866 = newJObject()
  add(query_580865, "fields", newJString(fields))
  add(query_580865, "quotaUser", newJString(quotaUser))
  add(query_580865, "alt", newJString(alt))
  add(path_580864, "sendAsEmail", newJString(sendAsEmail))
  add(query_580865, "oauth_token", newJString(oauthToken))
  add(query_580865, "userIp", newJString(userIp))
  add(query_580865, "key", newJString(key))
  if body != nil:
    body_580866 = body
  add(query_580865, "prettyPrint", newJBool(prettyPrint))
  add(path_580864, "userId", newJString(userId))
  result = call_580863.call(path_580864, query_580865, nil, nil, body_580866)

var gmailUsersSettingsSendAsSmimeInfoInsert* = Call_GmailUsersSettingsSendAsSmimeInfoInsert_580849(
    name: "gmailUsersSettingsSendAsSmimeInfoInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoInsert_580850,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoInsert_580851,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoList_580833 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsSmimeInfoList_580835(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/smimeInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsSmimeInfoList_580834(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580836 = path.getOrDefault("sendAsEmail")
  valid_580836 = validateParameter(valid_580836, JString, required = true,
                                 default = nil)
  if valid_580836 != nil:
    section.add "sendAsEmail", valid_580836
  var valid_580837 = path.getOrDefault("userId")
  valid_580837 = validateParameter(valid_580837, JString, required = true,
                                 default = newJString("me"))
  if valid_580837 != nil:
    section.add "userId", valid_580837
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
  var valid_580838 = query.getOrDefault("fields")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "fields", valid_580838
  var valid_580839 = query.getOrDefault("quotaUser")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "quotaUser", valid_580839
  var valid_580840 = query.getOrDefault("alt")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = newJString("json"))
  if valid_580840 != nil:
    section.add "alt", valid_580840
  var valid_580841 = query.getOrDefault("oauth_token")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "oauth_token", valid_580841
  var valid_580842 = query.getOrDefault("userIp")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "userIp", valid_580842
  var valid_580843 = query.getOrDefault("key")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "key", valid_580843
  var valid_580844 = query.getOrDefault("prettyPrint")
  valid_580844 = validateParameter(valid_580844, JBool, required = false,
                                 default = newJBool(true))
  if valid_580844 != nil:
    section.add "prettyPrint", valid_580844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580845: Call_GmailUsersSettingsSendAsSmimeInfoList_580833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  let valid = call_580845.validator(path, query, header, formData, body)
  let scheme = call_580845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580845.url(scheme.get, call_580845.host, call_580845.base,
                         call_580845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580845, url, valid)

proc call*(call_580846: Call_GmailUsersSettingsSendAsSmimeInfoList_580833;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoList
  ## Lists S/MIME configs for the specified send-as alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580847 = newJObject()
  var query_580848 = newJObject()
  add(query_580848, "fields", newJString(fields))
  add(query_580848, "quotaUser", newJString(quotaUser))
  add(query_580848, "alt", newJString(alt))
  add(path_580847, "sendAsEmail", newJString(sendAsEmail))
  add(query_580848, "oauth_token", newJString(oauthToken))
  add(query_580848, "userIp", newJString(userIp))
  add(query_580848, "key", newJString(key))
  add(query_580848, "prettyPrint", newJBool(prettyPrint))
  add(path_580847, "userId", newJString(userId))
  result = call_580846.call(path_580847, query_580848, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoList* = Call_GmailUsersSettingsSendAsSmimeInfoList_580833(
    name: "gmailUsersSettingsSendAsSmimeInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoList_580834,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoList_580835,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoGet_580867 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsSmimeInfoGet_580869(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/smimeInfo/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsSmimeInfoGet_580868(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580870 = path.getOrDefault("sendAsEmail")
  valid_580870 = validateParameter(valid_580870, JString, required = true,
                                 default = nil)
  if valid_580870 != nil:
    section.add "sendAsEmail", valid_580870
  var valid_580871 = path.getOrDefault("id")
  valid_580871 = validateParameter(valid_580871, JString, required = true,
                                 default = nil)
  if valid_580871 != nil:
    section.add "id", valid_580871
  var valid_580872 = path.getOrDefault("userId")
  valid_580872 = validateParameter(valid_580872, JString, required = true,
                                 default = newJString("me"))
  if valid_580872 != nil:
    section.add "userId", valid_580872
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
  var valid_580873 = query.getOrDefault("fields")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "fields", valid_580873
  var valid_580874 = query.getOrDefault("quotaUser")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "quotaUser", valid_580874
  var valid_580875 = query.getOrDefault("alt")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = newJString("json"))
  if valid_580875 != nil:
    section.add "alt", valid_580875
  var valid_580876 = query.getOrDefault("oauth_token")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "oauth_token", valid_580876
  var valid_580877 = query.getOrDefault("userIp")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "userIp", valid_580877
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("prettyPrint")
  valid_580879 = validateParameter(valid_580879, JBool, required = false,
                                 default = newJBool(true))
  if valid_580879 != nil:
    section.add "prettyPrint", valid_580879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580880: Call_GmailUsersSettingsSendAsSmimeInfoGet_580867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_580880.validator(path, query, header, formData, body)
  let scheme = call_580880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580880.url(scheme.get, call_580880.host, call_580880.base,
                         call_580880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580880, url, valid)

proc call*(call_580881: Call_GmailUsersSettingsSendAsSmimeInfoGet_580867;
          sendAsEmail: string; id: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoGet
  ## Gets the specified S/MIME config for the specified send-as alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580882 = newJObject()
  var query_580883 = newJObject()
  add(query_580883, "fields", newJString(fields))
  add(query_580883, "quotaUser", newJString(quotaUser))
  add(query_580883, "alt", newJString(alt))
  add(path_580882, "sendAsEmail", newJString(sendAsEmail))
  add(query_580883, "oauth_token", newJString(oauthToken))
  add(query_580883, "userIp", newJString(userIp))
  add(path_580882, "id", newJString(id))
  add(query_580883, "key", newJString(key))
  add(query_580883, "prettyPrint", newJBool(prettyPrint))
  add(path_580882, "userId", newJString(userId))
  result = call_580881.call(path_580882, query_580883, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoGet* = Call_GmailUsersSettingsSendAsSmimeInfoGet_580867(
    name: "gmailUsersSettingsSendAsSmimeInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoGet_580868,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoGet_580869,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoDelete_580884 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsSmimeInfoDelete_580886(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/smimeInfo/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsSmimeInfoDelete_580885(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580887 = path.getOrDefault("sendAsEmail")
  valid_580887 = validateParameter(valid_580887, JString, required = true,
                                 default = nil)
  if valid_580887 != nil:
    section.add "sendAsEmail", valid_580887
  var valid_580888 = path.getOrDefault("id")
  valid_580888 = validateParameter(valid_580888, JString, required = true,
                                 default = nil)
  if valid_580888 != nil:
    section.add "id", valid_580888
  var valid_580889 = path.getOrDefault("userId")
  valid_580889 = validateParameter(valid_580889, JString, required = true,
                                 default = newJString("me"))
  if valid_580889 != nil:
    section.add "userId", valid_580889
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
  var valid_580890 = query.getOrDefault("fields")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "fields", valid_580890
  var valid_580891 = query.getOrDefault("quotaUser")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "quotaUser", valid_580891
  var valid_580892 = query.getOrDefault("alt")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = newJString("json"))
  if valid_580892 != nil:
    section.add "alt", valid_580892
  var valid_580893 = query.getOrDefault("oauth_token")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "oauth_token", valid_580893
  var valid_580894 = query.getOrDefault("userIp")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "userIp", valid_580894
  var valid_580895 = query.getOrDefault("key")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "key", valid_580895
  var valid_580896 = query.getOrDefault("prettyPrint")
  valid_580896 = validateParameter(valid_580896, JBool, required = false,
                                 default = newJBool(true))
  if valid_580896 != nil:
    section.add "prettyPrint", valid_580896
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580897: Call_GmailUsersSettingsSendAsSmimeInfoDelete_580884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_580897.validator(path, query, header, formData, body)
  let scheme = call_580897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580897.url(scheme.get, call_580897.host, call_580897.base,
                         call_580897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580897, url, valid)

proc call*(call_580898: Call_GmailUsersSettingsSendAsSmimeInfoDelete_580884;
          sendAsEmail: string; id: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoDelete
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580899 = newJObject()
  var query_580900 = newJObject()
  add(query_580900, "fields", newJString(fields))
  add(query_580900, "quotaUser", newJString(quotaUser))
  add(query_580900, "alt", newJString(alt))
  add(path_580899, "sendAsEmail", newJString(sendAsEmail))
  add(query_580900, "oauth_token", newJString(oauthToken))
  add(query_580900, "userIp", newJString(userIp))
  add(path_580899, "id", newJString(id))
  add(query_580900, "key", newJString(key))
  add(query_580900, "prettyPrint", newJBool(prettyPrint))
  add(path_580899, "userId", newJString(userId))
  result = call_580898.call(path_580899, query_580900, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoDelete* = Call_GmailUsersSettingsSendAsSmimeInfoDelete_580884(
    name: "gmailUsersSettingsSendAsSmimeInfoDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoDelete_580885,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoDelete_580886,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_580901 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsSmimeInfoSetDefault_580903(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/smimeInfo/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/setDefault")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_580902(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580904 = path.getOrDefault("sendAsEmail")
  valid_580904 = validateParameter(valid_580904, JString, required = true,
                                 default = nil)
  if valid_580904 != nil:
    section.add "sendAsEmail", valid_580904
  var valid_580905 = path.getOrDefault("id")
  valid_580905 = validateParameter(valid_580905, JString, required = true,
                                 default = nil)
  if valid_580905 != nil:
    section.add "id", valid_580905
  var valid_580906 = path.getOrDefault("userId")
  valid_580906 = validateParameter(valid_580906, JString, required = true,
                                 default = newJString("me"))
  if valid_580906 != nil:
    section.add "userId", valid_580906
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
  var valid_580907 = query.getOrDefault("fields")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "fields", valid_580907
  var valid_580908 = query.getOrDefault("quotaUser")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "quotaUser", valid_580908
  var valid_580909 = query.getOrDefault("alt")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = newJString("json"))
  if valid_580909 != nil:
    section.add "alt", valid_580909
  var valid_580910 = query.getOrDefault("oauth_token")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "oauth_token", valid_580910
  var valid_580911 = query.getOrDefault("userIp")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "userIp", valid_580911
  var valid_580912 = query.getOrDefault("key")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "key", valid_580912
  var valid_580913 = query.getOrDefault("prettyPrint")
  valid_580913 = validateParameter(valid_580913, JBool, required = false,
                                 default = newJBool(true))
  if valid_580913 != nil:
    section.add "prettyPrint", valid_580913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580914: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_580901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  let valid = call_580914.validator(path, query, header, formData, body)
  let scheme = call_580914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580914.url(scheme.get, call_580914.host, call_580914.base,
                         call_580914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580914, url, valid)

proc call*(call_580915: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_580901;
          sendAsEmail: string; id: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoSetDefault
  ## Sets the default S/MIME config for the specified send-as alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580916 = newJObject()
  var query_580917 = newJObject()
  add(query_580917, "fields", newJString(fields))
  add(query_580917, "quotaUser", newJString(quotaUser))
  add(query_580917, "alt", newJString(alt))
  add(path_580916, "sendAsEmail", newJString(sendAsEmail))
  add(query_580917, "oauth_token", newJString(oauthToken))
  add(query_580917, "userIp", newJString(userIp))
  add(path_580916, "id", newJString(id))
  add(query_580917, "key", newJString(key))
  add(query_580917, "prettyPrint", newJBool(prettyPrint))
  add(path_580916, "userId", newJString(userId))
  result = call_580915.call(path_580916, query_580917, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoSetDefault* = Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_580901(
    name: "gmailUsersSettingsSendAsSmimeInfoSetDefault",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}/setDefault",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_580902,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoSetDefault_580903,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsVerify_580918 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsSendAsVerify_580920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "sendAsEmail" in path, "`sendAsEmail` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/sendAs/"),
               (kind: VariableSegment, value: "sendAsEmail"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsSendAsVerify_580919(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be verified.
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sendAsEmail` field"
  var valid_580921 = path.getOrDefault("sendAsEmail")
  valid_580921 = validateParameter(valid_580921, JString, required = true,
                                 default = nil)
  if valid_580921 != nil:
    section.add "sendAsEmail", valid_580921
  var valid_580922 = path.getOrDefault("userId")
  valid_580922 = validateParameter(valid_580922, JString, required = true,
                                 default = newJString("me"))
  if valid_580922 != nil:
    section.add "userId", valid_580922
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
  var valid_580923 = query.getOrDefault("fields")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "fields", valid_580923
  var valid_580924 = query.getOrDefault("quotaUser")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "quotaUser", valid_580924
  var valid_580925 = query.getOrDefault("alt")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = newJString("json"))
  if valid_580925 != nil:
    section.add "alt", valid_580925
  var valid_580926 = query.getOrDefault("oauth_token")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = nil)
  if valid_580926 != nil:
    section.add "oauth_token", valid_580926
  var valid_580927 = query.getOrDefault("userIp")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "userIp", valid_580927
  var valid_580928 = query.getOrDefault("key")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "key", valid_580928
  var valid_580929 = query.getOrDefault("prettyPrint")
  valid_580929 = validateParameter(valid_580929, JBool, required = false,
                                 default = newJBool(true))
  if valid_580929 != nil:
    section.add "prettyPrint", valid_580929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580930: Call_GmailUsersSettingsSendAsVerify_580918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_580930.validator(path, query, header, formData, body)
  let scheme = call_580930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580930.url(scheme.get, call_580930.host, call_580930.base,
                         call_580930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580930, url, valid)

proc call*(call_580931: Call_GmailUsersSettingsSendAsVerify_580918;
          sendAsEmail: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsSendAsVerify
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be verified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580932 = newJObject()
  var query_580933 = newJObject()
  add(query_580933, "fields", newJString(fields))
  add(query_580933, "quotaUser", newJString(quotaUser))
  add(query_580933, "alt", newJString(alt))
  add(path_580932, "sendAsEmail", newJString(sendAsEmail))
  add(query_580933, "oauth_token", newJString(oauthToken))
  add(query_580933, "userIp", newJString(userIp))
  add(query_580933, "key", newJString(key))
  add(query_580933, "prettyPrint", newJBool(prettyPrint))
  add(path_580932, "userId", newJString(userId))
  result = call_580931.call(path_580932, query_580933, nil, nil, nil)

var gmailUsersSettingsSendAsVerify* = Call_GmailUsersSettingsSendAsVerify_580918(
    name: "gmailUsersSettingsSendAsVerify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/verify",
    validator: validate_GmailUsersSettingsSendAsVerify_580919,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsVerify_580920,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateVacation_580949 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsUpdateVacation_580951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/vacation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsUpdateVacation_580950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vacation responder settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580952 = path.getOrDefault("userId")
  valid_580952 = validateParameter(valid_580952, JString, required = true,
                                 default = newJString("me"))
  if valid_580952 != nil:
    section.add "userId", valid_580952
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
  var valid_580953 = query.getOrDefault("fields")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "fields", valid_580953
  var valid_580954 = query.getOrDefault("quotaUser")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "quotaUser", valid_580954
  var valid_580955 = query.getOrDefault("alt")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = newJString("json"))
  if valid_580955 != nil:
    section.add "alt", valid_580955
  var valid_580956 = query.getOrDefault("oauth_token")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = nil)
  if valid_580956 != nil:
    section.add "oauth_token", valid_580956
  var valid_580957 = query.getOrDefault("userIp")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "userIp", valid_580957
  var valid_580958 = query.getOrDefault("key")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "key", valid_580958
  var valid_580959 = query.getOrDefault("prettyPrint")
  valid_580959 = validateParameter(valid_580959, JBool, required = false,
                                 default = newJBool(true))
  if valid_580959 != nil:
    section.add "prettyPrint", valid_580959
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

proc call*(call_580961: Call_GmailUsersSettingsUpdateVacation_580949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vacation responder settings.
  ## 
  let valid = call_580961.validator(path, query, header, formData, body)
  let scheme = call_580961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580961.url(scheme.get, call_580961.host, call_580961.base,
                         call_580961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580961, url, valid)

proc call*(call_580962: Call_GmailUsersSettingsUpdateVacation_580949;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsUpdateVacation
  ## Updates vacation responder settings.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580963 = newJObject()
  var query_580964 = newJObject()
  var body_580965 = newJObject()
  add(query_580964, "fields", newJString(fields))
  add(query_580964, "quotaUser", newJString(quotaUser))
  add(query_580964, "alt", newJString(alt))
  add(query_580964, "oauth_token", newJString(oauthToken))
  add(query_580964, "userIp", newJString(userIp))
  add(query_580964, "key", newJString(key))
  if body != nil:
    body_580965 = body
  add(query_580964, "prettyPrint", newJBool(prettyPrint))
  add(path_580963, "userId", newJString(userId))
  result = call_580962.call(path_580963, query_580964, nil, nil, body_580965)

var gmailUsersSettingsUpdateVacation* = Call_GmailUsersSettingsUpdateVacation_580949(
    name: "gmailUsersSettingsUpdateVacation", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsUpdateVacation_580950,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateVacation_580951,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetVacation_580934 = ref object of OpenApiRestCall_579424
proc url_GmailUsersSettingsGetVacation_580936(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/settings/vacation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersSettingsGetVacation_580935(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets vacation responder settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580937 = path.getOrDefault("userId")
  valid_580937 = validateParameter(valid_580937, JString, required = true,
                                 default = newJString("me"))
  if valid_580937 != nil:
    section.add "userId", valid_580937
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
  var valid_580938 = query.getOrDefault("fields")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "fields", valid_580938
  var valid_580939 = query.getOrDefault("quotaUser")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "quotaUser", valid_580939
  var valid_580940 = query.getOrDefault("alt")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = newJString("json"))
  if valid_580940 != nil:
    section.add "alt", valid_580940
  var valid_580941 = query.getOrDefault("oauth_token")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "oauth_token", valid_580941
  var valid_580942 = query.getOrDefault("userIp")
  valid_580942 = validateParameter(valid_580942, JString, required = false,
                                 default = nil)
  if valid_580942 != nil:
    section.add "userIp", valid_580942
  var valid_580943 = query.getOrDefault("key")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = nil)
  if valid_580943 != nil:
    section.add "key", valid_580943
  var valid_580944 = query.getOrDefault("prettyPrint")
  valid_580944 = validateParameter(valid_580944, JBool, required = false,
                                 default = newJBool(true))
  if valid_580944 != nil:
    section.add "prettyPrint", valid_580944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580945: Call_GmailUsersSettingsGetVacation_580934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets vacation responder settings.
  ## 
  let valid = call_580945.validator(path, query, header, formData, body)
  let scheme = call_580945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580945.url(scheme.get, call_580945.host, call_580945.base,
                         call_580945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580945, url, valid)

proc call*(call_580946: Call_GmailUsersSettingsGetVacation_580934;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersSettingsGetVacation
  ## Gets vacation responder settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  var path_580947 = newJObject()
  var query_580948 = newJObject()
  add(query_580948, "fields", newJString(fields))
  add(query_580948, "quotaUser", newJString(quotaUser))
  add(query_580948, "alt", newJString(alt))
  add(query_580948, "oauth_token", newJString(oauthToken))
  add(query_580948, "userIp", newJString(userIp))
  add(query_580948, "key", newJString(key))
  add(query_580948, "prettyPrint", newJBool(prettyPrint))
  add(path_580947, "userId", newJString(userId))
  result = call_580946.call(path_580947, query_580948, nil, nil, nil)

var gmailUsersSettingsGetVacation* = Call_GmailUsersSettingsGetVacation_580934(
    name: "gmailUsersSettingsGetVacation", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsGetVacation_580935,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetVacation_580936,
    schemes: {Scheme.Https})
type
  Call_GmailUsersStop_580966 = ref object of OpenApiRestCall_579424
proc url_GmailUsersStop_580968(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersStop_580967(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Stop receiving push notifications for the given user mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580969 = path.getOrDefault("userId")
  valid_580969 = validateParameter(valid_580969, JString, required = true,
                                 default = newJString("me"))
  if valid_580969 != nil:
    section.add "userId", valid_580969
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
  var valid_580970 = query.getOrDefault("fields")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "fields", valid_580970
  var valid_580971 = query.getOrDefault("quotaUser")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "quotaUser", valid_580971
  var valid_580972 = query.getOrDefault("alt")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = newJString("json"))
  if valid_580972 != nil:
    section.add "alt", valid_580972
  var valid_580973 = query.getOrDefault("oauth_token")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "oauth_token", valid_580973
  var valid_580974 = query.getOrDefault("userIp")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "userIp", valid_580974
  var valid_580975 = query.getOrDefault("key")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "key", valid_580975
  var valid_580976 = query.getOrDefault("prettyPrint")
  valid_580976 = validateParameter(valid_580976, JBool, required = false,
                                 default = newJBool(true))
  if valid_580976 != nil:
    section.add "prettyPrint", valid_580976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580977: Call_GmailUsersStop_580966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop receiving push notifications for the given user mailbox.
  ## 
  let valid = call_580977.validator(path, query, header, formData, body)
  let scheme = call_580977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580977.url(scheme.get, call_580977.host, call_580977.base,
                         call_580977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580977, url, valid)

proc call*(call_580978: Call_GmailUsersStop_580966; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          userId: string = "me"): Recallable =
  ## gmailUsersStop
  ## Stop receiving push notifications for the given user mailbox.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580979 = newJObject()
  var query_580980 = newJObject()
  add(query_580980, "fields", newJString(fields))
  add(query_580980, "quotaUser", newJString(quotaUser))
  add(query_580980, "alt", newJString(alt))
  add(query_580980, "oauth_token", newJString(oauthToken))
  add(query_580980, "userIp", newJString(userIp))
  add(query_580980, "key", newJString(key))
  add(query_580980, "prettyPrint", newJBool(prettyPrint))
  add(path_580979, "userId", newJString(userId))
  result = call_580978.call(path_580979, query_580980, nil, nil, nil)

var gmailUsersStop* = Call_GmailUsersStop_580966(name: "gmailUsersStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/stop",
    validator: validate_GmailUsersStop_580967, base: "/gmail/v1/users",
    url: url_GmailUsersStop_580968, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsList_580981 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsList_580983(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsList_580982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the threads in the user's mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580984 = path.getOrDefault("userId")
  valid_580984 = validateParameter(valid_580984, JString, required = true,
                                 default = newJString("me"))
  if valid_580984 != nil:
    section.add "userId", valid_580984
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of threads to return.
  ##   includeSpamTrash: JBool
  ##                   : Include threads from SPAM and TRASH in the results.
  ##   q: JString
  ##    : Only return threads matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   labelIds: JArray
  ##           : Only return threads with labels that match all of the specified label IDs.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580985 = query.getOrDefault("fields")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "fields", valid_580985
  var valid_580986 = query.getOrDefault("pageToken")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "pageToken", valid_580986
  var valid_580987 = query.getOrDefault("quotaUser")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "quotaUser", valid_580987
  var valid_580988 = query.getOrDefault("alt")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = newJString("json"))
  if valid_580988 != nil:
    section.add "alt", valid_580988
  var valid_580989 = query.getOrDefault("oauth_token")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "oauth_token", valid_580989
  var valid_580990 = query.getOrDefault("userIp")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "userIp", valid_580990
  var valid_580991 = query.getOrDefault("maxResults")
  valid_580991 = validateParameter(valid_580991, JInt, required = false,
                                 default = newJInt(100))
  if valid_580991 != nil:
    section.add "maxResults", valid_580991
  var valid_580992 = query.getOrDefault("includeSpamTrash")
  valid_580992 = validateParameter(valid_580992, JBool, required = false,
                                 default = newJBool(false))
  if valid_580992 != nil:
    section.add "includeSpamTrash", valid_580992
  var valid_580993 = query.getOrDefault("q")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "q", valid_580993
  var valid_580994 = query.getOrDefault("labelIds")
  valid_580994 = validateParameter(valid_580994, JArray, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "labelIds", valid_580994
  var valid_580995 = query.getOrDefault("key")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "key", valid_580995
  var valid_580996 = query.getOrDefault("prettyPrint")
  valid_580996 = validateParameter(valid_580996, JBool, required = false,
                                 default = newJBool(true))
  if valid_580996 != nil:
    section.add "prettyPrint", valid_580996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580997: Call_GmailUsersThreadsList_580981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the threads in the user's mailbox.
  ## 
  let valid = call_580997.validator(path, query, header, formData, body)
  let scheme = call_580997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580997.url(scheme.get, call_580997.host, call_580997.base,
                         call_580997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580997, url, valid)

proc call*(call_580998: Call_GmailUsersThreadsList_580981; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 100;
          includeSpamTrash: bool = false; q: string = ""; labelIds: JsonNode = nil;
          key: string = ""; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersThreadsList
  ## Lists the threads in the user's mailbox.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of threads to return.
  ##   includeSpamTrash: bool
  ##                   : Include threads from SPAM and TRASH in the results.
  ##   q: string
  ##    : Only return threads matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   labelIds: JArray
  ##           : Only return threads with labels that match all of the specified label IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_580999 = newJObject()
  var query_581000 = newJObject()
  add(query_581000, "fields", newJString(fields))
  add(query_581000, "pageToken", newJString(pageToken))
  add(query_581000, "quotaUser", newJString(quotaUser))
  add(query_581000, "alt", newJString(alt))
  add(query_581000, "oauth_token", newJString(oauthToken))
  add(query_581000, "userIp", newJString(userIp))
  add(query_581000, "maxResults", newJInt(maxResults))
  add(query_581000, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_581000, "q", newJString(q))
  if labelIds != nil:
    query_581000.add "labelIds", labelIds
  add(query_581000, "key", newJString(key))
  add(query_581000, "prettyPrint", newJBool(prettyPrint))
  add(path_580999, "userId", newJString(userId))
  result = call_580998.call(path_580999, query_581000, nil, nil, nil)

var gmailUsersThreadsList* = Call_GmailUsersThreadsList_580981(
    name: "gmailUsersThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads",
    validator: validate_GmailUsersThreadsList_580982, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsList_580983, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsGet_581001 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsGet_581003(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsGet_581002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified thread.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the thread to retrieve.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_581004 = path.getOrDefault("id")
  valid_581004 = validateParameter(valid_581004, JString, required = true,
                                 default = nil)
  if valid_581004 != nil:
    section.add "id", valid_581004
  var valid_581005 = path.getOrDefault("userId")
  valid_581005 = validateParameter(valid_581005, JString, required = true,
                                 default = newJString("me"))
  if valid_581005 != nil:
    section.add "userId", valid_581005
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
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : The format to return the messages in.
  section = newJObject()
  var valid_581006 = query.getOrDefault("fields")
  valid_581006 = validateParameter(valid_581006, JString, required = false,
                                 default = nil)
  if valid_581006 != nil:
    section.add "fields", valid_581006
  var valid_581007 = query.getOrDefault("quotaUser")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "quotaUser", valid_581007
  var valid_581008 = query.getOrDefault("alt")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = newJString("json"))
  if valid_581008 != nil:
    section.add "alt", valid_581008
  var valid_581009 = query.getOrDefault("oauth_token")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "oauth_token", valid_581009
  var valid_581010 = query.getOrDefault("userIp")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = nil)
  if valid_581010 != nil:
    section.add "userIp", valid_581010
  var valid_581011 = query.getOrDefault("metadataHeaders")
  valid_581011 = validateParameter(valid_581011, JArray, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "metadataHeaders", valid_581011
  var valid_581012 = query.getOrDefault("key")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "key", valid_581012
  var valid_581013 = query.getOrDefault("prettyPrint")
  valid_581013 = validateParameter(valid_581013, JBool, required = false,
                                 default = newJBool(true))
  if valid_581013 != nil:
    section.add "prettyPrint", valid_581013
  var valid_581014 = query.getOrDefault("format")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = newJString("full"))
  if valid_581014 != nil:
    section.add "format", valid_581014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581015: Call_GmailUsersThreadsGet_581001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified thread.
  ## 
  let valid = call_581015.validator(path, query, header, formData, body)
  let scheme = call_581015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581015.url(scheme.get, call_581015.host, call_581015.base,
                         call_581015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581015, url, valid)

proc call*(call_581016: Call_GmailUsersThreadsGet_581001; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; metadataHeaders: JsonNode = nil;
          key: string = ""; prettyPrint: bool = true; format: string = "full";
          userId: string = "me"): Recallable =
  ## gmailUsersThreadsGet
  ## Gets the specified thread.
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
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   id: string (required)
  ##     : The ID of the thread to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The format to return the messages in.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581017 = newJObject()
  var query_581018 = newJObject()
  add(query_581018, "fields", newJString(fields))
  add(query_581018, "quotaUser", newJString(quotaUser))
  add(query_581018, "alt", newJString(alt))
  add(query_581018, "oauth_token", newJString(oauthToken))
  add(query_581018, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_581018.add "metadataHeaders", metadataHeaders
  add(path_581017, "id", newJString(id))
  add(query_581018, "key", newJString(key))
  add(query_581018, "prettyPrint", newJBool(prettyPrint))
  add(query_581018, "format", newJString(format))
  add(path_581017, "userId", newJString(userId))
  result = call_581016.call(path_581017, query_581018, nil, nil, nil)

var gmailUsersThreadsGet* = Call_GmailUsersThreadsGet_581001(
    name: "gmailUsersThreadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsGet_581002, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsGet_581003, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsDelete_581019 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsDelete_581021(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsDelete_581020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : ID of the Thread to delete.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_581022 = path.getOrDefault("id")
  valid_581022 = validateParameter(valid_581022, JString, required = true,
                                 default = nil)
  if valid_581022 != nil:
    section.add "id", valid_581022
  var valid_581023 = path.getOrDefault("userId")
  valid_581023 = validateParameter(valid_581023, JString, required = true,
                                 default = newJString("me"))
  if valid_581023 != nil:
    section.add "userId", valid_581023
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
  var valid_581024 = query.getOrDefault("fields")
  valid_581024 = validateParameter(valid_581024, JString, required = false,
                                 default = nil)
  if valid_581024 != nil:
    section.add "fields", valid_581024
  var valid_581025 = query.getOrDefault("quotaUser")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "quotaUser", valid_581025
  var valid_581026 = query.getOrDefault("alt")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = newJString("json"))
  if valid_581026 != nil:
    section.add "alt", valid_581026
  var valid_581027 = query.getOrDefault("oauth_token")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "oauth_token", valid_581027
  var valid_581028 = query.getOrDefault("userIp")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = nil)
  if valid_581028 != nil:
    section.add "userIp", valid_581028
  var valid_581029 = query.getOrDefault("key")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = nil)
  if valid_581029 != nil:
    section.add "key", valid_581029
  var valid_581030 = query.getOrDefault("prettyPrint")
  valid_581030 = validateParameter(valid_581030, JBool, required = false,
                                 default = newJBool(true))
  if valid_581030 != nil:
    section.add "prettyPrint", valid_581030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581031: Call_GmailUsersThreadsDelete_581019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ## 
  let valid = call_581031.validator(path, query, header, formData, body)
  let scheme = call_581031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581031.url(scheme.get, call_581031.host, call_581031.base,
                         call_581031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581031, url, valid)

proc call*(call_581032: Call_GmailUsersThreadsDelete_581019; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersThreadsDelete
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
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
  ##   id: string (required)
  ##     : ID of the Thread to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581033 = newJObject()
  var query_581034 = newJObject()
  add(query_581034, "fields", newJString(fields))
  add(query_581034, "quotaUser", newJString(quotaUser))
  add(query_581034, "alt", newJString(alt))
  add(query_581034, "oauth_token", newJString(oauthToken))
  add(query_581034, "userIp", newJString(userIp))
  add(path_581033, "id", newJString(id))
  add(query_581034, "key", newJString(key))
  add(query_581034, "prettyPrint", newJBool(prettyPrint))
  add(path_581033, "userId", newJString(userId))
  result = call_581032.call(path_581033, query_581034, nil, nil, nil)

var gmailUsersThreadsDelete* = Call_GmailUsersThreadsDelete_581019(
    name: "gmailUsersThreadsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsDelete_581020, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsDelete_581021, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsModify_581035 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsModify_581037(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/modify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsModify_581036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the thread to modify.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_581038 = path.getOrDefault("id")
  valid_581038 = validateParameter(valid_581038, JString, required = true,
                                 default = nil)
  if valid_581038 != nil:
    section.add "id", valid_581038
  var valid_581039 = path.getOrDefault("userId")
  valid_581039 = validateParameter(valid_581039, JString, required = true,
                                 default = newJString("me"))
  if valid_581039 != nil:
    section.add "userId", valid_581039
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
  var valid_581040 = query.getOrDefault("fields")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = nil)
  if valid_581040 != nil:
    section.add "fields", valid_581040
  var valid_581041 = query.getOrDefault("quotaUser")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = nil)
  if valid_581041 != nil:
    section.add "quotaUser", valid_581041
  var valid_581042 = query.getOrDefault("alt")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = newJString("json"))
  if valid_581042 != nil:
    section.add "alt", valid_581042
  var valid_581043 = query.getOrDefault("oauth_token")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "oauth_token", valid_581043
  var valid_581044 = query.getOrDefault("userIp")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "userIp", valid_581044
  var valid_581045 = query.getOrDefault("key")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = nil)
  if valid_581045 != nil:
    section.add "key", valid_581045
  var valid_581046 = query.getOrDefault("prettyPrint")
  valid_581046 = validateParameter(valid_581046, JBool, required = false,
                                 default = newJBool(true))
  if valid_581046 != nil:
    section.add "prettyPrint", valid_581046
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

proc call*(call_581048: Call_GmailUsersThreadsModify_581035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ## 
  let valid = call_581048.validator(path, query, header, formData, body)
  let scheme = call_581048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581048.url(scheme.get, call_581048.host, call_581048.base,
                         call_581048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581048, url, valid)

proc call*(call_581049: Call_GmailUsersThreadsModify_581035; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersThreadsModify
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
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
  ##   id: string (required)
  ##     : The ID of the thread to modify.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581050 = newJObject()
  var query_581051 = newJObject()
  var body_581052 = newJObject()
  add(query_581051, "fields", newJString(fields))
  add(query_581051, "quotaUser", newJString(quotaUser))
  add(query_581051, "alt", newJString(alt))
  add(query_581051, "oauth_token", newJString(oauthToken))
  add(query_581051, "userIp", newJString(userIp))
  add(path_581050, "id", newJString(id))
  add(query_581051, "key", newJString(key))
  if body != nil:
    body_581052 = body
  add(query_581051, "prettyPrint", newJBool(prettyPrint))
  add(path_581050, "userId", newJString(userId))
  result = call_581049.call(path_581050, query_581051, nil, nil, body_581052)

var gmailUsersThreadsModify* = Call_GmailUsersThreadsModify_581035(
    name: "gmailUsersThreadsModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/modify",
    validator: validate_GmailUsersThreadsModify_581036, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsModify_581037, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsTrash_581053 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsTrash_581055(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/trash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsTrash_581054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Moves the specified thread to the trash.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the thread to Trash.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_581056 = path.getOrDefault("id")
  valid_581056 = validateParameter(valid_581056, JString, required = true,
                                 default = nil)
  if valid_581056 != nil:
    section.add "id", valid_581056
  var valid_581057 = path.getOrDefault("userId")
  valid_581057 = validateParameter(valid_581057, JString, required = true,
                                 default = newJString("me"))
  if valid_581057 != nil:
    section.add "userId", valid_581057
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
  var valid_581058 = query.getOrDefault("fields")
  valid_581058 = validateParameter(valid_581058, JString, required = false,
                                 default = nil)
  if valid_581058 != nil:
    section.add "fields", valid_581058
  var valid_581059 = query.getOrDefault("quotaUser")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "quotaUser", valid_581059
  var valid_581060 = query.getOrDefault("alt")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = newJString("json"))
  if valid_581060 != nil:
    section.add "alt", valid_581060
  var valid_581061 = query.getOrDefault("oauth_token")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "oauth_token", valid_581061
  var valid_581062 = query.getOrDefault("userIp")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "userIp", valid_581062
  var valid_581063 = query.getOrDefault("key")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = nil)
  if valid_581063 != nil:
    section.add "key", valid_581063
  var valid_581064 = query.getOrDefault("prettyPrint")
  valid_581064 = validateParameter(valid_581064, JBool, required = false,
                                 default = newJBool(true))
  if valid_581064 != nil:
    section.add "prettyPrint", valid_581064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581065: Call_GmailUsersThreadsTrash_581053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified thread to the trash.
  ## 
  let valid = call_581065.validator(path, query, header, formData, body)
  let scheme = call_581065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581065.url(scheme.get, call_581065.host, call_581065.base,
                         call_581065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581065, url, valid)

proc call*(call_581066: Call_GmailUsersThreadsTrash_581053; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersThreadsTrash
  ## Moves the specified thread to the trash.
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
  ##   id: string (required)
  ##     : The ID of the thread to Trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581067 = newJObject()
  var query_581068 = newJObject()
  add(query_581068, "fields", newJString(fields))
  add(query_581068, "quotaUser", newJString(quotaUser))
  add(query_581068, "alt", newJString(alt))
  add(query_581068, "oauth_token", newJString(oauthToken))
  add(query_581068, "userIp", newJString(userIp))
  add(path_581067, "id", newJString(id))
  add(query_581068, "key", newJString(key))
  add(query_581068, "prettyPrint", newJBool(prettyPrint))
  add(path_581067, "userId", newJString(userId))
  result = call_581066.call(path_581067, query_581068, nil, nil, nil)

var gmailUsersThreadsTrash* = Call_GmailUsersThreadsTrash_581053(
    name: "gmailUsersThreadsTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/trash",
    validator: validate_GmailUsersThreadsTrash_581054, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsTrash_581055, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsUntrash_581069 = ref object of OpenApiRestCall_579424
proc url_GmailUsersThreadsUntrash_581071(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/threads/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/untrash")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersThreadsUntrash_581070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the specified thread from the trash.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the thread to remove from Trash.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_581072 = path.getOrDefault("id")
  valid_581072 = validateParameter(valid_581072, JString, required = true,
                                 default = nil)
  if valid_581072 != nil:
    section.add "id", valid_581072
  var valid_581073 = path.getOrDefault("userId")
  valid_581073 = validateParameter(valid_581073, JString, required = true,
                                 default = newJString("me"))
  if valid_581073 != nil:
    section.add "userId", valid_581073
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
  var valid_581074 = query.getOrDefault("fields")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = nil)
  if valid_581074 != nil:
    section.add "fields", valid_581074
  var valid_581075 = query.getOrDefault("quotaUser")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = nil)
  if valid_581075 != nil:
    section.add "quotaUser", valid_581075
  var valid_581076 = query.getOrDefault("alt")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = newJString("json"))
  if valid_581076 != nil:
    section.add "alt", valid_581076
  var valid_581077 = query.getOrDefault("oauth_token")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "oauth_token", valid_581077
  var valid_581078 = query.getOrDefault("userIp")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "userIp", valid_581078
  var valid_581079 = query.getOrDefault("key")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "key", valid_581079
  var valid_581080 = query.getOrDefault("prettyPrint")
  valid_581080 = validateParameter(valid_581080, JBool, required = false,
                                 default = newJBool(true))
  if valid_581080 != nil:
    section.add "prettyPrint", valid_581080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581081: Call_GmailUsersThreadsUntrash_581069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified thread from the trash.
  ## 
  let valid = call_581081.validator(path, query, header, formData, body)
  let scheme = call_581081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581081.url(scheme.get, call_581081.host, call_581081.base,
                         call_581081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581081, url, valid)

proc call*(call_581082: Call_GmailUsersThreadsUntrash_581069; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersThreadsUntrash
  ## Removes the specified thread from the trash.
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
  ##   id: string (required)
  ##     : The ID of the thread to remove from Trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581083 = newJObject()
  var query_581084 = newJObject()
  add(query_581084, "fields", newJString(fields))
  add(query_581084, "quotaUser", newJString(quotaUser))
  add(query_581084, "alt", newJString(alt))
  add(query_581084, "oauth_token", newJString(oauthToken))
  add(query_581084, "userIp", newJString(userIp))
  add(path_581083, "id", newJString(id))
  add(query_581084, "key", newJString(key))
  add(query_581084, "prettyPrint", newJBool(prettyPrint))
  add(path_581083, "userId", newJString(userId))
  result = call_581082.call(path_581083, query_581084, nil, nil, nil)

var gmailUsersThreadsUntrash* = Call_GmailUsersThreadsUntrash_581069(
    name: "gmailUsersThreadsUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/untrash",
    validator: validate_GmailUsersThreadsUntrash_581070, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsUntrash_581071, schemes: {Scheme.Https})
type
  Call_GmailUsersWatch_581085 = ref object of OpenApiRestCall_579424
proc url_GmailUsersWatch_581087(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GmailUsersWatch_581086(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Set up or update a push notification watch on the given user mailbox.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_581088 = path.getOrDefault("userId")
  valid_581088 = validateParameter(valid_581088, JString, required = true,
                                 default = newJString("me"))
  if valid_581088 != nil:
    section.add "userId", valid_581088
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
  var valid_581089 = query.getOrDefault("fields")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = nil)
  if valid_581089 != nil:
    section.add "fields", valid_581089
  var valid_581090 = query.getOrDefault("quotaUser")
  valid_581090 = validateParameter(valid_581090, JString, required = false,
                                 default = nil)
  if valid_581090 != nil:
    section.add "quotaUser", valid_581090
  var valid_581091 = query.getOrDefault("alt")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = newJString("json"))
  if valid_581091 != nil:
    section.add "alt", valid_581091
  var valid_581092 = query.getOrDefault("oauth_token")
  valid_581092 = validateParameter(valid_581092, JString, required = false,
                                 default = nil)
  if valid_581092 != nil:
    section.add "oauth_token", valid_581092
  var valid_581093 = query.getOrDefault("userIp")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "userIp", valid_581093
  var valid_581094 = query.getOrDefault("key")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "key", valid_581094
  var valid_581095 = query.getOrDefault("prettyPrint")
  valid_581095 = validateParameter(valid_581095, JBool, required = false,
                                 default = newJBool(true))
  if valid_581095 != nil:
    section.add "prettyPrint", valid_581095
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

proc call*(call_581097: Call_GmailUsersWatch_581085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set up or update a push notification watch on the given user mailbox.
  ## 
  let valid = call_581097.validator(path, query, header, formData, body)
  let scheme = call_581097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581097.url(scheme.get, call_581097.host, call_581097.base,
                         call_581097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581097, url, valid)

proc call*(call_581098: Call_GmailUsersWatch_581085; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; userId: string = "me"): Recallable =
  ## gmailUsersWatch
  ## Set up or update a push notification watch on the given user mailbox.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  var path_581099 = newJObject()
  var query_581100 = newJObject()
  var body_581101 = newJObject()
  add(query_581100, "fields", newJString(fields))
  add(query_581100, "quotaUser", newJString(quotaUser))
  add(query_581100, "alt", newJString(alt))
  add(query_581100, "oauth_token", newJString(oauthToken))
  add(query_581100, "userIp", newJString(userIp))
  add(query_581100, "key", newJString(key))
  if body != nil:
    body_581101 = body
  add(query_581100, "prettyPrint", newJBool(prettyPrint))
  add(path_581099, "userId", newJString(userId))
  result = call_581098.call(path_581099, query_581100, nil, nil, body_581101)

var gmailUsersWatch* = Call_GmailUsersWatch_581085(name: "gmailUsersWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/watch",
    validator: validate_GmailUsersWatch_581086, base: "/gmail/v1/users",
    url: url_GmailUsersWatch_581087, schemes: {Scheme.Https})
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
