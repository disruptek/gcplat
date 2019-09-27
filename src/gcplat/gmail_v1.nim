
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "gmail"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GmailUsersDraftsCreate_593981 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsCreate_593983(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsCreate_593982(path: JsonNode; query: JsonNode;
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
  var valid_593984 = path.getOrDefault("userId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("me"))
  if valid_593984 != nil:
    section.add "userId", valid_593984
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
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("oauth_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "oauth_token", valid_593988
  var valid_593989 = query.getOrDefault("userIp")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "userIp", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
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

proc call*(call_593993: Call_GmailUsersDraftsCreate_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new draft with the DRAFT label.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_GmailUsersDraftsCreate_593981; fields: string = "";
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "userIp", newJString(userIp))
  add(query_593996, "key", newJString(key))
  if body != nil:
    body_593997 = body
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  add(path_593995, "userId", newJString(userId))
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var gmailUsersDraftsCreate* = Call_GmailUsersDraftsCreate_593981(
    name: "gmailUsersDraftsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsCreate_593982, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsCreate_593983, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsList_593692 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsList_593694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsList_593693(path: JsonNode; query: JsonNode;
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
  var valid_593833 = path.getOrDefault("userId")
  valid_593833 = validateParameter(valid_593833, JString, required = true,
                                 default = newJString("me"))
  if valid_593833 != nil:
    section.add "userId", valid_593833
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
  var valid_593834 = query.getOrDefault("fields")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = nil)
  if valid_593834 != nil:
    section.add "fields", valid_593834
  var valid_593835 = query.getOrDefault("pageToken")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = nil)
  if valid_593835 != nil:
    section.add "pageToken", valid_593835
  var valid_593836 = query.getOrDefault("quotaUser")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "quotaUser", valid_593836
  var valid_593837 = query.getOrDefault("alt")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = newJString("json"))
  if valid_593837 != nil:
    section.add "alt", valid_593837
  var valid_593838 = query.getOrDefault("oauth_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "oauth_token", valid_593838
  var valid_593839 = query.getOrDefault("userIp")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "userIp", valid_593839
  var valid_593841 = query.getOrDefault("maxResults")
  valid_593841 = validateParameter(valid_593841, JInt, required = false,
                                 default = newJInt(100))
  if valid_593841 != nil:
    section.add "maxResults", valid_593841
  var valid_593842 = query.getOrDefault("includeSpamTrash")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(false))
  if valid_593842 != nil:
    section.add "includeSpamTrash", valid_593842
  var valid_593843 = query.getOrDefault("q")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "q", valid_593843
  var valid_593844 = query.getOrDefault("key")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "key", valid_593844
  var valid_593845 = query.getOrDefault("prettyPrint")
  valid_593845 = validateParameter(valid_593845, JBool, required = false,
                                 default = newJBool(true))
  if valid_593845 != nil:
    section.add "prettyPrint", valid_593845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593868: Call_GmailUsersDraftsList_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the drafts in the user's mailbox.
  ## 
  let valid = call_593868.validator(path, query, header, formData, body)
  let scheme = call_593868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593868.url(scheme.get, call_593868.host, call_593868.base,
                         call_593868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593868, url, valid)

proc call*(call_593939: Call_GmailUsersDraftsList_593692; fields: string = "";
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
  var path_593940 = newJObject()
  var query_593942 = newJObject()
  add(query_593942, "fields", newJString(fields))
  add(query_593942, "pageToken", newJString(pageToken))
  add(query_593942, "quotaUser", newJString(quotaUser))
  add(query_593942, "alt", newJString(alt))
  add(query_593942, "oauth_token", newJString(oauthToken))
  add(query_593942, "userIp", newJString(userIp))
  add(query_593942, "maxResults", newJInt(maxResults))
  add(query_593942, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_593942, "q", newJString(q))
  add(query_593942, "key", newJString(key))
  add(query_593942, "prettyPrint", newJBool(prettyPrint))
  add(path_593940, "userId", newJString(userId))
  result = call_593939.call(path_593940, query_593942, nil, nil, nil)

var gmailUsersDraftsList* = Call_GmailUsersDraftsList_593692(
    name: "gmailUsersDraftsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsList_593693, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsList_593694, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsSend_593998 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsSend_594000(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsSend_593999(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("userId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = newJString("me"))
  if valid_594001 != nil:
    section.add "userId", valid_594001
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
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("userIp")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "userIp", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
  var valid_594008 = query.getOrDefault("prettyPrint")
  valid_594008 = validateParameter(valid_594008, JBool, required = false,
                                 default = newJBool(true))
  if valid_594008 != nil:
    section.add "prettyPrint", valid_594008
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

proc call*(call_594010: Call_GmailUsersDraftsSend_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_GmailUsersDraftsSend_593998; fields: string = "";
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
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(query_594013, "fields", newJString(fields))
  add(query_594013, "quotaUser", newJString(quotaUser))
  add(query_594013, "alt", newJString(alt))
  add(query_594013, "oauth_token", newJString(oauthToken))
  add(query_594013, "userIp", newJString(userIp))
  add(query_594013, "key", newJString(key))
  if body != nil:
    body_594014 = body
  add(query_594013, "prettyPrint", newJBool(prettyPrint))
  add(path_594012, "userId", newJString(userId))
  result = call_594011.call(path_594012, query_594013, nil, nil, body_594014)

var gmailUsersDraftsSend* = Call_GmailUsersDraftsSend_593998(
    name: "gmailUsersDraftsSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts/send",
    validator: validate_GmailUsersDraftsSend_593999, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsSend_594000, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsUpdate_594032 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsUpdate_594034(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsUpdate_594033(path: JsonNode; query: JsonNode;
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
  var valid_594035 = path.getOrDefault("id")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "id", valid_594035
  var valid_594036 = path.getOrDefault("userId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = newJString("me"))
  if valid_594036 != nil:
    section.add "userId", valid_594036
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
  var valid_594037 = query.getOrDefault("fields")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "fields", valid_594037
  var valid_594038 = query.getOrDefault("quotaUser")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "quotaUser", valid_594038
  var valid_594039 = query.getOrDefault("alt")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("json"))
  if valid_594039 != nil:
    section.add "alt", valid_594039
  var valid_594040 = query.getOrDefault("oauth_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "oauth_token", valid_594040
  var valid_594041 = query.getOrDefault("userIp")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "userIp", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("prettyPrint")
  valid_594043 = validateParameter(valid_594043, JBool, required = false,
                                 default = newJBool(true))
  if valid_594043 != nil:
    section.add "prettyPrint", valid_594043
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

proc call*(call_594045: Call_GmailUsersDraftsUpdate_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces a draft's content.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_GmailUsersDraftsUpdate_594032; id: string;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  var body_594049 = newJObject()
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "userIp", newJString(userIp))
  add(path_594047, "id", newJString(id))
  add(query_594048, "key", newJString(key))
  if body != nil:
    body_594049 = body
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  add(path_594047, "userId", newJString(userId))
  result = call_594046.call(path_594047, query_594048, nil, nil, body_594049)

var gmailUsersDraftsUpdate* = Call_GmailUsersDraftsUpdate_594032(
    name: "gmailUsersDraftsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsUpdate_594033, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsUpdate_594034, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsGet_594015 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsGet_594017(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsGet_594016(path: JsonNode; query: JsonNode;
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
  var valid_594018 = path.getOrDefault("id")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "id", valid_594018
  var valid_594019 = path.getOrDefault("userId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = newJString("me"))
  if valid_594019 != nil:
    section.add "userId", valid_594019
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
  var valid_594020 = query.getOrDefault("fields")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "fields", valid_594020
  var valid_594021 = query.getOrDefault("quotaUser")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "quotaUser", valid_594021
  var valid_594022 = query.getOrDefault("alt")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = newJString("json"))
  if valid_594022 != nil:
    section.add "alt", valid_594022
  var valid_594023 = query.getOrDefault("oauth_token")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "oauth_token", valid_594023
  var valid_594024 = query.getOrDefault("userIp")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "userIp", valid_594024
  var valid_594025 = query.getOrDefault("key")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "key", valid_594025
  var valid_594026 = query.getOrDefault("prettyPrint")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "prettyPrint", valid_594026
  var valid_594027 = query.getOrDefault("format")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("full"))
  if valid_594027 != nil:
    section.add "format", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_GmailUsersDraftsGet_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified draft.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_GmailUsersDraftsGet_594015; id: string;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(query_594031, "userIp", newJString(userIp))
  add(path_594030, "id", newJString(id))
  add(query_594031, "key", newJString(key))
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  add(query_594031, "format", newJString(format))
  add(path_594030, "userId", newJString(userId))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var gmailUsersDraftsGet* = Call_GmailUsersDraftsGet_594015(
    name: "gmailUsersDraftsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsGet_594016, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsGet_594017, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsDelete_594050 = ref object of OpenApiRestCall_593424
proc url_GmailUsersDraftsDelete_594052(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersDraftsDelete_594051(path: JsonNode; query: JsonNode;
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
  var valid_594053 = path.getOrDefault("id")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "id", valid_594053
  var valid_594054 = path.getOrDefault("userId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = newJString("me"))
  if valid_594054 != nil:
    section.add "userId", valid_594054
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
  var valid_594055 = query.getOrDefault("fields")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "fields", valid_594055
  var valid_594056 = query.getOrDefault("quotaUser")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "quotaUser", valid_594056
  var valid_594057 = query.getOrDefault("alt")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("json"))
  if valid_594057 != nil:
    section.add "alt", valid_594057
  var valid_594058 = query.getOrDefault("oauth_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "oauth_token", valid_594058
  var valid_594059 = query.getOrDefault("userIp")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "userIp", valid_594059
  var valid_594060 = query.getOrDefault("key")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "key", valid_594060
  var valid_594061 = query.getOrDefault("prettyPrint")
  valid_594061 = validateParameter(valid_594061, JBool, required = false,
                                 default = newJBool(true))
  if valid_594061 != nil:
    section.add "prettyPrint", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_GmailUsersDraftsDelete_594050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_GmailUsersDraftsDelete_594050; id: string;
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
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(query_594065, "fields", newJString(fields))
  add(query_594065, "quotaUser", newJString(quotaUser))
  add(query_594065, "alt", newJString(alt))
  add(query_594065, "oauth_token", newJString(oauthToken))
  add(query_594065, "userIp", newJString(userIp))
  add(path_594064, "id", newJString(id))
  add(query_594065, "key", newJString(key))
  add(query_594065, "prettyPrint", newJBool(prettyPrint))
  add(path_594064, "userId", newJString(userId))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var gmailUsersDraftsDelete* = Call_GmailUsersDraftsDelete_594050(
    name: "gmailUsersDraftsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsDelete_594051, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsDelete_594052, schemes: {Scheme.Https})
type
  Call_GmailUsersHistoryList_594066 = ref object of OpenApiRestCall_593424
proc url_GmailUsersHistoryList_594068(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersHistoryList_594067(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("userId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = newJString("me"))
  if valid_594069 != nil:
    section.add "userId", valid_594069
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
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("pageToken")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "pageToken", valid_594071
  var valid_594072 = query.getOrDefault("quotaUser")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "quotaUser", valid_594072
  var valid_594073 = query.getOrDefault("alt")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("json"))
  if valid_594073 != nil:
    section.add "alt", valid_594073
  var valid_594074 = query.getOrDefault("labelId")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "labelId", valid_594074
  var valid_594075 = query.getOrDefault("oauth_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "oauth_token", valid_594075
  var valid_594076 = query.getOrDefault("userIp")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "userIp", valid_594076
  var valid_594077 = query.getOrDefault("historyTypes")
  valid_594077 = validateParameter(valid_594077, JArray, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "historyTypes", valid_594077
  var valid_594078 = query.getOrDefault("startHistoryId")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "startHistoryId", valid_594078
  var valid_594079 = query.getOrDefault("maxResults")
  valid_594079 = validateParameter(valid_594079, JInt, required = false,
                                 default = newJInt(100))
  if valid_594079 != nil:
    section.add "maxResults", valid_594079
  var valid_594080 = query.getOrDefault("key")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "key", valid_594080
  var valid_594081 = query.getOrDefault("prettyPrint")
  valid_594081 = validateParameter(valid_594081, JBool, required = false,
                                 default = newJBool(true))
  if valid_594081 != nil:
    section.add "prettyPrint", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_GmailUsersHistoryList_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_GmailUsersHistoryList_594066; fields: string = "";
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
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(query_594085, "fields", newJString(fields))
  add(query_594085, "pageToken", newJString(pageToken))
  add(query_594085, "quotaUser", newJString(quotaUser))
  add(query_594085, "alt", newJString(alt))
  add(query_594085, "labelId", newJString(labelId))
  add(query_594085, "oauth_token", newJString(oauthToken))
  add(query_594085, "userIp", newJString(userIp))
  if historyTypes != nil:
    query_594085.add "historyTypes", historyTypes
  add(query_594085, "startHistoryId", newJString(startHistoryId))
  add(query_594085, "maxResults", newJInt(maxResults))
  add(query_594085, "key", newJString(key))
  add(query_594085, "prettyPrint", newJBool(prettyPrint))
  add(path_594084, "userId", newJString(userId))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var gmailUsersHistoryList* = Call_GmailUsersHistoryList_594066(
    name: "gmailUsersHistoryList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/history",
    validator: validate_GmailUsersHistoryList_594067, base: "/gmail/v1/users",
    url: url_GmailUsersHistoryList_594068, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsCreate_594101 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsCreate_594103(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsCreate_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("userId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = newJString("me"))
  if valid_594104 != nil:
    section.add "userId", valid_594104
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
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("userIp")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "userIp", valid_594109
  var valid_594110 = query.getOrDefault("key")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "key", valid_594110
  var valid_594111 = query.getOrDefault("prettyPrint")
  valid_594111 = validateParameter(valid_594111, JBool, required = false,
                                 default = newJBool(true))
  if valid_594111 != nil:
    section.add "prettyPrint", valid_594111
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

proc call*(call_594113: Call_GmailUsersLabelsCreate_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new label.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_GmailUsersLabelsCreate_594101; fields: string = "";
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  var body_594117 = newJObject()
  add(query_594116, "fields", newJString(fields))
  add(query_594116, "quotaUser", newJString(quotaUser))
  add(query_594116, "alt", newJString(alt))
  add(query_594116, "oauth_token", newJString(oauthToken))
  add(query_594116, "userIp", newJString(userIp))
  add(query_594116, "key", newJString(key))
  if body != nil:
    body_594117 = body
  add(query_594116, "prettyPrint", newJBool(prettyPrint))
  add(path_594115, "userId", newJString(userId))
  result = call_594114.call(path_594115, query_594116, nil, nil, body_594117)

var gmailUsersLabelsCreate* = Call_GmailUsersLabelsCreate_594101(
    name: "gmailUsersLabelsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsCreate_594102, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsCreate_594103, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsList_594086 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsList_594088(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsList_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("userId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = newJString("me"))
  if valid_594089 != nil:
    section.add "userId", valid_594089
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
  var valid_594090 = query.getOrDefault("fields")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "fields", valid_594090
  var valid_594091 = query.getOrDefault("quotaUser")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "quotaUser", valid_594091
  var valid_594092 = query.getOrDefault("alt")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = newJString("json"))
  if valid_594092 != nil:
    section.add "alt", valid_594092
  var valid_594093 = query.getOrDefault("oauth_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "oauth_token", valid_594093
  var valid_594094 = query.getOrDefault("userIp")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "userIp", valid_594094
  var valid_594095 = query.getOrDefault("key")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "key", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_GmailUsersLabelsList_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all labels in the user's mailbox.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_GmailUsersLabelsList_594086; fields: string = "";
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "userIp", newJString(userIp))
  add(query_594100, "key", newJString(key))
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  add(path_594099, "userId", newJString(userId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var gmailUsersLabelsList* = Call_GmailUsersLabelsList_594086(
    name: "gmailUsersLabelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsList_594087, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsList_594088, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsUpdate_594134 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsUpdate_594136(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsUpdate_594135(path: JsonNode; query: JsonNode;
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
  var valid_594137 = path.getOrDefault("id")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "id", valid_594137
  var valid_594138 = path.getOrDefault("userId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = newJString("me"))
  if valid_594138 != nil:
    section.add "userId", valid_594138
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
  var valid_594139 = query.getOrDefault("fields")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "fields", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("oauth_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "oauth_token", valid_594142
  var valid_594143 = query.getOrDefault("userIp")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "userIp", valid_594143
  var valid_594144 = query.getOrDefault("key")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "key", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
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

proc call*(call_594147: Call_GmailUsersLabelsUpdate_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_GmailUsersLabelsUpdate_594134; id: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "userIp", newJString(userIp))
  add(path_594149, "id", newJString(id))
  add(query_594150, "key", newJString(key))
  if body != nil:
    body_594151 = body
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  add(path_594149, "userId", newJString(userId))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var gmailUsersLabelsUpdate* = Call_GmailUsersLabelsUpdate_594134(
    name: "gmailUsersLabelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsUpdate_594135, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsUpdate_594136, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsGet_594118 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsGet_594120(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsGet_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("id")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "id", valid_594121
  var valid_594122 = path.getOrDefault("userId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = newJString("me"))
  if valid_594122 != nil:
    section.add "userId", valid_594122
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
  var valid_594123 = query.getOrDefault("fields")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "fields", valid_594123
  var valid_594124 = query.getOrDefault("quotaUser")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "quotaUser", valid_594124
  var valid_594125 = query.getOrDefault("alt")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("json"))
  if valid_594125 != nil:
    section.add "alt", valid_594125
  var valid_594126 = query.getOrDefault("oauth_token")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "oauth_token", valid_594126
  var valid_594127 = query.getOrDefault("userIp")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "userIp", valid_594127
  var valid_594128 = query.getOrDefault("key")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "key", valid_594128
  var valid_594129 = query.getOrDefault("prettyPrint")
  valid_594129 = validateParameter(valid_594129, JBool, required = false,
                                 default = newJBool(true))
  if valid_594129 != nil:
    section.add "prettyPrint", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_GmailUsersLabelsGet_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified label.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_GmailUsersLabelsGet_594118; id: string;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(query_594133, "fields", newJString(fields))
  add(query_594133, "quotaUser", newJString(quotaUser))
  add(query_594133, "alt", newJString(alt))
  add(query_594133, "oauth_token", newJString(oauthToken))
  add(query_594133, "userIp", newJString(userIp))
  add(path_594132, "id", newJString(id))
  add(query_594133, "key", newJString(key))
  add(query_594133, "prettyPrint", newJBool(prettyPrint))
  add(path_594132, "userId", newJString(userId))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var gmailUsersLabelsGet* = Call_GmailUsersLabelsGet_594118(
    name: "gmailUsersLabelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsGet_594119, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsGet_594120, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsPatch_594168 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsPatch_594170(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsPatch_594169(path: JsonNode; query: JsonNode;
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
  var valid_594171 = path.getOrDefault("id")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "id", valid_594171
  var valid_594172 = path.getOrDefault("userId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = newJString("me"))
  if valid_594172 != nil:
    section.add "userId", valid_594172
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
  var valid_594173 = query.getOrDefault("fields")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "fields", valid_594173
  var valid_594174 = query.getOrDefault("quotaUser")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "quotaUser", valid_594174
  var valid_594175 = query.getOrDefault("alt")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = newJString("json"))
  if valid_594175 != nil:
    section.add "alt", valid_594175
  var valid_594176 = query.getOrDefault("oauth_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "oauth_token", valid_594176
  var valid_594177 = query.getOrDefault("userIp")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "userIp", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("prettyPrint")
  valid_594179 = validateParameter(valid_594179, JBool, required = false,
                                 default = newJBool(true))
  if valid_594179 != nil:
    section.add "prettyPrint", valid_594179
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

proc call*(call_594181: Call_GmailUsersLabelsPatch_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label. This method supports patch semantics.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_GmailUsersLabelsPatch_594168; id: string;
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
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  var body_594185 = newJObject()
  add(query_594184, "fields", newJString(fields))
  add(query_594184, "quotaUser", newJString(quotaUser))
  add(query_594184, "alt", newJString(alt))
  add(query_594184, "oauth_token", newJString(oauthToken))
  add(query_594184, "userIp", newJString(userIp))
  add(path_594183, "id", newJString(id))
  add(query_594184, "key", newJString(key))
  if body != nil:
    body_594185 = body
  add(query_594184, "prettyPrint", newJBool(prettyPrint))
  add(path_594183, "userId", newJString(userId))
  result = call_594182.call(path_594183, query_594184, nil, nil, body_594185)

var gmailUsersLabelsPatch* = Call_GmailUsersLabelsPatch_594168(
    name: "gmailUsersLabelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsPatch_594169, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsPatch_594170, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsDelete_594152 = ref object of OpenApiRestCall_593424
proc url_GmailUsersLabelsDelete_594154(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersLabelsDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("id")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "id", valid_594155
  var valid_594156 = path.getOrDefault("userId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = newJString("me"))
  if valid_594156 != nil:
    section.add "userId", valid_594156
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
  var valid_594157 = query.getOrDefault("fields")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "fields", valid_594157
  var valid_594158 = query.getOrDefault("quotaUser")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "quotaUser", valid_594158
  var valid_594159 = query.getOrDefault("alt")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = newJString("json"))
  if valid_594159 != nil:
    section.add "alt", valid_594159
  var valid_594160 = query.getOrDefault("oauth_token")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "oauth_token", valid_594160
  var valid_594161 = query.getOrDefault("userIp")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "userIp", valid_594161
  var valid_594162 = query.getOrDefault("key")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "key", valid_594162
  var valid_594163 = query.getOrDefault("prettyPrint")
  valid_594163 = validateParameter(valid_594163, JBool, required = false,
                                 default = newJBool(true))
  if valid_594163 != nil:
    section.add "prettyPrint", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_GmailUsersLabelsDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_GmailUsersLabelsDelete_594152; id: string;
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
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(query_594167, "fields", newJString(fields))
  add(query_594167, "quotaUser", newJString(quotaUser))
  add(query_594167, "alt", newJString(alt))
  add(query_594167, "oauth_token", newJString(oauthToken))
  add(query_594167, "userIp", newJString(userIp))
  add(path_594166, "id", newJString(id))
  add(query_594167, "key", newJString(key))
  add(query_594167, "prettyPrint", newJBool(prettyPrint))
  add(path_594166, "userId", newJString(userId))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var gmailUsersLabelsDelete* = Call_GmailUsersLabelsDelete_594152(
    name: "gmailUsersLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsDelete_594153, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsDelete_594154, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesInsert_594206 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesInsert_594208(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesInsert_594207(path: JsonNode; query: JsonNode;
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
  var valid_594209 = path.getOrDefault("userId")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = newJString("me"))
  if valid_594209 != nil:
    section.add "userId", valid_594209
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
  var valid_594210 = query.getOrDefault("fields")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "fields", valid_594210
  var valid_594211 = query.getOrDefault("internalDateSource")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("receivedTime"))
  if valid_594211 != nil:
    section.add "internalDateSource", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("userIp")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "userIp", valid_594215
  var valid_594216 = query.getOrDefault("key")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "key", valid_594216
  var valid_594217 = query.getOrDefault("prettyPrint")
  valid_594217 = validateParameter(valid_594217, JBool, required = false,
                                 default = newJBool(true))
  if valid_594217 != nil:
    section.add "prettyPrint", valid_594217
  var valid_594218 = query.getOrDefault("deleted")
  valid_594218 = validateParameter(valid_594218, JBool, required = false,
                                 default = newJBool(false))
  if valid_594218 != nil:
    section.add "deleted", valid_594218
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

proc call*(call_594220: Call_GmailUsersMessagesInsert_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_GmailUsersMessagesInsert_594206; fields: string = "";
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
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  var body_594224 = newJObject()
  add(query_594223, "fields", newJString(fields))
  add(query_594223, "internalDateSource", newJString(internalDateSource))
  add(query_594223, "quotaUser", newJString(quotaUser))
  add(query_594223, "alt", newJString(alt))
  add(query_594223, "oauth_token", newJString(oauthToken))
  add(query_594223, "userIp", newJString(userIp))
  add(query_594223, "key", newJString(key))
  if body != nil:
    body_594224 = body
  add(query_594223, "prettyPrint", newJBool(prettyPrint))
  add(query_594223, "deleted", newJBool(deleted))
  add(path_594222, "userId", newJString(userId))
  result = call_594221.call(path_594222, query_594223, nil, nil, body_594224)

var gmailUsersMessagesInsert* = Call_GmailUsersMessagesInsert_594206(
    name: "gmailUsersMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesInsert_594207, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesInsert_594208, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesList_594186 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesList_594188(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesList_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("userId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = newJString("me"))
  if valid_594189 != nil:
    section.add "userId", valid_594189
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
  var valid_594190 = query.getOrDefault("fields")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "fields", valid_594190
  var valid_594191 = query.getOrDefault("pageToken")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "pageToken", valid_594191
  var valid_594192 = query.getOrDefault("quotaUser")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "quotaUser", valid_594192
  var valid_594193 = query.getOrDefault("alt")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("json"))
  if valid_594193 != nil:
    section.add "alt", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("userIp")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "userIp", valid_594195
  var valid_594196 = query.getOrDefault("maxResults")
  valid_594196 = validateParameter(valid_594196, JInt, required = false,
                                 default = newJInt(100))
  if valid_594196 != nil:
    section.add "maxResults", valid_594196
  var valid_594197 = query.getOrDefault("includeSpamTrash")
  valid_594197 = validateParameter(valid_594197, JBool, required = false,
                                 default = newJBool(false))
  if valid_594197 != nil:
    section.add "includeSpamTrash", valid_594197
  var valid_594198 = query.getOrDefault("q")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "q", valid_594198
  var valid_594199 = query.getOrDefault("labelIds")
  valid_594199 = validateParameter(valid_594199, JArray, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "labelIds", valid_594199
  var valid_594200 = query.getOrDefault("key")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "key", valid_594200
  var valid_594201 = query.getOrDefault("prettyPrint")
  valid_594201 = validateParameter(valid_594201, JBool, required = false,
                                 default = newJBool(true))
  if valid_594201 != nil:
    section.add "prettyPrint", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_GmailUsersMessagesList_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the messages in the user's mailbox.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_GmailUsersMessagesList_594186; fields: string = "";
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
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "pageToken", newJString(pageToken))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "userIp", newJString(userIp))
  add(query_594205, "maxResults", newJInt(maxResults))
  add(query_594205, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_594205, "q", newJString(q))
  if labelIds != nil:
    query_594205.add "labelIds", labelIds
  add(query_594205, "key", newJString(key))
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  add(path_594204, "userId", newJString(userId))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var gmailUsersMessagesList* = Call_GmailUsersMessagesList_594186(
    name: "gmailUsersMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesList_594187, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesList_594188, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchDelete_594225 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesBatchDelete_594227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesBatchDelete_594226(path: JsonNode; query: JsonNode;
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
  var valid_594228 = path.getOrDefault("userId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = newJString("me"))
  if valid_594228 != nil:
    section.add "userId", valid_594228
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
  var valid_594229 = query.getOrDefault("fields")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "fields", valid_594229
  var valid_594230 = query.getOrDefault("quotaUser")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "quotaUser", valid_594230
  var valid_594231 = query.getOrDefault("alt")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = newJString("json"))
  if valid_594231 != nil:
    section.add "alt", valid_594231
  var valid_594232 = query.getOrDefault("oauth_token")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "oauth_token", valid_594232
  var valid_594233 = query.getOrDefault("userIp")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "userIp", valid_594233
  var valid_594234 = query.getOrDefault("key")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "key", valid_594234
  var valid_594235 = query.getOrDefault("prettyPrint")
  valid_594235 = validateParameter(valid_594235, JBool, required = false,
                                 default = newJBool(true))
  if valid_594235 != nil:
    section.add "prettyPrint", valid_594235
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

proc call*(call_594237: Call_GmailUsersMessagesBatchDelete_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_GmailUsersMessagesBatchDelete_594225;
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
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  var body_594241 = newJObject()
  add(query_594240, "fields", newJString(fields))
  add(query_594240, "quotaUser", newJString(quotaUser))
  add(query_594240, "alt", newJString(alt))
  add(query_594240, "oauth_token", newJString(oauthToken))
  add(query_594240, "userIp", newJString(userIp))
  add(query_594240, "key", newJString(key))
  if body != nil:
    body_594241 = body
  add(query_594240, "prettyPrint", newJBool(prettyPrint))
  add(path_594239, "userId", newJString(userId))
  result = call_594238.call(path_594239, query_594240, nil, nil, body_594241)

var gmailUsersMessagesBatchDelete* = Call_GmailUsersMessagesBatchDelete_594225(
    name: "gmailUsersMessagesBatchDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchDelete",
    validator: validate_GmailUsersMessagesBatchDelete_594226,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchDelete_594227,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchModify_594242 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesBatchModify_594244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesBatchModify_594243(path: JsonNode; query: JsonNode;
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
  var valid_594245 = path.getOrDefault("userId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = newJString("me"))
  if valid_594245 != nil:
    section.add "userId", valid_594245
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
  var valid_594246 = query.getOrDefault("fields")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "fields", valid_594246
  var valid_594247 = query.getOrDefault("quotaUser")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "quotaUser", valid_594247
  var valid_594248 = query.getOrDefault("alt")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = newJString("json"))
  if valid_594248 != nil:
    section.add "alt", valid_594248
  var valid_594249 = query.getOrDefault("oauth_token")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "oauth_token", valid_594249
  var valid_594250 = query.getOrDefault("userIp")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "userIp", valid_594250
  var valid_594251 = query.getOrDefault("key")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "key", valid_594251
  var valid_594252 = query.getOrDefault("prettyPrint")
  valid_594252 = validateParameter(valid_594252, JBool, required = false,
                                 default = newJBool(true))
  if valid_594252 != nil:
    section.add "prettyPrint", valid_594252
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

proc call*(call_594254: Call_GmailUsersMessagesBatchModify_594242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified messages.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_GmailUsersMessagesBatchModify_594242;
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
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  var body_594258 = newJObject()
  add(query_594257, "fields", newJString(fields))
  add(query_594257, "quotaUser", newJString(quotaUser))
  add(query_594257, "alt", newJString(alt))
  add(query_594257, "oauth_token", newJString(oauthToken))
  add(query_594257, "userIp", newJString(userIp))
  add(query_594257, "key", newJString(key))
  if body != nil:
    body_594258 = body
  add(query_594257, "prettyPrint", newJBool(prettyPrint))
  add(path_594256, "userId", newJString(userId))
  result = call_594255.call(path_594256, query_594257, nil, nil, body_594258)

var gmailUsersMessagesBatchModify* = Call_GmailUsersMessagesBatchModify_594242(
    name: "gmailUsersMessagesBatchModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchModify",
    validator: validate_GmailUsersMessagesBatchModify_594243,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchModify_594244,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesImport_594259 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesImport_594261(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesImport_594260(path: JsonNode; query: JsonNode;
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
  var valid_594262 = path.getOrDefault("userId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = newJString("me"))
  if valid_594262 != nil:
    section.add "userId", valid_594262
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
  var valid_594263 = query.getOrDefault("fields")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "fields", valid_594263
  var valid_594264 = query.getOrDefault("internalDateSource")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = newJString("dateHeader"))
  if valid_594264 != nil:
    section.add "internalDateSource", valid_594264
  var valid_594265 = query.getOrDefault("quotaUser")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "quotaUser", valid_594265
  var valid_594266 = query.getOrDefault("alt")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = newJString("json"))
  if valid_594266 != nil:
    section.add "alt", valid_594266
  var valid_594267 = query.getOrDefault("oauth_token")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "oauth_token", valid_594267
  var valid_594268 = query.getOrDefault("userIp")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "userIp", valid_594268
  var valid_594269 = query.getOrDefault("neverMarkSpam")
  valid_594269 = validateParameter(valid_594269, JBool, required = false,
                                 default = newJBool(false))
  if valid_594269 != nil:
    section.add "neverMarkSpam", valid_594269
  var valid_594270 = query.getOrDefault("key")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "key", valid_594270
  var valid_594271 = query.getOrDefault("processForCalendar")
  valid_594271 = validateParameter(valid_594271, JBool, required = false,
                                 default = newJBool(false))
  if valid_594271 != nil:
    section.add "processForCalendar", valid_594271
  var valid_594272 = query.getOrDefault("prettyPrint")
  valid_594272 = validateParameter(valid_594272, JBool, required = false,
                                 default = newJBool(true))
  if valid_594272 != nil:
    section.add "prettyPrint", valid_594272
  var valid_594273 = query.getOrDefault("deleted")
  valid_594273 = validateParameter(valid_594273, JBool, required = false,
                                 default = newJBool(false))
  if valid_594273 != nil:
    section.add "deleted", valid_594273
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

proc call*(call_594275: Call_GmailUsersMessagesImport_594259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ## 
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_GmailUsersMessagesImport_594259; fields: string = "";
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
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  var body_594279 = newJObject()
  add(query_594278, "fields", newJString(fields))
  add(query_594278, "internalDateSource", newJString(internalDateSource))
  add(query_594278, "quotaUser", newJString(quotaUser))
  add(query_594278, "alt", newJString(alt))
  add(query_594278, "oauth_token", newJString(oauthToken))
  add(query_594278, "userIp", newJString(userIp))
  add(query_594278, "neverMarkSpam", newJBool(neverMarkSpam))
  add(query_594278, "key", newJString(key))
  add(query_594278, "processForCalendar", newJBool(processForCalendar))
  if body != nil:
    body_594279 = body
  add(query_594278, "prettyPrint", newJBool(prettyPrint))
  add(query_594278, "deleted", newJBool(deleted))
  add(path_594277, "userId", newJString(userId))
  result = call_594276.call(path_594277, query_594278, nil, nil, body_594279)

var gmailUsersMessagesImport* = Call_GmailUsersMessagesImport_594259(
    name: "gmailUsersMessagesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/import",
    validator: validate_GmailUsersMessagesImport_594260, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesImport_594261, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesSend_594280 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesSend_594282(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesSend_594281(path: JsonNode; query: JsonNode;
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
  var valid_594283 = path.getOrDefault("userId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = newJString("me"))
  if valid_594283 != nil:
    section.add "userId", valid_594283
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
  var valid_594284 = query.getOrDefault("fields")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "fields", valid_594284
  var valid_594285 = query.getOrDefault("quotaUser")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "quotaUser", valid_594285
  var valid_594286 = query.getOrDefault("alt")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = newJString("json"))
  if valid_594286 != nil:
    section.add "alt", valid_594286
  var valid_594287 = query.getOrDefault("oauth_token")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "oauth_token", valid_594287
  var valid_594288 = query.getOrDefault("userIp")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "userIp", valid_594288
  var valid_594289 = query.getOrDefault("key")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "key", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
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

proc call*(call_594292: Call_GmailUsersMessagesSend_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_GmailUsersMessagesSend_594280; fields: string = "";
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  var body_594296 = newJObject()
  add(query_594295, "fields", newJString(fields))
  add(query_594295, "quotaUser", newJString(quotaUser))
  add(query_594295, "alt", newJString(alt))
  add(query_594295, "oauth_token", newJString(oauthToken))
  add(query_594295, "userIp", newJString(userIp))
  add(query_594295, "key", newJString(key))
  if body != nil:
    body_594296 = body
  add(query_594295, "prettyPrint", newJBool(prettyPrint))
  add(path_594294, "userId", newJString(userId))
  result = call_594293.call(path_594294, query_594295, nil, nil, body_594296)

var gmailUsersMessagesSend* = Call_GmailUsersMessagesSend_594280(
    name: "gmailUsersMessagesSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/send",
    validator: validate_GmailUsersMessagesSend_594281, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesSend_594282, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesGet_594297 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesGet_594299(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesGet_594298(path: JsonNode; query: JsonNode;
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
  var valid_594300 = path.getOrDefault("id")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "id", valid_594300
  var valid_594301 = path.getOrDefault("userId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = newJString("me"))
  if valid_594301 != nil:
    section.add "userId", valid_594301
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
  var valid_594302 = query.getOrDefault("fields")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "fields", valid_594302
  var valid_594303 = query.getOrDefault("quotaUser")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "quotaUser", valid_594303
  var valid_594304 = query.getOrDefault("alt")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("json"))
  if valid_594304 != nil:
    section.add "alt", valid_594304
  var valid_594305 = query.getOrDefault("oauth_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "oauth_token", valid_594305
  var valid_594306 = query.getOrDefault("userIp")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "userIp", valid_594306
  var valid_594307 = query.getOrDefault("metadataHeaders")
  valid_594307 = validateParameter(valid_594307, JArray, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "metadataHeaders", valid_594307
  var valid_594308 = query.getOrDefault("key")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "key", valid_594308
  var valid_594309 = query.getOrDefault("prettyPrint")
  valid_594309 = validateParameter(valid_594309, JBool, required = false,
                                 default = newJBool(true))
  if valid_594309 != nil:
    section.add "prettyPrint", valid_594309
  var valid_594310 = query.getOrDefault("format")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = newJString("full"))
  if valid_594310 != nil:
    section.add "format", valid_594310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594311: Call_GmailUsersMessagesGet_594297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified message.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_GmailUsersMessagesGet_594297; id: string;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  add(query_594314, "fields", newJString(fields))
  add(query_594314, "quotaUser", newJString(quotaUser))
  add(query_594314, "alt", newJString(alt))
  add(query_594314, "oauth_token", newJString(oauthToken))
  add(query_594314, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_594314.add "metadataHeaders", metadataHeaders
  add(path_594313, "id", newJString(id))
  add(query_594314, "key", newJString(key))
  add(query_594314, "prettyPrint", newJBool(prettyPrint))
  add(query_594314, "format", newJString(format))
  add(path_594313, "userId", newJString(userId))
  result = call_594312.call(path_594313, query_594314, nil, nil, nil)

var gmailUsersMessagesGet* = Call_GmailUsersMessagesGet_594297(
    name: "gmailUsersMessagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesGet_594298, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesGet_594299, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesDelete_594315 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesDelete_594317(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesDelete_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("id")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "id", valid_594318
  var valid_594319 = path.getOrDefault("userId")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = newJString("me"))
  if valid_594319 != nil:
    section.add "userId", valid_594319
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
  var valid_594320 = query.getOrDefault("fields")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "fields", valid_594320
  var valid_594321 = query.getOrDefault("quotaUser")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "quotaUser", valid_594321
  var valid_594322 = query.getOrDefault("alt")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = newJString("json"))
  if valid_594322 != nil:
    section.add "alt", valid_594322
  var valid_594323 = query.getOrDefault("oauth_token")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "oauth_token", valid_594323
  var valid_594324 = query.getOrDefault("userIp")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "userIp", valid_594324
  var valid_594325 = query.getOrDefault("key")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "key", valid_594325
  var valid_594326 = query.getOrDefault("prettyPrint")
  valid_594326 = validateParameter(valid_594326, JBool, required = false,
                                 default = newJBool(true))
  if valid_594326 != nil:
    section.add "prettyPrint", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_GmailUsersMessagesDelete_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ## 
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_GmailUsersMessagesDelete_594315; id: string;
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
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(query_594330, "fields", newJString(fields))
  add(query_594330, "quotaUser", newJString(quotaUser))
  add(query_594330, "alt", newJString(alt))
  add(query_594330, "oauth_token", newJString(oauthToken))
  add(query_594330, "userIp", newJString(userIp))
  add(path_594329, "id", newJString(id))
  add(query_594330, "key", newJString(key))
  add(query_594330, "prettyPrint", newJBool(prettyPrint))
  add(path_594329, "userId", newJString(userId))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var gmailUsersMessagesDelete* = Call_GmailUsersMessagesDelete_594315(
    name: "gmailUsersMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesDelete_594316, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesDelete_594317, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesModify_594331 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesModify_594333(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesModify_594332(path: JsonNode; query: JsonNode;
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
  var valid_594334 = path.getOrDefault("id")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "id", valid_594334
  var valid_594335 = path.getOrDefault("userId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = newJString("me"))
  if valid_594335 != nil:
    section.add "userId", valid_594335
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
  var valid_594336 = query.getOrDefault("fields")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "fields", valid_594336
  var valid_594337 = query.getOrDefault("quotaUser")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "quotaUser", valid_594337
  var valid_594338 = query.getOrDefault("alt")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = newJString("json"))
  if valid_594338 != nil:
    section.add "alt", valid_594338
  var valid_594339 = query.getOrDefault("oauth_token")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "oauth_token", valid_594339
  var valid_594340 = query.getOrDefault("userIp")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "userIp", valid_594340
  var valid_594341 = query.getOrDefault("key")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "key", valid_594341
  var valid_594342 = query.getOrDefault("prettyPrint")
  valid_594342 = validateParameter(valid_594342, JBool, required = false,
                                 default = newJBool(true))
  if valid_594342 != nil:
    section.add "prettyPrint", valid_594342
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

proc call*(call_594344: Call_GmailUsersMessagesModify_594331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified message.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_GmailUsersMessagesModify_594331; id: string;
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
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  var body_594348 = newJObject()
  add(query_594347, "fields", newJString(fields))
  add(query_594347, "quotaUser", newJString(quotaUser))
  add(query_594347, "alt", newJString(alt))
  add(query_594347, "oauth_token", newJString(oauthToken))
  add(query_594347, "userIp", newJString(userIp))
  add(path_594346, "id", newJString(id))
  add(query_594347, "key", newJString(key))
  if body != nil:
    body_594348 = body
  add(query_594347, "prettyPrint", newJBool(prettyPrint))
  add(path_594346, "userId", newJString(userId))
  result = call_594345.call(path_594346, query_594347, nil, nil, body_594348)

var gmailUsersMessagesModify* = Call_GmailUsersMessagesModify_594331(
    name: "gmailUsersMessagesModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/modify",
    validator: validate_GmailUsersMessagesModify_594332, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesModify_594333, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesTrash_594349 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesTrash_594351(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesTrash_594350(path: JsonNode; query: JsonNode;
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
  var valid_594352 = path.getOrDefault("id")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "id", valid_594352
  var valid_594353 = path.getOrDefault("userId")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = newJString("me"))
  if valid_594353 != nil:
    section.add "userId", valid_594353
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
  var valid_594354 = query.getOrDefault("fields")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "fields", valid_594354
  var valid_594355 = query.getOrDefault("quotaUser")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "quotaUser", valid_594355
  var valid_594356 = query.getOrDefault("alt")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = newJString("json"))
  if valid_594356 != nil:
    section.add "alt", valid_594356
  var valid_594357 = query.getOrDefault("oauth_token")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "oauth_token", valid_594357
  var valid_594358 = query.getOrDefault("userIp")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "userIp", valid_594358
  var valid_594359 = query.getOrDefault("key")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "key", valid_594359
  var valid_594360 = query.getOrDefault("prettyPrint")
  valid_594360 = validateParameter(valid_594360, JBool, required = false,
                                 default = newJBool(true))
  if valid_594360 != nil:
    section.add "prettyPrint", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_GmailUsersMessagesTrash_594349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified message to the trash.
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_GmailUsersMessagesTrash_594349; id: string;
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
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(query_594364, "fields", newJString(fields))
  add(query_594364, "quotaUser", newJString(quotaUser))
  add(query_594364, "alt", newJString(alt))
  add(query_594364, "oauth_token", newJString(oauthToken))
  add(query_594364, "userIp", newJString(userIp))
  add(path_594363, "id", newJString(id))
  add(query_594364, "key", newJString(key))
  add(query_594364, "prettyPrint", newJBool(prettyPrint))
  add(path_594363, "userId", newJString(userId))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var gmailUsersMessagesTrash* = Call_GmailUsersMessagesTrash_594349(
    name: "gmailUsersMessagesTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/trash",
    validator: validate_GmailUsersMessagesTrash_594350, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesTrash_594351, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesUntrash_594365 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesUntrash_594367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesUntrash_594366(path: JsonNode; query: JsonNode;
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
  var valid_594368 = path.getOrDefault("id")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "id", valid_594368
  var valid_594369 = path.getOrDefault("userId")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = newJString("me"))
  if valid_594369 != nil:
    section.add "userId", valid_594369
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
  var valid_594370 = query.getOrDefault("fields")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "fields", valid_594370
  var valid_594371 = query.getOrDefault("quotaUser")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "quotaUser", valid_594371
  var valid_594372 = query.getOrDefault("alt")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = newJString("json"))
  if valid_594372 != nil:
    section.add "alt", valid_594372
  var valid_594373 = query.getOrDefault("oauth_token")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "oauth_token", valid_594373
  var valid_594374 = query.getOrDefault("userIp")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "userIp", valid_594374
  var valid_594375 = query.getOrDefault("key")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "key", valid_594375
  var valid_594376 = query.getOrDefault("prettyPrint")
  valid_594376 = validateParameter(valid_594376, JBool, required = false,
                                 default = newJBool(true))
  if valid_594376 != nil:
    section.add "prettyPrint", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594377: Call_GmailUsersMessagesUntrash_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified message from the trash.
  ## 
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_GmailUsersMessagesUntrash_594365; id: string;
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
  var path_594379 = newJObject()
  var query_594380 = newJObject()
  add(query_594380, "fields", newJString(fields))
  add(query_594380, "quotaUser", newJString(quotaUser))
  add(query_594380, "alt", newJString(alt))
  add(query_594380, "oauth_token", newJString(oauthToken))
  add(query_594380, "userIp", newJString(userIp))
  add(path_594379, "id", newJString(id))
  add(query_594380, "key", newJString(key))
  add(query_594380, "prettyPrint", newJBool(prettyPrint))
  add(path_594379, "userId", newJString(userId))
  result = call_594378.call(path_594379, query_594380, nil, nil, nil)

var gmailUsersMessagesUntrash* = Call_GmailUsersMessagesUntrash_594365(
    name: "gmailUsersMessagesUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/untrash",
    validator: validate_GmailUsersMessagesUntrash_594366, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesUntrash_594367, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesAttachmentsGet_594381 = ref object of OpenApiRestCall_593424
proc url_GmailUsersMessagesAttachmentsGet_594383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersMessagesAttachmentsGet_594382(path: JsonNode;
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
  var valid_594384 = path.getOrDefault("messageId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "messageId", valid_594384
  var valid_594385 = path.getOrDefault("id")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "id", valid_594385
  var valid_594386 = path.getOrDefault("userId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = newJString("me"))
  if valid_594386 != nil:
    section.add "userId", valid_594386
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
  var valid_594387 = query.getOrDefault("fields")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "fields", valid_594387
  var valid_594388 = query.getOrDefault("quotaUser")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "quotaUser", valid_594388
  var valid_594389 = query.getOrDefault("alt")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = newJString("json"))
  if valid_594389 != nil:
    section.add "alt", valid_594389
  var valid_594390 = query.getOrDefault("oauth_token")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "oauth_token", valid_594390
  var valid_594391 = query.getOrDefault("userIp")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "userIp", valid_594391
  var valid_594392 = query.getOrDefault("key")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "key", valid_594392
  var valid_594393 = query.getOrDefault("prettyPrint")
  valid_594393 = validateParameter(valid_594393, JBool, required = false,
                                 default = newJBool(true))
  if valid_594393 != nil:
    section.add "prettyPrint", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_GmailUsersMessagesAttachmentsGet_594381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified message attachment.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_GmailUsersMessagesAttachmentsGet_594381;
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
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(query_594397, "fields", newJString(fields))
  add(query_594397, "quotaUser", newJString(quotaUser))
  add(query_594397, "alt", newJString(alt))
  add(query_594397, "oauth_token", newJString(oauthToken))
  add(query_594397, "userIp", newJString(userIp))
  add(path_594396, "messageId", newJString(messageId))
  add(path_594396, "id", newJString(id))
  add(query_594397, "key", newJString(key))
  add(query_594397, "prettyPrint", newJBool(prettyPrint))
  add(path_594396, "userId", newJString(userId))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var gmailUsersMessagesAttachmentsGet* = Call_GmailUsersMessagesAttachmentsGet_594381(
    name: "gmailUsersMessagesAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/messages/{messageId}/attachments/{id}",
    validator: validate_GmailUsersMessagesAttachmentsGet_594382,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesAttachmentsGet_594383,
    schemes: {Scheme.Https})
type
  Call_GmailUsersGetProfile_594398 = ref object of OpenApiRestCall_593424
proc url_GmailUsersGetProfile_594400(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersGetProfile_594399(path: JsonNode; query: JsonNode;
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
  var valid_594401 = path.getOrDefault("userId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = newJString("me"))
  if valid_594401 != nil:
    section.add "userId", valid_594401
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
  var valid_594402 = query.getOrDefault("fields")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "fields", valid_594402
  var valid_594403 = query.getOrDefault("quotaUser")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "quotaUser", valid_594403
  var valid_594404 = query.getOrDefault("alt")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = newJString("json"))
  if valid_594404 != nil:
    section.add "alt", valid_594404
  var valid_594405 = query.getOrDefault("oauth_token")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "oauth_token", valid_594405
  var valid_594406 = query.getOrDefault("userIp")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "userIp", valid_594406
  var valid_594407 = query.getOrDefault("key")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "key", valid_594407
  var valid_594408 = query.getOrDefault("prettyPrint")
  valid_594408 = validateParameter(valid_594408, JBool, required = false,
                                 default = newJBool(true))
  if valid_594408 != nil:
    section.add "prettyPrint", valid_594408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594409: Call_GmailUsersGetProfile_594398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current user's Gmail profile.
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_GmailUsersGetProfile_594398; fields: string = "";
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
  var path_594411 = newJObject()
  var query_594412 = newJObject()
  add(query_594412, "fields", newJString(fields))
  add(query_594412, "quotaUser", newJString(quotaUser))
  add(query_594412, "alt", newJString(alt))
  add(query_594412, "oauth_token", newJString(oauthToken))
  add(query_594412, "userIp", newJString(userIp))
  add(query_594412, "key", newJString(key))
  add(query_594412, "prettyPrint", newJBool(prettyPrint))
  add(path_594411, "userId", newJString(userId))
  result = call_594410.call(path_594411, query_594412, nil, nil, nil)

var gmailUsersGetProfile* = Call_GmailUsersGetProfile_594398(
    name: "gmailUsersGetProfile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/profile",
    validator: validate_GmailUsersGetProfile_594399, base: "/gmail/v1/users",
    url: url_GmailUsersGetProfile_594400, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateAutoForwarding_594428 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsUpdateAutoForwarding_594430(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsUpdateAutoForwarding_594429(path: JsonNode;
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
  var valid_594431 = path.getOrDefault("userId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = newJString("me"))
  if valid_594431 != nil:
    section.add "userId", valid_594431
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
  var valid_594432 = query.getOrDefault("fields")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "fields", valid_594432
  var valid_594433 = query.getOrDefault("quotaUser")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "quotaUser", valid_594433
  var valid_594434 = query.getOrDefault("alt")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = newJString("json"))
  if valid_594434 != nil:
    section.add "alt", valid_594434
  var valid_594435 = query.getOrDefault("oauth_token")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "oauth_token", valid_594435
  var valid_594436 = query.getOrDefault("userIp")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "userIp", valid_594436
  var valid_594437 = query.getOrDefault("key")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "key", valid_594437
  var valid_594438 = query.getOrDefault("prettyPrint")
  valid_594438 = validateParameter(valid_594438, JBool, required = false,
                                 default = newJBool(true))
  if valid_594438 != nil:
    section.add "prettyPrint", valid_594438
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

proc call*(call_594440: Call_GmailUsersSettingsUpdateAutoForwarding_594428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594440.validator(path, query, header, formData, body)
  let scheme = call_594440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594440.url(scheme.get, call_594440.host, call_594440.base,
                         call_594440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594440, url, valid)

proc call*(call_594441: Call_GmailUsersSettingsUpdateAutoForwarding_594428;
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
  var path_594442 = newJObject()
  var query_594443 = newJObject()
  var body_594444 = newJObject()
  add(query_594443, "fields", newJString(fields))
  add(query_594443, "quotaUser", newJString(quotaUser))
  add(query_594443, "alt", newJString(alt))
  add(query_594443, "oauth_token", newJString(oauthToken))
  add(query_594443, "userIp", newJString(userIp))
  add(query_594443, "key", newJString(key))
  if body != nil:
    body_594444 = body
  add(query_594443, "prettyPrint", newJBool(prettyPrint))
  add(path_594442, "userId", newJString(userId))
  result = call_594441.call(path_594442, query_594443, nil, nil, body_594444)

var gmailUsersSettingsUpdateAutoForwarding* = Call_GmailUsersSettingsUpdateAutoForwarding_594428(
    name: "gmailUsersSettingsUpdateAutoForwarding", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsUpdateAutoForwarding_594429,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateAutoForwarding_594430,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetAutoForwarding_594413 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsGetAutoForwarding_594415(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsGetAutoForwarding_594414(path: JsonNode;
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
  var valid_594416 = path.getOrDefault("userId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = newJString("me"))
  if valid_594416 != nil:
    section.add "userId", valid_594416
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
  var valid_594417 = query.getOrDefault("fields")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "fields", valid_594417
  var valid_594418 = query.getOrDefault("quotaUser")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "quotaUser", valid_594418
  var valid_594419 = query.getOrDefault("alt")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("json"))
  if valid_594419 != nil:
    section.add "alt", valid_594419
  var valid_594420 = query.getOrDefault("oauth_token")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "oauth_token", valid_594420
  var valid_594421 = query.getOrDefault("userIp")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "userIp", valid_594421
  var valid_594422 = query.getOrDefault("key")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "key", valid_594422
  var valid_594423 = query.getOrDefault("prettyPrint")
  valid_594423 = validateParameter(valid_594423, JBool, required = false,
                                 default = newJBool(true))
  if valid_594423 != nil:
    section.add "prettyPrint", valid_594423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594424: Call_GmailUsersSettingsGetAutoForwarding_594413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the auto-forwarding setting for the specified account.
  ## 
  let valid = call_594424.validator(path, query, header, formData, body)
  let scheme = call_594424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594424.url(scheme.get, call_594424.host, call_594424.base,
                         call_594424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594424, url, valid)

proc call*(call_594425: Call_GmailUsersSettingsGetAutoForwarding_594413;
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
  var path_594426 = newJObject()
  var query_594427 = newJObject()
  add(query_594427, "fields", newJString(fields))
  add(query_594427, "quotaUser", newJString(quotaUser))
  add(query_594427, "alt", newJString(alt))
  add(query_594427, "oauth_token", newJString(oauthToken))
  add(query_594427, "userIp", newJString(userIp))
  add(query_594427, "key", newJString(key))
  add(query_594427, "prettyPrint", newJBool(prettyPrint))
  add(path_594426, "userId", newJString(userId))
  result = call_594425.call(path_594426, query_594427, nil, nil, nil)

var gmailUsersSettingsGetAutoForwarding* = Call_GmailUsersSettingsGetAutoForwarding_594413(
    name: "gmailUsersSettingsGetAutoForwarding", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsGetAutoForwarding_594414,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetAutoForwarding_594415,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesCreate_594460 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsDelegatesCreate_594462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsDelegatesCreate_594461(path: JsonNode;
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
  var valid_594463 = path.getOrDefault("userId")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = newJString("me"))
  if valid_594463 != nil:
    section.add "userId", valid_594463
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
  var valid_594464 = query.getOrDefault("fields")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "fields", valid_594464
  var valid_594465 = query.getOrDefault("quotaUser")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "quotaUser", valid_594465
  var valid_594466 = query.getOrDefault("alt")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = newJString("json"))
  if valid_594466 != nil:
    section.add "alt", valid_594466
  var valid_594467 = query.getOrDefault("oauth_token")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "oauth_token", valid_594467
  var valid_594468 = query.getOrDefault("userIp")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = nil)
  if valid_594468 != nil:
    section.add "userIp", valid_594468
  var valid_594469 = query.getOrDefault("key")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "key", valid_594469
  var valid_594470 = query.getOrDefault("prettyPrint")
  valid_594470 = validateParameter(valid_594470, JBool, required = false,
                                 default = newJBool(true))
  if valid_594470 != nil:
    section.add "prettyPrint", valid_594470
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

proc call*(call_594472: Call_GmailUsersSettingsDelegatesCreate_594460;
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
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_GmailUsersSettingsDelegatesCreate_594460;
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
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  var body_594476 = newJObject()
  add(query_594475, "fields", newJString(fields))
  add(query_594475, "quotaUser", newJString(quotaUser))
  add(query_594475, "alt", newJString(alt))
  add(query_594475, "oauth_token", newJString(oauthToken))
  add(query_594475, "userIp", newJString(userIp))
  add(query_594475, "key", newJString(key))
  if body != nil:
    body_594476 = body
  add(query_594475, "prettyPrint", newJBool(prettyPrint))
  add(path_594474, "userId", newJString(userId))
  result = call_594473.call(path_594474, query_594475, nil, nil, body_594476)

var gmailUsersSettingsDelegatesCreate* = Call_GmailUsersSettingsDelegatesCreate_594460(
    name: "gmailUsersSettingsDelegatesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesCreate_594461,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesCreate_594462,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesList_594445 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsDelegatesList_594447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsDelegatesList_594446(path: JsonNode;
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
  var valid_594448 = path.getOrDefault("userId")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = newJString("me"))
  if valid_594448 != nil:
    section.add "userId", valid_594448
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
  var valid_594449 = query.getOrDefault("fields")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "fields", valid_594449
  var valid_594450 = query.getOrDefault("quotaUser")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "quotaUser", valid_594450
  var valid_594451 = query.getOrDefault("alt")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = newJString("json"))
  if valid_594451 != nil:
    section.add "alt", valid_594451
  var valid_594452 = query.getOrDefault("oauth_token")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "oauth_token", valid_594452
  var valid_594453 = query.getOrDefault("userIp")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "userIp", valid_594453
  var valid_594454 = query.getOrDefault("key")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "key", valid_594454
  var valid_594455 = query.getOrDefault("prettyPrint")
  valid_594455 = validateParameter(valid_594455, JBool, required = false,
                                 default = newJBool(true))
  if valid_594455 != nil:
    section.add "prettyPrint", valid_594455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594456: Call_GmailUsersSettingsDelegatesList_594445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594456.validator(path, query, header, formData, body)
  let scheme = call_594456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594456.url(scheme.get, call_594456.host, call_594456.base,
                         call_594456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594456, url, valid)

proc call*(call_594457: Call_GmailUsersSettingsDelegatesList_594445;
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
  var path_594458 = newJObject()
  var query_594459 = newJObject()
  add(query_594459, "fields", newJString(fields))
  add(query_594459, "quotaUser", newJString(quotaUser))
  add(query_594459, "alt", newJString(alt))
  add(query_594459, "oauth_token", newJString(oauthToken))
  add(query_594459, "userIp", newJString(userIp))
  add(query_594459, "key", newJString(key))
  add(query_594459, "prettyPrint", newJBool(prettyPrint))
  add(path_594458, "userId", newJString(userId))
  result = call_594457.call(path_594458, query_594459, nil, nil, nil)

var gmailUsersSettingsDelegatesList* = Call_GmailUsersSettingsDelegatesList_594445(
    name: "gmailUsersSettingsDelegatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesList_594446,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesList_594447,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesGet_594477 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsDelegatesGet_594479(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsDelegatesGet_594478(path: JsonNode;
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
  var valid_594480 = path.getOrDefault("delegateEmail")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "delegateEmail", valid_594480
  var valid_594481 = path.getOrDefault("userId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = newJString("me"))
  if valid_594481 != nil:
    section.add "userId", valid_594481
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
  var valid_594482 = query.getOrDefault("fields")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "fields", valid_594482
  var valid_594483 = query.getOrDefault("quotaUser")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "quotaUser", valid_594483
  var valid_594484 = query.getOrDefault("alt")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = newJString("json"))
  if valid_594484 != nil:
    section.add "alt", valid_594484
  var valid_594485 = query.getOrDefault("oauth_token")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "oauth_token", valid_594485
  var valid_594486 = query.getOrDefault("userIp")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "userIp", valid_594486
  var valid_594487 = query.getOrDefault("key")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "key", valid_594487
  var valid_594488 = query.getOrDefault("prettyPrint")
  valid_594488 = validateParameter(valid_594488, JBool, required = false,
                                 default = newJBool(true))
  if valid_594488 != nil:
    section.add "prettyPrint", valid_594488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594489: Call_GmailUsersSettingsDelegatesGet_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594489.validator(path, query, header, formData, body)
  let scheme = call_594489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594489.url(scheme.get, call_594489.host, call_594489.base,
                         call_594489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594489, url, valid)

proc call*(call_594490: Call_GmailUsersSettingsDelegatesGet_594477;
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
  var path_594491 = newJObject()
  var query_594492 = newJObject()
  add(query_594492, "fields", newJString(fields))
  add(query_594492, "quotaUser", newJString(quotaUser))
  add(query_594492, "alt", newJString(alt))
  add(path_594491, "delegateEmail", newJString(delegateEmail))
  add(query_594492, "oauth_token", newJString(oauthToken))
  add(query_594492, "userIp", newJString(userIp))
  add(query_594492, "key", newJString(key))
  add(query_594492, "prettyPrint", newJBool(prettyPrint))
  add(path_594491, "userId", newJString(userId))
  result = call_594490.call(path_594491, query_594492, nil, nil, nil)

var gmailUsersSettingsDelegatesGet* = Call_GmailUsersSettingsDelegatesGet_594477(
    name: "gmailUsersSettingsDelegatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesGet_594478,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesGet_594479,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesDelete_594493 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsDelegatesDelete_594495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsDelegatesDelete_594494(path: JsonNode;
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
  var valid_594496 = path.getOrDefault("delegateEmail")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "delegateEmail", valid_594496
  var valid_594497 = path.getOrDefault("userId")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = newJString("me"))
  if valid_594497 != nil:
    section.add "userId", valid_594497
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
  var valid_594498 = query.getOrDefault("fields")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "fields", valid_594498
  var valid_594499 = query.getOrDefault("quotaUser")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "quotaUser", valid_594499
  var valid_594500 = query.getOrDefault("alt")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = newJString("json"))
  if valid_594500 != nil:
    section.add "alt", valid_594500
  var valid_594501 = query.getOrDefault("oauth_token")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "oauth_token", valid_594501
  var valid_594502 = query.getOrDefault("userIp")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "userIp", valid_594502
  var valid_594503 = query.getOrDefault("key")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "key", valid_594503
  var valid_594504 = query.getOrDefault("prettyPrint")
  valid_594504 = validateParameter(valid_594504, JBool, required = false,
                                 default = newJBool(true))
  if valid_594504 != nil:
    section.add "prettyPrint", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_GmailUsersSettingsDelegatesDelete_594493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_GmailUsersSettingsDelegatesDelete_594493;
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
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(query_594508, "fields", newJString(fields))
  add(query_594508, "quotaUser", newJString(quotaUser))
  add(query_594508, "alt", newJString(alt))
  add(path_594507, "delegateEmail", newJString(delegateEmail))
  add(query_594508, "oauth_token", newJString(oauthToken))
  add(query_594508, "userIp", newJString(userIp))
  add(query_594508, "key", newJString(key))
  add(query_594508, "prettyPrint", newJBool(prettyPrint))
  add(path_594507, "userId", newJString(userId))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var gmailUsersSettingsDelegatesDelete* = Call_GmailUsersSettingsDelegatesDelete_594493(
    name: "gmailUsersSettingsDelegatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesDelete_594494,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesDelete_594495,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersCreate_594524 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsFiltersCreate_594526(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsFiltersCreate_594525(path: JsonNode;
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
  var valid_594527 = path.getOrDefault("userId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = newJString("me"))
  if valid_594527 != nil:
    section.add "userId", valid_594527
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
  var valid_594528 = query.getOrDefault("fields")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "fields", valid_594528
  var valid_594529 = query.getOrDefault("quotaUser")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "quotaUser", valid_594529
  var valid_594530 = query.getOrDefault("alt")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = newJString("json"))
  if valid_594530 != nil:
    section.add "alt", valid_594530
  var valid_594531 = query.getOrDefault("oauth_token")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "oauth_token", valid_594531
  var valid_594532 = query.getOrDefault("userIp")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "userIp", valid_594532
  var valid_594533 = query.getOrDefault("key")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "key", valid_594533
  var valid_594534 = query.getOrDefault("prettyPrint")
  valid_594534 = validateParameter(valid_594534, JBool, required = false,
                                 default = newJBool(true))
  if valid_594534 != nil:
    section.add "prettyPrint", valid_594534
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

proc call*(call_594536: Call_GmailUsersSettingsFiltersCreate_594524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a filter.
  ## 
  let valid = call_594536.validator(path, query, header, formData, body)
  let scheme = call_594536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594536.url(scheme.get, call_594536.host, call_594536.base,
                         call_594536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594536, url, valid)

proc call*(call_594537: Call_GmailUsersSettingsFiltersCreate_594524;
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
  var path_594538 = newJObject()
  var query_594539 = newJObject()
  var body_594540 = newJObject()
  add(query_594539, "fields", newJString(fields))
  add(query_594539, "quotaUser", newJString(quotaUser))
  add(query_594539, "alt", newJString(alt))
  add(query_594539, "oauth_token", newJString(oauthToken))
  add(query_594539, "userIp", newJString(userIp))
  add(query_594539, "key", newJString(key))
  if body != nil:
    body_594540 = body
  add(query_594539, "prettyPrint", newJBool(prettyPrint))
  add(path_594538, "userId", newJString(userId))
  result = call_594537.call(path_594538, query_594539, nil, nil, body_594540)

var gmailUsersSettingsFiltersCreate* = Call_GmailUsersSettingsFiltersCreate_594524(
    name: "gmailUsersSettingsFiltersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersCreate_594525,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersCreate_594526,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersList_594509 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsFiltersList_594511(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsFiltersList_594510(path: JsonNode; query: JsonNode;
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
  var valid_594512 = path.getOrDefault("userId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = newJString("me"))
  if valid_594512 != nil:
    section.add "userId", valid_594512
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
  var valid_594513 = query.getOrDefault("fields")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "fields", valid_594513
  var valid_594514 = query.getOrDefault("quotaUser")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "quotaUser", valid_594514
  var valid_594515 = query.getOrDefault("alt")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = newJString("json"))
  if valid_594515 != nil:
    section.add "alt", valid_594515
  var valid_594516 = query.getOrDefault("oauth_token")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "oauth_token", valid_594516
  var valid_594517 = query.getOrDefault("userIp")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "userIp", valid_594517
  var valid_594518 = query.getOrDefault("key")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "key", valid_594518
  var valid_594519 = query.getOrDefault("prettyPrint")
  valid_594519 = validateParameter(valid_594519, JBool, required = false,
                                 default = newJBool(true))
  if valid_594519 != nil:
    section.add "prettyPrint", valid_594519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594520: Call_GmailUsersSettingsFiltersList_594509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the message filters of a Gmail user.
  ## 
  let valid = call_594520.validator(path, query, header, formData, body)
  let scheme = call_594520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594520.url(scheme.get, call_594520.host, call_594520.base,
                         call_594520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594520, url, valid)

proc call*(call_594521: Call_GmailUsersSettingsFiltersList_594509;
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
  var path_594522 = newJObject()
  var query_594523 = newJObject()
  add(query_594523, "fields", newJString(fields))
  add(query_594523, "quotaUser", newJString(quotaUser))
  add(query_594523, "alt", newJString(alt))
  add(query_594523, "oauth_token", newJString(oauthToken))
  add(query_594523, "userIp", newJString(userIp))
  add(query_594523, "key", newJString(key))
  add(query_594523, "prettyPrint", newJBool(prettyPrint))
  add(path_594522, "userId", newJString(userId))
  result = call_594521.call(path_594522, query_594523, nil, nil, nil)

var gmailUsersSettingsFiltersList* = Call_GmailUsersSettingsFiltersList_594509(
    name: "gmailUsersSettingsFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersList_594510,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersList_594511,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersGet_594541 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsFiltersGet_594543(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsFiltersGet_594542(path: JsonNode; query: JsonNode;
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
  var valid_594544 = path.getOrDefault("id")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "id", valid_594544
  var valid_594545 = path.getOrDefault("userId")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = newJString("me"))
  if valid_594545 != nil:
    section.add "userId", valid_594545
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
  var valid_594549 = query.getOrDefault("oauth_token")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "oauth_token", valid_594549
  var valid_594550 = query.getOrDefault("userIp")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "userIp", valid_594550
  var valid_594551 = query.getOrDefault("key")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "key", valid_594551
  var valid_594552 = query.getOrDefault("prettyPrint")
  valid_594552 = validateParameter(valid_594552, JBool, required = false,
                                 default = newJBool(true))
  if valid_594552 != nil:
    section.add "prettyPrint", valid_594552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594553: Call_GmailUsersSettingsFiltersGet_594541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a filter.
  ## 
  let valid = call_594553.validator(path, query, header, formData, body)
  let scheme = call_594553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594553.url(scheme.get, call_594553.host, call_594553.base,
                         call_594553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594553, url, valid)

proc call*(call_594554: Call_GmailUsersSettingsFiltersGet_594541; id: string;
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
  var path_594555 = newJObject()
  var query_594556 = newJObject()
  add(query_594556, "fields", newJString(fields))
  add(query_594556, "quotaUser", newJString(quotaUser))
  add(query_594556, "alt", newJString(alt))
  add(query_594556, "oauth_token", newJString(oauthToken))
  add(query_594556, "userIp", newJString(userIp))
  add(path_594555, "id", newJString(id))
  add(query_594556, "key", newJString(key))
  add(query_594556, "prettyPrint", newJBool(prettyPrint))
  add(path_594555, "userId", newJString(userId))
  result = call_594554.call(path_594555, query_594556, nil, nil, nil)

var gmailUsersSettingsFiltersGet* = Call_GmailUsersSettingsFiltersGet_594541(
    name: "gmailUsersSettingsFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersGet_594542,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersGet_594543,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersDelete_594557 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsFiltersDelete_594559(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsFiltersDelete_594558(path: JsonNode;
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
  var valid_594560 = path.getOrDefault("id")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "id", valid_594560
  var valid_594561 = path.getOrDefault("userId")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = newJString("me"))
  if valid_594561 != nil:
    section.add "userId", valid_594561
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
  var valid_594562 = query.getOrDefault("fields")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "fields", valid_594562
  var valid_594563 = query.getOrDefault("quotaUser")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "quotaUser", valid_594563
  var valid_594564 = query.getOrDefault("alt")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = newJString("json"))
  if valid_594564 != nil:
    section.add "alt", valid_594564
  var valid_594565 = query.getOrDefault("oauth_token")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "oauth_token", valid_594565
  var valid_594566 = query.getOrDefault("userIp")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "userIp", valid_594566
  var valid_594567 = query.getOrDefault("key")
  valid_594567 = validateParameter(valid_594567, JString, required = false,
                                 default = nil)
  if valid_594567 != nil:
    section.add "key", valid_594567
  var valid_594568 = query.getOrDefault("prettyPrint")
  valid_594568 = validateParameter(valid_594568, JBool, required = false,
                                 default = newJBool(true))
  if valid_594568 != nil:
    section.add "prettyPrint", valid_594568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594569: Call_GmailUsersSettingsFiltersDelete_594557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a filter.
  ## 
  let valid = call_594569.validator(path, query, header, formData, body)
  let scheme = call_594569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594569.url(scheme.get, call_594569.host, call_594569.base,
                         call_594569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594569, url, valid)

proc call*(call_594570: Call_GmailUsersSettingsFiltersDelete_594557; id: string;
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
  var path_594571 = newJObject()
  var query_594572 = newJObject()
  add(query_594572, "fields", newJString(fields))
  add(query_594572, "quotaUser", newJString(quotaUser))
  add(query_594572, "alt", newJString(alt))
  add(query_594572, "oauth_token", newJString(oauthToken))
  add(query_594572, "userIp", newJString(userIp))
  add(path_594571, "id", newJString(id))
  add(query_594572, "key", newJString(key))
  add(query_594572, "prettyPrint", newJBool(prettyPrint))
  add(path_594571, "userId", newJString(userId))
  result = call_594570.call(path_594571, query_594572, nil, nil, nil)

var gmailUsersSettingsFiltersDelete* = Call_GmailUsersSettingsFiltersDelete_594557(
    name: "gmailUsersSettingsFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersDelete_594558,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersDelete_594559,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesCreate_594588 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsForwardingAddressesCreate_594590(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsForwardingAddressesCreate_594589(path: JsonNode;
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
  var valid_594591 = path.getOrDefault("userId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = newJString("me"))
  if valid_594591 != nil:
    section.add "userId", valid_594591
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
  var valid_594592 = query.getOrDefault("fields")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "fields", valid_594592
  var valid_594593 = query.getOrDefault("quotaUser")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "quotaUser", valid_594593
  var valid_594594 = query.getOrDefault("alt")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = newJString("json"))
  if valid_594594 != nil:
    section.add "alt", valid_594594
  var valid_594595 = query.getOrDefault("oauth_token")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "oauth_token", valid_594595
  var valid_594596 = query.getOrDefault("userIp")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "userIp", valid_594596
  var valid_594597 = query.getOrDefault("key")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "key", valid_594597
  var valid_594598 = query.getOrDefault("prettyPrint")
  valid_594598 = validateParameter(valid_594598, JBool, required = false,
                                 default = newJBool(true))
  if valid_594598 != nil:
    section.add "prettyPrint", valid_594598
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

proc call*(call_594600: Call_GmailUsersSettingsForwardingAddressesCreate_594588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_GmailUsersSettingsForwardingAddressesCreate_594588;
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
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  var body_594604 = newJObject()
  add(query_594603, "fields", newJString(fields))
  add(query_594603, "quotaUser", newJString(quotaUser))
  add(query_594603, "alt", newJString(alt))
  add(query_594603, "oauth_token", newJString(oauthToken))
  add(query_594603, "userIp", newJString(userIp))
  add(query_594603, "key", newJString(key))
  if body != nil:
    body_594604 = body
  add(query_594603, "prettyPrint", newJBool(prettyPrint))
  add(path_594602, "userId", newJString(userId))
  result = call_594601.call(path_594602, query_594603, nil, nil, body_594604)

var gmailUsersSettingsForwardingAddressesCreate* = Call_GmailUsersSettingsForwardingAddressesCreate_594588(
    name: "gmailUsersSettingsForwardingAddressesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesCreate_594589,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesCreate_594590,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesList_594573 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsForwardingAddressesList_594575(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsForwardingAddressesList_594574(path: JsonNode;
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
  var valid_594576 = path.getOrDefault("userId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = newJString("me"))
  if valid_594576 != nil:
    section.add "userId", valid_594576
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
  var valid_594577 = query.getOrDefault("fields")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "fields", valid_594577
  var valid_594578 = query.getOrDefault("quotaUser")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "quotaUser", valid_594578
  var valid_594579 = query.getOrDefault("alt")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = newJString("json"))
  if valid_594579 != nil:
    section.add "alt", valid_594579
  var valid_594580 = query.getOrDefault("oauth_token")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "oauth_token", valid_594580
  var valid_594581 = query.getOrDefault("userIp")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = nil)
  if valid_594581 != nil:
    section.add "userIp", valid_594581
  var valid_594582 = query.getOrDefault("key")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "key", valid_594582
  var valid_594583 = query.getOrDefault("prettyPrint")
  valid_594583 = validateParameter(valid_594583, JBool, required = false,
                                 default = newJBool(true))
  if valid_594583 != nil:
    section.add "prettyPrint", valid_594583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594584: Call_GmailUsersSettingsForwardingAddressesList_594573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the forwarding addresses for the specified account.
  ## 
  let valid = call_594584.validator(path, query, header, formData, body)
  let scheme = call_594584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594584.url(scheme.get, call_594584.host, call_594584.base,
                         call_594584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594584, url, valid)

proc call*(call_594585: Call_GmailUsersSettingsForwardingAddressesList_594573;
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
  var path_594586 = newJObject()
  var query_594587 = newJObject()
  add(query_594587, "fields", newJString(fields))
  add(query_594587, "quotaUser", newJString(quotaUser))
  add(query_594587, "alt", newJString(alt))
  add(query_594587, "oauth_token", newJString(oauthToken))
  add(query_594587, "userIp", newJString(userIp))
  add(query_594587, "key", newJString(key))
  add(query_594587, "prettyPrint", newJBool(prettyPrint))
  add(path_594586, "userId", newJString(userId))
  result = call_594585.call(path_594586, query_594587, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesList* = Call_GmailUsersSettingsForwardingAddressesList_594573(
    name: "gmailUsersSettingsForwardingAddressesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesList_594574,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesList_594575,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesGet_594605 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsForwardingAddressesGet_594607(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsForwardingAddressesGet_594606(path: JsonNode;
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
  var valid_594608 = path.getOrDefault("forwardingEmail")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "forwardingEmail", valid_594608
  var valid_594609 = path.getOrDefault("userId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = newJString("me"))
  if valid_594609 != nil:
    section.add "userId", valid_594609
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
  var valid_594610 = query.getOrDefault("fields")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "fields", valid_594610
  var valid_594611 = query.getOrDefault("quotaUser")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "quotaUser", valid_594611
  var valid_594612 = query.getOrDefault("alt")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = newJString("json"))
  if valid_594612 != nil:
    section.add "alt", valid_594612
  var valid_594613 = query.getOrDefault("oauth_token")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "oauth_token", valid_594613
  var valid_594614 = query.getOrDefault("userIp")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "userIp", valid_594614
  var valid_594615 = query.getOrDefault("key")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "key", valid_594615
  var valid_594616 = query.getOrDefault("prettyPrint")
  valid_594616 = validateParameter(valid_594616, JBool, required = false,
                                 default = newJBool(true))
  if valid_594616 != nil:
    section.add "prettyPrint", valid_594616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594617: Call_GmailUsersSettingsForwardingAddressesGet_594605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified forwarding address.
  ## 
  let valid = call_594617.validator(path, query, header, formData, body)
  let scheme = call_594617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594617.url(scheme.get, call_594617.host, call_594617.base,
                         call_594617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594617, url, valid)

proc call*(call_594618: Call_GmailUsersSettingsForwardingAddressesGet_594605;
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
  var path_594619 = newJObject()
  var query_594620 = newJObject()
  add(query_594620, "fields", newJString(fields))
  add(query_594620, "quotaUser", newJString(quotaUser))
  add(query_594620, "alt", newJString(alt))
  add(path_594619, "forwardingEmail", newJString(forwardingEmail))
  add(query_594620, "oauth_token", newJString(oauthToken))
  add(query_594620, "userIp", newJString(userIp))
  add(query_594620, "key", newJString(key))
  add(query_594620, "prettyPrint", newJBool(prettyPrint))
  add(path_594619, "userId", newJString(userId))
  result = call_594618.call(path_594619, query_594620, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesGet* = Call_GmailUsersSettingsForwardingAddressesGet_594605(
    name: "gmailUsersSettingsForwardingAddressesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesGet_594606,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesGet_594607,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesDelete_594621 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsForwardingAddressesDelete_594623(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsForwardingAddressesDelete_594622(path: JsonNode;
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
  var valid_594624 = path.getOrDefault("forwardingEmail")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "forwardingEmail", valid_594624
  var valid_594625 = path.getOrDefault("userId")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = newJString("me"))
  if valid_594625 != nil:
    section.add "userId", valid_594625
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
  var valid_594626 = query.getOrDefault("fields")
  valid_594626 = validateParameter(valid_594626, JString, required = false,
                                 default = nil)
  if valid_594626 != nil:
    section.add "fields", valid_594626
  var valid_594627 = query.getOrDefault("quotaUser")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "quotaUser", valid_594627
  var valid_594628 = query.getOrDefault("alt")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = newJString("json"))
  if valid_594628 != nil:
    section.add "alt", valid_594628
  var valid_594629 = query.getOrDefault("oauth_token")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "oauth_token", valid_594629
  var valid_594630 = query.getOrDefault("userIp")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = nil)
  if valid_594630 != nil:
    section.add "userIp", valid_594630
  var valid_594631 = query.getOrDefault("key")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "key", valid_594631
  var valid_594632 = query.getOrDefault("prettyPrint")
  valid_594632 = validateParameter(valid_594632, JBool, required = false,
                                 default = newJBool(true))
  if valid_594632 != nil:
    section.add "prettyPrint", valid_594632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594633: Call_GmailUsersSettingsForwardingAddressesDelete_594621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594633.validator(path, query, header, formData, body)
  let scheme = call_594633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594633.url(scheme.get, call_594633.host, call_594633.base,
                         call_594633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594633, url, valid)

proc call*(call_594634: Call_GmailUsersSettingsForwardingAddressesDelete_594621;
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
  var path_594635 = newJObject()
  var query_594636 = newJObject()
  add(query_594636, "fields", newJString(fields))
  add(query_594636, "quotaUser", newJString(quotaUser))
  add(query_594636, "alt", newJString(alt))
  add(path_594635, "forwardingEmail", newJString(forwardingEmail))
  add(query_594636, "oauth_token", newJString(oauthToken))
  add(query_594636, "userIp", newJString(userIp))
  add(query_594636, "key", newJString(key))
  add(query_594636, "prettyPrint", newJBool(prettyPrint))
  add(path_594635, "userId", newJString(userId))
  result = call_594634.call(path_594635, query_594636, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesDelete* = Call_GmailUsersSettingsForwardingAddressesDelete_594621(
    name: "gmailUsersSettingsForwardingAddressesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesDelete_594622,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesDelete_594623,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateImap_594652 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsUpdateImap_594654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsUpdateImap_594653(path: JsonNode; query: JsonNode;
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
  var valid_594655 = path.getOrDefault("userId")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = newJString("me"))
  if valid_594655 != nil:
    section.add "userId", valid_594655
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
  var valid_594656 = query.getOrDefault("fields")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "fields", valid_594656
  var valid_594657 = query.getOrDefault("quotaUser")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "quotaUser", valid_594657
  var valid_594658 = query.getOrDefault("alt")
  valid_594658 = validateParameter(valid_594658, JString, required = false,
                                 default = newJString("json"))
  if valid_594658 != nil:
    section.add "alt", valid_594658
  var valid_594659 = query.getOrDefault("oauth_token")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "oauth_token", valid_594659
  var valid_594660 = query.getOrDefault("userIp")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = nil)
  if valid_594660 != nil:
    section.add "userIp", valid_594660
  var valid_594661 = query.getOrDefault("key")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "key", valid_594661
  var valid_594662 = query.getOrDefault("prettyPrint")
  valid_594662 = validateParameter(valid_594662, JBool, required = false,
                                 default = newJBool(true))
  if valid_594662 != nil:
    section.add "prettyPrint", valid_594662
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

proc call*(call_594664: Call_GmailUsersSettingsUpdateImap_594652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates IMAP settings.
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_GmailUsersSettingsUpdateImap_594652;
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
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  var body_594668 = newJObject()
  add(query_594667, "fields", newJString(fields))
  add(query_594667, "quotaUser", newJString(quotaUser))
  add(query_594667, "alt", newJString(alt))
  add(query_594667, "oauth_token", newJString(oauthToken))
  add(query_594667, "userIp", newJString(userIp))
  add(query_594667, "key", newJString(key))
  if body != nil:
    body_594668 = body
  add(query_594667, "prettyPrint", newJBool(prettyPrint))
  add(path_594666, "userId", newJString(userId))
  result = call_594665.call(path_594666, query_594667, nil, nil, body_594668)

var gmailUsersSettingsUpdateImap* = Call_GmailUsersSettingsUpdateImap_594652(
    name: "gmailUsersSettingsUpdateImap", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsUpdateImap_594653,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateImap_594654,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetImap_594637 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsGetImap_594639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsGetImap_594638(path: JsonNode; query: JsonNode;
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
  var valid_594640 = path.getOrDefault("userId")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = newJString("me"))
  if valid_594640 != nil:
    section.add "userId", valid_594640
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
  var valid_594641 = query.getOrDefault("fields")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "fields", valid_594641
  var valid_594642 = query.getOrDefault("quotaUser")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = nil)
  if valid_594642 != nil:
    section.add "quotaUser", valid_594642
  var valid_594643 = query.getOrDefault("alt")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = newJString("json"))
  if valid_594643 != nil:
    section.add "alt", valid_594643
  var valid_594644 = query.getOrDefault("oauth_token")
  valid_594644 = validateParameter(valid_594644, JString, required = false,
                                 default = nil)
  if valid_594644 != nil:
    section.add "oauth_token", valid_594644
  var valid_594645 = query.getOrDefault("userIp")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = nil)
  if valid_594645 != nil:
    section.add "userIp", valid_594645
  var valid_594646 = query.getOrDefault("key")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "key", valid_594646
  var valid_594647 = query.getOrDefault("prettyPrint")
  valid_594647 = validateParameter(valid_594647, JBool, required = false,
                                 default = newJBool(true))
  if valid_594647 != nil:
    section.add "prettyPrint", valid_594647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594648: Call_GmailUsersSettingsGetImap_594637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets IMAP settings.
  ## 
  let valid = call_594648.validator(path, query, header, formData, body)
  let scheme = call_594648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594648.url(scheme.get, call_594648.host, call_594648.base,
                         call_594648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594648, url, valid)

proc call*(call_594649: Call_GmailUsersSettingsGetImap_594637; fields: string = "";
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
  var path_594650 = newJObject()
  var query_594651 = newJObject()
  add(query_594651, "fields", newJString(fields))
  add(query_594651, "quotaUser", newJString(quotaUser))
  add(query_594651, "alt", newJString(alt))
  add(query_594651, "oauth_token", newJString(oauthToken))
  add(query_594651, "userIp", newJString(userIp))
  add(query_594651, "key", newJString(key))
  add(query_594651, "prettyPrint", newJBool(prettyPrint))
  add(path_594650, "userId", newJString(userId))
  result = call_594649.call(path_594650, query_594651, nil, nil, nil)

var gmailUsersSettingsGetImap* = Call_GmailUsersSettingsGetImap_594637(
    name: "gmailUsersSettingsGetImap", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsGetImap_594638, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetImap_594639, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateLanguage_594684 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsUpdateLanguage_594686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsUpdateLanguage_594685(path: JsonNode;
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
  var valid_594687 = path.getOrDefault("userId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = newJString("me"))
  if valid_594687 != nil:
    section.add "userId", valid_594687
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
  var valid_594688 = query.getOrDefault("fields")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "fields", valid_594688
  var valid_594689 = query.getOrDefault("quotaUser")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "quotaUser", valid_594689
  var valid_594690 = query.getOrDefault("alt")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = newJString("json"))
  if valid_594690 != nil:
    section.add "alt", valid_594690
  var valid_594691 = query.getOrDefault("oauth_token")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "oauth_token", valid_594691
  var valid_594692 = query.getOrDefault("userIp")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "userIp", valid_594692
  var valid_594693 = query.getOrDefault("key")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = nil)
  if valid_594693 != nil:
    section.add "key", valid_594693
  var valid_594694 = query.getOrDefault("prettyPrint")
  valid_594694 = validateParameter(valid_594694, JBool, required = false,
                                 default = newJBool(true))
  if valid_594694 != nil:
    section.add "prettyPrint", valid_594694
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

proc call*(call_594696: Call_GmailUsersSettingsUpdateLanguage_594684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
  ## 
  let valid = call_594696.validator(path, query, header, formData, body)
  let scheme = call_594696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594696.url(scheme.get, call_594696.host, call_594696.base,
                         call_594696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594696, url, valid)

proc call*(call_594697: Call_GmailUsersSettingsUpdateLanguage_594684;
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
  var path_594698 = newJObject()
  var query_594699 = newJObject()
  var body_594700 = newJObject()
  add(query_594699, "fields", newJString(fields))
  add(query_594699, "quotaUser", newJString(quotaUser))
  add(query_594699, "alt", newJString(alt))
  add(query_594699, "oauth_token", newJString(oauthToken))
  add(query_594699, "userIp", newJString(userIp))
  add(query_594699, "key", newJString(key))
  if body != nil:
    body_594700 = body
  add(query_594699, "prettyPrint", newJBool(prettyPrint))
  add(path_594698, "userId", newJString(userId))
  result = call_594697.call(path_594698, query_594699, nil, nil, body_594700)

var gmailUsersSettingsUpdateLanguage* = Call_GmailUsersSettingsUpdateLanguage_594684(
    name: "gmailUsersSettingsUpdateLanguage", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsUpdateLanguage_594685,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateLanguage_594686,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetLanguage_594669 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsGetLanguage_594671(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsGetLanguage_594670(path: JsonNode; query: JsonNode;
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
  var valid_594672 = path.getOrDefault("userId")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = newJString("me"))
  if valid_594672 != nil:
    section.add "userId", valid_594672
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
  var valid_594673 = query.getOrDefault("fields")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "fields", valid_594673
  var valid_594674 = query.getOrDefault("quotaUser")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "quotaUser", valid_594674
  var valid_594675 = query.getOrDefault("alt")
  valid_594675 = validateParameter(valid_594675, JString, required = false,
                                 default = newJString("json"))
  if valid_594675 != nil:
    section.add "alt", valid_594675
  var valid_594676 = query.getOrDefault("oauth_token")
  valid_594676 = validateParameter(valid_594676, JString, required = false,
                                 default = nil)
  if valid_594676 != nil:
    section.add "oauth_token", valid_594676
  var valid_594677 = query.getOrDefault("userIp")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = nil)
  if valid_594677 != nil:
    section.add "userIp", valid_594677
  var valid_594678 = query.getOrDefault("key")
  valid_594678 = validateParameter(valid_594678, JString, required = false,
                                 default = nil)
  if valid_594678 != nil:
    section.add "key", valid_594678
  var valid_594679 = query.getOrDefault("prettyPrint")
  valid_594679 = validateParameter(valid_594679, JBool, required = false,
                                 default = newJBool(true))
  if valid_594679 != nil:
    section.add "prettyPrint", valid_594679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594680: Call_GmailUsersSettingsGetLanguage_594669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets language settings.
  ## 
  let valid = call_594680.validator(path, query, header, formData, body)
  let scheme = call_594680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594680.url(scheme.get, call_594680.host, call_594680.base,
                         call_594680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594680, url, valid)

proc call*(call_594681: Call_GmailUsersSettingsGetLanguage_594669;
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
  var path_594682 = newJObject()
  var query_594683 = newJObject()
  add(query_594683, "fields", newJString(fields))
  add(query_594683, "quotaUser", newJString(quotaUser))
  add(query_594683, "alt", newJString(alt))
  add(query_594683, "oauth_token", newJString(oauthToken))
  add(query_594683, "userIp", newJString(userIp))
  add(query_594683, "key", newJString(key))
  add(query_594683, "prettyPrint", newJBool(prettyPrint))
  add(path_594682, "userId", newJString(userId))
  result = call_594681.call(path_594682, query_594683, nil, nil, nil)

var gmailUsersSettingsGetLanguage* = Call_GmailUsersSettingsGetLanguage_594669(
    name: "gmailUsersSettingsGetLanguage", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsGetLanguage_594670,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetLanguage_594671,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdatePop_594716 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsUpdatePop_594718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsUpdatePop_594717(path: JsonNode; query: JsonNode;
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
  var valid_594719 = path.getOrDefault("userId")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = newJString("me"))
  if valid_594719 != nil:
    section.add "userId", valid_594719
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
  var valid_594720 = query.getOrDefault("fields")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = nil)
  if valid_594720 != nil:
    section.add "fields", valid_594720
  var valid_594721 = query.getOrDefault("quotaUser")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "quotaUser", valid_594721
  var valid_594722 = query.getOrDefault("alt")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = newJString("json"))
  if valid_594722 != nil:
    section.add "alt", valid_594722
  var valid_594723 = query.getOrDefault("oauth_token")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "oauth_token", valid_594723
  var valid_594724 = query.getOrDefault("userIp")
  valid_594724 = validateParameter(valid_594724, JString, required = false,
                                 default = nil)
  if valid_594724 != nil:
    section.add "userIp", valid_594724
  var valid_594725 = query.getOrDefault("key")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "key", valid_594725
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594728: Call_GmailUsersSettingsUpdatePop_594716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates POP settings.
  ## 
  let valid = call_594728.validator(path, query, header, formData, body)
  let scheme = call_594728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594728.url(scheme.get, call_594728.host, call_594728.base,
                         call_594728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594728, url, valid)

proc call*(call_594729: Call_GmailUsersSettingsUpdatePop_594716;
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
  var path_594730 = newJObject()
  var query_594731 = newJObject()
  var body_594732 = newJObject()
  add(query_594731, "fields", newJString(fields))
  add(query_594731, "quotaUser", newJString(quotaUser))
  add(query_594731, "alt", newJString(alt))
  add(query_594731, "oauth_token", newJString(oauthToken))
  add(query_594731, "userIp", newJString(userIp))
  add(query_594731, "key", newJString(key))
  if body != nil:
    body_594732 = body
  add(query_594731, "prettyPrint", newJBool(prettyPrint))
  add(path_594730, "userId", newJString(userId))
  result = call_594729.call(path_594730, query_594731, nil, nil, body_594732)

var gmailUsersSettingsUpdatePop* = Call_GmailUsersSettingsUpdatePop_594716(
    name: "gmailUsersSettingsUpdatePop", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsUpdatePop_594717,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdatePop_594718,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetPop_594701 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsGetPop_594703(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsGetPop_594702(path: JsonNode; query: JsonNode;
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
  var valid_594704 = path.getOrDefault("userId")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = newJString("me"))
  if valid_594704 != nil:
    section.add "userId", valid_594704
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
  var valid_594705 = query.getOrDefault("fields")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "fields", valid_594705
  var valid_594706 = query.getOrDefault("quotaUser")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "quotaUser", valid_594706
  var valid_594707 = query.getOrDefault("alt")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = newJString("json"))
  if valid_594707 != nil:
    section.add "alt", valid_594707
  var valid_594708 = query.getOrDefault("oauth_token")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "oauth_token", valid_594708
  var valid_594709 = query.getOrDefault("userIp")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "userIp", valid_594709
  var valid_594710 = query.getOrDefault("key")
  valid_594710 = validateParameter(valid_594710, JString, required = false,
                                 default = nil)
  if valid_594710 != nil:
    section.add "key", valid_594710
  var valid_594711 = query.getOrDefault("prettyPrint")
  valid_594711 = validateParameter(valid_594711, JBool, required = false,
                                 default = newJBool(true))
  if valid_594711 != nil:
    section.add "prettyPrint", valid_594711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594712: Call_GmailUsersSettingsGetPop_594701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets POP settings.
  ## 
  let valid = call_594712.validator(path, query, header, formData, body)
  let scheme = call_594712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594712.url(scheme.get, call_594712.host, call_594712.base,
                         call_594712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594712, url, valid)

proc call*(call_594713: Call_GmailUsersSettingsGetPop_594701; fields: string = "";
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
  var path_594714 = newJObject()
  var query_594715 = newJObject()
  add(query_594715, "fields", newJString(fields))
  add(query_594715, "quotaUser", newJString(quotaUser))
  add(query_594715, "alt", newJString(alt))
  add(query_594715, "oauth_token", newJString(oauthToken))
  add(query_594715, "userIp", newJString(userIp))
  add(query_594715, "key", newJString(key))
  add(query_594715, "prettyPrint", newJBool(prettyPrint))
  add(path_594714, "userId", newJString(userId))
  result = call_594713.call(path_594714, query_594715, nil, nil, nil)

var gmailUsersSettingsGetPop* = Call_GmailUsersSettingsGetPop_594701(
    name: "gmailUsersSettingsGetPop", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsGetPop_594702, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetPop_594703, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsCreate_594748 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsCreate_594750(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsCreate_594749(path: JsonNode;
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
  var valid_594751 = path.getOrDefault("userId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = newJString("me"))
  if valid_594751 != nil:
    section.add "userId", valid_594751
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
  var valid_594752 = query.getOrDefault("fields")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "fields", valid_594752
  var valid_594753 = query.getOrDefault("quotaUser")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "quotaUser", valid_594753
  var valid_594754 = query.getOrDefault("alt")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = newJString("json"))
  if valid_594754 != nil:
    section.add "alt", valid_594754
  var valid_594755 = query.getOrDefault("oauth_token")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "oauth_token", valid_594755
  var valid_594756 = query.getOrDefault("userIp")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "userIp", valid_594756
  var valid_594757 = query.getOrDefault("key")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = nil)
  if valid_594757 != nil:
    section.add "key", valid_594757
  var valid_594758 = query.getOrDefault("prettyPrint")
  valid_594758 = validateParameter(valid_594758, JBool, required = false,
                                 default = newJBool(true))
  if valid_594758 != nil:
    section.add "prettyPrint", valid_594758
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

proc call*(call_594760: Call_GmailUsersSettingsSendAsCreate_594748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594760.validator(path, query, header, formData, body)
  let scheme = call_594760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594760.url(scheme.get, call_594760.host, call_594760.base,
                         call_594760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594760, url, valid)

proc call*(call_594761: Call_GmailUsersSettingsSendAsCreate_594748;
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
  var path_594762 = newJObject()
  var query_594763 = newJObject()
  var body_594764 = newJObject()
  add(query_594763, "fields", newJString(fields))
  add(query_594763, "quotaUser", newJString(quotaUser))
  add(query_594763, "alt", newJString(alt))
  add(query_594763, "oauth_token", newJString(oauthToken))
  add(query_594763, "userIp", newJString(userIp))
  add(query_594763, "key", newJString(key))
  if body != nil:
    body_594764 = body
  add(query_594763, "prettyPrint", newJBool(prettyPrint))
  add(path_594762, "userId", newJString(userId))
  result = call_594761.call(path_594762, query_594763, nil, nil, body_594764)

var gmailUsersSettingsSendAsCreate* = Call_GmailUsersSettingsSendAsCreate_594748(
    name: "gmailUsersSettingsSendAsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsCreate_594749,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsCreate_594750,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsList_594733 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsList_594735(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsList_594734(path: JsonNode; query: JsonNode;
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
  var valid_594736 = path.getOrDefault("userId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = newJString("me"))
  if valid_594736 != nil:
    section.add "userId", valid_594736
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
  var valid_594737 = query.getOrDefault("fields")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "fields", valid_594737
  var valid_594738 = query.getOrDefault("quotaUser")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = nil)
  if valid_594738 != nil:
    section.add "quotaUser", valid_594738
  var valid_594739 = query.getOrDefault("alt")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = newJString("json"))
  if valid_594739 != nil:
    section.add "alt", valid_594739
  var valid_594740 = query.getOrDefault("oauth_token")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "oauth_token", valid_594740
  var valid_594741 = query.getOrDefault("userIp")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "userIp", valid_594741
  var valid_594742 = query.getOrDefault("key")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "key", valid_594742
  var valid_594743 = query.getOrDefault("prettyPrint")
  valid_594743 = validateParameter(valid_594743, JBool, required = false,
                                 default = newJBool(true))
  if valid_594743 != nil:
    section.add "prettyPrint", valid_594743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594744: Call_GmailUsersSettingsSendAsList_594733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
  ## 
  let valid = call_594744.validator(path, query, header, formData, body)
  let scheme = call_594744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594744.url(scheme.get, call_594744.host, call_594744.base,
                         call_594744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594744, url, valid)

proc call*(call_594745: Call_GmailUsersSettingsSendAsList_594733;
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
  var path_594746 = newJObject()
  var query_594747 = newJObject()
  add(query_594747, "fields", newJString(fields))
  add(query_594747, "quotaUser", newJString(quotaUser))
  add(query_594747, "alt", newJString(alt))
  add(query_594747, "oauth_token", newJString(oauthToken))
  add(query_594747, "userIp", newJString(userIp))
  add(query_594747, "key", newJString(key))
  add(query_594747, "prettyPrint", newJBool(prettyPrint))
  add(path_594746, "userId", newJString(userId))
  result = call_594745.call(path_594746, query_594747, nil, nil, nil)

var gmailUsersSettingsSendAsList* = Call_GmailUsersSettingsSendAsList_594733(
    name: "gmailUsersSettingsSendAsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsList_594734,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsList_594735,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsUpdate_594781 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsUpdate_594783(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsUpdate_594782(path: JsonNode;
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
  var valid_594784 = path.getOrDefault("sendAsEmail")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "sendAsEmail", valid_594784
  var valid_594785 = path.getOrDefault("userId")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = newJString("me"))
  if valid_594785 != nil:
    section.add "userId", valid_594785
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
  var valid_594786 = query.getOrDefault("fields")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "fields", valid_594786
  var valid_594787 = query.getOrDefault("quotaUser")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = nil)
  if valid_594787 != nil:
    section.add "quotaUser", valid_594787
  var valid_594788 = query.getOrDefault("alt")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = newJString("json"))
  if valid_594788 != nil:
    section.add "alt", valid_594788
  var valid_594789 = query.getOrDefault("oauth_token")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "oauth_token", valid_594789
  var valid_594790 = query.getOrDefault("userIp")
  valid_594790 = validateParameter(valid_594790, JString, required = false,
                                 default = nil)
  if valid_594790 != nil:
    section.add "userIp", valid_594790
  var valid_594791 = query.getOrDefault("key")
  valid_594791 = validateParameter(valid_594791, JString, required = false,
                                 default = nil)
  if valid_594791 != nil:
    section.add "key", valid_594791
  var valid_594792 = query.getOrDefault("prettyPrint")
  valid_594792 = validateParameter(valid_594792, JBool, required = false,
                                 default = newJBool(true))
  if valid_594792 != nil:
    section.add "prettyPrint", valid_594792
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

proc call*(call_594794: Call_GmailUsersSettingsSendAsUpdate_594781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594794.validator(path, query, header, formData, body)
  let scheme = call_594794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594794.url(scheme.get, call_594794.host, call_594794.base,
                         call_594794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594794, url, valid)

proc call*(call_594795: Call_GmailUsersSettingsSendAsUpdate_594781;
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
  var path_594796 = newJObject()
  var query_594797 = newJObject()
  var body_594798 = newJObject()
  add(query_594797, "fields", newJString(fields))
  add(query_594797, "quotaUser", newJString(quotaUser))
  add(query_594797, "alt", newJString(alt))
  add(path_594796, "sendAsEmail", newJString(sendAsEmail))
  add(query_594797, "oauth_token", newJString(oauthToken))
  add(query_594797, "userIp", newJString(userIp))
  add(query_594797, "key", newJString(key))
  if body != nil:
    body_594798 = body
  add(query_594797, "prettyPrint", newJBool(prettyPrint))
  add(path_594796, "userId", newJString(userId))
  result = call_594795.call(path_594796, query_594797, nil, nil, body_594798)

var gmailUsersSettingsSendAsUpdate* = Call_GmailUsersSettingsSendAsUpdate_594781(
    name: "gmailUsersSettingsSendAsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsUpdate_594782,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsUpdate_594783,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsGet_594765 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsGet_594767(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsGet_594766(path: JsonNode; query: JsonNode;
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
  var valid_594768 = path.getOrDefault("sendAsEmail")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "sendAsEmail", valid_594768
  var valid_594769 = path.getOrDefault("userId")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = newJString("me"))
  if valid_594769 != nil:
    section.add "userId", valid_594769
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
  var valid_594770 = query.getOrDefault("fields")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "fields", valid_594770
  var valid_594771 = query.getOrDefault("quotaUser")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = nil)
  if valid_594771 != nil:
    section.add "quotaUser", valid_594771
  var valid_594772 = query.getOrDefault("alt")
  valid_594772 = validateParameter(valid_594772, JString, required = false,
                                 default = newJString("json"))
  if valid_594772 != nil:
    section.add "alt", valid_594772
  var valid_594773 = query.getOrDefault("oauth_token")
  valid_594773 = validateParameter(valid_594773, JString, required = false,
                                 default = nil)
  if valid_594773 != nil:
    section.add "oauth_token", valid_594773
  var valid_594774 = query.getOrDefault("userIp")
  valid_594774 = validateParameter(valid_594774, JString, required = false,
                                 default = nil)
  if valid_594774 != nil:
    section.add "userIp", valid_594774
  var valid_594775 = query.getOrDefault("key")
  valid_594775 = validateParameter(valid_594775, JString, required = false,
                                 default = nil)
  if valid_594775 != nil:
    section.add "key", valid_594775
  var valid_594776 = query.getOrDefault("prettyPrint")
  valid_594776 = validateParameter(valid_594776, JBool, required = false,
                                 default = newJBool(true))
  if valid_594776 != nil:
    section.add "prettyPrint", valid_594776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594777: Call_GmailUsersSettingsSendAsGet_594765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  let valid = call_594777.validator(path, query, header, formData, body)
  let scheme = call_594777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594777.url(scheme.get, call_594777.host, call_594777.base,
                         call_594777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594777, url, valid)

proc call*(call_594778: Call_GmailUsersSettingsSendAsGet_594765;
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
  var path_594779 = newJObject()
  var query_594780 = newJObject()
  add(query_594780, "fields", newJString(fields))
  add(query_594780, "quotaUser", newJString(quotaUser))
  add(query_594780, "alt", newJString(alt))
  add(path_594779, "sendAsEmail", newJString(sendAsEmail))
  add(query_594780, "oauth_token", newJString(oauthToken))
  add(query_594780, "userIp", newJString(userIp))
  add(query_594780, "key", newJString(key))
  add(query_594780, "prettyPrint", newJBool(prettyPrint))
  add(path_594779, "userId", newJString(userId))
  result = call_594778.call(path_594779, query_594780, nil, nil, nil)

var gmailUsersSettingsSendAsGet* = Call_GmailUsersSettingsSendAsGet_594765(
    name: "gmailUsersSettingsSendAsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsGet_594766,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsGet_594767,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsPatch_594815 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsPatch_594817(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsPatch_594816(path: JsonNode; query: JsonNode;
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
  var valid_594818 = path.getOrDefault("sendAsEmail")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "sendAsEmail", valid_594818
  var valid_594819 = path.getOrDefault("userId")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = newJString("me"))
  if valid_594819 != nil:
    section.add "userId", valid_594819
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
  var valid_594820 = query.getOrDefault("fields")
  valid_594820 = validateParameter(valid_594820, JString, required = false,
                                 default = nil)
  if valid_594820 != nil:
    section.add "fields", valid_594820
  var valid_594821 = query.getOrDefault("quotaUser")
  valid_594821 = validateParameter(valid_594821, JString, required = false,
                                 default = nil)
  if valid_594821 != nil:
    section.add "quotaUser", valid_594821
  var valid_594822 = query.getOrDefault("alt")
  valid_594822 = validateParameter(valid_594822, JString, required = false,
                                 default = newJString("json"))
  if valid_594822 != nil:
    section.add "alt", valid_594822
  var valid_594823 = query.getOrDefault("oauth_token")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "oauth_token", valid_594823
  var valid_594824 = query.getOrDefault("userIp")
  valid_594824 = validateParameter(valid_594824, JString, required = false,
                                 default = nil)
  if valid_594824 != nil:
    section.add "userIp", valid_594824
  var valid_594825 = query.getOrDefault("key")
  valid_594825 = validateParameter(valid_594825, JString, required = false,
                                 default = nil)
  if valid_594825 != nil:
    section.add "key", valid_594825
  var valid_594826 = query.getOrDefault("prettyPrint")
  valid_594826 = validateParameter(valid_594826, JBool, required = false,
                                 default = newJBool(true))
  if valid_594826 != nil:
    section.add "prettyPrint", valid_594826
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

proc call*(call_594828: Call_GmailUsersSettingsSendAsPatch_594815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  let valid = call_594828.validator(path, query, header, formData, body)
  let scheme = call_594828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594828.url(scheme.get, call_594828.host, call_594828.base,
                         call_594828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594828, url, valid)

proc call*(call_594829: Call_GmailUsersSettingsSendAsPatch_594815;
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
  var path_594830 = newJObject()
  var query_594831 = newJObject()
  var body_594832 = newJObject()
  add(query_594831, "fields", newJString(fields))
  add(query_594831, "quotaUser", newJString(quotaUser))
  add(query_594831, "alt", newJString(alt))
  add(path_594830, "sendAsEmail", newJString(sendAsEmail))
  add(query_594831, "oauth_token", newJString(oauthToken))
  add(query_594831, "userIp", newJString(userIp))
  add(query_594831, "key", newJString(key))
  if body != nil:
    body_594832 = body
  add(query_594831, "prettyPrint", newJBool(prettyPrint))
  add(path_594830, "userId", newJString(userId))
  result = call_594829.call(path_594830, query_594831, nil, nil, body_594832)

var gmailUsersSettingsSendAsPatch* = Call_GmailUsersSettingsSendAsPatch_594815(
    name: "gmailUsersSettingsSendAsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsPatch_594816,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsPatch_594817,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsDelete_594799 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsDelete_594801(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsDelete_594800(path: JsonNode;
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
  var valid_594802 = path.getOrDefault("sendAsEmail")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "sendAsEmail", valid_594802
  var valid_594803 = path.getOrDefault("userId")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = newJString("me"))
  if valid_594803 != nil:
    section.add "userId", valid_594803
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
  var valid_594804 = query.getOrDefault("fields")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "fields", valid_594804
  var valid_594805 = query.getOrDefault("quotaUser")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "quotaUser", valid_594805
  var valid_594806 = query.getOrDefault("alt")
  valid_594806 = validateParameter(valid_594806, JString, required = false,
                                 default = newJString("json"))
  if valid_594806 != nil:
    section.add "alt", valid_594806
  var valid_594807 = query.getOrDefault("oauth_token")
  valid_594807 = validateParameter(valid_594807, JString, required = false,
                                 default = nil)
  if valid_594807 != nil:
    section.add "oauth_token", valid_594807
  var valid_594808 = query.getOrDefault("userIp")
  valid_594808 = validateParameter(valid_594808, JString, required = false,
                                 default = nil)
  if valid_594808 != nil:
    section.add "userIp", valid_594808
  var valid_594809 = query.getOrDefault("key")
  valid_594809 = validateParameter(valid_594809, JString, required = false,
                                 default = nil)
  if valid_594809 != nil:
    section.add "key", valid_594809
  var valid_594810 = query.getOrDefault("prettyPrint")
  valid_594810 = validateParameter(valid_594810, JBool, required = false,
                                 default = newJBool(true))
  if valid_594810 != nil:
    section.add "prettyPrint", valid_594810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594811: Call_GmailUsersSettingsSendAsDelete_594799; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594811.validator(path, query, header, formData, body)
  let scheme = call_594811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594811.url(scheme.get, call_594811.host, call_594811.base,
                         call_594811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594811, url, valid)

proc call*(call_594812: Call_GmailUsersSettingsSendAsDelete_594799;
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
  var path_594813 = newJObject()
  var query_594814 = newJObject()
  add(query_594814, "fields", newJString(fields))
  add(query_594814, "quotaUser", newJString(quotaUser))
  add(query_594814, "alt", newJString(alt))
  add(path_594813, "sendAsEmail", newJString(sendAsEmail))
  add(query_594814, "oauth_token", newJString(oauthToken))
  add(query_594814, "userIp", newJString(userIp))
  add(query_594814, "key", newJString(key))
  add(query_594814, "prettyPrint", newJBool(prettyPrint))
  add(path_594813, "userId", newJString(userId))
  result = call_594812.call(path_594813, query_594814, nil, nil, nil)

var gmailUsersSettingsSendAsDelete* = Call_GmailUsersSettingsSendAsDelete_594799(
    name: "gmailUsersSettingsSendAsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsDelete_594800,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsDelete_594801,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoInsert_594849 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsSmimeInfoInsert_594851(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsSmimeInfoInsert_594850(path: JsonNode;
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
  var valid_594852 = path.getOrDefault("sendAsEmail")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "sendAsEmail", valid_594852
  var valid_594853 = path.getOrDefault("userId")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = newJString("me"))
  if valid_594853 != nil:
    section.add "userId", valid_594853
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
  var valid_594854 = query.getOrDefault("fields")
  valid_594854 = validateParameter(valid_594854, JString, required = false,
                                 default = nil)
  if valid_594854 != nil:
    section.add "fields", valid_594854
  var valid_594855 = query.getOrDefault("quotaUser")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "quotaUser", valid_594855
  var valid_594856 = query.getOrDefault("alt")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = newJString("json"))
  if valid_594856 != nil:
    section.add "alt", valid_594856
  var valid_594857 = query.getOrDefault("oauth_token")
  valid_594857 = validateParameter(valid_594857, JString, required = false,
                                 default = nil)
  if valid_594857 != nil:
    section.add "oauth_token", valid_594857
  var valid_594858 = query.getOrDefault("userIp")
  valid_594858 = validateParameter(valid_594858, JString, required = false,
                                 default = nil)
  if valid_594858 != nil:
    section.add "userIp", valid_594858
  var valid_594859 = query.getOrDefault("key")
  valid_594859 = validateParameter(valid_594859, JString, required = false,
                                 default = nil)
  if valid_594859 != nil:
    section.add "key", valid_594859
  var valid_594860 = query.getOrDefault("prettyPrint")
  valid_594860 = validateParameter(valid_594860, JBool, required = false,
                                 default = newJBool(true))
  if valid_594860 != nil:
    section.add "prettyPrint", valid_594860
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

proc call*(call_594862: Call_GmailUsersSettingsSendAsSmimeInfoInsert_594849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  let valid = call_594862.validator(path, query, header, formData, body)
  let scheme = call_594862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594862.url(scheme.get, call_594862.host, call_594862.base,
                         call_594862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594862, url, valid)

proc call*(call_594863: Call_GmailUsersSettingsSendAsSmimeInfoInsert_594849;
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
  var path_594864 = newJObject()
  var query_594865 = newJObject()
  var body_594866 = newJObject()
  add(query_594865, "fields", newJString(fields))
  add(query_594865, "quotaUser", newJString(quotaUser))
  add(query_594865, "alt", newJString(alt))
  add(path_594864, "sendAsEmail", newJString(sendAsEmail))
  add(query_594865, "oauth_token", newJString(oauthToken))
  add(query_594865, "userIp", newJString(userIp))
  add(query_594865, "key", newJString(key))
  if body != nil:
    body_594866 = body
  add(query_594865, "prettyPrint", newJBool(prettyPrint))
  add(path_594864, "userId", newJString(userId))
  result = call_594863.call(path_594864, query_594865, nil, nil, body_594866)

var gmailUsersSettingsSendAsSmimeInfoInsert* = Call_GmailUsersSettingsSendAsSmimeInfoInsert_594849(
    name: "gmailUsersSettingsSendAsSmimeInfoInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoInsert_594850,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoInsert_594851,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoList_594833 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsSmimeInfoList_594835(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsSmimeInfoList_594834(path: JsonNode;
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
  var valid_594836 = path.getOrDefault("sendAsEmail")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "sendAsEmail", valid_594836
  var valid_594837 = path.getOrDefault("userId")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = newJString("me"))
  if valid_594837 != nil:
    section.add "userId", valid_594837
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
  var valid_594838 = query.getOrDefault("fields")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = nil)
  if valid_594838 != nil:
    section.add "fields", valid_594838
  var valid_594839 = query.getOrDefault("quotaUser")
  valid_594839 = validateParameter(valid_594839, JString, required = false,
                                 default = nil)
  if valid_594839 != nil:
    section.add "quotaUser", valid_594839
  var valid_594840 = query.getOrDefault("alt")
  valid_594840 = validateParameter(valid_594840, JString, required = false,
                                 default = newJString("json"))
  if valid_594840 != nil:
    section.add "alt", valid_594840
  var valid_594841 = query.getOrDefault("oauth_token")
  valid_594841 = validateParameter(valid_594841, JString, required = false,
                                 default = nil)
  if valid_594841 != nil:
    section.add "oauth_token", valid_594841
  var valid_594842 = query.getOrDefault("userIp")
  valid_594842 = validateParameter(valid_594842, JString, required = false,
                                 default = nil)
  if valid_594842 != nil:
    section.add "userIp", valid_594842
  var valid_594843 = query.getOrDefault("key")
  valid_594843 = validateParameter(valid_594843, JString, required = false,
                                 default = nil)
  if valid_594843 != nil:
    section.add "key", valid_594843
  var valid_594844 = query.getOrDefault("prettyPrint")
  valid_594844 = validateParameter(valid_594844, JBool, required = false,
                                 default = newJBool(true))
  if valid_594844 != nil:
    section.add "prettyPrint", valid_594844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594845: Call_GmailUsersSettingsSendAsSmimeInfoList_594833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  let valid = call_594845.validator(path, query, header, formData, body)
  let scheme = call_594845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594845.url(scheme.get, call_594845.host, call_594845.base,
                         call_594845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594845, url, valid)

proc call*(call_594846: Call_GmailUsersSettingsSendAsSmimeInfoList_594833;
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
  var path_594847 = newJObject()
  var query_594848 = newJObject()
  add(query_594848, "fields", newJString(fields))
  add(query_594848, "quotaUser", newJString(quotaUser))
  add(query_594848, "alt", newJString(alt))
  add(path_594847, "sendAsEmail", newJString(sendAsEmail))
  add(query_594848, "oauth_token", newJString(oauthToken))
  add(query_594848, "userIp", newJString(userIp))
  add(query_594848, "key", newJString(key))
  add(query_594848, "prettyPrint", newJBool(prettyPrint))
  add(path_594847, "userId", newJString(userId))
  result = call_594846.call(path_594847, query_594848, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoList* = Call_GmailUsersSettingsSendAsSmimeInfoList_594833(
    name: "gmailUsersSettingsSendAsSmimeInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoList_594834,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoList_594835,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoGet_594867 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsSmimeInfoGet_594869(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsSmimeInfoGet_594868(path: JsonNode;
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
  var valid_594870 = path.getOrDefault("sendAsEmail")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "sendAsEmail", valid_594870
  var valid_594871 = path.getOrDefault("id")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "id", valid_594871
  var valid_594872 = path.getOrDefault("userId")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = newJString("me"))
  if valid_594872 != nil:
    section.add "userId", valid_594872
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
  var valid_594873 = query.getOrDefault("fields")
  valid_594873 = validateParameter(valid_594873, JString, required = false,
                                 default = nil)
  if valid_594873 != nil:
    section.add "fields", valid_594873
  var valid_594874 = query.getOrDefault("quotaUser")
  valid_594874 = validateParameter(valid_594874, JString, required = false,
                                 default = nil)
  if valid_594874 != nil:
    section.add "quotaUser", valid_594874
  var valid_594875 = query.getOrDefault("alt")
  valid_594875 = validateParameter(valid_594875, JString, required = false,
                                 default = newJString("json"))
  if valid_594875 != nil:
    section.add "alt", valid_594875
  var valid_594876 = query.getOrDefault("oauth_token")
  valid_594876 = validateParameter(valid_594876, JString, required = false,
                                 default = nil)
  if valid_594876 != nil:
    section.add "oauth_token", valid_594876
  var valid_594877 = query.getOrDefault("userIp")
  valid_594877 = validateParameter(valid_594877, JString, required = false,
                                 default = nil)
  if valid_594877 != nil:
    section.add "userIp", valid_594877
  var valid_594878 = query.getOrDefault("key")
  valid_594878 = validateParameter(valid_594878, JString, required = false,
                                 default = nil)
  if valid_594878 != nil:
    section.add "key", valid_594878
  var valid_594879 = query.getOrDefault("prettyPrint")
  valid_594879 = validateParameter(valid_594879, JBool, required = false,
                                 default = newJBool(true))
  if valid_594879 != nil:
    section.add "prettyPrint", valid_594879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594880: Call_GmailUsersSettingsSendAsSmimeInfoGet_594867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_594880.validator(path, query, header, formData, body)
  let scheme = call_594880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594880.url(scheme.get, call_594880.host, call_594880.base,
                         call_594880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594880, url, valid)

proc call*(call_594881: Call_GmailUsersSettingsSendAsSmimeInfoGet_594867;
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
  var path_594882 = newJObject()
  var query_594883 = newJObject()
  add(query_594883, "fields", newJString(fields))
  add(query_594883, "quotaUser", newJString(quotaUser))
  add(query_594883, "alt", newJString(alt))
  add(path_594882, "sendAsEmail", newJString(sendAsEmail))
  add(query_594883, "oauth_token", newJString(oauthToken))
  add(query_594883, "userIp", newJString(userIp))
  add(path_594882, "id", newJString(id))
  add(query_594883, "key", newJString(key))
  add(query_594883, "prettyPrint", newJBool(prettyPrint))
  add(path_594882, "userId", newJString(userId))
  result = call_594881.call(path_594882, query_594883, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoGet* = Call_GmailUsersSettingsSendAsSmimeInfoGet_594867(
    name: "gmailUsersSettingsSendAsSmimeInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoGet_594868,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoGet_594869,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoDelete_594884 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsSmimeInfoDelete_594886(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsSmimeInfoDelete_594885(path: JsonNode;
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
  var valid_594887 = path.getOrDefault("sendAsEmail")
  valid_594887 = validateParameter(valid_594887, JString, required = true,
                                 default = nil)
  if valid_594887 != nil:
    section.add "sendAsEmail", valid_594887
  var valid_594888 = path.getOrDefault("id")
  valid_594888 = validateParameter(valid_594888, JString, required = true,
                                 default = nil)
  if valid_594888 != nil:
    section.add "id", valid_594888
  var valid_594889 = path.getOrDefault("userId")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = newJString("me"))
  if valid_594889 != nil:
    section.add "userId", valid_594889
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
  var valid_594890 = query.getOrDefault("fields")
  valid_594890 = validateParameter(valid_594890, JString, required = false,
                                 default = nil)
  if valid_594890 != nil:
    section.add "fields", valid_594890
  var valid_594891 = query.getOrDefault("quotaUser")
  valid_594891 = validateParameter(valid_594891, JString, required = false,
                                 default = nil)
  if valid_594891 != nil:
    section.add "quotaUser", valid_594891
  var valid_594892 = query.getOrDefault("alt")
  valid_594892 = validateParameter(valid_594892, JString, required = false,
                                 default = newJString("json"))
  if valid_594892 != nil:
    section.add "alt", valid_594892
  var valid_594893 = query.getOrDefault("oauth_token")
  valid_594893 = validateParameter(valid_594893, JString, required = false,
                                 default = nil)
  if valid_594893 != nil:
    section.add "oauth_token", valid_594893
  var valid_594894 = query.getOrDefault("userIp")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = nil)
  if valid_594894 != nil:
    section.add "userIp", valid_594894
  var valid_594895 = query.getOrDefault("key")
  valid_594895 = validateParameter(valid_594895, JString, required = false,
                                 default = nil)
  if valid_594895 != nil:
    section.add "key", valid_594895
  var valid_594896 = query.getOrDefault("prettyPrint")
  valid_594896 = validateParameter(valid_594896, JBool, required = false,
                                 default = newJBool(true))
  if valid_594896 != nil:
    section.add "prettyPrint", valid_594896
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594897: Call_GmailUsersSettingsSendAsSmimeInfoDelete_594884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_594897.validator(path, query, header, formData, body)
  let scheme = call_594897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594897.url(scheme.get, call_594897.host, call_594897.base,
                         call_594897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594897, url, valid)

proc call*(call_594898: Call_GmailUsersSettingsSendAsSmimeInfoDelete_594884;
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
  var path_594899 = newJObject()
  var query_594900 = newJObject()
  add(query_594900, "fields", newJString(fields))
  add(query_594900, "quotaUser", newJString(quotaUser))
  add(query_594900, "alt", newJString(alt))
  add(path_594899, "sendAsEmail", newJString(sendAsEmail))
  add(query_594900, "oauth_token", newJString(oauthToken))
  add(query_594900, "userIp", newJString(userIp))
  add(path_594899, "id", newJString(id))
  add(query_594900, "key", newJString(key))
  add(query_594900, "prettyPrint", newJBool(prettyPrint))
  add(path_594899, "userId", newJString(userId))
  result = call_594898.call(path_594899, query_594900, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoDelete* = Call_GmailUsersSettingsSendAsSmimeInfoDelete_594884(
    name: "gmailUsersSettingsSendAsSmimeInfoDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoDelete_594885,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoDelete_594886,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_594901 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsSmimeInfoSetDefault_594903(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_594902(path: JsonNode;
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
  var valid_594904 = path.getOrDefault("sendAsEmail")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "sendAsEmail", valid_594904
  var valid_594905 = path.getOrDefault("id")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "id", valid_594905
  var valid_594906 = path.getOrDefault("userId")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = newJString("me"))
  if valid_594906 != nil:
    section.add "userId", valid_594906
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
  var valid_594907 = query.getOrDefault("fields")
  valid_594907 = validateParameter(valid_594907, JString, required = false,
                                 default = nil)
  if valid_594907 != nil:
    section.add "fields", valid_594907
  var valid_594908 = query.getOrDefault("quotaUser")
  valid_594908 = validateParameter(valid_594908, JString, required = false,
                                 default = nil)
  if valid_594908 != nil:
    section.add "quotaUser", valid_594908
  var valid_594909 = query.getOrDefault("alt")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = newJString("json"))
  if valid_594909 != nil:
    section.add "alt", valid_594909
  var valid_594910 = query.getOrDefault("oauth_token")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "oauth_token", valid_594910
  var valid_594911 = query.getOrDefault("userIp")
  valid_594911 = validateParameter(valid_594911, JString, required = false,
                                 default = nil)
  if valid_594911 != nil:
    section.add "userIp", valid_594911
  var valid_594912 = query.getOrDefault("key")
  valid_594912 = validateParameter(valid_594912, JString, required = false,
                                 default = nil)
  if valid_594912 != nil:
    section.add "key", valid_594912
  var valid_594913 = query.getOrDefault("prettyPrint")
  valid_594913 = validateParameter(valid_594913, JBool, required = false,
                                 default = newJBool(true))
  if valid_594913 != nil:
    section.add "prettyPrint", valid_594913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594914: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_594901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  let valid = call_594914.validator(path, query, header, formData, body)
  let scheme = call_594914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594914.url(scheme.get, call_594914.host, call_594914.base,
                         call_594914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594914, url, valid)

proc call*(call_594915: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_594901;
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
  var path_594916 = newJObject()
  var query_594917 = newJObject()
  add(query_594917, "fields", newJString(fields))
  add(query_594917, "quotaUser", newJString(quotaUser))
  add(query_594917, "alt", newJString(alt))
  add(path_594916, "sendAsEmail", newJString(sendAsEmail))
  add(query_594917, "oauth_token", newJString(oauthToken))
  add(query_594917, "userIp", newJString(userIp))
  add(path_594916, "id", newJString(id))
  add(query_594917, "key", newJString(key))
  add(query_594917, "prettyPrint", newJBool(prettyPrint))
  add(path_594916, "userId", newJString(userId))
  result = call_594915.call(path_594916, query_594917, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoSetDefault* = Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_594901(
    name: "gmailUsersSettingsSendAsSmimeInfoSetDefault",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}/setDefault",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_594902,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoSetDefault_594903,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsVerify_594918 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsSendAsVerify_594920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsSendAsVerify_594919(path: JsonNode;
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
  var valid_594921 = path.getOrDefault("sendAsEmail")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "sendAsEmail", valid_594921
  var valid_594922 = path.getOrDefault("userId")
  valid_594922 = validateParameter(valid_594922, JString, required = true,
                                 default = newJString("me"))
  if valid_594922 != nil:
    section.add "userId", valid_594922
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
  var valid_594923 = query.getOrDefault("fields")
  valid_594923 = validateParameter(valid_594923, JString, required = false,
                                 default = nil)
  if valid_594923 != nil:
    section.add "fields", valid_594923
  var valid_594924 = query.getOrDefault("quotaUser")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "quotaUser", valid_594924
  var valid_594925 = query.getOrDefault("alt")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = newJString("json"))
  if valid_594925 != nil:
    section.add "alt", valid_594925
  var valid_594926 = query.getOrDefault("oauth_token")
  valid_594926 = validateParameter(valid_594926, JString, required = false,
                                 default = nil)
  if valid_594926 != nil:
    section.add "oauth_token", valid_594926
  var valid_594927 = query.getOrDefault("userIp")
  valid_594927 = validateParameter(valid_594927, JString, required = false,
                                 default = nil)
  if valid_594927 != nil:
    section.add "userIp", valid_594927
  var valid_594928 = query.getOrDefault("key")
  valid_594928 = validateParameter(valid_594928, JString, required = false,
                                 default = nil)
  if valid_594928 != nil:
    section.add "key", valid_594928
  var valid_594929 = query.getOrDefault("prettyPrint")
  valid_594929 = validateParameter(valid_594929, JBool, required = false,
                                 default = newJBool(true))
  if valid_594929 != nil:
    section.add "prettyPrint", valid_594929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594930: Call_GmailUsersSettingsSendAsVerify_594918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_594930.validator(path, query, header, formData, body)
  let scheme = call_594930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594930.url(scheme.get, call_594930.host, call_594930.base,
                         call_594930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594930, url, valid)

proc call*(call_594931: Call_GmailUsersSettingsSendAsVerify_594918;
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
  var path_594932 = newJObject()
  var query_594933 = newJObject()
  add(query_594933, "fields", newJString(fields))
  add(query_594933, "quotaUser", newJString(quotaUser))
  add(query_594933, "alt", newJString(alt))
  add(path_594932, "sendAsEmail", newJString(sendAsEmail))
  add(query_594933, "oauth_token", newJString(oauthToken))
  add(query_594933, "userIp", newJString(userIp))
  add(query_594933, "key", newJString(key))
  add(query_594933, "prettyPrint", newJBool(prettyPrint))
  add(path_594932, "userId", newJString(userId))
  result = call_594931.call(path_594932, query_594933, nil, nil, nil)

var gmailUsersSettingsSendAsVerify* = Call_GmailUsersSettingsSendAsVerify_594918(
    name: "gmailUsersSettingsSendAsVerify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/verify",
    validator: validate_GmailUsersSettingsSendAsVerify_594919,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsVerify_594920,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateVacation_594949 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsUpdateVacation_594951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsUpdateVacation_594950(path: JsonNode;
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
  var valid_594952 = path.getOrDefault("userId")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = newJString("me"))
  if valid_594952 != nil:
    section.add "userId", valid_594952
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
  var valid_594953 = query.getOrDefault("fields")
  valid_594953 = validateParameter(valid_594953, JString, required = false,
                                 default = nil)
  if valid_594953 != nil:
    section.add "fields", valid_594953
  var valid_594954 = query.getOrDefault("quotaUser")
  valid_594954 = validateParameter(valid_594954, JString, required = false,
                                 default = nil)
  if valid_594954 != nil:
    section.add "quotaUser", valid_594954
  var valid_594955 = query.getOrDefault("alt")
  valid_594955 = validateParameter(valid_594955, JString, required = false,
                                 default = newJString("json"))
  if valid_594955 != nil:
    section.add "alt", valid_594955
  var valid_594956 = query.getOrDefault("oauth_token")
  valid_594956 = validateParameter(valid_594956, JString, required = false,
                                 default = nil)
  if valid_594956 != nil:
    section.add "oauth_token", valid_594956
  var valid_594957 = query.getOrDefault("userIp")
  valid_594957 = validateParameter(valid_594957, JString, required = false,
                                 default = nil)
  if valid_594957 != nil:
    section.add "userIp", valid_594957
  var valid_594958 = query.getOrDefault("key")
  valid_594958 = validateParameter(valid_594958, JString, required = false,
                                 default = nil)
  if valid_594958 != nil:
    section.add "key", valid_594958
  var valid_594959 = query.getOrDefault("prettyPrint")
  valid_594959 = validateParameter(valid_594959, JBool, required = false,
                                 default = newJBool(true))
  if valid_594959 != nil:
    section.add "prettyPrint", valid_594959
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

proc call*(call_594961: Call_GmailUsersSettingsUpdateVacation_594949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vacation responder settings.
  ## 
  let valid = call_594961.validator(path, query, header, formData, body)
  let scheme = call_594961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594961.url(scheme.get, call_594961.host, call_594961.base,
                         call_594961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594961, url, valid)

proc call*(call_594962: Call_GmailUsersSettingsUpdateVacation_594949;
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
  var path_594963 = newJObject()
  var query_594964 = newJObject()
  var body_594965 = newJObject()
  add(query_594964, "fields", newJString(fields))
  add(query_594964, "quotaUser", newJString(quotaUser))
  add(query_594964, "alt", newJString(alt))
  add(query_594964, "oauth_token", newJString(oauthToken))
  add(query_594964, "userIp", newJString(userIp))
  add(query_594964, "key", newJString(key))
  if body != nil:
    body_594965 = body
  add(query_594964, "prettyPrint", newJBool(prettyPrint))
  add(path_594963, "userId", newJString(userId))
  result = call_594962.call(path_594963, query_594964, nil, nil, body_594965)

var gmailUsersSettingsUpdateVacation* = Call_GmailUsersSettingsUpdateVacation_594949(
    name: "gmailUsersSettingsUpdateVacation", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsUpdateVacation_594950,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateVacation_594951,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetVacation_594934 = ref object of OpenApiRestCall_593424
proc url_GmailUsersSettingsGetVacation_594936(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersSettingsGetVacation_594935(path: JsonNode; query: JsonNode;
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
  var valid_594937 = path.getOrDefault("userId")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = newJString("me"))
  if valid_594937 != nil:
    section.add "userId", valid_594937
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
  var valid_594938 = query.getOrDefault("fields")
  valid_594938 = validateParameter(valid_594938, JString, required = false,
                                 default = nil)
  if valid_594938 != nil:
    section.add "fields", valid_594938
  var valid_594939 = query.getOrDefault("quotaUser")
  valid_594939 = validateParameter(valid_594939, JString, required = false,
                                 default = nil)
  if valid_594939 != nil:
    section.add "quotaUser", valid_594939
  var valid_594940 = query.getOrDefault("alt")
  valid_594940 = validateParameter(valid_594940, JString, required = false,
                                 default = newJString("json"))
  if valid_594940 != nil:
    section.add "alt", valid_594940
  var valid_594941 = query.getOrDefault("oauth_token")
  valid_594941 = validateParameter(valid_594941, JString, required = false,
                                 default = nil)
  if valid_594941 != nil:
    section.add "oauth_token", valid_594941
  var valid_594942 = query.getOrDefault("userIp")
  valid_594942 = validateParameter(valid_594942, JString, required = false,
                                 default = nil)
  if valid_594942 != nil:
    section.add "userIp", valid_594942
  var valid_594943 = query.getOrDefault("key")
  valid_594943 = validateParameter(valid_594943, JString, required = false,
                                 default = nil)
  if valid_594943 != nil:
    section.add "key", valid_594943
  var valid_594944 = query.getOrDefault("prettyPrint")
  valid_594944 = validateParameter(valid_594944, JBool, required = false,
                                 default = newJBool(true))
  if valid_594944 != nil:
    section.add "prettyPrint", valid_594944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594945: Call_GmailUsersSettingsGetVacation_594934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets vacation responder settings.
  ## 
  let valid = call_594945.validator(path, query, header, formData, body)
  let scheme = call_594945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594945.url(scheme.get, call_594945.host, call_594945.base,
                         call_594945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594945, url, valid)

proc call*(call_594946: Call_GmailUsersSettingsGetVacation_594934;
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
  var path_594947 = newJObject()
  var query_594948 = newJObject()
  add(query_594948, "fields", newJString(fields))
  add(query_594948, "quotaUser", newJString(quotaUser))
  add(query_594948, "alt", newJString(alt))
  add(query_594948, "oauth_token", newJString(oauthToken))
  add(query_594948, "userIp", newJString(userIp))
  add(query_594948, "key", newJString(key))
  add(query_594948, "prettyPrint", newJBool(prettyPrint))
  add(path_594947, "userId", newJString(userId))
  result = call_594946.call(path_594947, query_594948, nil, nil, nil)

var gmailUsersSettingsGetVacation* = Call_GmailUsersSettingsGetVacation_594934(
    name: "gmailUsersSettingsGetVacation", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsGetVacation_594935,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetVacation_594936,
    schemes: {Scheme.Https})
type
  Call_GmailUsersStop_594966 = ref object of OpenApiRestCall_593424
proc url_GmailUsersStop_594968(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersStop_594967(path: JsonNode; query: JsonNode;
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
  var valid_594969 = path.getOrDefault("userId")
  valid_594969 = validateParameter(valid_594969, JString, required = true,
                                 default = newJString("me"))
  if valid_594969 != nil:
    section.add "userId", valid_594969
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
  var valid_594970 = query.getOrDefault("fields")
  valid_594970 = validateParameter(valid_594970, JString, required = false,
                                 default = nil)
  if valid_594970 != nil:
    section.add "fields", valid_594970
  var valid_594971 = query.getOrDefault("quotaUser")
  valid_594971 = validateParameter(valid_594971, JString, required = false,
                                 default = nil)
  if valid_594971 != nil:
    section.add "quotaUser", valid_594971
  var valid_594972 = query.getOrDefault("alt")
  valid_594972 = validateParameter(valid_594972, JString, required = false,
                                 default = newJString("json"))
  if valid_594972 != nil:
    section.add "alt", valid_594972
  var valid_594973 = query.getOrDefault("oauth_token")
  valid_594973 = validateParameter(valid_594973, JString, required = false,
                                 default = nil)
  if valid_594973 != nil:
    section.add "oauth_token", valid_594973
  var valid_594974 = query.getOrDefault("userIp")
  valid_594974 = validateParameter(valid_594974, JString, required = false,
                                 default = nil)
  if valid_594974 != nil:
    section.add "userIp", valid_594974
  var valid_594975 = query.getOrDefault("key")
  valid_594975 = validateParameter(valid_594975, JString, required = false,
                                 default = nil)
  if valid_594975 != nil:
    section.add "key", valid_594975
  var valid_594976 = query.getOrDefault("prettyPrint")
  valid_594976 = validateParameter(valid_594976, JBool, required = false,
                                 default = newJBool(true))
  if valid_594976 != nil:
    section.add "prettyPrint", valid_594976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594977: Call_GmailUsersStop_594966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop receiving push notifications for the given user mailbox.
  ## 
  let valid = call_594977.validator(path, query, header, formData, body)
  let scheme = call_594977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594977.url(scheme.get, call_594977.host, call_594977.base,
                         call_594977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594977, url, valid)

proc call*(call_594978: Call_GmailUsersStop_594966; fields: string = "";
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
  var path_594979 = newJObject()
  var query_594980 = newJObject()
  add(query_594980, "fields", newJString(fields))
  add(query_594980, "quotaUser", newJString(quotaUser))
  add(query_594980, "alt", newJString(alt))
  add(query_594980, "oauth_token", newJString(oauthToken))
  add(query_594980, "userIp", newJString(userIp))
  add(query_594980, "key", newJString(key))
  add(query_594980, "prettyPrint", newJBool(prettyPrint))
  add(path_594979, "userId", newJString(userId))
  result = call_594978.call(path_594979, query_594980, nil, nil, nil)

var gmailUsersStop* = Call_GmailUsersStop_594966(name: "gmailUsersStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/stop",
    validator: validate_GmailUsersStop_594967, base: "/gmail/v1/users",
    url: url_GmailUsersStop_594968, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsList_594981 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsList_594983(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsList_594982(path: JsonNode; query: JsonNode;
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
  var valid_594984 = path.getOrDefault("userId")
  valid_594984 = validateParameter(valid_594984, JString, required = true,
                                 default = newJString("me"))
  if valid_594984 != nil:
    section.add "userId", valid_594984
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
  var valid_594985 = query.getOrDefault("fields")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "fields", valid_594985
  var valid_594986 = query.getOrDefault("pageToken")
  valid_594986 = validateParameter(valid_594986, JString, required = false,
                                 default = nil)
  if valid_594986 != nil:
    section.add "pageToken", valid_594986
  var valid_594987 = query.getOrDefault("quotaUser")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = nil)
  if valid_594987 != nil:
    section.add "quotaUser", valid_594987
  var valid_594988 = query.getOrDefault("alt")
  valid_594988 = validateParameter(valid_594988, JString, required = false,
                                 default = newJString("json"))
  if valid_594988 != nil:
    section.add "alt", valid_594988
  var valid_594989 = query.getOrDefault("oauth_token")
  valid_594989 = validateParameter(valid_594989, JString, required = false,
                                 default = nil)
  if valid_594989 != nil:
    section.add "oauth_token", valid_594989
  var valid_594990 = query.getOrDefault("userIp")
  valid_594990 = validateParameter(valid_594990, JString, required = false,
                                 default = nil)
  if valid_594990 != nil:
    section.add "userIp", valid_594990
  var valid_594991 = query.getOrDefault("maxResults")
  valid_594991 = validateParameter(valid_594991, JInt, required = false,
                                 default = newJInt(100))
  if valid_594991 != nil:
    section.add "maxResults", valid_594991
  var valid_594992 = query.getOrDefault("includeSpamTrash")
  valid_594992 = validateParameter(valid_594992, JBool, required = false,
                                 default = newJBool(false))
  if valid_594992 != nil:
    section.add "includeSpamTrash", valid_594992
  var valid_594993 = query.getOrDefault("q")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = nil)
  if valid_594993 != nil:
    section.add "q", valid_594993
  var valid_594994 = query.getOrDefault("labelIds")
  valid_594994 = validateParameter(valid_594994, JArray, required = false,
                                 default = nil)
  if valid_594994 != nil:
    section.add "labelIds", valid_594994
  var valid_594995 = query.getOrDefault("key")
  valid_594995 = validateParameter(valid_594995, JString, required = false,
                                 default = nil)
  if valid_594995 != nil:
    section.add "key", valid_594995
  var valid_594996 = query.getOrDefault("prettyPrint")
  valid_594996 = validateParameter(valid_594996, JBool, required = false,
                                 default = newJBool(true))
  if valid_594996 != nil:
    section.add "prettyPrint", valid_594996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594997: Call_GmailUsersThreadsList_594981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the threads in the user's mailbox.
  ## 
  let valid = call_594997.validator(path, query, header, formData, body)
  let scheme = call_594997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594997.url(scheme.get, call_594997.host, call_594997.base,
                         call_594997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594997, url, valid)

proc call*(call_594998: Call_GmailUsersThreadsList_594981; fields: string = "";
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
  var path_594999 = newJObject()
  var query_595000 = newJObject()
  add(query_595000, "fields", newJString(fields))
  add(query_595000, "pageToken", newJString(pageToken))
  add(query_595000, "quotaUser", newJString(quotaUser))
  add(query_595000, "alt", newJString(alt))
  add(query_595000, "oauth_token", newJString(oauthToken))
  add(query_595000, "userIp", newJString(userIp))
  add(query_595000, "maxResults", newJInt(maxResults))
  add(query_595000, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_595000, "q", newJString(q))
  if labelIds != nil:
    query_595000.add "labelIds", labelIds
  add(query_595000, "key", newJString(key))
  add(query_595000, "prettyPrint", newJBool(prettyPrint))
  add(path_594999, "userId", newJString(userId))
  result = call_594998.call(path_594999, query_595000, nil, nil, nil)

var gmailUsersThreadsList* = Call_GmailUsersThreadsList_594981(
    name: "gmailUsersThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads",
    validator: validate_GmailUsersThreadsList_594982, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsList_594983, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsGet_595001 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsGet_595003(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsGet_595002(path: JsonNode; query: JsonNode;
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
  var valid_595004 = path.getOrDefault("id")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "id", valid_595004
  var valid_595005 = path.getOrDefault("userId")
  valid_595005 = validateParameter(valid_595005, JString, required = true,
                                 default = newJString("me"))
  if valid_595005 != nil:
    section.add "userId", valid_595005
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
  var valid_595006 = query.getOrDefault("fields")
  valid_595006 = validateParameter(valid_595006, JString, required = false,
                                 default = nil)
  if valid_595006 != nil:
    section.add "fields", valid_595006
  var valid_595007 = query.getOrDefault("quotaUser")
  valid_595007 = validateParameter(valid_595007, JString, required = false,
                                 default = nil)
  if valid_595007 != nil:
    section.add "quotaUser", valid_595007
  var valid_595008 = query.getOrDefault("alt")
  valid_595008 = validateParameter(valid_595008, JString, required = false,
                                 default = newJString("json"))
  if valid_595008 != nil:
    section.add "alt", valid_595008
  var valid_595009 = query.getOrDefault("oauth_token")
  valid_595009 = validateParameter(valid_595009, JString, required = false,
                                 default = nil)
  if valid_595009 != nil:
    section.add "oauth_token", valid_595009
  var valid_595010 = query.getOrDefault("userIp")
  valid_595010 = validateParameter(valid_595010, JString, required = false,
                                 default = nil)
  if valid_595010 != nil:
    section.add "userIp", valid_595010
  var valid_595011 = query.getOrDefault("metadataHeaders")
  valid_595011 = validateParameter(valid_595011, JArray, required = false,
                                 default = nil)
  if valid_595011 != nil:
    section.add "metadataHeaders", valid_595011
  var valid_595012 = query.getOrDefault("key")
  valid_595012 = validateParameter(valid_595012, JString, required = false,
                                 default = nil)
  if valid_595012 != nil:
    section.add "key", valid_595012
  var valid_595013 = query.getOrDefault("prettyPrint")
  valid_595013 = validateParameter(valid_595013, JBool, required = false,
                                 default = newJBool(true))
  if valid_595013 != nil:
    section.add "prettyPrint", valid_595013
  var valid_595014 = query.getOrDefault("format")
  valid_595014 = validateParameter(valid_595014, JString, required = false,
                                 default = newJString("full"))
  if valid_595014 != nil:
    section.add "format", valid_595014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595015: Call_GmailUsersThreadsGet_595001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified thread.
  ## 
  let valid = call_595015.validator(path, query, header, formData, body)
  let scheme = call_595015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595015.url(scheme.get, call_595015.host, call_595015.base,
                         call_595015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595015, url, valid)

proc call*(call_595016: Call_GmailUsersThreadsGet_595001; id: string;
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
  var path_595017 = newJObject()
  var query_595018 = newJObject()
  add(query_595018, "fields", newJString(fields))
  add(query_595018, "quotaUser", newJString(quotaUser))
  add(query_595018, "alt", newJString(alt))
  add(query_595018, "oauth_token", newJString(oauthToken))
  add(query_595018, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_595018.add "metadataHeaders", metadataHeaders
  add(path_595017, "id", newJString(id))
  add(query_595018, "key", newJString(key))
  add(query_595018, "prettyPrint", newJBool(prettyPrint))
  add(query_595018, "format", newJString(format))
  add(path_595017, "userId", newJString(userId))
  result = call_595016.call(path_595017, query_595018, nil, nil, nil)

var gmailUsersThreadsGet* = Call_GmailUsersThreadsGet_595001(
    name: "gmailUsersThreadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsGet_595002, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsGet_595003, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsDelete_595019 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsDelete_595021(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsDelete_595020(path: JsonNode; query: JsonNode;
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
  var valid_595022 = path.getOrDefault("id")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "id", valid_595022
  var valid_595023 = path.getOrDefault("userId")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = newJString("me"))
  if valid_595023 != nil:
    section.add "userId", valid_595023
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
  var valid_595024 = query.getOrDefault("fields")
  valid_595024 = validateParameter(valid_595024, JString, required = false,
                                 default = nil)
  if valid_595024 != nil:
    section.add "fields", valid_595024
  var valid_595025 = query.getOrDefault("quotaUser")
  valid_595025 = validateParameter(valid_595025, JString, required = false,
                                 default = nil)
  if valid_595025 != nil:
    section.add "quotaUser", valid_595025
  var valid_595026 = query.getOrDefault("alt")
  valid_595026 = validateParameter(valid_595026, JString, required = false,
                                 default = newJString("json"))
  if valid_595026 != nil:
    section.add "alt", valid_595026
  var valid_595027 = query.getOrDefault("oauth_token")
  valid_595027 = validateParameter(valid_595027, JString, required = false,
                                 default = nil)
  if valid_595027 != nil:
    section.add "oauth_token", valid_595027
  var valid_595028 = query.getOrDefault("userIp")
  valid_595028 = validateParameter(valid_595028, JString, required = false,
                                 default = nil)
  if valid_595028 != nil:
    section.add "userIp", valid_595028
  var valid_595029 = query.getOrDefault("key")
  valid_595029 = validateParameter(valid_595029, JString, required = false,
                                 default = nil)
  if valid_595029 != nil:
    section.add "key", valid_595029
  var valid_595030 = query.getOrDefault("prettyPrint")
  valid_595030 = validateParameter(valid_595030, JBool, required = false,
                                 default = newJBool(true))
  if valid_595030 != nil:
    section.add "prettyPrint", valid_595030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595031: Call_GmailUsersThreadsDelete_595019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ## 
  let valid = call_595031.validator(path, query, header, formData, body)
  let scheme = call_595031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595031.url(scheme.get, call_595031.host, call_595031.base,
                         call_595031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595031, url, valid)

proc call*(call_595032: Call_GmailUsersThreadsDelete_595019; id: string;
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
  var path_595033 = newJObject()
  var query_595034 = newJObject()
  add(query_595034, "fields", newJString(fields))
  add(query_595034, "quotaUser", newJString(quotaUser))
  add(query_595034, "alt", newJString(alt))
  add(query_595034, "oauth_token", newJString(oauthToken))
  add(query_595034, "userIp", newJString(userIp))
  add(path_595033, "id", newJString(id))
  add(query_595034, "key", newJString(key))
  add(query_595034, "prettyPrint", newJBool(prettyPrint))
  add(path_595033, "userId", newJString(userId))
  result = call_595032.call(path_595033, query_595034, nil, nil, nil)

var gmailUsersThreadsDelete* = Call_GmailUsersThreadsDelete_595019(
    name: "gmailUsersThreadsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsDelete_595020, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsDelete_595021, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsModify_595035 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsModify_595037(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsModify_595036(path: JsonNode; query: JsonNode;
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
  var valid_595038 = path.getOrDefault("id")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "id", valid_595038
  var valid_595039 = path.getOrDefault("userId")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = newJString("me"))
  if valid_595039 != nil:
    section.add "userId", valid_595039
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
  var valid_595040 = query.getOrDefault("fields")
  valid_595040 = validateParameter(valid_595040, JString, required = false,
                                 default = nil)
  if valid_595040 != nil:
    section.add "fields", valid_595040
  var valid_595041 = query.getOrDefault("quotaUser")
  valid_595041 = validateParameter(valid_595041, JString, required = false,
                                 default = nil)
  if valid_595041 != nil:
    section.add "quotaUser", valid_595041
  var valid_595042 = query.getOrDefault("alt")
  valid_595042 = validateParameter(valid_595042, JString, required = false,
                                 default = newJString("json"))
  if valid_595042 != nil:
    section.add "alt", valid_595042
  var valid_595043 = query.getOrDefault("oauth_token")
  valid_595043 = validateParameter(valid_595043, JString, required = false,
                                 default = nil)
  if valid_595043 != nil:
    section.add "oauth_token", valid_595043
  var valid_595044 = query.getOrDefault("userIp")
  valid_595044 = validateParameter(valid_595044, JString, required = false,
                                 default = nil)
  if valid_595044 != nil:
    section.add "userIp", valid_595044
  var valid_595045 = query.getOrDefault("key")
  valid_595045 = validateParameter(valid_595045, JString, required = false,
                                 default = nil)
  if valid_595045 != nil:
    section.add "key", valid_595045
  var valid_595046 = query.getOrDefault("prettyPrint")
  valid_595046 = validateParameter(valid_595046, JBool, required = false,
                                 default = newJBool(true))
  if valid_595046 != nil:
    section.add "prettyPrint", valid_595046
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

proc call*(call_595048: Call_GmailUsersThreadsModify_595035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ## 
  let valid = call_595048.validator(path, query, header, formData, body)
  let scheme = call_595048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595048.url(scheme.get, call_595048.host, call_595048.base,
                         call_595048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595048, url, valid)

proc call*(call_595049: Call_GmailUsersThreadsModify_595035; id: string;
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
  var path_595050 = newJObject()
  var query_595051 = newJObject()
  var body_595052 = newJObject()
  add(query_595051, "fields", newJString(fields))
  add(query_595051, "quotaUser", newJString(quotaUser))
  add(query_595051, "alt", newJString(alt))
  add(query_595051, "oauth_token", newJString(oauthToken))
  add(query_595051, "userIp", newJString(userIp))
  add(path_595050, "id", newJString(id))
  add(query_595051, "key", newJString(key))
  if body != nil:
    body_595052 = body
  add(query_595051, "prettyPrint", newJBool(prettyPrint))
  add(path_595050, "userId", newJString(userId))
  result = call_595049.call(path_595050, query_595051, nil, nil, body_595052)

var gmailUsersThreadsModify* = Call_GmailUsersThreadsModify_595035(
    name: "gmailUsersThreadsModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/modify",
    validator: validate_GmailUsersThreadsModify_595036, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsModify_595037, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsTrash_595053 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsTrash_595055(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsTrash_595054(path: JsonNode; query: JsonNode;
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
  var valid_595056 = path.getOrDefault("id")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "id", valid_595056
  var valid_595057 = path.getOrDefault("userId")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = newJString("me"))
  if valid_595057 != nil:
    section.add "userId", valid_595057
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
  var valid_595058 = query.getOrDefault("fields")
  valid_595058 = validateParameter(valid_595058, JString, required = false,
                                 default = nil)
  if valid_595058 != nil:
    section.add "fields", valid_595058
  var valid_595059 = query.getOrDefault("quotaUser")
  valid_595059 = validateParameter(valid_595059, JString, required = false,
                                 default = nil)
  if valid_595059 != nil:
    section.add "quotaUser", valid_595059
  var valid_595060 = query.getOrDefault("alt")
  valid_595060 = validateParameter(valid_595060, JString, required = false,
                                 default = newJString("json"))
  if valid_595060 != nil:
    section.add "alt", valid_595060
  var valid_595061 = query.getOrDefault("oauth_token")
  valid_595061 = validateParameter(valid_595061, JString, required = false,
                                 default = nil)
  if valid_595061 != nil:
    section.add "oauth_token", valid_595061
  var valid_595062 = query.getOrDefault("userIp")
  valid_595062 = validateParameter(valid_595062, JString, required = false,
                                 default = nil)
  if valid_595062 != nil:
    section.add "userIp", valid_595062
  var valid_595063 = query.getOrDefault("key")
  valid_595063 = validateParameter(valid_595063, JString, required = false,
                                 default = nil)
  if valid_595063 != nil:
    section.add "key", valid_595063
  var valid_595064 = query.getOrDefault("prettyPrint")
  valid_595064 = validateParameter(valid_595064, JBool, required = false,
                                 default = newJBool(true))
  if valid_595064 != nil:
    section.add "prettyPrint", valid_595064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595065: Call_GmailUsersThreadsTrash_595053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified thread to the trash.
  ## 
  let valid = call_595065.validator(path, query, header, formData, body)
  let scheme = call_595065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595065.url(scheme.get, call_595065.host, call_595065.base,
                         call_595065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595065, url, valid)

proc call*(call_595066: Call_GmailUsersThreadsTrash_595053; id: string;
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
  var path_595067 = newJObject()
  var query_595068 = newJObject()
  add(query_595068, "fields", newJString(fields))
  add(query_595068, "quotaUser", newJString(quotaUser))
  add(query_595068, "alt", newJString(alt))
  add(query_595068, "oauth_token", newJString(oauthToken))
  add(query_595068, "userIp", newJString(userIp))
  add(path_595067, "id", newJString(id))
  add(query_595068, "key", newJString(key))
  add(query_595068, "prettyPrint", newJBool(prettyPrint))
  add(path_595067, "userId", newJString(userId))
  result = call_595066.call(path_595067, query_595068, nil, nil, nil)

var gmailUsersThreadsTrash* = Call_GmailUsersThreadsTrash_595053(
    name: "gmailUsersThreadsTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/trash",
    validator: validate_GmailUsersThreadsTrash_595054, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsTrash_595055, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsUntrash_595069 = ref object of OpenApiRestCall_593424
proc url_GmailUsersThreadsUntrash_595071(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersThreadsUntrash_595070(path: JsonNode; query: JsonNode;
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
  var valid_595072 = path.getOrDefault("id")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "id", valid_595072
  var valid_595073 = path.getOrDefault("userId")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = newJString("me"))
  if valid_595073 != nil:
    section.add "userId", valid_595073
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
  var valid_595074 = query.getOrDefault("fields")
  valid_595074 = validateParameter(valid_595074, JString, required = false,
                                 default = nil)
  if valid_595074 != nil:
    section.add "fields", valid_595074
  var valid_595075 = query.getOrDefault("quotaUser")
  valid_595075 = validateParameter(valid_595075, JString, required = false,
                                 default = nil)
  if valid_595075 != nil:
    section.add "quotaUser", valid_595075
  var valid_595076 = query.getOrDefault("alt")
  valid_595076 = validateParameter(valid_595076, JString, required = false,
                                 default = newJString("json"))
  if valid_595076 != nil:
    section.add "alt", valid_595076
  var valid_595077 = query.getOrDefault("oauth_token")
  valid_595077 = validateParameter(valid_595077, JString, required = false,
                                 default = nil)
  if valid_595077 != nil:
    section.add "oauth_token", valid_595077
  var valid_595078 = query.getOrDefault("userIp")
  valid_595078 = validateParameter(valid_595078, JString, required = false,
                                 default = nil)
  if valid_595078 != nil:
    section.add "userIp", valid_595078
  var valid_595079 = query.getOrDefault("key")
  valid_595079 = validateParameter(valid_595079, JString, required = false,
                                 default = nil)
  if valid_595079 != nil:
    section.add "key", valid_595079
  var valid_595080 = query.getOrDefault("prettyPrint")
  valid_595080 = validateParameter(valid_595080, JBool, required = false,
                                 default = newJBool(true))
  if valid_595080 != nil:
    section.add "prettyPrint", valid_595080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595081: Call_GmailUsersThreadsUntrash_595069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified thread from the trash.
  ## 
  let valid = call_595081.validator(path, query, header, formData, body)
  let scheme = call_595081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595081.url(scheme.get, call_595081.host, call_595081.base,
                         call_595081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595081, url, valid)

proc call*(call_595082: Call_GmailUsersThreadsUntrash_595069; id: string;
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
  var path_595083 = newJObject()
  var query_595084 = newJObject()
  add(query_595084, "fields", newJString(fields))
  add(query_595084, "quotaUser", newJString(quotaUser))
  add(query_595084, "alt", newJString(alt))
  add(query_595084, "oauth_token", newJString(oauthToken))
  add(query_595084, "userIp", newJString(userIp))
  add(path_595083, "id", newJString(id))
  add(query_595084, "key", newJString(key))
  add(query_595084, "prettyPrint", newJBool(prettyPrint))
  add(path_595083, "userId", newJString(userId))
  result = call_595082.call(path_595083, query_595084, nil, nil, nil)

var gmailUsersThreadsUntrash* = Call_GmailUsersThreadsUntrash_595069(
    name: "gmailUsersThreadsUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/untrash",
    validator: validate_GmailUsersThreadsUntrash_595070, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsUntrash_595071, schemes: {Scheme.Https})
type
  Call_GmailUsersWatch_595085 = ref object of OpenApiRestCall_593424
proc url_GmailUsersWatch_595087(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GmailUsersWatch_595086(path: JsonNode; query: JsonNode;
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
  var valid_595088 = path.getOrDefault("userId")
  valid_595088 = validateParameter(valid_595088, JString, required = true,
                                 default = newJString("me"))
  if valid_595088 != nil:
    section.add "userId", valid_595088
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
  var valid_595089 = query.getOrDefault("fields")
  valid_595089 = validateParameter(valid_595089, JString, required = false,
                                 default = nil)
  if valid_595089 != nil:
    section.add "fields", valid_595089
  var valid_595090 = query.getOrDefault("quotaUser")
  valid_595090 = validateParameter(valid_595090, JString, required = false,
                                 default = nil)
  if valid_595090 != nil:
    section.add "quotaUser", valid_595090
  var valid_595091 = query.getOrDefault("alt")
  valid_595091 = validateParameter(valid_595091, JString, required = false,
                                 default = newJString("json"))
  if valid_595091 != nil:
    section.add "alt", valid_595091
  var valid_595092 = query.getOrDefault("oauth_token")
  valid_595092 = validateParameter(valid_595092, JString, required = false,
                                 default = nil)
  if valid_595092 != nil:
    section.add "oauth_token", valid_595092
  var valid_595093 = query.getOrDefault("userIp")
  valid_595093 = validateParameter(valid_595093, JString, required = false,
                                 default = nil)
  if valid_595093 != nil:
    section.add "userIp", valid_595093
  var valid_595094 = query.getOrDefault("key")
  valid_595094 = validateParameter(valid_595094, JString, required = false,
                                 default = nil)
  if valid_595094 != nil:
    section.add "key", valid_595094
  var valid_595095 = query.getOrDefault("prettyPrint")
  valid_595095 = validateParameter(valid_595095, JBool, required = false,
                                 default = newJBool(true))
  if valid_595095 != nil:
    section.add "prettyPrint", valid_595095
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

proc call*(call_595097: Call_GmailUsersWatch_595085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set up or update a push notification watch on the given user mailbox.
  ## 
  let valid = call_595097.validator(path, query, header, formData, body)
  let scheme = call_595097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595097.url(scheme.get, call_595097.host, call_595097.base,
                         call_595097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595097, url, valid)

proc call*(call_595098: Call_GmailUsersWatch_595085; fields: string = "";
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
  var path_595099 = newJObject()
  var query_595100 = newJObject()
  var body_595101 = newJObject()
  add(query_595100, "fields", newJString(fields))
  add(query_595100, "quotaUser", newJString(quotaUser))
  add(query_595100, "alt", newJString(alt))
  add(query_595100, "oauth_token", newJString(oauthToken))
  add(query_595100, "userIp", newJString(userIp))
  add(query_595100, "key", newJString(key))
  if body != nil:
    body_595101 = body
  add(query_595100, "prettyPrint", newJBool(prettyPrint))
  add(path_595099, "userId", newJString(userId))
  result = call_595098.call(path_595099, query_595100, nil, nil, body_595101)

var gmailUsersWatch* = Call_GmailUsersWatch_595085(name: "gmailUsersWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/watch",
    validator: validate_GmailUsersWatch_595086, base: "/gmail/v1/users",
    url: url_GmailUsersWatch_595087, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
