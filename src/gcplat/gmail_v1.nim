
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
  gcpServiceName = "gmail"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GmailUsersDraftsCreate_589014 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsCreate_589016(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsCreate_589015(path: JsonNode; query: JsonNode;
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
  var valid_589017 = path.getOrDefault("userId")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = newJString("me"))
  if valid_589017 != nil:
    section.add "userId", valid_589017
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
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("userIp")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "userIp", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_GmailUsersDraftsCreate_589014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new draft with the DRAFT label.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_GmailUsersDraftsCreate_589014; fields: string = "";
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "userIp", newJString(userIp))
  add(query_589029, "key", newJString(key))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  add(path_589028, "userId", newJString(userId))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var gmailUsersDraftsCreate* = Call_GmailUsersDraftsCreate_589014(
    name: "gmailUsersDraftsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsCreate_589015, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsCreate_589016, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsList_588725 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsList_588727(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsList_588726(path: JsonNode; query: JsonNode;
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
  var valid_588866 = path.getOrDefault("userId")
  valid_588866 = validateParameter(valid_588866, JString, required = true,
                                 default = newJString("me"))
  if valid_588866 != nil:
    section.add "userId", valid_588866
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
  var valid_588867 = query.getOrDefault("fields")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "fields", valid_588867
  var valid_588868 = query.getOrDefault("pageToken")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "pageToken", valid_588868
  var valid_588869 = query.getOrDefault("quotaUser")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "quotaUser", valid_588869
  var valid_588870 = query.getOrDefault("alt")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("json"))
  if valid_588870 != nil:
    section.add "alt", valid_588870
  var valid_588871 = query.getOrDefault("oauth_token")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "oauth_token", valid_588871
  var valid_588872 = query.getOrDefault("userIp")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "userIp", valid_588872
  var valid_588874 = query.getOrDefault("maxResults")
  valid_588874 = validateParameter(valid_588874, JInt, required = false,
                                 default = newJInt(100))
  if valid_588874 != nil:
    section.add "maxResults", valid_588874
  var valid_588875 = query.getOrDefault("includeSpamTrash")
  valid_588875 = validateParameter(valid_588875, JBool, required = false,
                                 default = newJBool(false))
  if valid_588875 != nil:
    section.add "includeSpamTrash", valid_588875
  var valid_588876 = query.getOrDefault("q")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "q", valid_588876
  var valid_588877 = query.getOrDefault("key")
  valid_588877 = validateParameter(valid_588877, JString, required = false,
                                 default = nil)
  if valid_588877 != nil:
    section.add "key", valid_588877
  var valid_588878 = query.getOrDefault("prettyPrint")
  valid_588878 = validateParameter(valid_588878, JBool, required = false,
                                 default = newJBool(true))
  if valid_588878 != nil:
    section.add "prettyPrint", valid_588878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588901: Call_GmailUsersDraftsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the drafts in the user's mailbox.
  ## 
  let valid = call_588901.validator(path, query, header, formData, body)
  let scheme = call_588901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588901.url(scheme.get, call_588901.host, call_588901.base,
                         call_588901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588901, url, valid)

proc call*(call_588972: Call_GmailUsersDraftsList_588725; fields: string = "";
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
  var path_588973 = newJObject()
  var query_588975 = newJObject()
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "pageToken", newJString(pageToken))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "maxResults", newJInt(maxResults))
  add(query_588975, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_588975, "q", newJString(q))
  add(query_588975, "key", newJString(key))
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(path_588973, "userId", newJString(userId))
  result = call_588972.call(path_588973, query_588975, nil, nil, nil)

var gmailUsersDraftsList* = Call_GmailUsersDraftsList_588725(
    name: "gmailUsersDraftsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsList_588726, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsList_588727, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsSend_589031 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsSend_589033(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsSend_589032(path: JsonNode; query: JsonNode;
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
  var valid_589034 = path.getOrDefault("userId")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = newJString("me"))
  if valid_589034 != nil:
    section.add "userId", valid_589034
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
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

proc call*(call_589043: Call_GmailUsersDraftsSend_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_GmailUsersDraftsSend_589031; fields: string = "";
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "userIp", newJString(userIp))
  add(query_589046, "key", newJString(key))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(path_589045, "userId", newJString(userId))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var gmailUsersDraftsSend* = Call_GmailUsersDraftsSend_589031(
    name: "gmailUsersDraftsSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts/send",
    validator: validate_GmailUsersDraftsSend_589032, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsSend_589033, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsUpdate_589065 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsUpdate_589067(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsUpdate_589066(path: JsonNode; query: JsonNode;
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
  var valid_589068 = path.getOrDefault("id")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "id", valid_589068
  var valid_589069 = path.getOrDefault("userId")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = newJString("me"))
  if valid_589069 != nil:
    section.add "userId", valid_589069
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
  var valid_589070 = query.getOrDefault("fields")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "fields", valid_589070
  var valid_589071 = query.getOrDefault("quotaUser")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "quotaUser", valid_589071
  var valid_589072 = query.getOrDefault("alt")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("json"))
  if valid_589072 != nil:
    section.add "alt", valid_589072
  var valid_589073 = query.getOrDefault("oauth_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "oauth_token", valid_589073
  var valid_589074 = query.getOrDefault("userIp")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "userIp", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
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

proc call*(call_589078: Call_GmailUsersDraftsUpdate_589065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces a draft's content.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_GmailUsersDraftsUpdate_589065; id: string;
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  var body_589082 = newJObject()
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "userIp", newJString(userIp))
  add(path_589080, "id", newJString(id))
  add(query_589081, "key", newJString(key))
  if body != nil:
    body_589082 = body
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  add(path_589080, "userId", newJString(userId))
  result = call_589079.call(path_589080, query_589081, nil, nil, body_589082)

var gmailUsersDraftsUpdate* = Call_GmailUsersDraftsUpdate_589065(
    name: "gmailUsersDraftsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsUpdate_589066, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsUpdate_589067, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsGet_589048 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsGet_589050(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsGet_589049(path: JsonNode; query: JsonNode;
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
  var valid_589051 = path.getOrDefault("id")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "id", valid_589051
  var valid_589052 = path.getOrDefault("userId")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = newJString("me"))
  if valid_589052 != nil:
    section.add "userId", valid_589052
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
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("userIp")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "userIp", valid_589057
  var valid_589058 = query.getOrDefault("key")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "key", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
  var valid_589060 = query.getOrDefault("format")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("full"))
  if valid_589060 != nil:
    section.add "format", valid_589060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589061: Call_GmailUsersDraftsGet_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified draft.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_GmailUsersDraftsGet_589048; id: string;
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
  var path_589063 = newJObject()
  var query_589064 = newJObject()
  add(query_589064, "fields", newJString(fields))
  add(query_589064, "quotaUser", newJString(quotaUser))
  add(query_589064, "alt", newJString(alt))
  add(query_589064, "oauth_token", newJString(oauthToken))
  add(query_589064, "userIp", newJString(userIp))
  add(path_589063, "id", newJString(id))
  add(query_589064, "key", newJString(key))
  add(query_589064, "prettyPrint", newJBool(prettyPrint))
  add(query_589064, "format", newJString(format))
  add(path_589063, "userId", newJString(userId))
  result = call_589062.call(path_589063, query_589064, nil, nil, nil)

var gmailUsersDraftsGet* = Call_GmailUsersDraftsGet_589048(
    name: "gmailUsersDraftsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsGet_589049, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsGet_589050, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsDelete_589083 = ref object of OpenApiRestCall_588457
proc url_GmailUsersDraftsDelete_589085(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsDelete_589084(path: JsonNode; query: JsonNode;
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
  var valid_589086 = path.getOrDefault("id")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "id", valid_589086
  var valid_589087 = path.getOrDefault("userId")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = newJString("me"))
  if valid_589087 != nil:
    section.add "userId", valid_589087
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
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("userIp")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "userIp", valid_589092
  var valid_589093 = query.getOrDefault("key")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "key", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589095: Call_GmailUsersDraftsDelete_589083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_GmailUsersDraftsDelete_589083; id: string;
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
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "userIp", newJString(userIp))
  add(path_589097, "id", newJString(id))
  add(query_589098, "key", newJString(key))
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  add(path_589097, "userId", newJString(userId))
  result = call_589096.call(path_589097, query_589098, nil, nil, nil)

var gmailUsersDraftsDelete* = Call_GmailUsersDraftsDelete_589083(
    name: "gmailUsersDraftsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsDelete_589084, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsDelete_589085, schemes: {Scheme.Https})
type
  Call_GmailUsersHistoryList_589099 = ref object of OpenApiRestCall_588457
proc url_GmailUsersHistoryList_589101(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersHistoryList_589100(path: JsonNode; query: JsonNode;
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
  var valid_589102 = path.getOrDefault("userId")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = newJString("me"))
  if valid_589102 != nil:
    section.add "userId", valid_589102
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
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("pageToken")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "pageToken", valid_589104
  var valid_589105 = query.getOrDefault("quotaUser")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "quotaUser", valid_589105
  var valid_589106 = query.getOrDefault("alt")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("json"))
  if valid_589106 != nil:
    section.add "alt", valid_589106
  var valid_589107 = query.getOrDefault("labelId")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "labelId", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("userIp")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "userIp", valid_589109
  var valid_589110 = query.getOrDefault("historyTypes")
  valid_589110 = validateParameter(valid_589110, JArray, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "historyTypes", valid_589110
  var valid_589111 = query.getOrDefault("startHistoryId")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "startHistoryId", valid_589111
  var valid_589112 = query.getOrDefault("maxResults")
  valid_589112 = validateParameter(valid_589112, JInt, required = false,
                                 default = newJInt(100))
  if valid_589112 != nil:
    section.add "maxResults", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589115: Call_GmailUsersHistoryList_589099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ## 
  let valid = call_589115.validator(path, query, header, formData, body)
  let scheme = call_589115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589115.url(scheme.get, call_589115.host, call_589115.base,
                         call_589115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589115, url, valid)

proc call*(call_589116: Call_GmailUsersHistoryList_589099; fields: string = "";
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
  var path_589117 = newJObject()
  var query_589118 = newJObject()
  add(query_589118, "fields", newJString(fields))
  add(query_589118, "pageToken", newJString(pageToken))
  add(query_589118, "quotaUser", newJString(quotaUser))
  add(query_589118, "alt", newJString(alt))
  add(query_589118, "labelId", newJString(labelId))
  add(query_589118, "oauth_token", newJString(oauthToken))
  add(query_589118, "userIp", newJString(userIp))
  if historyTypes != nil:
    query_589118.add "historyTypes", historyTypes
  add(query_589118, "startHistoryId", newJString(startHistoryId))
  add(query_589118, "maxResults", newJInt(maxResults))
  add(query_589118, "key", newJString(key))
  add(query_589118, "prettyPrint", newJBool(prettyPrint))
  add(path_589117, "userId", newJString(userId))
  result = call_589116.call(path_589117, query_589118, nil, nil, nil)

var gmailUsersHistoryList* = Call_GmailUsersHistoryList_589099(
    name: "gmailUsersHistoryList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/history",
    validator: validate_GmailUsersHistoryList_589100, base: "/gmail/v1/users",
    url: url_GmailUsersHistoryList_589101, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsCreate_589134 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsCreate_589136(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsCreate_589135(path: JsonNode; query: JsonNode;
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
  var valid_589137 = path.getOrDefault("userId")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = newJString("me"))
  if valid_589137 != nil:
    section.add "userId", valid_589137
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
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("userIp")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "userIp", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
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

proc call*(call_589146: Call_GmailUsersLabelsCreate_589134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new label.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_GmailUsersLabelsCreate_589134; fields: string = "";
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
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  var body_589150 = newJObject()
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "userIp", newJString(userIp))
  add(query_589149, "key", newJString(key))
  if body != nil:
    body_589150 = body
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  add(path_589148, "userId", newJString(userId))
  result = call_589147.call(path_589148, query_589149, nil, nil, body_589150)

var gmailUsersLabelsCreate* = Call_GmailUsersLabelsCreate_589134(
    name: "gmailUsersLabelsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsCreate_589135, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsCreate_589136, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsList_589119 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsList_589121(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsList_589120(path: JsonNode; query: JsonNode;
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
  var valid_589122 = path.getOrDefault("userId")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = newJString("me"))
  if valid_589122 != nil:
    section.add "userId", valid_589122
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
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("quotaUser")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "quotaUser", valid_589124
  var valid_589125 = query.getOrDefault("alt")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("json"))
  if valid_589125 != nil:
    section.add "alt", valid_589125
  var valid_589126 = query.getOrDefault("oauth_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "oauth_token", valid_589126
  var valid_589127 = query.getOrDefault("userIp")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "userIp", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589130: Call_GmailUsersLabelsList_589119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all labels in the user's mailbox.
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_GmailUsersLabelsList_589119; fields: string = "";
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
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "userIp", newJString(userIp))
  add(query_589133, "key", newJString(key))
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  add(path_589132, "userId", newJString(userId))
  result = call_589131.call(path_589132, query_589133, nil, nil, nil)

var gmailUsersLabelsList* = Call_GmailUsersLabelsList_589119(
    name: "gmailUsersLabelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsList_589120, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsList_589121, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsUpdate_589167 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsUpdate_589169(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsUpdate_589168(path: JsonNode; query: JsonNode;
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
  var valid_589170 = path.getOrDefault("id")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "id", valid_589170
  var valid_589171 = path.getOrDefault("userId")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = newJString("me"))
  if valid_589171 != nil:
    section.add "userId", valid_589171
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
  var valid_589172 = query.getOrDefault("fields")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "fields", valid_589172
  var valid_589173 = query.getOrDefault("quotaUser")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "quotaUser", valid_589173
  var valid_589174 = query.getOrDefault("alt")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("json"))
  if valid_589174 != nil:
    section.add "alt", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("userIp")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "userIp", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("prettyPrint")
  valid_589178 = validateParameter(valid_589178, JBool, required = false,
                                 default = newJBool(true))
  if valid_589178 != nil:
    section.add "prettyPrint", valid_589178
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

proc call*(call_589180: Call_GmailUsersLabelsUpdate_589167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label.
  ## 
  let valid = call_589180.validator(path, query, header, formData, body)
  let scheme = call_589180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589180.url(scheme.get, call_589180.host, call_589180.base,
                         call_589180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589180, url, valid)

proc call*(call_589181: Call_GmailUsersLabelsUpdate_589167; id: string;
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
  var path_589182 = newJObject()
  var query_589183 = newJObject()
  var body_589184 = newJObject()
  add(query_589183, "fields", newJString(fields))
  add(query_589183, "quotaUser", newJString(quotaUser))
  add(query_589183, "alt", newJString(alt))
  add(query_589183, "oauth_token", newJString(oauthToken))
  add(query_589183, "userIp", newJString(userIp))
  add(path_589182, "id", newJString(id))
  add(query_589183, "key", newJString(key))
  if body != nil:
    body_589184 = body
  add(query_589183, "prettyPrint", newJBool(prettyPrint))
  add(path_589182, "userId", newJString(userId))
  result = call_589181.call(path_589182, query_589183, nil, nil, body_589184)

var gmailUsersLabelsUpdate* = Call_GmailUsersLabelsUpdate_589167(
    name: "gmailUsersLabelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsUpdate_589168, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsUpdate_589169, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsGet_589151 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsGet_589153(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsGet_589152(path: JsonNode; query: JsonNode;
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
  var valid_589154 = path.getOrDefault("id")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "id", valid_589154
  var valid_589155 = path.getOrDefault("userId")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = newJString("me"))
  if valid_589155 != nil:
    section.add "userId", valid_589155
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
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("oauth_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "oauth_token", valid_589159
  var valid_589160 = query.getOrDefault("userIp")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "userIp", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("prettyPrint")
  valid_589162 = validateParameter(valid_589162, JBool, required = false,
                                 default = newJBool(true))
  if valid_589162 != nil:
    section.add "prettyPrint", valid_589162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589163: Call_GmailUsersLabelsGet_589151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified label.
  ## 
  let valid = call_589163.validator(path, query, header, formData, body)
  let scheme = call_589163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589163.url(scheme.get, call_589163.host, call_589163.base,
                         call_589163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589163, url, valid)

proc call*(call_589164: Call_GmailUsersLabelsGet_589151; id: string;
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
  var path_589165 = newJObject()
  var query_589166 = newJObject()
  add(query_589166, "fields", newJString(fields))
  add(query_589166, "quotaUser", newJString(quotaUser))
  add(query_589166, "alt", newJString(alt))
  add(query_589166, "oauth_token", newJString(oauthToken))
  add(query_589166, "userIp", newJString(userIp))
  add(path_589165, "id", newJString(id))
  add(query_589166, "key", newJString(key))
  add(query_589166, "prettyPrint", newJBool(prettyPrint))
  add(path_589165, "userId", newJString(userId))
  result = call_589164.call(path_589165, query_589166, nil, nil, nil)

var gmailUsersLabelsGet* = Call_GmailUsersLabelsGet_589151(
    name: "gmailUsersLabelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsGet_589152, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsGet_589153, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsPatch_589201 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsPatch_589203(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsPatch_589202(path: JsonNode; query: JsonNode;
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
  var valid_589204 = path.getOrDefault("id")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "id", valid_589204
  var valid_589205 = path.getOrDefault("userId")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = newJString("me"))
  if valid_589205 != nil:
    section.add "userId", valid_589205
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
  var valid_589206 = query.getOrDefault("fields")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fields", valid_589206
  var valid_589207 = query.getOrDefault("quotaUser")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "quotaUser", valid_589207
  var valid_589208 = query.getOrDefault("alt")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("json"))
  if valid_589208 != nil:
    section.add "alt", valid_589208
  var valid_589209 = query.getOrDefault("oauth_token")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "oauth_token", valid_589209
  var valid_589210 = query.getOrDefault("userIp")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "userIp", valid_589210
  var valid_589211 = query.getOrDefault("key")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "key", valid_589211
  var valid_589212 = query.getOrDefault("prettyPrint")
  valid_589212 = validateParameter(valid_589212, JBool, required = false,
                                 default = newJBool(true))
  if valid_589212 != nil:
    section.add "prettyPrint", valid_589212
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

proc call*(call_589214: Call_GmailUsersLabelsPatch_589201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label. This method supports patch semantics.
  ## 
  let valid = call_589214.validator(path, query, header, formData, body)
  let scheme = call_589214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589214.url(scheme.get, call_589214.host, call_589214.base,
                         call_589214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589214, url, valid)

proc call*(call_589215: Call_GmailUsersLabelsPatch_589201; id: string;
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
  var path_589216 = newJObject()
  var query_589217 = newJObject()
  var body_589218 = newJObject()
  add(query_589217, "fields", newJString(fields))
  add(query_589217, "quotaUser", newJString(quotaUser))
  add(query_589217, "alt", newJString(alt))
  add(query_589217, "oauth_token", newJString(oauthToken))
  add(query_589217, "userIp", newJString(userIp))
  add(path_589216, "id", newJString(id))
  add(query_589217, "key", newJString(key))
  if body != nil:
    body_589218 = body
  add(query_589217, "prettyPrint", newJBool(prettyPrint))
  add(path_589216, "userId", newJString(userId))
  result = call_589215.call(path_589216, query_589217, nil, nil, body_589218)

var gmailUsersLabelsPatch* = Call_GmailUsersLabelsPatch_589201(
    name: "gmailUsersLabelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsPatch_589202, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsPatch_589203, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsDelete_589185 = ref object of OpenApiRestCall_588457
proc url_GmailUsersLabelsDelete_589187(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsDelete_589186(path: JsonNode; query: JsonNode;
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
  var valid_589188 = path.getOrDefault("id")
  valid_589188 = validateParameter(valid_589188, JString, required = true,
                                 default = nil)
  if valid_589188 != nil:
    section.add "id", valid_589188
  var valid_589189 = path.getOrDefault("userId")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = newJString("me"))
  if valid_589189 != nil:
    section.add "userId", valid_589189
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
  var valid_589190 = query.getOrDefault("fields")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "fields", valid_589190
  var valid_589191 = query.getOrDefault("quotaUser")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "quotaUser", valid_589191
  var valid_589192 = query.getOrDefault("alt")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("json"))
  if valid_589192 != nil:
    section.add "alt", valid_589192
  var valid_589193 = query.getOrDefault("oauth_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "oauth_token", valid_589193
  var valid_589194 = query.getOrDefault("userIp")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "userIp", valid_589194
  var valid_589195 = query.getOrDefault("key")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "key", valid_589195
  var valid_589196 = query.getOrDefault("prettyPrint")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(true))
  if valid_589196 != nil:
    section.add "prettyPrint", valid_589196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589197: Call_GmailUsersLabelsDelete_589185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ## 
  let valid = call_589197.validator(path, query, header, formData, body)
  let scheme = call_589197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589197.url(scheme.get, call_589197.host, call_589197.base,
                         call_589197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589197, url, valid)

proc call*(call_589198: Call_GmailUsersLabelsDelete_589185; id: string;
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
  var path_589199 = newJObject()
  var query_589200 = newJObject()
  add(query_589200, "fields", newJString(fields))
  add(query_589200, "quotaUser", newJString(quotaUser))
  add(query_589200, "alt", newJString(alt))
  add(query_589200, "oauth_token", newJString(oauthToken))
  add(query_589200, "userIp", newJString(userIp))
  add(path_589199, "id", newJString(id))
  add(query_589200, "key", newJString(key))
  add(query_589200, "prettyPrint", newJBool(prettyPrint))
  add(path_589199, "userId", newJString(userId))
  result = call_589198.call(path_589199, query_589200, nil, nil, nil)

var gmailUsersLabelsDelete* = Call_GmailUsersLabelsDelete_589185(
    name: "gmailUsersLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsDelete_589186, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsDelete_589187, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesInsert_589239 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesInsert_589241(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesInsert_589240(path: JsonNode; query: JsonNode;
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
  var valid_589242 = path.getOrDefault("userId")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = newJString("me"))
  if valid_589242 != nil:
    section.add "userId", valid_589242
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
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("internalDateSource")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("receivedTime"))
  if valid_589244 != nil:
    section.add "internalDateSource", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("alt")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("json"))
  if valid_589246 != nil:
    section.add "alt", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("userIp")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "userIp", valid_589248
  var valid_589249 = query.getOrDefault("key")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "key", valid_589249
  var valid_589250 = query.getOrDefault("prettyPrint")
  valid_589250 = validateParameter(valid_589250, JBool, required = false,
                                 default = newJBool(true))
  if valid_589250 != nil:
    section.add "prettyPrint", valid_589250
  var valid_589251 = query.getOrDefault("deleted")
  valid_589251 = validateParameter(valid_589251, JBool, required = false,
                                 default = newJBool(false))
  if valid_589251 != nil:
    section.add "deleted", valid_589251
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

proc call*(call_589253: Call_GmailUsersMessagesInsert_589239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ## 
  let valid = call_589253.validator(path, query, header, formData, body)
  let scheme = call_589253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589253.url(scheme.get, call_589253.host, call_589253.base,
                         call_589253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589253, url, valid)

proc call*(call_589254: Call_GmailUsersMessagesInsert_589239; fields: string = "";
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
  var path_589255 = newJObject()
  var query_589256 = newJObject()
  var body_589257 = newJObject()
  add(query_589256, "fields", newJString(fields))
  add(query_589256, "internalDateSource", newJString(internalDateSource))
  add(query_589256, "quotaUser", newJString(quotaUser))
  add(query_589256, "alt", newJString(alt))
  add(query_589256, "oauth_token", newJString(oauthToken))
  add(query_589256, "userIp", newJString(userIp))
  add(query_589256, "key", newJString(key))
  if body != nil:
    body_589257 = body
  add(query_589256, "prettyPrint", newJBool(prettyPrint))
  add(query_589256, "deleted", newJBool(deleted))
  add(path_589255, "userId", newJString(userId))
  result = call_589254.call(path_589255, query_589256, nil, nil, body_589257)

var gmailUsersMessagesInsert* = Call_GmailUsersMessagesInsert_589239(
    name: "gmailUsersMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesInsert_589240, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesInsert_589241, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesList_589219 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesList_589221(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesList_589220(path: JsonNode; query: JsonNode;
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
  var valid_589222 = path.getOrDefault("userId")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = newJString("me"))
  if valid_589222 != nil:
    section.add "userId", valid_589222
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
  var valid_589223 = query.getOrDefault("fields")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "fields", valid_589223
  var valid_589224 = query.getOrDefault("pageToken")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "pageToken", valid_589224
  var valid_589225 = query.getOrDefault("quotaUser")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "quotaUser", valid_589225
  var valid_589226 = query.getOrDefault("alt")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = newJString("json"))
  if valid_589226 != nil:
    section.add "alt", valid_589226
  var valid_589227 = query.getOrDefault("oauth_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "oauth_token", valid_589227
  var valid_589228 = query.getOrDefault("userIp")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "userIp", valid_589228
  var valid_589229 = query.getOrDefault("maxResults")
  valid_589229 = validateParameter(valid_589229, JInt, required = false,
                                 default = newJInt(100))
  if valid_589229 != nil:
    section.add "maxResults", valid_589229
  var valid_589230 = query.getOrDefault("includeSpamTrash")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(false))
  if valid_589230 != nil:
    section.add "includeSpamTrash", valid_589230
  var valid_589231 = query.getOrDefault("q")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "q", valid_589231
  var valid_589232 = query.getOrDefault("labelIds")
  valid_589232 = validateParameter(valid_589232, JArray, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "labelIds", valid_589232
  var valid_589233 = query.getOrDefault("key")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "key", valid_589233
  var valid_589234 = query.getOrDefault("prettyPrint")
  valid_589234 = validateParameter(valid_589234, JBool, required = false,
                                 default = newJBool(true))
  if valid_589234 != nil:
    section.add "prettyPrint", valid_589234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589235: Call_GmailUsersMessagesList_589219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the messages in the user's mailbox.
  ## 
  let valid = call_589235.validator(path, query, header, formData, body)
  let scheme = call_589235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589235.url(scheme.get, call_589235.host, call_589235.base,
                         call_589235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589235, url, valid)

proc call*(call_589236: Call_GmailUsersMessagesList_589219; fields: string = "";
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
  var path_589237 = newJObject()
  var query_589238 = newJObject()
  add(query_589238, "fields", newJString(fields))
  add(query_589238, "pageToken", newJString(pageToken))
  add(query_589238, "quotaUser", newJString(quotaUser))
  add(query_589238, "alt", newJString(alt))
  add(query_589238, "oauth_token", newJString(oauthToken))
  add(query_589238, "userIp", newJString(userIp))
  add(query_589238, "maxResults", newJInt(maxResults))
  add(query_589238, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_589238, "q", newJString(q))
  if labelIds != nil:
    query_589238.add "labelIds", labelIds
  add(query_589238, "key", newJString(key))
  add(query_589238, "prettyPrint", newJBool(prettyPrint))
  add(path_589237, "userId", newJString(userId))
  result = call_589236.call(path_589237, query_589238, nil, nil, nil)

var gmailUsersMessagesList* = Call_GmailUsersMessagesList_589219(
    name: "gmailUsersMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesList_589220, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesList_589221, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchDelete_589258 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesBatchDelete_589260(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesBatchDelete_589259(path: JsonNode; query: JsonNode;
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
  var valid_589261 = path.getOrDefault("userId")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = newJString("me"))
  if valid_589261 != nil:
    section.add "userId", valid_589261
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
  var valid_589262 = query.getOrDefault("fields")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "fields", valid_589262
  var valid_589263 = query.getOrDefault("quotaUser")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "quotaUser", valid_589263
  var valid_589264 = query.getOrDefault("alt")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = newJString("json"))
  if valid_589264 != nil:
    section.add "alt", valid_589264
  var valid_589265 = query.getOrDefault("oauth_token")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "oauth_token", valid_589265
  var valid_589266 = query.getOrDefault("userIp")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "userIp", valid_589266
  var valid_589267 = query.getOrDefault("key")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "key", valid_589267
  var valid_589268 = query.getOrDefault("prettyPrint")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "prettyPrint", valid_589268
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

proc call*(call_589270: Call_GmailUsersMessagesBatchDelete_589258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
  ## 
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_GmailUsersMessagesBatchDelete_589258;
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
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  var body_589274 = newJObject()
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "userIp", newJString(userIp))
  add(query_589273, "key", newJString(key))
  if body != nil:
    body_589274 = body
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  add(path_589272, "userId", newJString(userId))
  result = call_589271.call(path_589272, query_589273, nil, nil, body_589274)

var gmailUsersMessagesBatchDelete* = Call_GmailUsersMessagesBatchDelete_589258(
    name: "gmailUsersMessagesBatchDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchDelete",
    validator: validate_GmailUsersMessagesBatchDelete_589259,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchDelete_589260,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchModify_589275 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesBatchModify_589277(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesBatchModify_589276(path: JsonNode; query: JsonNode;
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
  var valid_589278 = path.getOrDefault("userId")
  valid_589278 = validateParameter(valid_589278, JString, required = true,
                                 default = newJString("me"))
  if valid_589278 != nil:
    section.add "userId", valid_589278
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
  var valid_589279 = query.getOrDefault("fields")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "fields", valid_589279
  var valid_589280 = query.getOrDefault("quotaUser")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "quotaUser", valid_589280
  var valid_589281 = query.getOrDefault("alt")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("json"))
  if valid_589281 != nil:
    section.add "alt", valid_589281
  var valid_589282 = query.getOrDefault("oauth_token")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "oauth_token", valid_589282
  var valid_589283 = query.getOrDefault("userIp")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "userIp", valid_589283
  var valid_589284 = query.getOrDefault("key")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "key", valid_589284
  var valid_589285 = query.getOrDefault("prettyPrint")
  valid_589285 = validateParameter(valid_589285, JBool, required = false,
                                 default = newJBool(true))
  if valid_589285 != nil:
    section.add "prettyPrint", valid_589285
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

proc call*(call_589287: Call_GmailUsersMessagesBatchModify_589275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified messages.
  ## 
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_GmailUsersMessagesBatchModify_589275;
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
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  var body_589291 = newJObject()
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "userIp", newJString(userIp))
  add(query_589290, "key", newJString(key))
  if body != nil:
    body_589291 = body
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  add(path_589289, "userId", newJString(userId))
  result = call_589288.call(path_589289, query_589290, nil, nil, body_589291)

var gmailUsersMessagesBatchModify* = Call_GmailUsersMessagesBatchModify_589275(
    name: "gmailUsersMessagesBatchModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchModify",
    validator: validate_GmailUsersMessagesBatchModify_589276,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchModify_589277,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesImport_589292 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesImport_589294(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesImport_589293(path: JsonNode; query: JsonNode;
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
  var valid_589295 = path.getOrDefault("userId")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = newJString("me"))
  if valid_589295 != nil:
    section.add "userId", valid_589295
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
  var valid_589296 = query.getOrDefault("fields")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "fields", valid_589296
  var valid_589297 = query.getOrDefault("internalDateSource")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("dateHeader"))
  if valid_589297 != nil:
    section.add "internalDateSource", valid_589297
  var valid_589298 = query.getOrDefault("quotaUser")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "quotaUser", valid_589298
  var valid_589299 = query.getOrDefault("alt")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = newJString("json"))
  if valid_589299 != nil:
    section.add "alt", valid_589299
  var valid_589300 = query.getOrDefault("oauth_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "oauth_token", valid_589300
  var valid_589301 = query.getOrDefault("userIp")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "userIp", valid_589301
  var valid_589302 = query.getOrDefault("neverMarkSpam")
  valid_589302 = validateParameter(valid_589302, JBool, required = false,
                                 default = newJBool(false))
  if valid_589302 != nil:
    section.add "neverMarkSpam", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("processForCalendar")
  valid_589304 = validateParameter(valid_589304, JBool, required = false,
                                 default = newJBool(false))
  if valid_589304 != nil:
    section.add "processForCalendar", valid_589304
  var valid_589305 = query.getOrDefault("prettyPrint")
  valid_589305 = validateParameter(valid_589305, JBool, required = false,
                                 default = newJBool(true))
  if valid_589305 != nil:
    section.add "prettyPrint", valid_589305
  var valid_589306 = query.getOrDefault("deleted")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(false))
  if valid_589306 != nil:
    section.add "deleted", valid_589306
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

proc call*(call_589308: Call_GmailUsersMessagesImport_589292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ## 
  let valid = call_589308.validator(path, query, header, formData, body)
  let scheme = call_589308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589308.url(scheme.get, call_589308.host, call_589308.base,
                         call_589308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589308, url, valid)

proc call*(call_589309: Call_GmailUsersMessagesImport_589292; fields: string = "";
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
  var path_589310 = newJObject()
  var query_589311 = newJObject()
  var body_589312 = newJObject()
  add(query_589311, "fields", newJString(fields))
  add(query_589311, "internalDateSource", newJString(internalDateSource))
  add(query_589311, "quotaUser", newJString(quotaUser))
  add(query_589311, "alt", newJString(alt))
  add(query_589311, "oauth_token", newJString(oauthToken))
  add(query_589311, "userIp", newJString(userIp))
  add(query_589311, "neverMarkSpam", newJBool(neverMarkSpam))
  add(query_589311, "key", newJString(key))
  add(query_589311, "processForCalendar", newJBool(processForCalendar))
  if body != nil:
    body_589312 = body
  add(query_589311, "prettyPrint", newJBool(prettyPrint))
  add(query_589311, "deleted", newJBool(deleted))
  add(path_589310, "userId", newJString(userId))
  result = call_589309.call(path_589310, query_589311, nil, nil, body_589312)

var gmailUsersMessagesImport* = Call_GmailUsersMessagesImport_589292(
    name: "gmailUsersMessagesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/import",
    validator: validate_GmailUsersMessagesImport_589293, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesImport_589294, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesSend_589313 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesSend_589315(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesSend_589314(path: JsonNode; query: JsonNode;
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
  var valid_589316 = path.getOrDefault("userId")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = newJString("me"))
  if valid_589316 != nil:
    section.add "userId", valid_589316
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
  var valid_589317 = query.getOrDefault("fields")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "fields", valid_589317
  var valid_589318 = query.getOrDefault("quotaUser")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "quotaUser", valid_589318
  var valid_589319 = query.getOrDefault("alt")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("json"))
  if valid_589319 != nil:
    section.add "alt", valid_589319
  var valid_589320 = query.getOrDefault("oauth_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "oauth_token", valid_589320
  var valid_589321 = query.getOrDefault("userIp")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "userIp", valid_589321
  var valid_589322 = query.getOrDefault("key")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "key", valid_589322
  var valid_589323 = query.getOrDefault("prettyPrint")
  valid_589323 = validateParameter(valid_589323, JBool, required = false,
                                 default = newJBool(true))
  if valid_589323 != nil:
    section.add "prettyPrint", valid_589323
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

proc call*(call_589325: Call_GmailUsersMessagesSend_589313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_589325.validator(path, query, header, formData, body)
  let scheme = call_589325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589325.url(scheme.get, call_589325.host, call_589325.base,
                         call_589325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589325, url, valid)

proc call*(call_589326: Call_GmailUsersMessagesSend_589313; fields: string = "";
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
  var path_589327 = newJObject()
  var query_589328 = newJObject()
  var body_589329 = newJObject()
  add(query_589328, "fields", newJString(fields))
  add(query_589328, "quotaUser", newJString(quotaUser))
  add(query_589328, "alt", newJString(alt))
  add(query_589328, "oauth_token", newJString(oauthToken))
  add(query_589328, "userIp", newJString(userIp))
  add(query_589328, "key", newJString(key))
  if body != nil:
    body_589329 = body
  add(query_589328, "prettyPrint", newJBool(prettyPrint))
  add(path_589327, "userId", newJString(userId))
  result = call_589326.call(path_589327, query_589328, nil, nil, body_589329)

var gmailUsersMessagesSend* = Call_GmailUsersMessagesSend_589313(
    name: "gmailUsersMessagesSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/send",
    validator: validate_GmailUsersMessagesSend_589314, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesSend_589315, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesGet_589330 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesGet_589332(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesGet_589331(path: JsonNode; query: JsonNode;
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
  var valid_589333 = path.getOrDefault("id")
  valid_589333 = validateParameter(valid_589333, JString, required = true,
                                 default = nil)
  if valid_589333 != nil:
    section.add "id", valid_589333
  var valid_589334 = path.getOrDefault("userId")
  valid_589334 = validateParameter(valid_589334, JString, required = true,
                                 default = newJString("me"))
  if valid_589334 != nil:
    section.add "userId", valid_589334
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
  var valid_589335 = query.getOrDefault("fields")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "fields", valid_589335
  var valid_589336 = query.getOrDefault("quotaUser")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "quotaUser", valid_589336
  var valid_589337 = query.getOrDefault("alt")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = newJString("json"))
  if valid_589337 != nil:
    section.add "alt", valid_589337
  var valid_589338 = query.getOrDefault("oauth_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "oauth_token", valid_589338
  var valid_589339 = query.getOrDefault("userIp")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "userIp", valid_589339
  var valid_589340 = query.getOrDefault("metadataHeaders")
  valid_589340 = validateParameter(valid_589340, JArray, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "metadataHeaders", valid_589340
  var valid_589341 = query.getOrDefault("key")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "key", valid_589341
  var valid_589342 = query.getOrDefault("prettyPrint")
  valid_589342 = validateParameter(valid_589342, JBool, required = false,
                                 default = newJBool(true))
  if valid_589342 != nil:
    section.add "prettyPrint", valid_589342
  var valid_589343 = query.getOrDefault("format")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("full"))
  if valid_589343 != nil:
    section.add "format", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_GmailUsersMessagesGet_589330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified message.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_GmailUsersMessagesGet_589330; id: string;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(query_589347, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_589347.add "metadataHeaders", metadataHeaders
  add(path_589346, "id", newJString(id))
  add(query_589347, "key", newJString(key))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  add(query_589347, "format", newJString(format))
  add(path_589346, "userId", newJString(userId))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var gmailUsersMessagesGet* = Call_GmailUsersMessagesGet_589330(
    name: "gmailUsersMessagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesGet_589331, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesGet_589332, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesDelete_589348 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesDelete_589350(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesDelete_589349(path: JsonNode; query: JsonNode;
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
  var valid_589351 = path.getOrDefault("id")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "id", valid_589351
  var valid_589352 = path.getOrDefault("userId")
  valid_589352 = validateParameter(valid_589352, JString, required = true,
                                 default = newJString("me"))
  if valid_589352 != nil:
    section.add "userId", valid_589352
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
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("userIp")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "userIp", valid_589357
  var valid_589358 = query.getOrDefault("key")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "key", valid_589358
  var valid_589359 = query.getOrDefault("prettyPrint")
  valid_589359 = validateParameter(valid_589359, JBool, required = false,
                                 default = newJBool(true))
  if valid_589359 != nil:
    section.add "prettyPrint", valid_589359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589360: Call_GmailUsersMessagesDelete_589348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ## 
  let valid = call_589360.validator(path, query, header, formData, body)
  let scheme = call_589360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589360.url(scheme.get, call_589360.host, call_589360.base,
                         call_589360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589360, url, valid)

proc call*(call_589361: Call_GmailUsersMessagesDelete_589348; id: string;
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
  var path_589362 = newJObject()
  var query_589363 = newJObject()
  add(query_589363, "fields", newJString(fields))
  add(query_589363, "quotaUser", newJString(quotaUser))
  add(query_589363, "alt", newJString(alt))
  add(query_589363, "oauth_token", newJString(oauthToken))
  add(query_589363, "userIp", newJString(userIp))
  add(path_589362, "id", newJString(id))
  add(query_589363, "key", newJString(key))
  add(query_589363, "prettyPrint", newJBool(prettyPrint))
  add(path_589362, "userId", newJString(userId))
  result = call_589361.call(path_589362, query_589363, nil, nil, nil)

var gmailUsersMessagesDelete* = Call_GmailUsersMessagesDelete_589348(
    name: "gmailUsersMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesDelete_589349, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesDelete_589350, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesModify_589364 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesModify_589366(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesModify_589365(path: JsonNode; query: JsonNode;
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
  var valid_589367 = path.getOrDefault("id")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "id", valid_589367
  var valid_589368 = path.getOrDefault("userId")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = newJString("me"))
  if valid_589368 != nil:
    section.add "userId", valid_589368
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
  var valid_589369 = query.getOrDefault("fields")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "fields", valid_589369
  var valid_589370 = query.getOrDefault("quotaUser")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "quotaUser", valid_589370
  var valid_589371 = query.getOrDefault("alt")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("json"))
  if valid_589371 != nil:
    section.add "alt", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("userIp")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "userIp", valid_589373
  var valid_589374 = query.getOrDefault("key")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "key", valid_589374
  var valid_589375 = query.getOrDefault("prettyPrint")
  valid_589375 = validateParameter(valid_589375, JBool, required = false,
                                 default = newJBool(true))
  if valid_589375 != nil:
    section.add "prettyPrint", valid_589375
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

proc call*(call_589377: Call_GmailUsersMessagesModify_589364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified message.
  ## 
  let valid = call_589377.validator(path, query, header, formData, body)
  let scheme = call_589377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589377.url(scheme.get, call_589377.host, call_589377.base,
                         call_589377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589377, url, valid)

proc call*(call_589378: Call_GmailUsersMessagesModify_589364; id: string;
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
  var path_589379 = newJObject()
  var query_589380 = newJObject()
  var body_589381 = newJObject()
  add(query_589380, "fields", newJString(fields))
  add(query_589380, "quotaUser", newJString(quotaUser))
  add(query_589380, "alt", newJString(alt))
  add(query_589380, "oauth_token", newJString(oauthToken))
  add(query_589380, "userIp", newJString(userIp))
  add(path_589379, "id", newJString(id))
  add(query_589380, "key", newJString(key))
  if body != nil:
    body_589381 = body
  add(query_589380, "prettyPrint", newJBool(prettyPrint))
  add(path_589379, "userId", newJString(userId))
  result = call_589378.call(path_589379, query_589380, nil, nil, body_589381)

var gmailUsersMessagesModify* = Call_GmailUsersMessagesModify_589364(
    name: "gmailUsersMessagesModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/modify",
    validator: validate_GmailUsersMessagesModify_589365, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesModify_589366, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesTrash_589382 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesTrash_589384(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesTrash_589383(path: JsonNode; query: JsonNode;
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
  var valid_589385 = path.getOrDefault("id")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "id", valid_589385
  var valid_589386 = path.getOrDefault("userId")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = newJString("me"))
  if valid_589386 != nil:
    section.add "userId", valid_589386
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
  var valid_589387 = query.getOrDefault("fields")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "fields", valid_589387
  var valid_589388 = query.getOrDefault("quotaUser")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "quotaUser", valid_589388
  var valid_589389 = query.getOrDefault("alt")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("json"))
  if valid_589389 != nil:
    section.add "alt", valid_589389
  var valid_589390 = query.getOrDefault("oauth_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "oauth_token", valid_589390
  var valid_589391 = query.getOrDefault("userIp")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "userIp", valid_589391
  var valid_589392 = query.getOrDefault("key")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "key", valid_589392
  var valid_589393 = query.getOrDefault("prettyPrint")
  valid_589393 = validateParameter(valid_589393, JBool, required = false,
                                 default = newJBool(true))
  if valid_589393 != nil:
    section.add "prettyPrint", valid_589393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589394: Call_GmailUsersMessagesTrash_589382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified message to the trash.
  ## 
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_GmailUsersMessagesTrash_589382; id: string;
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
  var path_589396 = newJObject()
  var query_589397 = newJObject()
  add(query_589397, "fields", newJString(fields))
  add(query_589397, "quotaUser", newJString(quotaUser))
  add(query_589397, "alt", newJString(alt))
  add(query_589397, "oauth_token", newJString(oauthToken))
  add(query_589397, "userIp", newJString(userIp))
  add(path_589396, "id", newJString(id))
  add(query_589397, "key", newJString(key))
  add(query_589397, "prettyPrint", newJBool(prettyPrint))
  add(path_589396, "userId", newJString(userId))
  result = call_589395.call(path_589396, query_589397, nil, nil, nil)

var gmailUsersMessagesTrash* = Call_GmailUsersMessagesTrash_589382(
    name: "gmailUsersMessagesTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/trash",
    validator: validate_GmailUsersMessagesTrash_589383, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesTrash_589384, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesUntrash_589398 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesUntrash_589400(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesUntrash_589399(path: JsonNode; query: JsonNode;
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
  var valid_589401 = path.getOrDefault("id")
  valid_589401 = validateParameter(valid_589401, JString, required = true,
                                 default = nil)
  if valid_589401 != nil:
    section.add "id", valid_589401
  var valid_589402 = path.getOrDefault("userId")
  valid_589402 = validateParameter(valid_589402, JString, required = true,
                                 default = newJString("me"))
  if valid_589402 != nil:
    section.add "userId", valid_589402
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
  var valid_589403 = query.getOrDefault("fields")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "fields", valid_589403
  var valid_589404 = query.getOrDefault("quotaUser")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "quotaUser", valid_589404
  var valid_589405 = query.getOrDefault("alt")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = newJString("json"))
  if valid_589405 != nil:
    section.add "alt", valid_589405
  var valid_589406 = query.getOrDefault("oauth_token")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "oauth_token", valid_589406
  var valid_589407 = query.getOrDefault("userIp")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "userIp", valid_589407
  var valid_589408 = query.getOrDefault("key")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "key", valid_589408
  var valid_589409 = query.getOrDefault("prettyPrint")
  valid_589409 = validateParameter(valid_589409, JBool, required = false,
                                 default = newJBool(true))
  if valid_589409 != nil:
    section.add "prettyPrint", valid_589409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589410: Call_GmailUsersMessagesUntrash_589398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified message from the trash.
  ## 
  let valid = call_589410.validator(path, query, header, formData, body)
  let scheme = call_589410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589410.url(scheme.get, call_589410.host, call_589410.base,
                         call_589410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589410, url, valid)

proc call*(call_589411: Call_GmailUsersMessagesUntrash_589398; id: string;
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
  var path_589412 = newJObject()
  var query_589413 = newJObject()
  add(query_589413, "fields", newJString(fields))
  add(query_589413, "quotaUser", newJString(quotaUser))
  add(query_589413, "alt", newJString(alt))
  add(query_589413, "oauth_token", newJString(oauthToken))
  add(query_589413, "userIp", newJString(userIp))
  add(path_589412, "id", newJString(id))
  add(query_589413, "key", newJString(key))
  add(query_589413, "prettyPrint", newJBool(prettyPrint))
  add(path_589412, "userId", newJString(userId))
  result = call_589411.call(path_589412, query_589413, nil, nil, nil)

var gmailUsersMessagesUntrash* = Call_GmailUsersMessagesUntrash_589398(
    name: "gmailUsersMessagesUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/untrash",
    validator: validate_GmailUsersMessagesUntrash_589399, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesUntrash_589400, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesAttachmentsGet_589414 = ref object of OpenApiRestCall_588457
proc url_GmailUsersMessagesAttachmentsGet_589416(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesAttachmentsGet_589415(path: JsonNode;
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
  var valid_589417 = path.getOrDefault("messageId")
  valid_589417 = validateParameter(valid_589417, JString, required = true,
                                 default = nil)
  if valid_589417 != nil:
    section.add "messageId", valid_589417
  var valid_589418 = path.getOrDefault("id")
  valid_589418 = validateParameter(valid_589418, JString, required = true,
                                 default = nil)
  if valid_589418 != nil:
    section.add "id", valid_589418
  var valid_589419 = path.getOrDefault("userId")
  valid_589419 = validateParameter(valid_589419, JString, required = true,
                                 default = newJString("me"))
  if valid_589419 != nil:
    section.add "userId", valid_589419
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
  var valid_589420 = query.getOrDefault("fields")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "fields", valid_589420
  var valid_589421 = query.getOrDefault("quotaUser")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "quotaUser", valid_589421
  var valid_589422 = query.getOrDefault("alt")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = newJString("json"))
  if valid_589422 != nil:
    section.add "alt", valid_589422
  var valid_589423 = query.getOrDefault("oauth_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "oauth_token", valid_589423
  var valid_589424 = query.getOrDefault("userIp")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "userIp", valid_589424
  var valid_589425 = query.getOrDefault("key")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "key", valid_589425
  var valid_589426 = query.getOrDefault("prettyPrint")
  valid_589426 = validateParameter(valid_589426, JBool, required = false,
                                 default = newJBool(true))
  if valid_589426 != nil:
    section.add "prettyPrint", valid_589426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589427: Call_GmailUsersMessagesAttachmentsGet_589414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified message attachment.
  ## 
  let valid = call_589427.validator(path, query, header, formData, body)
  let scheme = call_589427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589427.url(scheme.get, call_589427.host, call_589427.base,
                         call_589427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589427, url, valid)

proc call*(call_589428: Call_GmailUsersMessagesAttachmentsGet_589414;
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
  var path_589429 = newJObject()
  var query_589430 = newJObject()
  add(query_589430, "fields", newJString(fields))
  add(query_589430, "quotaUser", newJString(quotaUser))
  add(query_589430, "alt", newJString(alt))
  add(query_589430, "oauth_token", newJString(oauthToken))
  add(query_589430, "userIp", newJString(userIp))
  add(path_589429, "messageId", newJString(messageId))
  add(path_589429, "id", newJString(id))
  add(query_589430, "key", newJString(key))
  add(query_589430, "prettyPrint", newJBool(prettyPrint))
  add(path_589429, "userId", newJString(userId))
  result = call_589428.call(path_589429, query_589430, nil, nil, nil)

var gmailUsersMessagesAttachmentsGet* = Call_GmailUsersMessagesAttachmentsGet_589414(
    name: "gmailUsersMessagesAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/messages/{messageId}/attachments/{id}",
    validator: validate_GmailUsersMessagesAttachmentsGet_589415,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesAttachmentsGet_589416,
    schemes: {Scheme.Https})
type
  Call_GmailUsersGetProfile_589431 = ref object of OpenApiRestCall_588457
proc url_GmailUsersGetProfile_589433(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersGetProfile_589432(path: JsonNode; query: JsonNode;
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
  var valid_589434 = path.getOrDefault("userId")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = newJString("me"))
  if valid_589434 != nil:
    section.add "userId", valid_589434
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
  var valid_589435 = query.getOrDefault("fields")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "fields", valid_589435
  var valid_589436 = query.getOrDefault("quotaUser")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "quotaUser", valid_589436
  var valid_589437 = query.getOrDefault("alt")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = newJString("json"))
  if valid_589437 != nil:
    section.add "alt", valid_589437
  var valid_589438 = query.getOrDefault("oauth_token")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "oauth_token", valid_589438
  var valid_589439 = query.getOrDefault("userIp")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "userIp", valid_589439
  var valid_589440 = query.getOrDefault("key")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "key", valid_589440
  var valid_589441 = query.getOrDefault("prettyPrint")
  valid_589441 = validateParameter(valid_589441, JBool, required = false,
                                 default = newJBool(true))
  if valid_589441 != nil:
    section.add "prettyPrint", valid_589441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589442: Call_GmailUsersGetProfile_589431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current user's Gmail profile.
  ## 
  let valid = call_589442.validator(path, query, header, formData, body)
  let scheme = call_589442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589442.url(scheme.get, call_589442.host, call_589442.base,
                         call_589442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589442, url, valid)

proc call*(call_589443: Call_GmailUsersGetProfile_589431; fields: string = "";
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
  var path_589444 = newJObject()
  var query_589445 = newJObject()
  add(query_589445, "fields", newJString(fields))
  add(query_589445, "quotaUser", newJString(quotaUser))
  add(query_589445, "alt", newJString(alt))
  add(query_589445, "oauth_token", newJString(oauthToken))
  add(query_589445, "userIp", newJString(userIp))
  add(query_589445, "key", newJString(key))
  add(query_589445, "prettyPrint", newJBool(prettyPrint))
  add(path_589444, "userId", newJString(userId))
  result = call_589443.call(path_589444, query_589445, nil, nil, nil)

var gmailUsersGetProfile* = Call_GmailUsersGetProfile_589431(
    name: "gmailUsersGetProfile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/profile",
    validator: validate_GmailUsersGetProfile_589432, base: "/gmail/v1/users",
    url: url_GmailUsersGetProfile_589433, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateAutoForwarding_589461 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsUpdateAutoForwarding_589463(protocol: Scheme;
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

proc validate_GmailUsersSettingsUpdateAutoForwarding_589462(path: JsonNode;
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
  var valid_589464 = path.getOrDefault("userId")
  valid_589464 = validateParameter(valid_589464, JString, required = true,
                                 default = newJString("me"))
  if valid_589464 != nil:
    section.add "userId", valid_589464
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
  var valid_589465 = query.getOrDefault("fields")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "fields", valid_589465
  var valid_589466 = query.getOrDefault("quotaUser")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "quotaUser", valid_589466
  var valid_589467 = query.getOrDefault("alt")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = newJString("json"))
  if valid_589467 != nil:
    section.add "alt", valid_589467
  var valid_589468 = query.getOrDefault("oauth_token")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "oauth_token", valid_589468
  var valid_589469 = query.getOrDefault("userIp")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "userIp", valid_589469
  var valid_589470 = query.getOrDefault("key")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "key", valid_589470
  var valid_589471 = query.getOrDefault("prettyPrint")
  valid_589471 = validateParameter(valid_589471, JBool, required = false,
                                 default = newJBool(true))
  if valid_589471 != nil:
    section.add "prettyPrint", valid_589471
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

proc call*(call_589473: Call_GmailUsersSettingsUpdateAutoForwarding_589461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589473.validator(path, query, header, formData, body)
  let scheme = call_589473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589473.url(scheme.get, call_589473.host, call_589473.base,
                         call_589473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589473, url, valid)

proc call*(call_589474: Call_GmailUsersSettingsUpdateAutoForwarding_589461;
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
  var path_589475 = newJObject()
  var query_589476 = newJObject()
  var body_589477 = newJObject()
  add(query_589476, "fields", newJString(fields))
  add(query_589476, "quotaUser", newJString(quotaUser))
  add(query_589476, "alt", newJString(alt))
  add(query_589476, "oauth_token", newJString(oauthToken))
  add(query_589476, "userIp", newJString(userIp))
  add(query_589476, "key", newJString(key))
  if body != nil:
    body_589477 = body
  add(query_589476, "prettyPrint", newJBool(prettyPrint))
  add(path_589475, "userId", newJString(userId))
  result = call_589474.call(path_589475, query_589476, nil, nil, body_589477)

var gmailUsersSettingsUpdateAutoForwarding* = Call_GmailUsersSettingsUpdateAutoForwarding_589461(
    name: "gmailUsersSettingsUpdateAutoForwarding", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsUpdateAutoForwarding_589462,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateAutoForwarding_589463,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetAutoForwarding_589446 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsGetAutoForwarding_589448(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetAutoForwarding_589447(path: JsonNode;
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
  var valid_589449 = path.getOrDefault("userId")
  valid_589449 = validateParameter(valid_589449, JString, required = true,
                                 default = newJString("me"))
  if valid_589449 != nil:
    section.add "userId", valid_589449
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
  var valid_589450 = query.getOrDefault("fields")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "fields", valid_589450
  var valid_589451 = query.getOrDefault("quotaUser")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "quotaUser", valid_589451
  var valid_589452 = query.getOrDefault("alt")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = newJString("json"))
  if valid_589452 != nil:
    section.add "alt", valid_589452
  var valid_589453 = query.getOrDefault("oauth_token")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "oauth_token", valid_589453
  var valid_589454 = query.getOrDefault("userIp")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "userIp", valid_589454
  var valid_589455 = query.getOrDefault("key")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "key", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589457: Call_GmailUsersSettingsGetAutoForwarding_589446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the auto-forwarding setting for the specified account.
  ## 
  let valid = call_589457.validator(path, query, header, formData, body)
  let scheme = call_589457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589457.url(scheme.get, call_589457.host, call_589457.base,
                         call_589457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589457, url, valid)

proc call*(call_589458: Call_GmailUsersSettingsGetAutoForwarding_589446;
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
  var path_589459 = newJObject()
  var query_589460 = newJObject()
  add(query_589460, "fields", newJString(fields))
  add(query_589460, "quotaUser", newJString(quotaUser))
  add(query_589460, "alt", newJString(alt))
  add(query_589460, "oauth_token", newJString(oauthToken))
  add(query_589460, "userIp", newJString(userIp))
  add(query_589460, "key", newJString(key))
  add(query_589460, "prettyPrint", newJBool(prettyPrint))
  add(path_589459, "userId", newJString(userId))
  result = call_589458.call(path_589459, query_589460, nil, nil, nil)

var gmailUsersSettingsGetAutoForwarding* = Call_GmailUsersSettingsGetAutoForwarding_589446(
    name: "gmailUsersSettingsGetAutoForwarding", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsGetAutoForwarding_589447,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetAutoForwarding_589448,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesCreate_589493 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsDelegatesCreate_589495(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesCreate_589494(path: JsonNode;
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
  var valid_589496 = path.getOrDefault("userId")
  valid_589496 = validateParameter(valid_589496, JString, required = true,
                                 default = newJString("me"))
  if valid_589496 != nil:
    section.add "userId", valid_589496
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
  var valid_589497 = query.getOrDefault("fields")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "fields", valid_589497
  var valid_589498 = query.getOrDefault("quotaUser")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "quotaUser", valid_589498
  var valid_589499 = query.getOrDefault("alt")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = newJString("json"))
  if valid_589499 != nil:
    section.add "alt", valid_589499
  var valid_589500 = query.getOrDefault("oauth_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "oauth_token", valid_589500
  var valid_589501 = query.getOrDefault("userIp")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "userIp", valid_589501
  var valid_589502 = query.getOrDefault("key")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "key", valid_589502
  var valid_589503 = query.getOrDefault("prettyPrint")
  valid_589503 = validateParameter(valid_589503, JBool, required = false,
                                 default = newJBool(true))
  if valid_589503 != nil:
    section.add "prettyPrint", valid_589503
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

proc call*(call_589505: Call_GmailUsersSettingsDelegatesCreate_589493;
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
  let valid = call_589505.validator(path, query, header, formData, body)
  let scheme = call_589505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589505.url(scheme.get, call_589505.host, call_589505.base,
                         call_589505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589505, url, valid)

proc call*(call_589506: Call_GmailUsersSettingsDelegatesCreate_589493;
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
  var path_589507 = newJObject()
  var query_589508 = newJObject()
  var body_589509 = newJObject()
  add(query_589508, "fields", newJString(fields))
  add(query_589508, "quotaUser", newJString(quotaUser))
  add(query_589508, "alt", newJString(alt))
  add(query_589508, "oauth_token", newJString(oauthToken))
  add(query_589508, "userIp", newJString(userIp))
  add(query_589508, "key", newJString(key))
  if body != nil:
    body_589509 = body
  add(query_589508, "prettyPrint", newJBool(prettyPrint))
  add(path_589507, "userId", newJString(userId))
  result = call_589506.call(path_589507, query_589508, nil, nil, body_589509)

var gmailUsersSettingsDelegatesCreate* = Call_GmailUsersSettingsDelegatesCreate_589493(
    name: "gmailUsersSettingsDelegatesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesCreate_589494,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesCreate_589495,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesList_589478 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsDelegatesList_589480(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesList_589479(path: JsonNode;
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
  var valid_589481 = path.getOrDefault("userId")
  valid_589481 = validateParameter(valid_589481, JString, required = true,
                                 default = newJString("me"))
  if valid_589481 != nil:
    section.add "userId", valid_589481
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
  var valid_589482 = query.getOrDefault("fields")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "fields", valid_589482
  var valid_589483 = query.getOrDefault("quotaUser")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "quotaUser", valid_589483
  var valid_589484 = query.getOrDefault("alt")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = newJString("json"))
  if valid_589484 != nil:
    section.add "alt", valid_589484
  var valid_589485 = query.getOrDefault("oauth_token")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "oauth_token", valid_589485
  var valid_589486 = query.getOrDefault("userIp")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "userIp", valid_589486
  var valid_589487 = query.getOrDefault("key")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "key", valid_589487
  var valid_589488 = query.getOrDefault("prettyPrint")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(true))
  if valid_589488 != nil:
    section.add "prettyPrint", valid_589488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589489: Call_GmailUsersSettingsDelegatesList_589478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589489.validator(path, query, header, formData, body)
  let scheme = call_589489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589489.url(scheme.get, call_589489.host, call_589489.base,
                         call_589489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589489, url, valid)

proc call*(call_589490: Call_GmailUsersSettingsDelegatesList_589478;
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
  var path_589491 = newJObject()
  var query_589492 = newJObject()
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "userIp", newJString(userIp))
  add(query_589492, "key", newJString(key))
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  add(path_589491, "userId", newJString(userId))
  result = call_589490.call(path_589491, query_589492, nil, nil, nil)

var gmailUsersSettingsDelegatesList* = Call_GmailUsersSettingsDelegatesList_589478(
    name: "gmailUsersSettingsDelegatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesList_589479,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesList_589480,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesGet_589510 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsDelegatesGet_589512(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesGet_589511(path: JsonNode;
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
  var valid_589513 = path.getOrDefault("delegateEmail")
  valid_589513 = validateParameter(valid_589513, JString, required = true,
                                 default = nil)
  if valid_589513 != nil:
    section.add "delegateEmail", valid_589513
  var valid_589514 = path.getOrDefault("userId")
  valid_589514 = validateParameter(valid_589514, JString, required = true,
                                 default = newJString("me"))
  if valid_589514 != nil:
    section.add "userId", valid_589514
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
  var valid_589515 = query.getOrDefault("fields")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "fields", valid_589515
  var valid_589516 = query.getOrDefault("quotaUser")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "quotaUser", valid_589516
  var valid_589517 = query.getOrDefault("alt")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = newJString("json"))
  if valid_589517 != nil:
    section.add "alt", valid_589517
  var valid_589518 = query.getOrDefault("oauth_token")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "oauth_token", valid_589518
  var valid_589519 = query.getOrDefault("userIp")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "userIp", valid_589519
  var valid_589520 = query.getOrDefault("key")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "key", valid_589520
  var valid_589521 = query.getOrDefault("prettyPrint")
  valid_589521 = validateParameter(valid_589521, JBool, required = false,
                                 default = newJBool(true))
  if valid_589521 != nil:
    section.add "prettyPrint", valid_589521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589522: Call_GmailUsersSettingsDelegatesGet_589510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589522.validator(path, query, header, formData, body)
  let scheme = call_589522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589522.url(scheme.get, call_589522.host, call_589522.base,
                         call_589522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589522, url, valid)

proc call*(call_589523: Call_GmailUsersSettingsDelegatesGet_589510;
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
  var path_589524 = newJObject()
  var query_589525 = newJObject()
  add(query_589525, "fields", newJString(fields))
  add(query_589525, "quotaUser", newJString(quotaUser))
  add(query_589525, "alt", newJString(alt))
  add(path_589524, "delegateEmail", newJString(delegateEmail))
  add(query_589525, "oauth_token", newJString(oauthToken))
  add(query_589525, "userIp", newJString(userIp))
  add(query_589525, "key", newJString(key))
  add(query_589525, "prettyPrint", newJBool(prettyPrint))
  add(path_589524, "userId", newJString(userId))
  result = call_589523.call(path_589524, query_589525, nil, nil, nil)

var gmailUsersSettingsDelegatesGet* = Call_GmailUsersSettingsDelegatesGet_589510(
    name: "gmailUsersSettingsDelegatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesGet_589511,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesGet_589512,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesDelete_589526 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsDelegatesDelete_589528(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesDelete_589527(path: JsonNode;
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
  var valid_589529 = path.getOrDefault("delegateEmail")
  valid_589529 = validateParameter(valid_589529, JString, required = true,
                                 default = nil)
  if valid_589529 != nil:
    section.add "delegateEmail", valid_589529
  var valid_589530 = path.getOrDefault("userId")
  valid_589530 = validateParameter(valid_589530, JString, required = true,
                                 default = newJString("me"))
  if valid_589530 != nil:
    section.add "userId", valid_589530
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
  var valid_589531 = query.getOrDefault("fields")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "fields", valid_589531
  var valid_589532 = query.getOrDefault("quotaUser")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "quotaUser", valid_589532
  var valid_589533 = query.getOrDefault("alt")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = newJString("json"))
  if valid_589533 != nil:
    section.add "alt", valid_589533
  var valid_589534 = query.getOrDefault("oauth_token")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "oauth_token", valid_589534
  var valid_589535 = query.getOrDefault("userIp")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "userIp", valid_589535
  var valid_589536 = query.getOrDefault("key")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "key", valid_589536
  var valid_589537 = query.getOrDefault("prettyPrint")
  valid_589537 = validateParameter(valid_589537, JBool, required = false,
                                 default = newJBool(true))
  if valid_589537 != nil:
    section.add "prettyPrint", valid_589537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589538: Call_GmailUsersSettingsDelegatesDelete_589526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589538.validator(path, query, header, formData, body)
  let scheme = call_589538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589538.url(scheme.get, call_589538.host, call_589538.base,
                         call_589538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589538, url, valid)

proc call*(call_589539: Call_GmailUsersSettingsDelegatesDelete_589526;
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
  var path_589540 = newJObject()
  var query_589541 = newJObject()
  add(query_589541, "fields", newJString(fields))
  add(query_589541, "quotaUser", newJString(quotaUser))
  add(query_589541, "alt", newJString(alt))
  add(path_589540, "delegateEmail", newJString(delegateEmail))
  add(query_589541, "oauth_token", newJString(oauthToken))
  add(query_589541, "userIp", newJString(userIp))
  add(query_589541, "key", newJString(key))
  add(query_589541, "prettyPrint", newJBool(prettyPrint))
  add(path_589540, "userId", newJString(userId))
  result = call_589539.call(path_589540, query_589541, nil, nil, nil)

var gmailUsersSettingsDelegatesDelete* = Call_GmailUsersSettingsDelegatesDelete_589526(
    name: "gmailUsersSettingsDelegatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesDelete_589527,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesDelete_589528,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersCreate_589557 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsFiltersCreate_589559(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersCreate_589558(path: JsonNode;
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
  var valid_589560 = path.getOrDefault("userId")
  valid_589560 = validateParameter(valid_589560, JString, required = true,
                                 default = newJString("me"))
  if valid_589560 != nil:
    section.add "userId", valid_589560
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
  var valid_589561 = query.getOrDefault("fields")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "fields", valid_589561
  var valid_589562 = query.getOrDefault("quotaUser")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "quotaUser", valid_589562
  var valid_589563 = query.getOrDefault("alt")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = newJString("json"))
  if valid_589563 != nil:
    section.add "alt", valid_589563
  var valid_589564 = query.getOrDefault("oauth_token")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "oauth_token", valid_589564
  var valid_589565 = query.getOrDefault("userIp")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "userIp", valid_589565
  var valid_589566 = query.getOrDefault("key")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "key", valid_589566
  var valid_589567 = query.getOrDefault("prettyPrint")
  valid_589567 = validateParameter(valid_589567, JBool, required = false,
                                 default = newJBool(true))
  if valid_589567 != nil:
    section.add "prettyPrint", valid_589567
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

proc call*(call_589569: Call_GmailUsersSettingsFiltersCreate_589557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a filter.
  ## 
  let valid = call_589569.validator(path, query, header, formData, body)
  let scheme = call_589569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589569.url(scheme.get, call_589569.host, call_589569.base,
                         call_589569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589569, url, valid)

proc call*(call_589570: Call_GmailUsersSettingsFiltersCreate_589557;
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
  var path_589571 = newJObject()
  var query_589572 = newJObject()
  var body_589573 = newJObject()
  add(query_589572, "fields", newJString(fields))
  add(query_589572, "quotaUser", newJString(quotaUser))
  add(query_589572, "alt", newJString(alt))
  add(query_589572, "oauth_token", newJString(oauthToken))
  add(query_589572, "userIp", newJString(userIp))
  add(query_589572, "key", newJString(key))
  if body != nil:
    body_589573 = body
  add(query_589572, "prettyPrint", newJBool(prettyPrint))
  add(path_589571, "userId", newJString(userId))
  result = call_589570.call(path_589571, query_589572, nil, nil, body_589573)

var gmailUsersSettingsFiltersCreate* = Call_GmailUsersSettingsFiltersCreate_589557(
    name: "gmailUsersSettingsFiltersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersCreate_589558,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersCreate_589559,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersList_589542 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsFiltersList_589544(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersList_589543(path: JsonNode; query: JsonNode;
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
  var valid_589545 = path.getOrDefault("userId")
  valid_589545 = validateParameter(valid_589545, JString, required = true,
                                 default = newJString("me"))
  if valid_589545 != nil:
    section.add "userId", valid_589545
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
  var valid_589546 = query.getOrDefault("fields")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "fields", valid_589546
  var valid_589547 = query.getOrDefault("quotaUser")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "quotaUser", valid_589547
  var valid_589548 = query.getOrDefault("alt")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = newJString("json"))
  if valid_589548 != nil:
    section.add "alt", valid_589548
  var valid_589549 = query.getOrDefault("oauth_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "oauth_token", valid_589549
  var valid_589550 = query.getOrDefault("userIp")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "userIp", valid_589550
  var valid_589551 = query.getOrDefault("key")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "key", valid_589551
  var valid_589552 = query.getOrDefault("prettyPrint")
  valid_589552 = validateParameter(valid_589552, JBool, required = false,
                                 default = newJBool(true))
  if valid_589552 != nil:
    section.add "prettyPrint", valid_589552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589553: Call_GmailUsersSettingsFiltersList_589542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the message filters of a Gmail user.
  ## 
  let valid = call_589553.validator(path, query, header, formData, body)
  let scheme = call_589553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589553.url(scheme.get, call_589553.host, call_589553.base,
                         call_589553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589553, url, valid)

proc call*(call_589554: Call_GmailUsersSettingsFiltersList_589542;
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
  var path_589555 = newJObject()
  var query_589556 = newJObject()
  add(query_589556, "fields", newJString(fields))
  add(query_589556, "quotaUser", newJString(quotaUser))
  add(query_589556, "alt", newJString(alt))
  add(query_589556, "oauth_token", newJString(oauthToken))
  add(query_589556, "userIp", newJString(userIp))
  add(query_589556, "key", newJString(key))
  add(query_589556, "prettyPrint", newJBool(prettyPrint))
  add(path_589555, "userId", newJString(userId))
  result = call_589554.call(path_589555, query_589556, nil, nil, nil)

var gmailUsersSettingsFiltersList* = Call_GmailUsersSettingsFiltersList_589542(
    name: "gmailUsersSettingsFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersList_589543,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersList_589544,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersGet_589574 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsFiltersGet_589576(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersGet_589575(path: JsonNode; query: JsonNode;
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
  var valid_589577 = path.getOrDefault("id")
  valid_589577 = validateParameter(valid_589577, JString, required = true,
                                 default = nil)
  if valid_589577 != nil:
    section.add "id", valid_589577
  var valid_589578 = path.getOrDefault("userId")
  valid_589578 = validateParameter(valid_589578, JString, required = true,
                                 default = newJString("me"))
  if valid_589578 != nil:
    section.add "userId", valid_589578
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
  var valid_589582 = query.getOrDefault("oauth_token")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "oauth_token", valid_589582
  var valid_589583 = query.getOrDefault("userIp")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "userIp", valid_589583
  var valid_589584 = query.getOrDefault("key")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "key", valid_589584
  var valid_589585 = query.getOrDefault("prettyPrint")
  valid_589585 = validateParameter(valid_589585, JBool, required = false,
                                 default = newJBool(true))
  if valid_589585 != nil:
    section.add "prettyPrint", valid_589585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589586: Call_GmailUsersSettingsFiltersGet_589574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a filter.
  ## 
  let valid = call_589586.validator(path, query, header, formData, body)
  let scheme = call_589586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589586.url(scheme.get, call_589586.host, call_589586.base,
                         call_589586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589586, url, valid)

proc call*(call_589587: Call_GmailUsersSettingsFiltersGet_589574; id: string;
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
  var path_589588 = newJObject()
  var query_589589 = newJObject()
  add(query_589589, "fields", newJString(fields))
  add(query_589589, "quotaUser", newJString(quotaUser))
  add(query_589589, "alt", newJString(alt))
  add(query_589589, "oauth_token", newJString(oauthToken))
  add(query_589589, "userIp", newJString(userIp))
  add(path_589588, "id", newJString(id))
  add(query_589589, "key", newJString(key))
  add(query_589589, "prettyPrint", newJBool(prettyPrint))
  add(path_589588, "userId", newJString(userId))
  result = call_589587.call(path_589588, query_589589, nil, nil, nil)

var gmailUsersSettingsFiltersGet* = Call_GmailUsersSettingsFiltersGet_589574(
    name: "gmailUsersSettingsFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersGet_589575,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersGet_589576,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersDelete_589590 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsFiltersDelete_589592(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersDelete_589591(path: JsonNode;
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
  var valid_589593 = path.getOrDefault("id")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = nil)
  if valid_589593 != nil:
    section.add "id", valid_589593
  var valid_589594 = path.getOrDefault("userId")
  valid_589594 = validateParameter(valid_589594, JString, required = true,
                                 default = newJString("me"))
  if valid_589594 != nil:
    section.add "userId", valid_589594
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
  var valid_589595 = query.getOrDefault("fields")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "fields", valid_589595
  var valid_589596 = query.getOrDefault("quotaUser")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "quotaUser", valid_589596
  var valid_589597 = query.getOrDefault("alt")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = newJString("json"))
  if valid_589597 != nil:
    section.add "alt", valid_589597
  var valid_589598 = query.getOrDefault("oauth_token")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "oauth_token", valid_589598
  var valid_589599 = query.getOrDefault("userIp")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "userIp", valid_589599
  var valid_589600 = query.getOrDefault("key")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "key", valid_589600
  var valid_589601 = query.getOrDefault("prettyPrint")
  valid_589601 = validateParameter(valid_589601, JBool, required = false,
                                 default = newJBool(true))
  if valid_589601 != nil:
    section.add "prettyPrint", valid_589601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589602: Call_GmailUsersSettingsFiltersDelete_589590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a filter.
  ## 
  let valid = call_589602.validator(path, query, header, formData, body)
  let scheme = call_589602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589602.url(scheme.get, call_589602.host, call_589602.base,
                         call_589602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589602, url, valid)

proc call*(call_589603: Call_GmailUsersSettingsFiltersDelete_589590; id: string;
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
  var path_589604 = newJObject()
  var query_589605 = newJObject()
  add(query_589605, "fields", newJString(fields))
  add(query_589605, "quotaUser", newJString(quotaUser))
  add(query_589605, "alt", newJString(alt))
  add(query_589605, "oauth_token", newJString(oauthToken))
  add(query_589605, "userIp", newJString(userIp))
  add(path_589604, "id", newJString(id))
  add(query_589605, "key", newJString(key))
  add(query_589605, "prettyPrint", newJBool(prettyPrint))
  add(path_589604, "userId", newJString(userId))
  result = call_589603.call(path_589604, query_589605, nil, nil, nil)

var gmailUsersSettingsFiltersDelete* = Call_GmailUsersSettingsFiltersDelete_589590(
    name: "gmailUsersSettingsFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersDelete_589591,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersDelete_589592,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesCreate_589621 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsForwardingAddressesCreate_589623(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesCreate_589622(path: JsonNode;
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
  var valid_589624 = path.getOrDefault("userId")
  valid_589624 = validateParameter(valid_589624, JString, required = true,
                                 default = newJString("me"))
  if valid_589624 != nil:
    section.add "userId", valid_589624
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
  var valid_589625 = query.getOrDefault("fields")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "fields", valid_589625
  var valid_589626 = query.getOrDefault("quotaUser")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "quotaUser", valid_589626
  var valid_589627 = query.getOrDefault("alt")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = newJString("json"))
  if valid_589627 != nil:
    section.add "alt", valid_589627
  var valid_589628 = query.getOrDefault("oauth_token")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "oauth_token", valid_589628
  var valid_589629 = query.getOrDefault("userIp")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "userIp", valid_589629
  var valid_589630 = query.getOrDefault("key")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "key", valid_589630
  var valid_589631 = query.getOrDefault("prettyPrint")
  valid_589631 = validateParameter(valid_589631, JBool, required = false,
                                 default = newJBool(true))
  if valid_589631 != nil:
    section.add "prettyPrint", valid_589631
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

proc call*(call_589633: Call_GmailUsersSettingsForwardingAddressesCreate_589621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589633.validator(path, query, header, formData, body)
  let scheme = call_589633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589633.url(scheme.get, call_589633.host, call_589633.base,
                         call_589633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589633, url, valid)

proc call*(call_589634: Call_GmailUsersSettingsForwardingAddressesCreate_589621;
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
  var path_589635 = newJObject()
  var query_589636 = newJObject()
  var body_589637 = newJObject()
  add(query_589636, "fields", newJString(fields))
  add(query_589636, "quotaUser", newJString(quotaUser))
  add(query_589636, "alt", newJString(alt))
  add(query_589636, "oauth_token", newJString(oauthToken))
  add(query_589636, "userIp", newJString(userIp))
  add(query_589636, "key", newJString(key))
  if body != nil:
    body_589637 = body
  add(query_589636, "prettyPrint", newJBool(prettyPrint))
  add(path_589635, "userId", newJString(userId))
  result = call_589634.call(path_589635, query_589636, nil, nil, body_589637)

var gmailUsersSettingsForwardingAddressesCreate* = Call_GmailUsersSettingsForwardingAddressesCreate_589621(
    name: "gmailUsersSettingsForwardingAddressesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesCreate_589622,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesCreate_589623,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesList_589606 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsForwardingAddressesList_589608(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesList_589607(path: JsonNode;
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
  var valid_589609 = path.getOrDefault("userId")
  valid_589609 = validateParameter(valid_589609, JString, required = true,
                                 default = newJString("me"))
  if valid_589609 != nil:
    section.add "userId", valid_589609
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
  var valid_589610 = query.getOrDefault("fields")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "fields", valid_589610
  var valid_589611 = query.getOrDefault("quotaUser")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "quotaUser", valid_589611
  var valid_589612 = query.getOrDefault("alt")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = newJString("json"))
  if valid_589612 != nil:
    section.add "alt", valid_589612
  var valid_589613 = query.getOrDefault("oauth_token")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "oauth_token", valid_589613
  var valid_589614 = query.getOrDefault("userIp")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "userIp", valid_589614
  var valid_589615 = query.getOrDefault("key")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "key", valid_589615
  var valid_589616 = query.getOrDefault("prettyPrint")
  valid_589616 = validateParameter(valid_589616, JBool, required = false,
                                 default = newJBool(true))
  if valid_589616 != nil:
    section.add "prettyPrint", valid_589616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589617: Call_GmailUsersSettingsForwardingAddressesList_589606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the forwarding addresses for the specified account.
  ## 
  let valid = call_589617.validator(path, query, header, formData, body)
  let scheme = call_589617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589617.url(scheme.get, call_589617.host, call_589617.base,
                         call_589617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589617, url, valid)

proc call*(call_589618: Call_GmailUsersSettingsForwardingAddressesList_589606;
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
  var path_589619 = newJObject()
  var query_589620 = newJObject()
  add(query_589620, "fields", newJString(fields))
  add(query_589620, "quotaUser", newJString(quotaUser))
  add(query_589620, "alt", newJString(alt))
  add(query_589620, "oauth_token", newJString(oauthToken))
  add(query_589620, "userIp", newJString(userIp))
  add(query_589620, "key", newJString(key))
  add(query_589620, "prettyPrint", newJBool(prettyPrint))
  add(path_589619, "userId", newJString(userId))
  result = call_589618.call(path_589619, query_589620, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesList* = Call_GmailUsersSettingsForwardingAddressesList_589606(
    name: "gmailUsersSettingsForwardingAddressesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesList_589607,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesList_589608,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesGet_589638 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsForwardingAddressesGet_589640(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesGet_589639(path: JsonNode;
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
  var valid_589641 = path.getOrDefault("forwardingEmail")
  valid_589641 = validateParameter(valid_589641, JString, required = true,
                                 default = nil)
  if valid_589641 != nil:
    section.add "forwardingEmail", valid_589641
  var valid_589642 = path.getOrDefault("userId")
  valid_589642 = validateParameter(valid_589642, JString, required = true,
                                 default = newJString("me"))
  if valid_589642 != nil:
    section.add "userId", valid_589642
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
  var valid_589643 = query.getOrDefault("fields")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "fields", valid_589643
  var valid_589644 = query.getOrDefault("quotaUser")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "quotaUser", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("oauth_token")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "oauth_token", valid_589646
  var valid_589647 = query.getOrDefault("userIp")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "userIp", valid_589647
  var valid_589648 = query.getOrDefault("key")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "key", valid_589648
  var valid_589649 = query.getOrDefault("prettyPrint")
  valid_589649 = validateParameter(valid_589649, JBool, required = false,
                                 default = newJBool(true))
  if valid_589649 != nil:
    section.add "prettyPrint", valid_589649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589650: Call_GmailUsersSettingsForwardingAddressesGet_589638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified forwarding address.
  ## 
  let valid = call_589650.validator(path, query, header, formData, body)
  let scheme = call_589650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589650.url(scheme.get, call_589650.host, call_589650.base,
                         call_589650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589650, url, valid)

proc call*(call_589651: Call_GmailUsersSettingsForwardingAddressesGet_589638;
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
  var path_589652 = newJObject()
  var query_589653 = newJObject()
  add(query_589653, "fields", newJString(fields))
  add(query_589653, "quotaUser", newJString(quotaUser))
  add(query_589653, "alt", newJString(alt))
  add(path_589652, "forwardingEmail", newJString(forwardingEmail))
  add(query_589653, "oauth_token", newJString(oauthToken))
  add(query_589653, "userIp", newJString(userIp))
  add(query_589653, "key", newJString(key))
  add(query_589653, "prettyPrint", newJBool(prettyPrint))
  add(path_589652, "userId", newJString(userId))
  result = call_589651.call(path_589652, query_589653, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesGet* = Call_GmailUsersSettingsForwardingAddressesGet_589638(
    name: "gmailUsersSettingsForwardingAddressesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesGet_589639,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesGet_589640,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesDelete_589654 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsForwardingAddressesDelete_589656(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesDelete_589655(path: JsonNode;
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
  var valid_589657 = path.getOrDefault("forwardingEmail")
  valid_589657 = validateParameter(valid_589657, JString, required = true,
                                 default = nil)
  if valid_589657 != nil:
    section.add "forwardingEmail", valid_589657
  var valid_589658 = path.getOrDefault("userId")
  valid_589658 = validateParameter(valid_589658, JString, required = true,
                                 default = newJString("me"))
  if valid_589658 != nil:
    section.add "userId", valid_589658
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
  var valid_589659 = query.getOrDefault("fields")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "fields", valid_589659
  var valid_589660 = query.getOrDefault("quotaUser")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "quotaUser", valid_589660
  var valid_589661 = query.getOrDefault("alt")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = newJString("json"))
  if valid_589661 != nil:
    section.add "alt", valid_589661
  var valid_589662 = query.getOrDefault("oauth_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "oauth_token", valid_589662
  var valid_589663 = query.getOrDefault("userIp")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "userIp", valid_589663
  var valid_589664 = query.getOrDefault("key")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "key", valid_589664
  var valid_589665 = query.getOrDefault("prettyPrint")
  valid_589665 = validateParameter(valid_589665, JBool, required = false,
                                 default = newJBool(true))
  if valid_589665 != nil:
    section.add "prettyPrint", valid_589665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589666: Call_GmailUsersSettingsForwardingAddressesDelete_589654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589666.validator(path, query, header, formData, body)
  let scheme = call_589666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589666.url(scheme.get, call_589666.host, call_589666.base,
                         call_589666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589666, url, valid)

proc call*(call_589667: Call_GmailUsersSettingsForwardingAddressesDelete_589654;
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
  var path_589668 = newJObject()
  var query_589669 = newJObject()
  add(query_589669, "fields", newJString(fields))
  add(query_589669, "quotaUser", newJString(quotaUser))
  add(query_589669, "alt", newJString(alt))
  add(path_589668, "forwardingEmail", newJString(forwardingEmail))
  add(query_589669, "oauth_token", newJString(oauthToken))
  add(query_589669, "userIp", newJString(userIp))
  add(query_589669, "key", newJString(key))
  add(query_589669, "prettyPrint", newJBool(prettyPrint))
  add(path_589668, "userId", newJString(userId))
  result = call_589667.call(path_589668, query_589669, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesDelete* = Call_GmailUsersSettingsForwardingAddressesDelete_589654(
    name: "gmailUsersSettingsForwardingAddressesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesDelete_589655,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesDelete_589656,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateImap_589685 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsUpdateImap_589687(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateImap_589686(path: JsonNode; query: JsonNode;
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
  var valid_589688 = path.getOrDefault("userId")
  valid_589688 = validateParameter(valid_589688, JString, required = true,
                                 default = newJString("me"))
  if valid_589688 != nil:
    section.add "userId", valid_589688
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
  var valid_589689 = query.getOrDefault("fields")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "fields", valid_589689
  var valid_589690 = query.getOrDefault("quotaUser")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "quotaUser", valid_589690
  var valid_589691 = query.getOrDefault("alt")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = newJString("json"))
  if valid_589691 != nil:
    section.add "alt", valid_589691
  var valid_589692 = query.getOrDefault("oauth_token")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "oauth_token", valid_589692
  var valid_589693 = query.getOrDefault("userIp")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "userIp", valid_589693
  var valid_589694 = query.getOrDefault("key")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "key", valid_589694
  var valid_589695 = query.getOrDefault("prettyPrint")
  valid_589695 = validateParameter(valid_589695, JBool, required = false,
                                 default = newJBool(true))
  if valid_589695 != nil:
    section.add "prettyPrint", valid_589695
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

proc call*(call_589697: Call_GmailUsersSettingsUpdateImap_589685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates IMAP settings.
  ## 
  let valid = call_589697.validator(path, query, header, formData, body)
  let scheme = call_589697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589697.url(scheme.get, call_589697.host, call_589697.base,
                         call_589697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589697, url, valid)

proc call*(call_589698: Call_GmailUsersSettingsUpdateImap_589685;
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
  var path_589699 = newJObject()
  var query_589700 = newJObject()
  var body_589701 = newJObject()
  add(query_589700, "fields", newJString(fields))
  add(query_589700, "quotaUser", newJString(quotaUser))
  add(query_589700, "alt", newJString(alt))
  add(query_589700, "oauth_token", newJString(oauthToken))
  add(query_589700, "userIp", newJString(userIp))
  add(query_589700, "key", newJString(key))
  if body != nil:
    body_589701 = body
  add(query_589700, "prettyPrint", newJBool(prettyPrint))
  add(path_589699, "userId", newJString(userId))
  result = call_589698.call(path_589699, query_589700, nil, nil, body_589701)

var gmailUsersSettingsUpdateImap* = Call_GmailUsersSettingsUpdateImap_589685(
    name: "gmailUsersSettingsUpdateImap", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsUpdateImap_589686,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateImap_589687,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetImap_589670 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsGetImap_589672(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetImap_589671(path: JsonNode; query: JsonNode;
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
  var valid_589673 = path.getOrDefault("userId")
  valid_589673 = validateParameter(valid_589673, JString, required = true,
                                 default = newJString("me"))
  if valid_589673 != nil:
    section.add "userId", valid_589673
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
  var valid_589674 = query.getOrDefault("fields")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "fields", valid_589674
  var valid_589675 = query.getOrDefault("quotaUser")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "quotaUser", valid_589675
  var valid_589676 = query.getOrDefault("alt")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = newJString("json"))
  if valid_589676 != nil:
    section.add "alt", valid_589676
  var valid_589677 = query.getOrDefault("oauth_token")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "oauth_token", valid_589677
  var valid_589678 = query.getOrDefault("userIp")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "userIp", valid_589678
  var valid_589679 = query.getOrDefault("key")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "key", valid_589679
  var valid_589680 = query.getOrDefault("prettyPrint")
  valid_589680 = validateParameter(valid_589680, JBool, required = false,
                                 default = newJBool(true))
  if valid_589680 != nil:
    section.add "prettyPrint", valid_589680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589681: Call_GmailUsersSettingsGetImap_589670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets IMAP settings.
  ## 
  let valid = call_589681.validator(path, query, header, formData, body)
  let scheme = call_589681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589681.url(scheme.get, call_589681.host, call_589681.base,
                         call_589681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589681, url, valid)

proc call*(call_589682: Call_GmailUsersSettingsGetImap_589670; fields: string = "";
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
  var path_589683 = newJObject()
  var query_589684 = newJObject()
  add(query_589684, "fields", newJString(fields))
  add(query_589684, "quotaUser", newJString(quotaUser))
  add(query_589684, "alt", newJString(alt))
  add(query_589684, "oauth_token", newJString(oauthToken))
  add(query_589684, "userIp", newJString(userIp))
  add(query_589684, "key", newJString(key))
  add(query_589684, "prettyPrint", newJBool(prettyPrint))
  add(path_589683, "userId", newJString(userId))
  result = call_589682.call(path_589683, query_589684, nil, nil, nil)

var gmailUsersSettingsGetImap* = Call_GmailUsersSettingsGetImap_589670(
    name: "gmailUsersSettingsGetImap", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsGetImap_589671, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetImap_589672, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateLanguage_589717 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsUpdateLanguage_589719(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateLanguage_589718(path: JsonNode;
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
  var valid_589720 = path.getOrDefault("userId")
  valid_589720 = validateParameter(valid_589720, JString, required = true,
                                 default = newJString("me"))
  if valid_589720 != nil:
    section.add "userId", valid_589720
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
  var valid_589721 = query.getOrDefault("fields")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "fields", valid_589721
  var valid_589722 = query.getOrDefault("quotaUser")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "quotaUser", valid_589722
  var valid_589723 = query.getOrDefault("alt")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = newJString("json"))
  if valid_589723 != nil:
    section.add "alt", valid_589723
  var valid_589724 = query.getOrDefault("oauth_token")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "oauth_token", valid_589724
  var valid_589725 = query.getOrDefault("userIp")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "userIp", valid_589725
  var valid_589726 = query.getOrDefault("key")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "key", valid_589726
  var valid_589727 = query.getOrDefault("prettyPrint")
  valid_589727 = validateParameter(valid_589727, JBool, required = false,
                                 default = newJBool(true))
  if valid_589727 != nil:
    section.add "prettyPrint", valid_589727
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

proc call*(call_589729: Call_GmailUsersSettingsUpdateLanguage_589717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
  ## 
  let valid = call_589729.validator(path, query, header, formData, body)
  let scheme = call_589729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589729.url(scheme.get, call_589729.host, call_589729.base,
                         call_589729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589729, url, valid)

proc call*(call_589730: Call_GmailUsersSettingsUpdateLanguage_589717;
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
  var path_589731 = newJObject()
  var query_589732 = newJObject()
  var body_589733 = newJObject()
  add(query_589732, "fields", newJString(fields))
  add(query_589732, "quotaUser", newJString(quotaUser))
  add(query_589732, "alt", newJString(alt))
  add(query_589732, "oauth_token", newJString(oauthToken))
  add(query_589732, "userIp", newJString(userIp))
  add(query_589732, "key", newJString(key))
  if body != nil:
    body_589733 = body
  add(query_589732, "prettyPrint", newJBool(prettyPrint))
  add(path_589731, "userId", newJString(userId))
  result = call_589730.call(path_589731, query_589732, nil, nil, body_589733)

var gmailUsersSettingsUpdateLanguage* = Call_GmailUsersSettingsUpdateLanguage_589717(
    name: "gmailUsersSettingsUpdateLanguage", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsUpdateLanguage_589718,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateLanguage_589719,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetLanguage_589702 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsGetLanguage_589704(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetLanguage_589703(path: JsonNode; query: JsonNode;
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
  var valid_589705 = path.getOrDefault("userId")
  valid_589705 = validateParameter(valid_589705, JString, required = true,
                                 default = newJString("me"))
  if valid_589705 != nil:
    section.add "userId", valid_589705
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
  var valid_589706 = query.getOrDefault("fields")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "fields", valid_589706
  var valid_589707 = query.getOrDefault("quotaUser")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "quotaUser", valid_589707
  var valid_589708 = query.getOrDefault("alt")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = newJString("json"))
  if valid_589708 != nil:
    section.add "alt", valid_589708
  var valid_589709 = query.getOrDefault("oauth_token")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "oauth_token", valid_589709
  var valid_589710 = query.getOrDefault("userIp")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = nil)
  if valid_589710 != nil:
    section.add "userIp", valid_589710
  var valid_589711 = query.getOrDefault("key")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = nil)
  if valid_589711 != nil:
    section.add "key", valid_589711
  var valid_589712 = query.getOrDefault("prettyPrint")
  valid_589712 = validateParameter(valid_589712, JBool, required = false,
                                 default = newJBool(true))
  if valid_589712 != nil:
    section.add "prettyPrint", valid_589712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589713: Call_GmailUsersSettingsGetLanguage_589702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets language settings.
  ## 
  let valid = call_589713.validator(path, query, header, formData, body)
  let scheme = call_589713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589713.url(scheme.get, call_589713.host, call_589713.base,
                         call_589713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589713, url, valid)

proc call*(call_589714: Call_GmailUsersSettingsGetLanguage_589702;
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
  var path_589715 = newJObject()
  var query_589716 = newJObject()
  add(query_589716, "fields", newJString(fields))
  add(query_589716, "quotaUser", newJString(quotaUser))
  add(query_589716, "alt", newJString(alt))
  add(query_589716, "oauth_token", newJString(oauthToken))
  add(query_589716, "userIp", newJString(userIp))
  add(query_589716, "key", newJString(key))
  add(query_589716, "prettyPrint", newJBool(prettyPrint))
  add(path_589715, "userId", newJString(userId))
  result = call_589714.call(path_589715, query_589716, nil, nil, nil)

var gmailUsersSettingsGetLanguage* = Call_GmailUsersSettingsGetLanguage_589702(
    name: "gmailUsersSettingsGetLanguage", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsGetLanguage_589703,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetLanguage_589704,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdatePop_589749 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsUpdatePop_589751(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdatePop_589750(path: JsonNode; query: JsonNode;
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
  var valid_589752 = path.getOrDefault("userId")
  valid_589752 = validateParameter(valid_589752, JString, required = true,
                                 default = newJString("me"))
  if valid_589752 != nil:
    section.add "userId", valid_589752
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
  var valid_589753 = query.getOrDefault("fields")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = nil)
  if valid_589753 != nil:
    section.add "fields", valid_589753
  var valid_589754 = query.getOrDefault("quotaUser")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "quotaUser", valid_589754
  var valid_589755 = query.getOrDefault("alt")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = newJString("json"))
  if valid_589755 != nil:
    section.add "alt", valid_589755
  var valid_589756 = query.getOrDefault("oauth_token")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "oauth_token", valid_589756
  var valid_589757 = query.getOrDefault("userIp")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "userIp", valid_589757
  var valid_589758 = query.getOrDefault("key")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = nil)
  if valid_589758 != nil:
    section.add "key", valid_589758
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589761: Call_GmailUsersSettingsUpdatePop_589749; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates POP settings.
  ## 
  let valid = call_589761.validator(path, query, header, formData, body)
  let scheme = call_589761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589761.url(scheme.get, call_589761.host, call_589761.base,
                         call_589761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589761, url, valid)

proc call*(call_589762: Call_GmailUsersSettingsUpdatePop_589749;
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
  var path_589763 = newJObject()
  var query_589764 = newJObject()
  var body_589765 = newJObject()
  add(query_589764, "fields", newJString(fields))
  add(query_589764, "quotaUser", newJString(quotaUser))
  add(query_589764, "alt", newJString(alt))
  add(query_589764, "oauth_token", newJString(oauthToken))
  add(query_589764, "userIp", newJString(userIp))
  add(query_589764, "key", newJString(key))
  if body != nil:
    body_589765 = body
  add(query_589764, "prettyPrint", newJBool(prettyPrint))
  add(path_589763, "userId", newJString(userId))
  result = call_589762.call(path_589763, query_589764, nil, nil, body_589765)

var gmailUsersSettingsUpdatePop* = Call_GmailUsersSettingsUpdatePop_589749(
    name: "gmailUsersSettingsUpdatePop", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsUpdatePop_589750,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdatePop_589751,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetPop_589734 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsGetPop_589736(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetPop_589735(path: JsonNode; query: JsonNode;
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
  var valid_589737 = path.getOrDefault("userId")
  valid_589737 = validateParameter(valid_589737, JString, required = true,
                                 default = newJString("me"))
  if valid_589737 != nil:
    section.add "userId", valid_589737
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
  var valid_589738 = query.getOrDefault("fields")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "fields", valid_589738
  var valid_589739 = query.getOrDefault("quotaUser")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "quotaUser", valid_589739
  var valid_589740 = query.getOrDefault("alt")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = newJString("json"))
  if valid_589740 != nil:
    section.add "alt", valid_589740
  var valid_589741 = query.getOrDefault("oauth_token")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "oauth_token", valid_589741
  var valid_589742 = query.getOrDefault("userIp")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "userIp", valid_589742
  var valid_589743 = query.getOrDefault("key")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "key", valid_589743
  var valid_589744 = query.getOrDefault("prettyPrint")
  valid_589744 = validateParameter(valid_589744, JBool, required = false,
                                 default = newJBool(true))
  if valid_589744 != nil:
    section.add "prettyPrint", valid_589744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589745: Call_GmailUsersSettingsGetPop_589734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets POP settings.
  ## 
  let valid = call_589745.validator(path, query, header, formData, body)
  let scheme = call_589745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589745.url(scheme.get, call_589745.host, call_589745.base,
                         call_589745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589745, url, valid)

proc call*(call_589746: Call_GmailUsersSettingsGetPop_589734; fields: string = "";
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
  var path_589747 = newJObject()
  var query_589748 = newJObject()
  add(query_589748, "fields", newJString(fields))
  add(query_589748, "quotaUser", newJString(quotaUser))
  add(query_589748, "alt", newJString(alt))
  add(query_589748, "oauth_token", newJString(oauthToken))
  add(query_589748, "userIp", newJString(userIp))
  add(query_589748, "key", newJString(key))
  add(query_589748, "prettyPrint", newJBool(prettyPrint))
  add(path_589747, "userId", newJString(userId))
  result = call_589746.call(path_589747, query_589748, nil, nil, nil)

var gmailUsersSettingsGetPop* = Call_GmailUsersSettingsGetPop_589734(
    name: "gmailUsersSettingsGetPop", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsGetPop_589735, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetPop_589736, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsCreate_589781 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsCreate_589783(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsCreate_589782(path: JsonNode;
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
  var valid_589784 = path.getOrDefault("userId")
  valid_589784 = validateParameter(valid_589784, JString, required = true,
                                 default = newJString("me"))
  if valid_589784 != nil:
    section.add "userId", valid_589784
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
  var valid_589785 = query.getOrDefault("fields")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "fields", valid_589785
  var valid_589786 = query.getOrDefault("quotaUser")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "quotaUser", valid_589786
  var valid_589787 = query.getOrDefault("alt")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = newJString("json"))
  if valid_589787 != nil:
    section.add "alt", valid_589787
  var valid_589788 = query.getOrDefault("oauth_token")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "oauth_token", valid_589788
  var valid_589789 = query.getOrDefault("userIp")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "userIp", valid_589789
  var valid_589790 = query.getOrDefault("key")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "key", valid_589790
  var valid_589791 = query.getOrDefault("prettyPrint")
  valid_589791 = validateParameter(valid_589791, JBool, required = false,
                                 default = newJBool(true))
  if valid_589791 != nil:
    section.add "prettyPrint", valid_589791
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

proc call*(call_589793: Call_GmailUsersSettingsSendAsCreate_589781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589793.validator(path, query, header, formData, body)
  let scheme = call_589793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589793.url(scheme.get, call_589793.host, call_589793.base,
                         call_589793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589793, url, valid)

proc call*(call_589794: Call_GmailUsersSettingsSendAsCreate_589781;
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
  var path_589795 = newJObject()
  var query_589796 = newJObject()
  var body_589797 = newJObject()
  add(query_589796, "fields", newJString(fields))
  add(query_589796, "quotaUser", newJString(quotaUser))
  add(query_589796, "alt", newJString(alt))
  add(query_589796, "oauth_token", newJString(oauthToken))
  add(query_589796, "userIp", newJString(userIp))
  add(query_589796, "key", newJString(key))
  if body != nil:
    body_589797 = body
  add(query_589796, "prettyPrint", newJBool(prettyPrint))
  add(path_589795, "userId", newJString(userId))
  result = call_589794.call(path_589795, query_589796, nil, nil, body_589797)

var gmailUsersSettingsSendAsCreate* = Call_GmailUsersSettingsSendAsCreate_589781(
    name: "gmailUsersSettingsSendAsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsCreate_589782,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsCreate_589783,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsList_589766 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsList_589768(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsList_589767(path: JsonNode; query: JsonNode;
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
  var valid_589769 = path.getOrDefault("userId")
  valid_589769 = validateParameter(valid_589769, JString, required = true,
                                 default = newJString("me"))
  if valid_589769 != nil:
    section.add "userId", valid_589769
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
  var valid_589770 = query.getOrDefault("fields")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "fields", valid_589770
  var valid_589771 = query.getOrDefault("quotaUser")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "quotaUser", valid_589771
  var valid_589772 = query.getOrDefault("alt")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = newJString("json"))
  if valid_589772 != nil:
    section.add "alt", valid_589772
  var valid_589773 = query.getOrDefault("oauth_token")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "oauth_token", valid_589773
  var valid_589774 = query.getOrDefault("userIp")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "userIp", valid_589774
  var valid_589775 = query.getOrDefault("key")
  valid_589775 = validateParameter(valid_589775, JString, required = false,
                                 default = nil)
  if valid_589775 != nil:
    section.add "key", valid_589775
  var valid_589776 = query.getOrDefault("prettyPrint")
  valid_589776 = validateParameter(valid_589776, JBool, required = false,
                                 default = newJBool(true))
  if valid_589776 != nil:
    section.add "prettyPrint", valid_589776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589777: Call_GmailUsersSettingsSendAsList_589766; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
  ## 
  let valid = call_589777.validator(path, query, header, formData, body)
  let scheme = call_589777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589777.url(scheme.get, call_589777.host, call_589777.base,
                         call_589777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589777, url, valid)

proc call*(call_589778: Call_GmailUsersSettingsSendAsList_589766;
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
  var path_589779 = newJObject()
  var query_589780 = newJObject()
  add(query_589780, "fields", newJString(fields))
  add(query_589780, "quotaUser", newJString(quotaUser))
  add(query_589780, "alt", newJString(alt))
  add(query_589780, "oauth_token", newJString(oauthToken))
  add(query_589780, "userIp", newJString(userIp))
  add(query_589780, "key", newJString(key))
  add(query_589780, "prettyPrint", newJBool(prettyPrint))
  add(path_589779, "userId", newJString(userId))
  result = call_589778.call(path_589779, query_589780, nil, nil, nil)

var gmailUsersSettingsSendAsList* = Call_GmailUsersSettingsSendAsList_589766(
    name: "gmailUsersSettingsSendAsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsList_589767,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsList_589768,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsUpdate_589814 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsUpdate_589816(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsUpdate_589815(path: JsonNode;
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
  var valid_589817 = path.getOrDefault("sendAsEmail")
  valid_589817 = validateParameter(valid_589817, JString, required = true,
                                 default = nil)
  if valid_589817 != nil:
    section.add "sendAsEmail", valid_589817
  var valid_589818 = path.getOrDefault("userId")
  valid_589818 = validateParameter(valid_589818, JString, required = true,
                                 default = newJString("me"))
  if valid_589818 != nil:
    section.add "userId", valid_589818
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
  var valid_589819 = query.getOrDefault("fields")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = nil)
  if valid_589819 != nil:
    section.add "fields", valid_589819
  var valid_589820 = query.getOrDefault("quotaUser")
  valid_589820 = validateParameter(valid_589820, JString, required = false,
                                 default = nil)
  if valid_589820 != nil:
    section.add "quotaUser", valid_589820
  var valid_589821 = query.getOrDefault("alt")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = newJString("json"))
  if valid_589821 != nil:
    section.add "alt", valid_589821
  var valid_589822 = query.getOrDefault("oauth_token")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "oauth_token", valid_589822
  var valid_589823 = query.getOrDefault("userIp")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "userIp", valid_589823
  var valid_589824 = query.getOrDefault("key")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "key", valid_589824
  var valid_589825 = query.getOrDefault("prettyPrint")
  valid_589825 = validateParameter(valid_589825, JBool, required = false,
                                 default = newJBool(true))
  if valid_589825 != nil:
    section.add "prettyPrint", valid_589825
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

proc call*(call_589827: Call_GmailUsersSettingsSendAsUpdate_589814; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589827.validator(path, query, header, formData, body)
  let scheme = call_589827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589827.url(scheme.get, call_589827.host, call_589827.base,
                         call_589827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589827, url, valid)

proc call*(call_589828: Call_GmailUsersSettingsSendAsUpdate_589814;
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
  var path_589829 = newJObject()
  var query_589830 = newJObject()
  var body_589831 = newJObject()
  add(query_589830, "fields", newJString(fields))
  add(query_589830, "quotaUser", newJString(quotaUser))
  add(query_589830, "alt", newJString(alt))
  add(path_589829, "sendAsEmail", newJString(sendAsEmail))
  add(query_589830, "oauth_token", newJString(oauthToken))
  add(query_589830, "userIp", newJString(userIp))
  add(query_589830, "key", newJString(key))
  if body != nil:
    body_589831 = body
  add(query_589830, "prettyPrint", newJBool(prettyPrint))
  add(path_589829, "userId", newJString(userId))
  result = call_589828.call(path_589829, query_589830, nil, nil, body_589831)

var gmailUsersSettingsSendAsUpdate* = Call_GmailUsersSettingsSendAsUpdate_589814(
    name: "gmailUsersSettingsSendAsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsUpdate_589815,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsUpdate_589816,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsGet_589798 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsGet_589800(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsGet_589799(path: JsonNode; query: JsonNode;
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
  var valid_589801 = path.getOrDefault("sendAsEmail")
  valid_589801 = validateParameter(valid_589801, JString, required = true,
                                 default = nil)
  if valid_589801 != nil:
    section.add "sendAsEmail", valid_589801
  var valid_589802 = path.getOrDefault("userId")
  valid_589802 = validateParameter(valid_589802, JString, required = true,
                                 default = newJString("me"))
  if valid_589802 != nil:
    section.add "userId", valid_589802
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
  var valid_589803 = query.getOrDefault("fields")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "fields", valid_589803
  var valid_589804 = query.getOrDefault("quotaUser")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "quotaUser", valid_589804
  var valid_589805 = query.getOrDefault("alt")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = newJString("json"))
  if valid_589805 != nil:
    section.add "alt", valid_589805
  var valid_589806 = query.getOrDefault("oauth_token")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "oauth_token", valid_589806
  var valid_589807 = query.getOrDefault("userIp")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "userIp", valid_589807
  var valid_589808 = query.getOrDefault("key")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "key", valid_589808
  var valid_589809 = query.getOrDefault("prettyPrint")
  valid_589809 = validateParameter(valid_589809, JBool, required = false,
                                 default = newJBool(true))
  if valid_589809 != nil:
    section.add "prettyPrint", valid_589809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589810: Call_GmailUsersSettingsSendAsGet_589798; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  let valid = call_589810.validator(path, query, header, formData, body)
  let scheme = call_589810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589810.url(scheme.get, call_589810.host, call_589810.base,
                         call_589810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589810, url, valid)

proc call*(call_589811: Call_GmailUsersSettingsSendAsGet_589798;
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
  var path_589812 = newJObject()
  var query_589813 = newJObject()
  add(query_589813, "fields", newJString(fields))
  add(query_589813, "quotaUser", newJString(quotaUser))
  add(query_589813, "alt", newJString(alt))
  add(path_589812, "sendAsEmail", newJString(sendAsEmail))
  add(query_589813, "oauth_token", newJString(oauthToken))
  add(query_589813, "userIp", newJString(userIp))
  add(query_589813, "key", newJString(key))
  add(query_589813, "prettyPrint", newJBool(prettyPrint))
  add(path_589812, "userId", newJString(userId))
  result = call_589811.call(path_589812, query_589813, nil, nil, nil)

var gmailUsersSettingsSendAsGet* = Call_GmailUsersSettingsSendAsGet_589798(
    name: "gmailUsersSettingsSendAsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsGet_589799,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsGet_589800,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsPatch_589848 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsPatch_589850(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsPatch_589849(path: JsonNode; query: JsonNode;
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
  var valid_589851 = path.getOrDefault("sendAsEmail")
  valid_589851 = validateParameter(valid_589851, JString, required = true,
                                 default = nil)
  if valid_589851 != nil:
    section.add "sendAsEmail", valid_589851
  var valid_589852 = path.getOrDefault("userId")
  valid_589852 = validateParameter(valid_589852, JString, required = true,
                                 default = newJString("me"))
  if valid_589852 != nil:
    section.add "userId", valid_589852
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
  var valid_589853 = query.getOrDefault("fields")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = nil)
  if valid_589853 != nil:
    section.add "fields", valid_589853
  var valid_589854 = query.getOrDefault("quotaUser")
  valid_589854 = validateParameter(valid_589854, JString, required = false,
                                 default = nil)
  if valid_589854 != nil:
    section.add "quotaUser", valid_589854
  var valid_589855 = query.getOrDefault("alt")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = newJString("json"))
  if valid_589855 != nil:
    section.add "alt", valid_589855
  var valid_589856 = query.getOrDefault("oauth_token")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "oauth_token", valid_589856
  var valid_589857 = query.getOrDefault("userIp")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "userIp", valid_589857
  var valid_589858 = query.getOrDefault("key")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = nil)
  if valid_589858 != nil:
    section.add "key", valid_589858
  var valid_589859 = query.getOrDefault("prettyPrint")
  valid_589859 = validateParameter(valid_589859, JBool, required = false,
                                 default = newJBool(true))
  if valid_589859 != nil:
    section.add "prettyPrint", valid_589859
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

proc call*(call_589861: Call_GmailUsersSettingsSendAsPatch_589848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  let valid = call_589861.validator(path, query, header, formData, body)
  let scheme = call_589861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589861.url(scheme.get, call_589861.host, call_589861.base,
                         call_589861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589861, url, valid)

proc call*(call_589862: Call_GmailUsersSettingsSendAsPatch_589848;
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
  var path_589863 = newJObject()
  var query_589864 = newJObject()
  var body_589865 = newJObject()
  add(query_589864, "fields", newJString(fields))
  add(query_589864, "quotaUser", newJString(quotaUser))
  add(query_589864, "alt", newJString(alt))
  add(path_589863, "sendAsEmail", newJString(sendAsEmail))
  add(query_589864, "oauth_token", newJString(oauthToken))
  add(query_589864, "userIp", newJString(userIp))
  add(query_589864, "key", newJString(key))
  if body != nil:
    body_589865 = body
  add(query_589864, "prettyPrint", newJBool(prettyPrint))
  add(path_589863, "userId", newJString(userId))
  result = call_589862.call(path_589863, query_589864, nil, nil, body_589865)

var gmailUsersSettingsSendAsPatch* = Call_GmailUsersSettingsSendAsPatch_589848(
    name: "gmailUsersSettingsSendAsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsPatch_589849,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsPatch_589850,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsDelete_589832 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsDelete_589834(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsDelete_589833(path: JsonNode;
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
  var valid_589835 = path.getOrDefault("sendAsEmail")
  valid_589835 = validateParameter(valid_589835, JString, required = true,
                                 default = nil)
  if valid_589835 != nil:
    section.add "sendAsEmail", valid_589835
  var valid_589836 = path.getOrDefault("userId")
  valid_589836 = validateParameter(valid_589836, JString, required = true,
                                 default = newJString("me"))
  if valid_589836 != nil:
    section.add "userId", valid_589836
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
  var valid_589837 = query.getOrDefault("fields")
  valid_589837 = validateParameter(valid_589837, JString, required = false,
                                 default = nil)
  if valid_589837 != nil:
    section.add "fields", valid_589837
  var valid_589838 = query.getOrDefault("quotaUser")
  valid_589838 = validateParameter(valid_589838, JString, required = false,
                                 default = nil)
  if valid_589838 != nil:
    section.add "quotaUser", valid_589838
  var valid_589839 = query.getOrDefault("alt")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = newJString("json"))
  if valid_589839 != nil:
    section.add "alt", valid_589839
  var valid_589840 = query.getOrDefault("oauth_token")
  valid_589840 = validateParameter(valid_589840, JString, required = false,
                                 default = nil)
  if valid_589840 != nil:
    section.add "oauth_token", valid_589840
  var valid_589841 = query.getOrDefault("userIp")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = nil)
  if valid_589841 != nil:
    section.add "userIp", valid_589841
  var valid_589842 = query.getOrDefault("key")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "key", valid_589842
  var valid_589843 = query.getOrDefault("prettyPrint")
  valid_589843 = validateParameter(valid_589843, JBool, required = false,
                                 default = newJBool(true))
  if valid_589843 != nil:
    section.add "prettyPrint", valid_589843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589844: Call_GmailUsersSettingsSendAsDelete_589832; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589844.validator(path, query, header, formData, body)
  let scheme = call_589844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589844.url(scheme.get, call_589844.host, call_589844.base,
                         call_589844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589844, url, valid)

proc call*(call_589845: Call_GmailUsersSettingsSendAsDelete_589832;
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
  var path_589846 = newJObject()
  var query_589847 = newJObject()
  add(query_589847, "fields", newJString(fields))
  add(query_589847, "quotaUser", newJString(quotaUser))
  add(query_589847, "alt", newJString(alt))
  add(path_589846, "sendAsEmail", newJString(sendAsEmail))
  add(query_589847, "oauth_token", newJString(oauthToken))
  add(query_589847, "userIp", newJString(userIp))
  add(query_589847, "key", newJString(key))
  add(query_589847, "prettyPrint", newJBool(prettyPrint))
  add(path_589846, "userId", newJString(userId))
  result = call_589845.call(path_589846, query_589847, nil, nil, nil)

var gmailUsersSettingsSendAsDelete* = Call_GmailUsersSettingsSendAsDelete_589832(
    name: "gmailUsersSettingsSendAsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsDelete_589833,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsDelete_589834,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoInsert_589882 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsSmimeInfoInsert_589884(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoInsert_589883(path: JsonNode;
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
  var valid_589885 = path.getOrDefault("sendAsEmail")
  valid_589885 = validateParameter(valid_589885, JString, required = true,
                                 default = nil)
  if valid_589885 != nil:
    section.add "sendAsEmail", valid_589885
  var valid_589886 = path.getOrDefault("userId")
  valid_589886 = validateParameter(valid_589886, JString, required = true,
                                 default = newJString("me"))
  if valid_589886 != nil:
    section.add "userId", valid_589886
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
  var valid_589887 = query.getOrDefault("fields")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = nil)
  if valid_589887 != nil:
    section.add "fields", valid_589887
  var valid_589888 = query.getOrDefault("quotaUser")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "quotaUser", valid_589888
  var valid_589889 = query.getOrDefault("alt")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = newJString("json"))
  if valid_589889 != nil:
    section.add "alt", valid_589889
  var valid_589890 = query.getOrDefault("oauth_token")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "oauth_token", valid_589890
  var valid_589891 = query.getOrDefault("userIp")
  valid_589891 = validateParameter(valid_589891, JString, required = false,
                                 default = nil)
  if valid_589891 != nil:
    section.add "userIp", valid_589891
  var valid_589892 = query.getOrDefault("key")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = nil)
  if valid_589892 != nil:
    section.add "key", valid_589892
  var valid_589893 = query.getOrDefault("prettyPrint")
  valid_589893 = validateParameter(valid_589893, JBool, required = false,
                                 default = newJBool(true))
  if valid_589893 != nil:
    section.add "prettyPrint", valid_589893
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

proc call*(call_589895: Call_GmailUsersSettingsSendAsSmimeInfoInsert_589882;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  let valid = call_589895.validator(path, query, header, formData, body)
  let scheme = call_589895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589895.url(scheme.get, call_589895.host, call_589895.base,
                         call_589895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589895, url, valid)

proc call*(call_589896: Call_GmailUsersSettingsSendAsSmimeInfoInsert_589882;
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
  var path_589897 = newJObject()
  var query_589898 = newJObject()
  var body_589899 = newJObject()
  add(query_589898, "fields", newJString(fields))
  add(query_589898, "quotaUser", newJString(quotaUser))
  add(query_589898, "alt", newJString(alt))
  add(path_589897, "sendAsEmail", newJString(sendAsEmail))
  add(query_589898, "oauth_token", newJString(oauthToken))
  add(query_589898, "userIp", newJString(userIp))
  add(query_589898, "key", newJString(key))
  if body != nil:
    body_589899 = body
  add(query_589898, "prettyPrint", newJBool(prettyPrint))
  add(path_589897, "userId", newJString(userId))
  result = call_589896.call(path_589897, query_589898, nil, nil, body_589899)

var gmailUsersSettingsSendAsSmimeInfoInsert* = Call_GmailUsersSettingsSendAsSmimeInfoInsert_589882(
    name: "gmailUsersSettingsSendAsSmimeInfoInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoInsert_589883,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoInsert_589884,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoList_589866 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsSmimeInfoList_589868(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoList_589867(path: JsonNode;
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
  var valid_589869 = path.getOrDefault("sendAsEmail")
  valid_589869 = validateParameter(valid_589869, JString, required = true,
                                 default = nil)
  if valid_589869 != nil:
    section.add "sendAsEmail", valid_589869
  var valid_589870 = path.getOrDefault("userId")
  valid_589870 = validateParameter(valid_589870, JString, required = true,
                                 default = newJString("me"))
  if valid_589870 != nil:
    section.add "userId", valid_589870
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
  var valid_589871 = query.getOrDefault("fields")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = nil)
  if valid_589871 != nil:
    section.add "fields", valid_589871
  var valid_589872 = query.getOrDefault("quotaUser")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "quotaUser", valid_589872
  var valid_589873 = query.getOrDefault("alt")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = newJString("json"))
  if valid_589873 != nil:
    section.add "alt", valid_589873
  var valid_589874 = query.getOrDefault("oauth_token")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "oauth_token", valid_589874
  var valid_589875 = query.getOrDefault("userIp")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = nil)
  if valid_589875 != nil:
    section.add "userIp", valid_589875
  var valid_589876 = query.getOrDefault("key")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "key", valid_589876
  var valid_589877 = query.getOrDefault("prettyPrint")
  valid_589877 = validateParameter(valid_589877, JBool, required = false,
                                 default = newJBool(true))
  if valid_589877 != nil:
    section.add "prettyPrint", valid_589877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589878: Call_GmailUsersSettingsSendAsSmimeInfoList_589866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  let valid = call_589878.validator(path, query, header, formData, body)
  let scheme = call_589878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589878.url(scheme.get, call_589878.host, call_589878.base,
                         call_589878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589878, url, valid)

proc call*(call_589879: Call_GmailUsersSettingsSendAsSmimeInfoList_589866;
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
  var path_589880 = newJObject()
  var query_589881 = newJObject()
  add(query_589881, "fields", newJString(fields))
  add(query_589881, "quotaUser", newJString(quotaUser))
  add(query_589881, "alt", newJString(alt))
  add(path_589880, "sendAsEmail", newJString(sendAsEmail))
  add(query_589881, "oauth_token", newJString(oauthToken))
  add(query_589881, "userIp", newJString(userIp))
  add(query_589881, "key", newJString(key))
  add(query_589881, "prettyPrint", newJBool(prettyPrint))
  add(path_589880, "userId", newJString(userId))
  result = call_589879.call(path_589880, query_589881, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoList* = Call_GmailUsersSettingsSendAsSmimeInfoList_589866(
    name: "gmailUsersSettingsSendAsSmimeInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoList_589867,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoList_589868,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoGet_589900 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsSmimeInfoGet_589902(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoGet_589901(path: JsonNode;
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
  var valid_589903 = path.getOrDefault("sendAsEmail")
  valid_589903 = validateParameter(valid_589903, JString, required = true,
                                 default = nil)
  if valid_589903 != nil:
    section.add "sendAsEmail", valid_589903
  var valid_589904 = path.getOrDefault("id")
  valid_589904 = validateParameter(valid_589904, JString, required = true,
                                 default = nil)
  if valid_589904 != nil:
    section.add "id", valid_589904
  var valid_589905 = path.getOrDefault("userId")
  valid_589905 = validateParameter(valid_589905, JString, required = true,
                                 default = newJString("me"))
  if valid_589905 != nil:
    section.add "userId", valid_589905
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
  var valid_589906 = query.getOrDefault("fields")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "fields", valid_589906
  var valid_589907 = query.getOrDefault("quotaUser")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "quotaUser", valid_589907
  var valid_589908 = query.getOrDefault("alt")
  valid_589908 = validateParameter(valid_589908, JString, required = false,
                                 default = newJString("json"))
  if valid_589908 != nil:
    section.add "alt", valid_589908
  var valid_589909 = query.getOrDefault("oauth_token")
  valid_589909 = validateParameter(valid_589909, JString, required = false,
                                 default = nil)
  if valid_589909 != nil:
    section.add "oauth_token", valid_589909
  var valid_589910 = query.getOrDefault("userIp")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "userIp", valid_589910
  var valid_589911 = query.getOrDefault("key")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = nil)
  if valid_589911 != nil:
    section.add "key", valid_589911
  var valid_589912 = query.getOrDefault("prettyPrint")
  valid_589912 = validateParameter(valid_589912, JBool, required = false,
                                 default = newJBool(true))
  if valid_589912 != nil:
    section.add "prettyPrint", valid_589912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589913: Call_GmailUsersSettingsSendAsSmimeInfoGet_589900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_589913.validator(path, query, header, formData, body)
  let scheme = call_589913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589913.url(scheme.get, call_589913.host, call_589913.base,
                         call_589913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589913, url, valid)

proc call*(call_589914: Call_GmailUsersSettingsSendAsSmimeInfoGet_589900;
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
  var path_589915 = newJObject()
  var query_589916 = newJObject()
  add(query_589916, "fields", newJString(fields))
  add(query_589916, "quotaUser", newJString(quotaUser))
  add(query_589916, "alt", newJString(alt))
  add(path_589915, "sendAsEmail", newJString(sendAsEmail))
  add(query_589916, "oauth_token", newJString(oauthToken))
  add(query_589916, "userIp", newJString(userIp))
  add(path_589915, "id", newJString(id))
  add(query_589916, "key", newJString(key))
  add(query_589916, "prettyPrint", newJBool(prettyPrint))
  add(path_589915, "userId", newJString(userId))
  result = call_589914.call(path_589915, query_589916, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoGet* = Call_GmailUsersSettingsSendAsSmimeInfoGet_589900(
    name: "gmailUsersSettingsSendAsSmimeInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoGet_589901,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoGet_589902,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoDelete_589917 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsSmimeInfoDelete_589919(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoDelete_589918(path: JsonNode;
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
  var valid_589920 = path.getOrDefault("sendAsEmail")
  valid_589920 = validateParameter(valid_589920, JString, required = true,
                                 default = nil)
  if valid_589920 != nil:
    section.add "sendAsEmail", valid_589920
  var valid_589921 = path.getOrDefault("id")
  valid_589921 = validateParameter(valid_589921, JString, required = true,
                                 default = nil)
  if valid_589921 != nil:
    section.add "id", valid_589921
  var valid_589922 = path.getOrDefault("userId")
  valid_589922 = validateParameter(valid_589922, JString, required = true,
                                 default = newJString("me"))
  if valid_589922 != nil:
    section.add "userId", valid_589922
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
  var valid_589923 = query.getOrDefault("fields")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "fields", valid_589923
  var valid_589924 = query.getOrDefault("quotaUser")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = nil)
  if valid_589924 != nil:
    section.add "quotaUser", valid_589924
  var valid_589925 = query.getOrDefault("alt")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = newJString("json"))
  if valid_589925 != nil:
    section.add "alt", valid_589925
  var valid_589926 = query.getOrDefault("oauth_token")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "oauth_token", valid_589926
  var valid_589927 = query.getOrDefault("userIp")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "userIp", valid_589927
  var valid_589928 = query.getOrDefault("key")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "key", valid_589928
  var valid_589929 = query.getOrDefault("prettyPrint")
  valid_589929 = validateParameter(valid_589929, JBool, required = false,
                                 default = newJBool(true))
  if valid_589929 != nil:
    section.add "prettyPrint", valid_589929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589930: Call_GmailUsersSettingsSendAsSmimeInfoDelete_589917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_589930.validator(path, query, header, formData, body)
  let scheme = call_589930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589930.url(scheme.get, call_589930.host, call_589930.base,
                         call_589930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589930, url, valid)

proc call*(call_589931: Call_GmailUsersSettingsSendAsSmimeInfoDelete_589917;
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
  var path_589932 = newJObject()
  var query_589933 = newJObject()
  add(query_589933, "fields", newJString(fields))
  add(query_589933, "quotaUser", newJString(quotaUser))
  add(query_589933, "alt", newJString(alt))
  add(path_589932, "sendAsEmail", newJString(sendAsEmail))
  add(query_589933, "oauth_token", newJString(oauthToken))
  add(query_589933, "userIp", newJString(userIp))
  add(path_589932, "id", newJString(id))
  add(query_589933, "key", newJString(key))
  add(query_589933, "prettyPrint", newJBool(prettyPrint))
  add(path_589932, "userId", newJString(userId))
  result = call_589931.call(path_589932, query_589933, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoDelete* = Call_GmailUsersSettingsSendAsSmimeInfoDelete_589917(
    name: "gmailUsersSettingsSendAsSmimeInfoDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoDelete_589918,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoDelete_589919,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_589934 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsSmimeInfoSetDefault_589936(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_589935(path: JsonNode;
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
  var valid_589937 = path.getOrDefault("sendAsEmail")
  valid_589937 = validateParameter(valid_589937, JString, required = true,
                                 default = nil)
  if valid_589937 != nil:
    section.add "sendAsEmail", valid_589937
  var valid_589938 = path.getOrDefault("id")
  valid_589938 = validateParameter(valid_589938, JString, required = true,
                                 default = nil)
  if valid_589938 != nil:
    section.add "id", valid_589938
  var valid_589939 = path.getOrDefault("userId")
  valid_589939 = validateParameter(valid_589939, JString, required = true,
                                 default = newJString("me"))
  if valid_589939 != nil:
    section.add "userId", valid_589939
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
  var valid_589940 = query.getOrDefault("fields")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "fields", valid_589940
  var valid_589941 = query.getOrDefault("quotaUser")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "quotaUser", valid_589941
  var valid_589942 = query.getOrDefault("alt")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = newJString("json"))
  if valid_589942 != nil:
    section.add "alt", valid_589942
  var valid_589943 = query.getOrDefault("oauth_token")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = nil)
  if valid_589943 != nil:
    section.add "oauth_token", valid_589943
  var valid_589944 = query.getOrDefault("userIp")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "userIp", valid_589944
  var valid_589945 = query.getOrDefault("key")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "key", valid_589945
  var valid_589946 = query.getOrDefault("prettyPrint")
  valid_589946 = validateParameter(valid_589946, JBool, required = false,
                                 default = newJBool(true))
  if valid_589946 != nil:
    section.add "prettyPrint", valid_589946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589947: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_589934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  let valid = call_589947.validator(path, query, header, formData, body)
  let scheme = call_589947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589947.url(scheme.get, call_589947.host, call_589947.base,
                         call_589947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589947, url, valid)

proc call*(call_589948: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_589934;
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
  var path_589949 = newJObject()
  var query_589950 = newJObject()
  add(query_589950, "fields", newJString(fields))
  add(query_589950, "quotaUser", newJString(quotaUser))
  add(query_589950, "alt", newJString(alt))
  add(path_589949, "sendAsEmail", newJString(sendAsEmail))
  add(query_589950, "oauth_token", newJString(oauthToken))
  add(query_589950, "userIp", newJString(userIp))
  add(path_589949, "id", newJString(id))
  add(query_589950, "key", newJString(key))
  add(query_589950, "prettyPrint", newJBool(prettyPrint))
  add(path_589949, "userId", newJString(userId))
  result = call_589948.call(path_589949, query_589950, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoSetDefault* = Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_589934(
    name: "gmailUsersSettingsSendAsSmimeInfoSetDefault",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}/setDefault",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_589935,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoSetDefault_589936,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsVerify_589951 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsSendAsVerify_589953(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsVerify_589952(path: JsonNode;
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
  var valid_589954 = path.getOrDefault("sendAsEmail")
  valid_589954 = validateParameter(valid_589954, JString, required = true,
                                 default = nil)
  if valid_589954 != nil:
    section.add "sendAsEmail", valid_589954
  var valid_589955 = path.getOrDefault("userId")
  valid_589955 = validateParameter(valid_589955, JString, required = true,
                                 default = newJString("me"))
  if valid_589955 != nil:
    section.add "userId", valid_589955
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
  var valid_589956 = query.getOrDefault("fields")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = nil)
  if valid_589956 != nil:
    section.add "fields", valid_589956
  var valid_589957 = query.getOrDefault("quotaUser")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = nil)
  if valid_589957 != nil:
    section.add "quotaUser", valid_589957
  var valid_589958 = query.getOrDefault("alt")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = newJString("json"))
  if valid_589958 != nil:
    section.add "alt", valid_589958
  var valid_589959 = query.getOrDefault("oauth_token")
  valid_589959 = validateParameter(valid_589959, JString, required = false,
                                 default = nil)
  if valid_589959 != nil:
    section.add "oauth_token", valid_589959
  var valid_589960 = query.getOrDefault("userIp")
  valid_589960 = validateParameter(valid_589960, JString, required = false,
                                 default = nil)
  if valid_589960 != nil:
    section.add "userIp", valid_589960
  var valid_589961 = query.getOrDefault("key")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "key", valid_589961
  var valid_589962 = query.getOrDefault("prettyPrint")
  valid_589962 = validateParameter(valid_589962, JBool, required = false,
                                 default = newJBool(true))
  if valid_589962 != nil:
    section.add "prettyPrint", valid_589962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589963: Call_GmailUsersSettingsSendAsVerify_589951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_589963.validator(path, query, header, formData, body)
  let scheme = call_589963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589963.url(scheme.get, call_589963.host, call_589963.base,
                         call_589963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589963, url, valid)

proc call*(call_589964: Call_GmailUsersSettingsSendAsVerify_589951;
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
  var path_589965 = newJObject()
  var query_589966 = newJObject()
  add(query_589966, "fields", newJString(fields))
  add(query_589966, "quotaUser", newJString(quotaUser))
  add(query_589966, "alt", newJString(alt))
  add(path_589965, "sendAsEmail", newJString(sendAsEmail))
  add(query_589966, "oauth_token", newJString(oauthToken))
  add(query_589966, "userIp", newJString(userIp))
  add(query_589966, "key", newJString(key))
  add(query_589966, "prettyPrint", newJBool(prettyPrint))
  add(path_589965, "userId", newJString(userId))
  result = call_589964.call(path_589965, query_589966, nil, nil, nil)

var gmailUsersSettingsSendAsVerify* = Call_GmailUsersSettingsSendAsVerify_589951(
    name: "gmailUsersSettingsSendAsVerify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/verify",
    validator: validate_GmailUsersSettingsSendAsVerify_589952,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsVerify_589953,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateVacation_589982 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsUpdateVacation_589984(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateVacation_589983(path: JsonNode;
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
  var valid_589985 = path.getOrDefault("userId")
  valid_589985 = validateParameter(valid_589985, JString, required = true,
                                 default = newJString("me"))
  if valid_589985 != nil:
    section.add "userId", valid_589985
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
  var valid_589986 = query.getOrDefault("fields")
  valid_589986 = validateParameter(valid_589986, JString, required = false,
                                 default = nil)
  if valid_589986 != nil:
    section.add "fields", valid_589986
  var valid_589987 = query.getOrDefault("quotaUser")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = nil)
  if valid_589987 != nil:
    section.add "quotaUser", valid_589987
  var valid_589988 = query.getOrDefault("alt")
  valid_589988 = validateParameter(valid_589988, JString, required = false,
                                 default = newJString("json"))
  if valid_589988 != nil:
    section.add "alt", valid_589988
  var valid_589989 = query.getOrDefault("oauth_token")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = nil)
  if valid_589989 != nil:
    section.add "oauth_token", valid_589989
  var valid_589990 = query.getOrDefault("userIp")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "userIp", valid_589990
  var valid_589991 = query.getOrDefault("key")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "key", valid_589991
  var valid_589992 = query.getOrDefault("prettyPrint")
  valid_589992 = validateParameter(valid_589992, JBool, required = false,
                                 default = newJBool(true))
  if valid_589992 != nil:
    section.add "prettyPrint", valid_589992
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

proc call*(call_589994: Call_GmailUsersSettingsUpdateVacation_589982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vacation responder settings.
  ## 
  let valid = call_589994.validator(path, query, header, formData, body)
  let scheme = call_589994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589994.url(scheme.get, call_589994.host, call_589994.base,
                         call_589994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589994, url, valid)

proc call*(call_589995: Call_GmailUsersSettingsUpdateVacation_589982;
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
  var path_589996 = newJObject()
  var query_589997 = newJObject()
  var body_589998 = newJObject()
  add(query_589997, "fields", newJString(fields))
  add(query_589997, "quotaUser", newJString(quotaUser))
  add(query_589997, "alt", newJString(alt))
  add(query_589997, "oauth_token", newJString(oauthToken))
  add(query_589997, "userIp", newJString(userIp))
  add(query_589997, "key", newJString(key))
  if body != nil:
    body_589998 = body
  add(query_589997, "prettyPrint", newJBool(prettyPrint))
  add(path_589996, "userId", newJString(userId))
  result = call_589995.call(path_589996, query_589997, nil, nil, body_589998)

var gmailUsersSettingsUpdateVacation* = Call_GmailUsersSettingsUpdateVacation_589982(
    name: "gmailUsersSettingsUpdateVacation", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsUpdateVacation_589983,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateVacation_589984,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetVacation_589967 = ref object of OpenApiRestCall_588457
proc url_GmailUsersSettingsGetVacation_589969(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetVacation_589968(path: JsonNode; query: JsonNode;
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
  var valid_589970 = path.getOrDefault("userId")
  valid_589970 = validateParameter(valid_589970, JString, required = true,
                                 default = newJString("me"))
  if valid_589970 != nil:
    section.add "userId", valid_589970
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
  var valid_589971 = query.getOrDefault("fields")
  valid_589971 = validateParameter(valid_589971, JString, required = false,
                                 default = nil)
  if valid_589971 != nil:
    section.add "fields", valid_589971
  var valid_589972 = query.getOrDefault("quotaUser")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = nil)
  if valid_589972 != nil:
    section.add "quotaUser", valid_589972
  var valid_589973 = query.getOrDefault("alt")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = newJString("json"))
  if valid_589973 != nil:
    section.add "alt", valid_589973
  var valid_589974 = query.getOrDefault("oauth_token")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "oauth_token", valid_589974
  var valid_589975 = query.getOrDefault("userIp")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = nil)
  if valid_589975 != nil:
    section.add "userIp", valid_589975
  var valid_589976 = query.getOrDefault("key")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "key", valid_589976
  var valid_589977 = query.getOrDefault("prettyPrint")
  valid_589977 = validateParameter(valid_589977, JBool, required = false,
                                 default = newJBool(true))
  if valid_589977 != nil:
    section.add "prettyPrint", valid_589977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589978: Call_GmailUsersSettingsGetVacation_589967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets vacation responder settings.
  ## 
  let valid = call_589978.validator(path, query, header, formData, body)
  let scheme = call_589978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589978.url(scheme.get, call_589978.host, call_589978.base,
                         call_589978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589978, url, valid)

proc call*(call_589979: Call_GmailUsersSettingsGetVacation_589967;
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
  var path_589980 = newJObject()
  var query_589981 = newJObject()
  add(query_589981, "fields", newJString(fields))
  add(query_589981, "quotaUser", newJString(quotaUser))
  add(query_589981, "alt", newJString(alt))
  add(query_589981, "oauth_token", newJString(oauthToken))
  add(query_589981, "userIp", newJString(userIp))
  add(query_589981, "key", newJString(key))
  add(query_589981, "prettyPrint", newJBool(prettyPrint))
  add(path_589980, "userId", newJString(userId))
  result = call_589979.call(path_589980, query_589981, nil, nil, nil)

var gmailUsersSettingsGetVacation* = Call_GmailUsersSettingsGetVacation_589967(
    name: "gmailUsersSettingsGetVacation", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsGetVacation_589968,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetVacation_589969,
    schemes: {Scheme.Https})
type
  Call_GmailUsersStop_589999 = ref object of OpenApiRestCall_588457
proc url_GmailUsersStop_590001(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersStop_590000(path: JsonNode; query: JsonNode;
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
  var valid_590002 = path.getOrDefault("userId")
  valid_590002 = validateParameter(valid_590002, JString, required = true,
                                 default = newJString("me"))
  if valid_590002 != nil:
    section.add "userId", valid_590002
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
  var valid_590003 = query.getOrDefault("fields")
  valid_590003 = validateParameter(valid_590003, JString, required = false,
                                 default = nil)
  if valid_590003 != nil:
    section.add "fields", valid_590003
  var valid_590004 = query.getOrDefault("quotaUser")
  valid_590004 = validateParameter(valid_590004, JString, required = false,
                                 default = nil)
  if valid_590004 != nil:
    section.add "quotaUser", valid_590004
  var valid_590005 = query.getOrDefault("alt")
  valid_590005 = validateParameter(valid_590005, JString, required = false,
                                 default = newJString("json"))
  if valid_590005 != nil:
    section.add "alt", valid_590005
  var valid_590006 = query.getOrDefault("oauth_token")
  valid_590006 = validateParameter(valid_590006, JString, required = false,
                                 default = nil)
  if valid_590006 != nil:
    section.add "oauth_token", valid_590006
  var valid_590007 = query.getOrDefault("userIp")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "userIp", valid_590007
  var valid_590008 = query.getOrDefault("key")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "key", valid_590008
  var valid_590009 = query.getOrDefault("prettyPrint")
  valid_590009 = validateParameter(valid_590009, JBool, required = false,
                                 default = newJBool(true))
  if valid_590009 != nil:
    section.add "prettyPrint", valid_590009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590010: Call_GmailUsersStop_589999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop receiving push notifications for the given user mailbox.
  ## 
  let valid = call_590010.validator(path, query, header, formData, body)
  let scheme = call_590010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590010.url(scheme.get, call_590010.host, call_590010.base,
                         call_590010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590010, url, valid)

proc call*(call_590011: Call_GmailUsersStop_589999; fields: string = "";
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
  var path_590012 = newJObject()
  var query_590013 = newJObject()
  add(query_590013, "fields", newJString(fields))
  add(query_590013, "quotaUser", newJString(quotaUser))
  add(query_590013, "alt", newJString(alt))
  add(query_590013, "oauth_token", newJString(oauthToken))
  add(query_590013, "userIp", newJString(userIp))
  add(query_590013, "key", newJString(key))
  add(query_590013, "prettyPrint", newJBool(prettyPrint))
  add(path_590012, "userId", newJString(userId))
  result = call_590011.call(path_590012, query_590013, nil, nil, nil)

var gmailUsersStop* = Call_GmailUsersStop_589999(name: "gmailUsersStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/stop",
    validator: validate_GmailUsersStop_590000, base: "/gmail/v1/users",
    url: url_GmailUsersStop_590001, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsList_590014 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsList_590016(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsList_590015(path: JsonNode; query: JsonNode;
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
  var valid_590017 = path.getOrDefault("userId")
  valid_590017 = validateParameter(valid_590017, JString, required = true,
                                 default = newJString("me"))
  if valid_590017 != nil:
    section.add "userId", valid_590017
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
  var valid_590018 = query.getOrDefault("fields")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "fields", valid_590018
  var valid_590019 = query.getOrDefault("pageToken")
  valid_590019 = validateParameter(valid_590019, JString, required = false,
                                 default = nil)
  if valid_590019 != nil:
    section.add "pageToken", valid_590019
  var valid_590020 = query.getOrDefault("quotaUser")
  valid_590020 = validateParameter(valid_590020, JString, required = false,
                                 default = nil)
  if valid_590020 != nil:
    section.add "quotaUser", valid_590020
  var valid_590021 = query.getOrDefault("alt")
  valid_590021 = validateParameter(valid_590021, JString, required = false,
                                 default = newJString("json"))
  if valid_590021 != nil:
    section.add "alt", valid_590021
  var valid_590022 = query.getOrDefault("oauth_token")
  valid_590022 = validateParameter(valid_590022, JString, required = false,
                                 default = nil)
  if valid_590022 != nil:
    section.add "oauth_token", valid_590022
  var valid_590023 = query.getOrDefault("userIp")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = nil)
  if valid_590023 != nil:
    section.add "userIp", valid_590023
  var valid_590024 = query.getOrDefault("maxResults")
  valid_590024 = validateParameter(valid_590024, JInt, required = false,
                                 default = newJInt(100))
  if valid_590024 != nil:
    section.add "maxResults", valid_590024
  var valid_590025 = query.getOrDefault("includeSpamTrash")
  valid_590025 = validateParameter(valid_590025, JBool, required = false,
                                 default = newJBool(false))
  if valid_590025 != nil:
    section.add "includeSpamTrash", valid_590025
  var valid_590026 = query.getOrDefault("q")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = nil)
  if valid_590026 != nil:
    section.add "q", valid_590026
  var valid_590027 = query.getOrDefault("labelIds")
  valid_590027 = validateParameter(valid_590027, JArray, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "labelIds", valid_590027
  var valid_590028 = query.getOrDefault("key")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "key", valid_590028
  var valid_590029 = query.getOrDefault("prettyPrint")
  valid_590029 = validateParameter(valid_590029, JBool, required = false,
                                 default = newJBool(true))
  if valid_590029 != nil:
    section.add "prettyPrint", valid_590029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590030: Call_GmailUsersThreadsList_590014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the threads in the user's mailbox.
  ## 
  let valid = call_590030.validator(path, query, header, formData, body)
  let scheme = call_590030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590030.url(scheme.get, call_590030.host, call_590030.base,
                         call_590030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590030, url, valid)

proc call*(call_590031: Call_GmailUsersThreadsList_590014; fields: string = "";
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
  var path_590032 = newJObject()
  var query_590033 = newJObject()
  add(query_590033, "fields", newJString(fields))
  add(query_590033, "pageToken", newJString(pageToken))
  add(query_590033, "quotaUser", newJString(quotaUser))
  add(query_590033, "alt", newJString(alt))
  add(query_590033, "oauth_token", newJString(oauthToken))
  add(query_590033, "userIp", newJString(userIp))
  add(query_590033, "maxResults", newJInt(maxResults))
  add(query_590033, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_590033, "q", newJString(q))
  if labelIds != nil:
    query_590033.add "labelIds", labelIds
  add(query_590033, "key", newJString(key))
  add(query_590033, "prettyPrint", newJBool(prettyPrint))
  add(path_590032, "userId", newJString(userId))
  result = call_590031.call(path_590032, query_590033, nil, nil, nil)

var gmailUsersThreadsList* = Call_GmailUsersThreadsList_590014(
    name: "gmailUsersThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads",
    validator: validate_GmailUsersThreadsList_590015, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsList_590016, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsGet_590034 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsGet_590036(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsGet_590035(path: JsonNode; query: JsonNode;
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
  var valid_590037 = path.getOrDefault("id")
  valid_590037 = validateParameter(valid_590037, JString, required = true,
                                 default = nil)
  if valid_590037 != nil:
    section.add "id", valid_590037
  var valid_590038 = path.getOrDefault("userId")
  valid_590038 = validateParameter(valid_590038, JString, required = true,
                                 default = newJString("me"))
  if valid_590038 != nil:
    section.add "userId", valid_590038
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
  var valid_590039 = query.getOrDefault("fields")
  valid_590039 = validateParameter(valid_590039, JString, required = false,
                                 default = nil)
  if valid_590039 != nil:
    section.add "fields", valid_590039
  var valid_590040 = query.getOrDefault("quotaUser")
  valid_590040 = validateParameter(valid_590040, JString, required = false,
                                 default = nil)
  if valid_590040 != nil:
    section.add "quotaUser", valid_590040
  var valid_590041 = query.getOrDefault("alt")
  valid_590041 = validateParameter(valid_590041, JString, required = false,
                                 default = newJString("json"))
  if valid_590041 != nil:
    section.add "alt", valid_590041
  var valid_590042 = query.getOrDefault("oauth_token")
  valid_590042 = validateParameter(valid_590042, JString, required = false,
                                 default = nil)
  if valid_590042 != nil:
    section.add "oauth_token", valid_590042
  var valid_590043 = query.getOrDefault("userIp")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "userIp", valid_590043
  var valid_590044 = query.getOrDefault("metadataHeaders")
  valid_590044 = validateParameter(valid_590044, JArray, required = false,
                                 default = nil)
  if valid_590044 != nil:
    section.add "metadataHeaders", valid_590044
  var valid_590045 = query.getOrDefault("key")
  valid_590045 = validateParameter(valid_590045, JString, required = false,
                                 default = nil)
  if valid_590045 != nil:
    section.add "key", valid_590045
  var valid_590046 = query.getOrDefault("prettyPrint")
  valid_590046 = validateParameter(valid_590046, JBool, required = false,
                                 default = newJBool(true))
  if valid_590046 != nil:
    section.add "prettyPrint", valid_590046
  var valid_590047 = query.getOrDefault("format")
  valid_590047 = validateParameter(valid_590047, JString, required = false,
                                 default = newJString("full"))
  if valid_590047 != nil:
    section.add "format", valid_590047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590048: Call_GmailUsersThreadsGet_590034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified thread.
  ## 
  let valid = call_590048.validator(path, query, header, formData, body)
  let scheme = call_590048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590048.url(scheme.get, call_590048.host, call_590048.base,
                         call_590048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590048, url, valid)

proc call*(call_590049: Call_GmailUsersThreadsGet_590034; id: string;
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
  var path_590050 = newJObject()
  var query_590051 = newJObject()
  add(query_590051, "fields", newJString(fields))
  add(query_590051, "quotaUser", newJString(quotaUser))
  add(query_590051, "alt", newJString(alt))
  add(query_590051, "oauth_token", newJString(oauthToken))
  add(query_590051, "userIp", newJString(userIp))
  if metadataHeaders != nil:
    query_590051.add "metadataHeaders", metadataHeaders
  add(path_590050, "id", newJString(id))
  add(query_590051, "key", newJString(key))
  add(query_590051, "prettyPrint", newJBool(prettyPrint))
  add(query_590051, "format", newJString(format))
  add(path_590050, "userId", newJString(userId))
  result = call_590049.call(path_590050, query_590051, nil, nil, nil)

var gmailUsersThreadsGet* = Call_GmailUsersThreadsGet_590034(
    name: "gmailUsersThreadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsGet_590035, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsGet_590036, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsDelete_590052 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsDelete_590054(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsDelete_590053(path: JsonNode; query: JsonNode;
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
  var valid_590055 = path.getOrDefault("id")
  valid_590055 = validateParameter(valid_590055, JString, required = true,
                                 default = nil)
  if valid_590055 != nil:
    section.add "id", valid_590055
  var valid_590056 = path.getOrDefault("userId")
  valid_590056 = validateParameter(valid_590056, JString, required = true,
                                 default = newJString("me"))
  if valid_590056 != nil:
    section.add "userId", valid_590056
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
  var valid_590057 = query.getOrDefault("fields")
  valid_590057 = validateParameter(valid_590057, JString, required = false,
                                 default = nil)
  if valid_590057 != nil:
    section.add "fields", valid_590057
  var valid_590058 = query.getOrDefault("quotaUser")
  valid_590058 = validateParameter(valid_590058, JString, required = false,
                                 default = nil)
  if valid_590058 != nil:
    section.add "quotaUser", valid_590058
  var valid_590059 = query.getOrDefault("alt")
  valid_590059 = validateParameter(valid_590059, JString, required = false,
                                 default = newJString("json"))
  if valid_590059 != nil:
    section.add "alt", valid_590059
  var valid_590060 = query.getOrDefault("oauth_token")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "oauth_token", valid_590060
  var valid_590061 = query.getOrDefault("userIp")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = nil)
  if valid_590061 != nil:
    section.add "userIp", valid_590061
  var valid_590062 = query.getOrDefault("key")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = nil)
  if valid_590062 != nil:
    section.add "key", valid_590062
  var valid_590063 = query.getOrDefault("prettyPrint")
  valid_590063 = validateParameter(valid_590063, JBool, required = false,
                                 default = newJBool(true))
  if valid_590063 != nil:
    section.add "prettyPrint", valid_590063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590064: Call_GmailUsersThreadsDelete_590052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ## 
  let valid = call_590064.validator(path, query, header, formData, body)
  let scheme = call_590064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590064.url(scheme.get, call_590064.host, call_590064.base,
                         call_590064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590064, url, valid)

proc call*(call_590065: Call_GmailUsersThreadsDelete_590052; id: string;
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
  var path_590066 = newJObject()
  var query_590067 = newJObject()
  add(query_590067, "fields", newJString(fields))
  add(query_590067, "quotaUser", newJString(quotaUser))
  add(query_590067, "alt", newJString(alt))
  add(query_590067, "oauth_token", newJString(oauthToken))
  add(query_590067, "userIp", newJString(userIp))
  add(path_590066, "id", newJString(id))
  add(query_590067, "key", newJString(key))
  add(query_590067, "prettyPrint", newJBool(prettyPrint))
  add(path_590066, "userId", newJString(userId))
  result = call_590065.call(path_590066, query_590067, nil, nil, nil)

var gmailUsersThreadsDelete* = Call_GmailUsersThreadsDelete_590052(
    name: "gmailUsersThreadsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsDelete_590053, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsDelete_590054, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsModify_590068 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsModify_590070(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsModify_590069(path: JsonNode; query: JsonNode;
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
  var valid_590071 = path.getOrDefault("id")
  valid_590071 = validateParameter(valid_590071, JString, required = true,
                                 default = nil)
  if valid_590071 != nil:
    section.add "id", valid_590071
  var valid_590072 = path.getOrDefault("userId")
  valid_590072 = validateParameter(valid_590072, JString, required = true,
                                 default = newJString("me"))
  if valid_590072 != nil:
    section.add "userId", valid_590072
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
  var valid_590073 = query.getOrDefault("fields")
  valid_590073 = validateParameter(valid_590073, JString, required = false,
                                 default = nil)
  if valid_590073 != nil:
    section.add "fields", valid_590073
  var valid_590074 = query.getOrDefault("quotaUser")
  valid_590074 = validateParameter(valid_590074, JString, required = false,
                                 default = nil)
  if valid_590074 != nil:
    section.add "quotaUser", valid_590074
  var valid_590075 = query.getOrDefault("alt")
  valid_590075 = validateParameter(valid_590075, JString, required = false,
                                 default = newJString("json"))
  if valid_590075 != nil:
    section.add "alt", valid_590075
  var valid_590076 = query.getOrDefault("oauth_token")
  valid_590076 = validateParameter(valid_590076, JString, required = false,
                                 default = nil)
  if valid_590076 != nil:
    section.add "oauth_token", valid_590076
  var valid_590077 = query.getOrDefault("userIp")
  valid_590077 = validateParameter(valid_590077, JString, required = false,
                                 default = nil)
  if valid_590077 != nil:
    section.add "userIp", valid_590077
  var valid_590078 = query.getOrDefault("key")
  valid_590078 = validateParameter(valid_590078, JString, required = false,
                                 default = nil)
  if valid_590078 != nil:
    section.add "key", valid_590078
  var valid_590079 = query.getOrDefault("prettyPrint")
  valid_590079 = validateParameter(valid_590079, JBool, required = false,
                                 default = newJBool(true))
  if valid_590079 != nil:
    section.add "prettyPrint", valid_590079
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

proc call*(call_590081: Call_GmailUsersThreadsModify_590068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ## 
  let valid = call_590081.validator(path, query, header, formData, body)
  let scheme = call_590081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590081.url(scheme.get, call_590081.host, call_590081.base,
                         call_590081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590081, url, valid)

proc call*(call_590082: Call_GmailUsersThreadsModify_590068; id: string;
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
  var path_590083 = newJObject()
  var query_590084 = newJObject()
  var body_590085 = newJObject()
  add(query_590084, "fields", newJString(fields))
  add(query_590084, "quotaUser", newJString(quotaUser))
  add(query_590084, "alt", newJString(alt))
  add(query_590084, "oauth_token", newJString(oauthToken))
  add(query_590084, "userIp", newJString(userIp))
  add(path_590083, "id", newJString(id))
  add(query_590084, "key", newJString(key))
  if body != nil:
    body_590085 = body
  add(query_590084, "prettyPrint", newJBool(prettyPrint))
  add(path_590083, "userId", newJString(userId))
  result = call_590082.call(path_590083, query_590084, nil, nil, body_590085)

var gmailUsersThreadsModify* = Call_GmailUsersThreadsModify_590068(
    name: "gmailUsersThreadsModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/modify",
    validator: validate_GmailUsersThreadsModify_590069, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsModify_590070, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsTrash_590086 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsTrash_590088(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsTrash_590087(path: JsonNode; query: JsonNode;
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
  var valid_590089 = path.getOrDefault("id")
  valid_590089 = validateParameter(valid_590089, JString, required = true,
                                 default = nil)
  if valid_590089 != nil:
    section.add "id", valid_590089
  var valid_590090 = path.getOrDefault("userId")
  valid_590090 = validateParameter(valid_590090, JString, required = true,
                                 default = newJString("me"))
  if valid_590090 != nil:
    section.add "userId", valid_590090
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
  var valid_590091 = query.getOrDefault("fields")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "fields", valid_590091
  var valid_590092 = query.getOrDefault("quotaUser")
  valid_590092 = validateParameter(valid_590092, JString, required = false,
                                 default = nil)
  if valid_590092 != nil:
    section.add "quotaUser", valid_590092
  var valid_590093 = query.getOrDefault("alt")
  valid_590093 = validateParameter(valid_590093, JString, required = false,
                                 default = newJString("json"))
  if valid_590093 != nil:
    section.add "alt", valid_590093
  var valid_590094 = query.getOrDefault("oauth_token")
  valid_590094 = validateParameter(valid_590094, JString, required = false,
                                 default = nil)
  if valid_590094 != nil:
    section.add "oauth_token", valid_590094
  var valid_590095 = query.getOrDefault("userIp")
  valid_590095 = validateParameter(valid_590095, JString, required = false,
                                 default = nil)
  if valid_590095 != nil:
    section.add "userIp", valid_590095
  var valid_590096 = query.getOrDefault("key")
  valid_590096 = validateParameter(valid_590096, JString, required = false,
                                 default = nil)
  if valid_590096 != nil:
    section.add "key", valid_590096
  var valid_590097 = query.getOrDefault("prettyPrint")
  valid_590097 = validateParameter(valid_590097, JBool, required = false,
                                 default = newJBool(true))
  if valid_590097 != nil:
    section.add "prettyPrint", valid_590097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590098: Call_GmailUsersThreadsTrash_590086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified thread to the trash.
  ## 
  let valid = call_590098.validator(path, query, header, formData, body)
  let scheme = call_590098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590098.url(scheme.get, call_590098.host, call_590098.base,
                         call_590098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590098, url, valid)

proc call*(call_590099: Call_GmailUsersThreadsTrash_590086; id: string;
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
  var path_590100 = newJObject()
  var query_590101 = newJObject()
  add(query_590101, "fields", newJString(fields))
  add(query_590101, "quotaUser", newJString(quotaUser))
  add(query_590101, "alt", newJString(alt))
  add(query_590101, "oauth_token", newJString(oauthToken))
  add(query_590101, "userIp", newJString(userIp))
  add(path_590100, "id", newJString(id))
  add(query_590101, "key", newJString(key))
  add(query_590101, "prettyPrint", newJBool(prettyPrint))
  add(path_590100, "userId", newJString(userId))
  result = call_590099.call(path_590100, query_590101, nil, nil, nil)

var gmailUsersThreadsTrash* = Call_GmailUsersThreadsTrash_590086(
    name: "gmailUsersThreadsTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/trash",
    validator: validate_GmailUsersThreadsTrash_590087, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsTrash_590088, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsUntrash_590102 = ref object of OpenApiRestCall_588457
proc url_GmailUsersThreadsUntrash_590104(protocol: Scheme; host: string;
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

proc validate_GmailUsersThreadsUntrash_590103(path: JsonNode; query: JsonNode;
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
  var valid_590105 = path.getOrDefault("id")
  valid_590105 = validateParameter(valid_590105, JString, required = true,
                                 default = nil)
  if valid_590105 != nil:
    section.add "id", valid_590105
  var valid_590106 = path.getOrDefault("userId")
  valid_590106 = validateParameter(valid_590106, JString, required = true,
                                 default = newJString("me"))
  if valid_590106 != nil:
    section.add "userId", valid_590106
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
  var valid_590107 = query.getOrDefault("fields")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = nil)
  if valid_590107 != nil:
    section.add "fields", valid_590107
  var valid_590108 = query.getOrDefault("quotaUser")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = nil)
  if valid_590108 != nil:
    section.add "quotaUser", valid_590108
  var valid_590109 = query.getOrDefault("alt")
  valid_590109 = validateParameter(valid_590109, JString, required = false,
                                 default = newJString("json"))
  if valid_590109 != nil:
    section.add "alt", valid_590109
  var valid_590110 = query.getOrDefault("oauth_token")
  valid_590110 = validateParameter(valid_590110, JString, required = false,
                                 default = nil)
  if valid_590110 != nil:
    section.add "oauth_token", valid_590110
  var valid_590111 = query.getOrDefault("userIp")
  valid_590111 = validateParameter(valid_590111, JString, required = false,
                                 default = nil)
  if valid_590111 != nil:
    section.add "userIp", valid_590111
  var valid_590112 = query.getOrDefault("key")
  valid_590112 = validateParameter(valid_590112, JString, required = false,
                                 default = nil)
  if valid_590112 != nil:
    section.add "key", valid_590112
  var valid_590113 = query.getOrDefault("prettyPrint")
  valid_590113 = validateParameter(valid_590113, JBool, required = false,
                                 default = newJBool(true))
  if valid_590113 != nil:
    section.add "prettyPrint", valid_590113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590114: Call_GmailUsersThreadsUntrash_590102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified thread from the trash.
  ## 
  let valid = call_590114.validator(path, query, header, formData, body)
  let scheme = call_590114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590114.url(scheme.get, call_590114.host, call_590114.base,
                         call_590114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590114, url, valid)

proc call*(call_590115: Call_GmailUsersThreadsUntrash_590102; id: string;
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
  var path_590116 = newJObject()
  var query_590117 = newJObject()
  add(query_590117, "fields", newJString(fields))
  add(query_590117, "quotaUser", newJString(quotaUser))
  add(query_590117, "alt", newJString(alt))
  add(query_590117, "oauth_token", newJString(oauthToken))
  add(query_590117, "userIp", newJString(userIp))
  add(path_590116, "id", newJString(id))
  add(query_590117, "key", newJString(key))
  add(query_590117, "prettyPrint", newJBool(prettyPrint))
  add(path_590116, "userId", newJString(userId))
  result = call_590115.call(path_590116, query_590117, nil, nil, nil)

var gmailUsersThreadsUntrash* = Call_GmailUsersThreadsUntrash_590102(
    name: "gmailUsersThreadsUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/untrash",
    validator: validate_GmailUsersThreadsUntrash_590103, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsUntrash_590104, schemes: {Scheme.Https})
type
  Call_GmailUsersWatch_590118 = ref object of OpenApiRestCall_588457
proc url_GmailUsersWatch_590120(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersWatch_590119(path: JsonNode; query: JsonNode;
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
  var valid_590121 = path.getOrDefault("userId")
  valid_590121 = validateParameter(valid_590121, JString, required = true,
                                 default = newJString("me"))
  if valid_590121 != nil:
    section.add "userId", valid_590121
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
  var valid_590122 = query.getOrDefault("fields")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "fields", valid_590122
  var valid_590123 = query.getOrDefault("quotaUser")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "quotaUser", valid_590123
  var valid_590124 = query.getOrDefault("alt")
  valid_590124 = validateParameter(valid_590124, JString, required = false,
                                 default = newJString("json"))
  if valid_590124 != nil:
    section.add "alt", valid_590124
  var valid_590125 = query.getOrDefault("oauth_token")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = nil)
  if valid_590125 != nil:
    section.add "oauth_token", valid_590125
  var valid_590126 = query.getOrDefault("userIp")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "userIp", valid_590126
  var valid_590127 = query.getOrDefault("key")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "key", valid_590127
  var valid_590128 = query.getOrDefault("prettyPrint")
  valid_590128 = validateParameter(valid_590128, JBool, required = false,
                                 default = newJBool(true))
  if valid_590128 != nil:
    section.add "prettyPrint", valid_590128
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

proc call*(call_590130: Call_GmailUsersWatch_590118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set up or update a push notification watch on the given user mailbox.
  ## 
  let valid = call_590130.validator(path, query, header, formData, body)
  let scheme = call_590130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590130.url(scheme.get, call_590130.host, call_590130.base,
                         call_590130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590130, url, valid)

proc call*(call_590131: Call_GmailUsersWatch_590118; fields: string = "";
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
  var path_590132 = newJObject()
  var query_590133 = newJObject()
  var body_590134 = newJObject()
  add(query_590133, "fields", newJString(fields))
  add(query_590133, "quotaUser", newJString(quotaUser))
  add(query_590133, "alt", newJString(alt))
  add(query_590133, "oauth_token", newJString(oauthToken))
  add(query_590133, "userIp", newJString(userIp))
  add(query_590133, "key", newJString(key))
  if body != nil:
    body_590134 = body
  add(query_590133, "prettyPrint", newJBool(prettyPrint))
  add(path_590132, "userId", newJString(userId))
  result = call_590131.call(path_590132, query_590133, nil, nil, body_590134)

var gmailUsersWatch* = Call_GmailUsersWatch_590118(name: "gmailUsersWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/watch",
    validator: validate_GmailUsersWatch_590119, base: "/gmail/v1/users",
    url: url_GmailUsersWatch_590120, schemes: {Scheme.Https})
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
