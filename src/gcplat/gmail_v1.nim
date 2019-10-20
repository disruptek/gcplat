
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
  gcpServiceName = "gmail"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GmailUsersDraftsCreate_578914 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsCreate_578916(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsCreate_578915(path: JsonNode; query: JsonNode;
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
  var valid_578917 = path.getOrDefault("userId")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = newJString("me"))
  if valid_578917 != nil:
    section.add "userId", valid_578917
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
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("userIp")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "userIp", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
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

proc call*(call_578926: Call_GmailUsersDraftsCreate_578914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new draft with the DRAFT label.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_GmailUsersDraftsCreate_578914; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersDraftsCreate
  ## Creates a new draft with the DRAFT label.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "userIp", newJString(userIp))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "userId", newJString(userId))
  if body != nil:
    body_578930 = body
  add(query_578929, "fields", newJString(fields))
  result = call_578927.call(path_578928, query_578929, nil, nil, body_578930)

var gmailUsersDraftsCreate* = Call_GmailUsersDraftsCreate_578914(
    name: "gmailUsersDraftsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsCreate_578915, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsCreate_578916, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsList_578625 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsList_578627(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsList_578626(path: JsonNode; query: JsonNode;
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
  var valid_578766 = path.getOrDefault("userId")
  valid_578766 = validateParameter(valid_578766, JString, required = true,
                                 default = newJString("me"))
  if valid_578766 != nil:
    section.add "userId", valid_578766
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString
  ##    : Only return draft messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread".
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: JBool
  ##                   : Include drafts from SPAM and TRASH in the results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of drafts to return.
  section = newJObject()
  var valid_578767 = query.getOrDefault("key")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "key", valid_578767
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578770 = query.getOrDefault("q")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "q", valid_578770
  var valid_578771 = query.getOrDefault("alt")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = newJString("json"))
  if valid_578771 != nil:
    section.add "alt", valid_578771
  var valid_578772 = query.getOrDefault("userIp")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "userIp", valid_578772
  var valid_578773 = query.getOrDefault("includeSpamTrash")
  valid_578773 = validateParameter(valid_578773, JBool, required = false,
                                 default = newJBool(false))
  if valid_578773 != nil:
    section.add "includeSpamTrash", valid_578773
  var valid_578774 = query.getOrDefault("quotaUser")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "quotaUser", valid_578774
  var valid_578775 = query.getOrDefault("pageToken")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "pageToken", valid_578775
  var valid_578776 = query.getOrDefault("fields")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "fields", valid_578776
  var valid_578778 = query.getOrDefault("maxResults")
  valid_578778 = validateParameter(valid_578778, JInt, required = false,
                                 default = newJInt(100))
  if valid_578778 != nil:
    section.add "maxResults", valid_578778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578801: Call_GmailUsersDraftsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the drafts in the user's mailbox.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_GmailUsersDraftsList_578625; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; q: string = "";
          alt: string = "json"; userIp: string = ""; includeSpamTrash: bool = false;
          quotaUser: string = ""; pageToken: string = ""; userId: string = "me";
          fields: string = ""; maxResults: int = 100): Recallable =
  ## gmailUsersDraftsList
  ## Lists the drafts in the user's mailbox.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string
  ##    : Only return draft messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: bool
  ##                   : Include drafts from SPAM and TRASH in the results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of drafts to return.
  var path_578873 = newJObject()
  var query_578875 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "q", newJString(q))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "pageToken", newJString(pageToken))
  add(path_578873, "userId", newJString(userId))
  add(query_578875, "fields", newJString(fields))
  add(query_578875, "maxResults", newJInt(maxResults))
  result = call_578872.call(path_578873, query_578875, nil, nil, nil)

var gmailUsersDraftsList* = Call_GmailUsersDraftsList_578625(
    name: "gmailUsersDraftsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts",
    validator: validate_GmailUsersDraftsList_578626, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsList_578627, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsSend_578931 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsSend_578933(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsSend_578932(path: JsonNode; query: JsonNode;
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
  var valid_578934 = path.getOrDefault("userId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = newJString("me"))
  if valid_578934 != nil:
    section.add "userId", valid_578934
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
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
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

proc call*(call_578943: Call_GmailUsersDraftsSend_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_GmailUsersDraftsSend_578931; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersDraftsSend
  ## Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "userIp", newJString(userIp))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "userId", newJString(userId))
  if body != nil:
    body_578947 = body
  add(query_578946, "fields", newJString(fields))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var gmailUsersDraftsSend* = Call_GmailUsersDraftsSend_578931(
    name: "gmailUsersDraftsSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/drafts/send",
    validator: validate_GmailUsersDraftsSend_578932, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsSend_578933, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsUpdate_578965 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsUpdate_578967(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsUpdate_578966(path: JsonNode; query: JsonNode;
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
  var valid_578968 = path.getOrDefault("id")
  valid_578968 = validateParameter(valid_578968, JString, required = true,
                                 default = nil)
  if valid_578968 != nil:
    section.add "id", valid_578968
  var valid_578969 = path.getOrDefault("userId")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = newJString("me"))
  if valid_578969 != nil:
    section.add "userId", valid_578969
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
  var valid_578970 = query.getOrDefault("key")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "key", valid_578970
  var valid_578971 = query.getOrDefault("prettyPrint")
  valid_578971 = validateParameter(valid_578971, JBool, required = false,
                                 default = newJBool(true))
  if valid_578971 != nil:
    section.add "prettyPrint", valid_578971
  var valid_578972 = query.getOrDefault("oauth_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "oauth_token", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("userIp")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "userIp", valid_578974
  var valid_578975 = query.getOrDefault("quotaUser")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "quotaUser", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
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

proc call*(call_578978: Call_GmailUsersDraftsUpdate_578965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces a draft's content.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_GmailUsersDraftsUpdate_578965; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersDraftsUpdate
  ## Replaces a draft's content.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the draft to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  var body_578982 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(path_578980, "id", newJString(id))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "userIp", newJString(userIp))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(path_578980, "userId", newJString(userId))
  if body != nil:
    body_578982 = body
  add(query_578981, "fields", newJString(fields))
  result = call_578979.call(path_578980, query_578981, nil, nil, body_578982)

var gmailUsersDraftsUpdate* = Call_GmailUsersDraftsUpdate_578965(
    name: "gmailUsersDraftsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsUpdate_578966, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsUpdate_578967, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsGet_578948 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsGet_578950(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsGet_578949(path: JsonNode; query: JsonNode;
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
  var valid_578951 = path.getOrDefault("id")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "id", valid_578951
  var valid_578952 = path.getOrDefault("userId")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = newJString("me"))
  if valid_578952 != nil:
    section.add "userId", valid_578952
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
  ##   format: JString
  ##         : The format to return the draft in.
  section = newJObject()
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("prettyPrint")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "prettyPrint", valid_578954
  var valid_578955 = query.getOrDefault("oauth_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "oauth_token", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("userIp")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "userIp", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
  var valid_578960 = query.getOrDefault("format")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("full"))
  if valid_578960 != nil:
    section.add "format", valid_578960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578961: Call_GmailUsersDraftsGet_578948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified draft.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_GmailUsersDraftsGet_578948; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""; format: string = "full"): Recallable =
  ## gmailUsersDraftsGet
  ## Gets the specified draft.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the draft to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   format: string
  ##         : The format to return the draft in.
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  add(query_578964, "key", newJString(key))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(path_578963, "id", newJString(id))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(path_578963, "userId", newJString(userId))
  add(query_578964, "fields", newJString(fields))
  add(query_578964, "format", newJString(format))
  result = call_578962.call(path_578963, query_578964, nil, nil, nil)

var gmailUsersDraftsGet* = Call_GmailUsersDraftsGet_578948(
    name: "gmailUsersDraftsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsGet_578949, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsGet_578950, schemes: {Scheme.Https})
type
  Call_GmailUsersDraftsDelete_578983 = ref object of OpenApiRestCall_578355
proc url_GmailUsersDraftsDelete_578985(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersDraftsDelete_578984(path: JsonNode; query: JsonNode;
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
  var valid_578986 = path.getOrDefault("id")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "id", valid_578986
  var valid_578987 = path.getOrDefault("userId")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = newJString("me"))
  if valid_578987 != nil:
    section.add "userId", valid_578987
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
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("userIp")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "userIp", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578995: Call_GmailUsersDraftsDelete_578983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_GmailUsersDraftsDelete_578983; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersDraftsDelete
  ## Immediately and permanently deletes the specified draft. Does not simply trash it.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the draft to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(path_578997, "id", newJString(id))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "userIp", newJString(userIp))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(path_578997, "userId", newJString(userId))
  add(query_578998, "fields", newJString(fields))
  result = call_578996.call(path_578997, query_578998, nil, nil, nil)

var gmailUsersDraftsDelete* = Call_GmailUsersDraftsDelete_578983(
    name: "gmailUsersDraftsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/drafts/{id}",
    validator: validate_GmailUsersDraftsDelete_578984, base: "/gmail/v1/users",
    url: url_GmailUsersDraftsDelete_578985, schemes: {Scheme.Https})
type
  Call_GmailUsersHistoryList_578999 = ref object of OpenApiRestCall_578355
proc url_GmailUsersHistoryList_579001(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersHistoryList_579000(path: JsonNode; query: JsonNode;
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
  var valid_579002 = path.getOrDefault("userId")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = newJString("me"))
  if valid_579002 != nil:
    section.add "userId", valid_579002
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   labelId: JString
  ##          : Only return messages with a label matching the ID.
  ##   startHistoryId: JString
  ##                 : Required. Returns history records after the specified startHistoryId. The supplied startHistoryId should be obtained from the historyId of a message, thread, or previous list response. History IDs increase chronologically but are not contiguous with random gaps in between valid IDs. Supplying an invalid or out of date startHistoryId typically returns an HTTP 404 error code. A historyId is typically valid for at least a week, but in some rare circumstances may be valid for only a few hours. If you receive an HTTP 404 error response, your application should perform a full sync. If you receive no nextPageToken in the response, there are no updates to retrieve and you can store the returned historyId for a future request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   historyTypes: JArray
  ##               : History types to be returned by the function
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of history records to return.
  section = newJObject()
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("labelId")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "labelId", valid_579006
  var valid_579007 = query.getOrDefault("startHistoryId")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "startHistoryId", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("userIp")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "userIp", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("pageToken")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "pageToken", valid_579011
  var valid_579012 = query.getOrDefault("historyTypes")
  valid_579012 = validateParameter(valid_579012, JArray, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "historyTypes", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  var valid_579014 = query.getOrDefault("maxResults")
  valid_579014 = validateParameter(valid_579014, JInt, required = false,
                                 default = newJInt(100))
  if valid_579014 != nil:
    section.add "maxResults", valid_579014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579015: Call_GmailUsersHistoryList_578999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ## 
  let valid = call_579015.validator(path, query, header, formData, body)
  let scheme = call_579015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579015.url(scheme.get, call_579015.host, call_579015.base,
                         call_579015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579015, url, valid)

proc call*(call_579016: Call_GmailUsersHistoryList_578999; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; labelId: string = "";
          startHistoryId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; userId: string = "me";
          historyTypes: JsonNode = nil; fields: string = ""; maxResults: int = 100): Recallable =
  ## gmailUsersHistoryList
  ## Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   labelId: string
  ##          : Only return messages with a label matching the ID.
  ##   startHistoryId: string
  ##                 : Required. Returns history records after the specified startHistoryId. The supplied startHistoryId should be obtained from the historyId of a message, thread, or previous list response. History IDs increase chronologically but are not contiguous with random gaps in between valid IDs. Supplying an invalid or out of date startHistoryId typically returns an HTTP 404 error code. A historyId is typically valid for at least a week, but in some rare circumstances may be valid for only a few hours. If you receive an HTTP 404 error response, your application should perform a full sync. If you receive no nextPageToken in the response, there are no updates to retrieve and you can store the returned historyId for a future request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   historyTypes: JArray
  ##               : History types to be returned by the function
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of history records to return.
  var path_579017 = newJObject()
  var query_579018 = newJObject()
  add(query_579018, "key", newJString(key))
  add(query_579018, "prettyPrint", newJBool(prettyPrint))
  add(query_579018, "oauth_token", newJString(oauthToken))
  add(query_579018, "labelId", newJString(labelId))
  add(query_579018, "startHistoryId", newJString(startHistoryId))
  add(query_579018, "alt", newJString(alt))
  add(query_579018, "userIp", newJString(userIp))
  add(query_579018, "quotaUser", newJString(quotaUser))
  add(query_579018, "pageToken", newJString(pageToken))
  add(path_579017, "userId", newJString(userId))
  if historyTypes != nil:
    query_579018.add "historyTypes", historyTypes
  add(query_579018, "fields", newJString(fields))
  add(query_579018, "maxResults", newJInt(maxResults))
  result = call_579016.call(path_579017, query_579018, nil, nil, nil)

var gmailUsersHistoryList* = Call_GmailUsersHistoryList_578999(
    name: "gmailUsersHistoryList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/history",
    validator: validate_GmailUsersHistoryList_579000, base: "/gmail/v1/users",
    url: url_GmailUsersHistoryList_579001, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsCreate_579034 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsCreate_579036(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsCreate_579035(path: JsonNode; query: JsonNode;
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
  var valid_579037 = path.getOrDefault("userId")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = newJString("me"))
  if valid_579037 != nil:
    section.add "userId", valid_579037
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
  var valid_579038 = query.getOrDefault("key")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "key", valid_579038
  var valid_579039 = query.getOrDefault("prettyPrint")
  valid_579039 = validateParameter(valid_579039, JBool, required = false,
                                 default = newJBool(true))
  if valid_579039 != nil:
    section.add "prettyPrint", valid_579039
  var valid_579040 = query.getOrDefault("oauth_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "oauth_token", valid_579040
  var valid_579041 = query.getOrDefault("alt")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("json"))
  if valid_579041 != nil:
    section.add "alt", valid_579041
  var valid_579042 = query.getOrDefault("userIp")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "userIp", valid_579042
  var valid_579043 = query.getOrDefault("quotaUser")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "quotaUser", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
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

proc call*(call_579046: Call_GmailUsersLabelsCreate_579034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new label.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_GmailUsersLabelsCreate_579034; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersLabelsCreate
  ## Creates a new label.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  var body_579050 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "userIp", newJString(userIp))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(path_579048, "userId", newJString(userId))
  if body != nil:
    body_579050 = body
  add(query_579049, "fields", newJString(fields))
  result = call_579047.call(path_579048, query_579049, nil, nil, body_579050)

var gmailUsersLabelsCreate* = Call_GmailUsersLabelsCreate_579034(
    name: "gmailUsersLabelsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsCreate_579035, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsCreate_579036, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsList_579019 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsList_579021(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsList_579020(path: JsonNode; query: JsonNode;
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
  var valid_579022 = path.getOrDefault("userId")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = newJString("me"))
  if valid_579022 != nil:
    section.add "userId", valid_579022
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
  var valid_579023 = query.getOrDefault("key")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "key", valid_579023
  var valid_579024 = query.getOrDefault("prettyPrint")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "prettyPrint", valid_579024
  var valid_579025 = query.getOrDefault("oauth_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "oauth_token", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("userIp")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "userIp", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579030: Call_GmailUsersLabelsList_579019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all labels in the user's mailbox.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_GmailUsersLabelsList_579019; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersLabelsList
  ## Lists all labels in the user's mailbox.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "userId", newJString(userId))
  add(query_579033, "fields", newJString(fields))
  result = call_579031.call(path_579032, query_579033, nil, nil, nil)

var gmailUsersLabelsList* = Call_GmailUsersLabelsList_579019(
    name: "gmailUsersLabelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels",
    validator: validate_GmailUsersLabelsList_579020, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsList_579021, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsUpdate_579067 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsUpdate_579069(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsUpdate_579068(path: JsonNode; query: JsonNode;
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
  var valid_579070 = path.getOrDefault("id")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "id", valid_579070
  var valid_579071 = path.getOrDefault("userId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = newJString("me"))
  if valid_579071 != nil:
    section.add "userId", valid_579071
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
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("prettyPrint")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "prettyPrint", valid_579073
  var valid_579074 = query.getOrDefault("oauth_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "oauth_token", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("userIp")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "userIp", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
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

proc call*(call_579080: Call_GmailUsersLabelsUpdate_579067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label.
  ## 
  let valid = call_579080.validator(path, query, header, formData, body)
  let scheme = call_579080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579080.url(scheme.get, call_579080.host, call_579080.base,
                         call_579080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579080, url, valid)

proc call*(call_579081: Call_GmailUsersLabelsUpdate_579067; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersLabelsUpdate
  ## Updates the specified label.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the label to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579082 = newJObject()
  var query_579083 = newJObject()
  var body_579084 = newJObject()
  add(query_579083, "key", newJString(key))
  add(query_579083, "prettyPrint", newJBool(prettyPrint))
  add(query_579083, "oauth_token", newJString(oauthToken))
  add(path_579082, "id", newJString(id))
  add(query_579083, "alt", newJString(alt))
  add(query_579083, "userIp", newJString(userIp))
  add(query_579083, "quotaUser", newJString(quotaUser))
  add(path_579082, "userId", newJString(userId))
  if body != nil:
    body_579084 = body
  add(query_579083, "fields", newJString(fields))
  result = call_579081.call(path_579082, query_579083, nil, nil, body_579084)

var gmailUsersLabelsUpdate* = Call_GmailUsersLabelsUpdate_579067(
    name: "gmailUsersLabelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsUpdate_579068, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsUpdate_579069, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsGet_579051 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsGet_579053(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsGet_579052(path: JsonNode; query: JsonNode;
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
  var valid_579054 = path.getOrDefault("id")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "id", valid_579054
  var valid_579055 = path.getOrDefault("userId")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = newJString("me"))
  if valid_579055 != nil:
    section.add "userId", valid_579055
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
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("userIp")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "userIp", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579063: Call_GmailUsersLabelsGet_579051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified label.
  ## 
  let valid = call_579063.validator(path, query, header, formData, body)
  let scheme = call_579063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579063.url(scheme.get, call_579063.host, call_579063.base,
                         call_579063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579063, url, valid)

proc call*(call_579064: Call_GmailUsersLabelsGet_579051; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersLabelsGet
  ## Gets the specified label.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the label to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579065 = newJObject()
  var query_579066 = newJObject()
  add(query_579066, "key", newJString(key))
  add(query_579066, "prettyPrint", newJBool(prettyPrint))
  add(query_579066, "oauth_token", newJString(oauthToken))
  add(path_579065, "id", newJString(id))
  add(query_579066, "alt", newJString(alt))
  add(query_579066, "userIp", newJString(userIp))
  add(query_579066, "quotaUser", newJString(quotaUser))
  add(path_579065, "userId", newJString(userId))
  add(query_579066, "fields", newJString(fields))
  result = call_579064.call(path_579065, query_579066, nil, nil, nil)

var gmailUsersLabelsGet* = Call_GmailUsersLabelsGet_579051(
    name: "gmailUsersLabelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsGet_579052, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsGet_579053, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsPatch_579101 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsPatch_579103(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsPatch_579102(path: JsonNode; query: JsonNode;
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
  var valid_579104 = path.getOrDefault("id")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "id", valid_579104
  var valid_579105 = path.getOrDefault("userId")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = newJString("me"))
  if valid_579105 != nil:
    section.add "userId", valid_579105
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
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("alt")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("json"))
  if valid_579109 != nil:
    section.add "alt", valid_579109
  var valid_579110 = query.getOrDefault("userIp")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "userIp", valid_579110
  var valid_579111 = query.getOrDefault("quotaUser")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "quotaUser", valid_579111
  var valid_579112 = query.getOrDefault("fields")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "fields", valid_579112
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

proc call*(call_579114: Call_GmailUsersLabelsPatch_579101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified label. This method supports patch semantics.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_GmailUsersLabelsPatch_579101; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersLabelsPatch
  ## Updates the specified label. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the label to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  var body_579118 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(path_579116, "id", newJString(id))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "userIp", newJString(userIp))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(path_579116, "userId", newJString(userId))
  if body != nil:
    body_579118 = body
  add(query_579117, "fields", newJString(fields))
  result = call_579115.call(path_579116, query_579117, nil, nil, body_579118)

var gmailUsersLabelsPatch* = Call_GmailUsersLabelsPatch_579101(
    name: "gmailUsersLabelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsPatch_579102, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsPatch_579103, schemes: {Scheme.Https})
type
  Call_GmailUsersLabelsDelete_579085 = ref object of OpenApiRestCall_578355
proc url_GmailUsersLabelsDelete_579087(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersLabelsDelete_579086(path: JsonNode; query: JsonNode;
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
  var valid_579088 = path.getOrDefault("id")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "id", valid_579088
  var valid_579089 = path.getOrDefault("userId")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = newJString("me"))
  if valid_579089 != nil:
    section.add "userId", valid_579089
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("alt")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("json"))
  if valid_579093 != nil:
    section.add "alt", valid_579093
  var valid_579094 = query.getOrDefault("userIp")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "userIp", valid_579094
  var valid_579095 = query.getOrDefault("quotaUser")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "quotaUser", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579097: Call_GmailUsersLabelsDelete_579085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_GmailUsersLabelsDelete_579085; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersLabelsDelete
  ## Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the label to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(path_579099, "id", newJString(id))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "userIp", newJString(userIp))
  add(query_579100, "quotaUser", newJString(quotaUser))
  add(path_579099, "userId", newJString(userId))
  add(query_579100, "fields", newJString(fields))
  result = call_579098.call(path_579099, query_579100, nil, nil, nil)

var gmailUsersLabelsDelete* = Call_GmailUsersLabelsDelete_579085(
    name: "gmailUsersLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/labels/{id}",
    validator: validate_GmailUsersLabelsDelete_579086, base: "/gmail/v1/users",
    url: url_GmailUsersLabelsDelete_579087, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesInsert_579139 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesInsert_579141(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesInsert_579140(path: JsonNode; query: JsonNode;
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
  var valid_579142 = path.getOrDefault("userId")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = newJString("me"))
  if valid_579142 != nil:
    section.add "userId", valid_579142
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
  ##   deleted: JBool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   internalDateSource: JString
  ##                     : Source for Gmail's internal date of the message.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579143 = query.getOrDefault("key")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "key", valid_579143
  var valid_579144 = query.getOrDefault("prettyPrint")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(true))
  if valid_579144 != nil:
    section.add "prettyPrint", valid_579144
  var valid_579145 = query.getOrDefault("oauth_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "oauth_token", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("userIp")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "userIp", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("deleted")
  valid_579149 = validateParameter(valid_579149, JBool, required = false,
                                 default = newJBool(false))
  if valid_579149 != nil:
    section.add "deleted", valid_579149
  var valid_579150 = query.getOrDefault("internalDateSource")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("receivedTime"))
  if valid_579150 != nil:
    section.add "internalDateSource", valid_579150
  var valid_579151 = query.getOrDefault("fields")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "fields", valid_579151
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

proc call*(call_579153: Call_GmailUsersMessagesInsert_579139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_GmailUsersMessagesInsert_579139; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          deleted: bool = false; body: JsonNode = nil;
          internalDateSource: string = "receivedTime"; fields: string = ""): Recallable =
  ## gmailUsersMessagesInsert
  ## Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   deleted: bool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   body: JObject
  ##   internalDateSource: string
  ##                     : Source for Gmail's internal date of the message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  var body_579157 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "userIp", newJString(userIp))
  add(query_579156, "quotaUser", newJString(quotaUser))
  add(path_579155, "userId", newJString(userId))
  add(query_579156, "deleted", newJBool(deleted))
  if body != nil:
    body_579157 = body
  add(query_579156, "internalDateSource", newJString(internalDateSource))
  add(query_579156, "fields", newJString(fields))
  result = call_579154.call(path_579155, query_579156, nil, nil, body_579157)

var gmailUsersMessagesInsert* = Call_GmailUsersMessagesInsert_579139(
    name: "gmailUsersMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesInsert_579140, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesInsert_579141, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesList_579119 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesList_579121(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesList_579120(path: JsonNode; query: JsonNode;
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
  var valid_579122 = path.getOrDefault("userId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = newJString("me"))
  if valid_579122 != nil:
    section.add "userId", valid_579122
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labelIds: JArray
  ##           : Only return messages with labels that match all of the specified label IDs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString
  ##    : Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid:<somemsgid@example.com> is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: JBool
  ##                   : Include messages from SPAM and TRASH in the results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of messages to return.
  section = newJObject()
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("labelIds")
  valid_579124 = validateParameter(valid_579124, JArray, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "labelIds", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("q")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "q", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("userIp")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "userIp", valid_579129
  var valid_579130 = query.getOrDefault("includeSpamTrash")
  valid_579130 = validateParameter(valid_579130, JBool, required = false,
                                 default = newJBool(false))
  if valid_579130 != nil:
    section.add "includeSpamTrash", valid_579130
  var valid_579131 = query.getOrDefault("quotaUser")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "quotaUser", valid_579131
  var valid_579132 = query.getOrDefault("pageToken")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "pageToken", valid_579132
  var valid_579133 = query.getOrDefault("fields")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "fields", valid_579133
  var valid_579134 = query.getOrDefault("maxResults")
  valid_579134 = validateParameter(valid_579134, JInt, required = false,
                                 default = newJInt(100))
  if valid_579134 != nil:
    section.add "maxResults", valid_579134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579135: Call_GmailUsersMessagesList_579119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the messages in the user's mailbox.
  ## 
  let valid = call_579135.validator(path, query, header, formData, body)
  let scheme = call_579135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579135.url(scheme.get, call_579135.host, call_579135.base,
                         call_579135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579135, url, valid)

proc call*(call_579136: Call_GmailUsersMessagesList_579119; key: string = "";
          labelIds: JsonNode = nil; prettyPrint: bool = true; oauthToken: string = "";
          q: string = ""; alt: string = "json"; userIp: string = "";
          includeSpamTrash: bool = false; quotaUser: string = "";
          pageToken: string = ""; userId: string = "me"; fields: string = "";
          maxResults: int = 100): Recallable =
  ## gmailUsersMessagesList
  ## Lists the messages in the user's mailbox.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labelIds: JArray
  ##           : Only return messages with labels that match all of the specified label IDs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string
  ##    : Only return messages matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid:<somemsgid@example.com> is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: bool
  ##                   : Include messages from SPAM and TRASH in the results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of messages to return.
  var path_579137 = newJObject()
  var query_579138 = newJObject()
  add(query_579138, "key", newJString(key))
  if labelIds != nil:
    query_579138.add "labelIds", labelIds
  add(query_579138, "prettyPrint", newJBool(prettyPrint))
  add(query_579138, "oauth_token", newJString(oauthToken))
  add(query_579138, "q", newJString(q))
  add(query_579138, "alt", newJString(alt))
  add(query_579138, "userIp", newJString(userIp))
  add(query_579138, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_579138, "quotaUser", newJString(quotaUser))
  add(query_579138, "pageToken", newJString(pageToken))
  add(path_579137, "userId", newJString(userId))
  add(query_579138, "fields", newJString(fields))
  add(query_579138, "maxResults", newJInt(maxResults))
  result = call_579136.call(path_579137, query_579138, nil, nil, nil)

var gmailUsersMessagesList* = Call_GmailUsersMessagesList_579119(
    name: "gmailUsersMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages",
    validator: validate_GmailUsersMessagesList_579120, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesList_579121, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchDelete_579158 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesBatchDelete_579160(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesBatchDelete_579159(path: JsonNode; query: JsonNode;
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
  var valid_579161 = path.getOrDefault("userId")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = newJString("me"))
  if valid_579161 != nil:
    section.add "userId", valid_579161
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
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("prettyPrint")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "prettyPrint", valid_579163
  var valid_579164 = query.getOrDefault("oauth_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "oauth_token", valid_579164
  var valid_579165 = query.getOrDefault("alt")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = newJString("json"))
  if valid_579165 != nil:
    section.add "alt", valid_579165
  var valid_579166 = query.getOrDefault("userIp")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "userIp", valid_579166
  var valid_579167 = query.getOrDefault("quotaUser")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "quotaUser", valid_579167
  var valid_579168 = query.getOrDefault("fields")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "fields", valid_579168
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

proc call*(call_579170: Call_GmailUsersMessagesBatchDelete_579158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
  ## 
  let valid = call_579170.validator(path, query, header, formData, body)
  let scheme = call_579170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579170.url(scheme.get, call_579170.host, call_579170.base,
                         call_579170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579170, url, valid)

proc call*(call_579171: Call_GmailUsersMessagesBatchDelete_579158;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersMessagesBatchDelete
  ## Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579172 = newJObject()
  var query_579173 = newJObject()
  var body_579174 = newJObject()
  add(query_579173, "key", newJString(key))
  add(query_579173, "prettyPrint", newJBool(prettyPrint))
  add(query_579173, "oauth_token", newJString(oauthToken))
  add(query_579173, "alt", newJString(alt))
  add(query_579173, "userIp", newJString(userIp))
  add(query_579173, "quotaUser", newJString(quotaUser))
  add(path_579172, "userId", newJString(userId))
  if body != nil:
    body_579174 = body
  add(query_579173, "fields", newJString(fields))
  result = call_579171.call(path_579172, query_579173, nil, nil, body_579174)

var gmailUsersMessagesBatchDelete* = Call_GmailUsersMessagesBatchDelete_579158(
    name: "gmailUsersMessagesBatchDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchDelete",
    validator: validate_GmailUsersMessagesBatchDelete_579159,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchDelete_579160,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesBatchModify_579175 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesBatchModify_579177(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesBatchModify_579176(path: JsonNode; query: JsonNode;
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
  var valid_579178 = path.getOrDefault("userId")
  valid_579178 = validateParameter(valid_579178, JString, required = true,
                                 default = newJString("me"))
  if valid_579178 != nil:
    section.add "userId", valid_579178
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
  var valid_579179 = query.getOrDefault("key")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "key", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("alt")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("json"))
  if valid_579182 != nil:
    section.add "alt", valid_579182
  var valid_579183 = query.getOrDefault("userIp")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "userIp", valid_579183
  var valid_579184 = query.getOrDefault("quotaUser")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "quotaUser", valid_579184
  var valid_579185 = query.getOrDefault("fields")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "fields", valid_579185
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

proc call*(call_579187: Call_GmailUsersMessagesBatchModify_579175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified messages.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_GmailUsersMessagesBatchModify_579175;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersMessagesBatchModify
  ## Modifies the labels on the specified messages.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  var body_579191 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "userIp", newJString(userIp))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "userId", newJString(userId))
  if body != nil:
    body_579191 = body
  add(query_579190, "fields", newJString(fields))
  result = call_579188.call(path_579189, query_579190, nil, nil, body_579191)

var gmailUsersMessagesBatchModify* = Call_GmailUsersMessagesBatchModify_579175(
    name: "gmailUsersMessagesBatchModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/batchModify",
    validator: validate_GmailUsersMessagesBatchModify_579176,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesBatchModify_579177,
    schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesImport_579192 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesImport_579194(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesImport_579193(path: JsonNode; query: JsonNode;
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
  var valid_579195 = path.getOrDefault("userId")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = newJString("me"))
  if valid_579195 != nil:
    section.add "userId", valid_579195
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
  ##   processForCalendar: JBool
  ##                     : Process calendar invites in the email and add any extracted meetings to the Google Calendar for this user.
  ##   neverMarkSpam: JBool
  ##                : Ignore the Gmail spam classifier decision and never mark this email as SPAM in the mailbox.
  ##   deleted: JBool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   internalDateSource: JString
  ##                     : Source for Gmail's internal date of the message.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("alt")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("json"))
  if valid_579199 != nil:
    section.add "alt", valid_579199
  var valid_579200 = query.getOrDefault("userIp")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "userIp", valid_579200
  var valid_579201 = query.getOrDefault("quotaUser")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "quotaUser", valid_579201
  var valid_579202 = query.getOrDefault("processForCalendar")
  valid_579202 = validateParameter(valid_579202, JBool, required = false,
                                 default = newJBool(false))
  if valid_579202 != nil:
    section.add "processForCalendar", valid_579202
  var valid_579203 = query.getOrDefault("neverMarkSpam")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(false))
  if valid_579203 != nil:
    section.add "neverMarkSpam", valid_579203
  var valid_579204 = query.getOrDefault("deleted")
  valid_579204 = validateParameter(valid_579204, JBool, required = false,
                                 default = newJBool(false))
  if valid_579204 != nil:
    section.add "deleted", valid_579204
  var valid_579205 = query.getOrDefault("internalDateSource")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("dateHeader"))
  if valid_579205 != nil:
    section.add "internalDateSource", valid_579205
  var valid_579206 = query.getOrDefault("fields")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "fields", valid_579206
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

proc call*(call_579208: Call_GmailUsersMessagesImport_579192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
  ## 
  let valid = call_579208.validator(path, query, header, formData, body)
  let scheme = call_579208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579208.url(scheme.get, call_579208.host, call_579208.base,
                         call_579208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579208, url, valid)

proc call*(call_579209: Call_GmailUsersMessagesImport_579192; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; processForCalendar: bool = false;
          userId: string = "me"; neverMarkSpam: bool = false; deleted: bool = false;
          body: JsonNode = nil; internalDateSource: string = "dateHeader";
          fields: string = ""): Recallable =
  ## gmailUsersMessagesImport
  ## Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
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
  ##   processForCalendar: bool
  ##                     : Process calendar invites in the email and add any extracted meetings to the Google Calendar for this user.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   neverMarkSpam: bool
  ##                : Ignore the Gmail spam classifier decision and never mark this email as SPAM in the mailbox.
  ##   deleted: bool
  ##          : Mark the email as permanently deleted (not TRASH) and only visible in Google Vault to a Vault administrator. Only used for G Suite accounts.
  ##   body: JObject
  ##   internalDateSource: string
  ##                     : Source for Gmail's internal date of the message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579210 = newJObject()
  var query_579211 = newJObject()
  var body_579212 = newJObject()
  add(query_579211, "key", newJString(key))
  add(query_579211, "prettyPrint", newJBool(prettyPrint))
  add(query_579211, "oauth_token", newJString(oauthToken))
  add(query_579211, "alt", newJString(alt))
  add(query_579211, "userIp", newJString(userIp))
  add(query_579211, "quotaUser", newJString(quotaUser))
  add(query_579211, "processForCalendar", newJBool(processForCalendar))
  add(path_579210, "userId", newJString(userId))
  add(query_579211, "neverMarkSpam", newJBool(neverMarkSpam))
  add(query_579211, "deleted", newJBool(deleted))
  if body != nil:
    body_579212 = body
  add(query_579211, "internalDateSource", newJString(internalDateSource))
  add(query_579211, "fields", newJString(fields))
  result = call_579209.call(path_579210, query_579211, nil, nil, body_579212)

var gmailUsersMessagesImport* = Call_GmailUsersMessagesImport_579192(
    name: "gmailUsersMessagesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/import",
    validator: validate_GmailUsersMessagesImport_579193, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesImport_579194, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesSend_579213 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesSend_579215(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesSend_579214(path: JsonNode; query: JsonNode;
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
  var valid_579216 = path.getOrDefault("userId")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = newJString("me"))
  if valid_579216 != nil:
    section.add "userId", valid_579216
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
  var valid_579217 = query.getOrDefault("key")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "key", valid_579217
  var valid_579218 = query.getOrDefault("prettyPrint")
  valid_579218 = validateParameter(valid_579218, JBool, required = false,
                                 default = newJBool(true))
  if valid_579218 != nil:
    section.add "prettyPrint", valid_579218
  var valid_579219 = query.getOrDefault("oauth_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "oauth_token", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("userIp")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "userIp", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("fields")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "fields", valid_579223
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

proc call*(call_579225: Call_GmailUsersMessagesSend_579213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
  ## 
  let valid = call_579225.validator(path, query, header, formData, body)
  let scheme = call_579225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579225.url(scheme.get, call_579225.host, call_579225.base,
                         call_579225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579225, url, valid)

proc call*(call_579226: Call_GmailUsersMessagesSend_579213; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersMessagesSend
  ## Sends the specified message to the recipients in the To, Cc, and Bcc headers.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579227 = newJObject()
  var query_579228 = newJObject()
  var body_579229 = newJObject()
  add(query_579228, "key", newJString(key))
  add(query_579228, "prettyPrint", newJBool(prettyPrint))
  add(query_579228, "oauth_token", newJString(oauthToken))
  add(query_579228, "alt", newJString(alt))
  add(query_579228, "userIp", newJString(userIp))
  add(query_579228, "quotaUser", newJString(quotaUser))
  add(path_579227, "userId", newJString(userId))
  if body != nil:
    body_579229 = body
  add(query_579228, "fields", newJString(fields))
  result = call_579226.call(path_579227, query_579228, nil, nil, body_579229)

var gmailUsersMessagesSend* = Call_GmailUsersMessagesSend_579213(
    name: "gmailUsersMessagesSend", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/send",
    validator: validate_GmailUsersMessagesSend_579214, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesSend_579215, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesGet_579230 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesGet_579232(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesGet_579231(path: JsonNode; query: JsonNode;
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
  var valid_579233 = path.getOrDefault("id")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "id", valid_579233
  var valid_579234 = path.getOrDefault("userId")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = newJString("me"))
  if valid_579234 != nil:
    section.add "userId", valid_579234
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   format: JString
  ##         : The format to return the message in.
  section = newJObject()
  var valid_579235 = query.getOrDefault("key")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "key", valid_579235
  var valid_579236 = query.getOrDefault("prettyPrint")
  valid_579236 = validateParameter(valid_579236, JBool, required = false,
                                 default = newJBool(true))
  if valid_579236 != nil:
    section.add "prettyPrint", valid_579236
  var valid_579237 = query.getOrDefault("oauth_token")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "oauth_token", valid_579237
  var valid_579238 = query.getOrDefault("metadataHeaders")
  valid_579238 = validateParameter(valid_579238, JArray, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "metadataHeaders", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("userIp")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "userIp", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("fields")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fields", valid_579242
  var valid_579243 = query.getOrDefault("format")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = newJString("full"))
  if valid_579243 != nil:
    section.add "format", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_GmailUsersMessagesGet_579230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified message.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_GmailUsersMessagesGet_579230; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          metadataHeaders: JsonNode = nil; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = "";
          format: string = "full"): Recallable =
  ## gmailUsersMessagesGet
  ## Gets the specified message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   id: string (required)
  ##     : The ID of the message to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   format: string
  ##         : The format to return the message in.
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  if metadataHeaders != nil:
    query_579247.add "metadataHeaders", metadataHeaders
  add(path_579246, "id", newJString(id))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(path_579246, "userId", newJString(userId))
  add(query_579247, "fields", newJString(fields))
  add(query_579247, "format", newJString(format))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var gmailUsersMessagesGet* = Call_GmailUsersMessagesGet_579230(
    name: "gmailUsersMessagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesGet_579231, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesGet_579232, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesDelete_579248 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesDelete_579250(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesDelete_579249(path: JsonNode; query: JsonNode;
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
  var valid_579251 = path.getOrDefault("id")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "id", valid_579251
  var valid_579252 = path.getOrDefault("userId")
  valid_579252 = validateParameter(valid_579252, JString, required = true,
                                 default = newJString("me"))
  if valid_579252 != nil:
    section.add "userId", valid_579252
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
  var valid_579253 = query.getOrDefault("key")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "key", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("userIp")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "userIp", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
  var valid_579259 = query.getOrDefault("fields")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "fields", valid_579259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579260: Call_GmailUsersMessagesDelete_579248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ## 
  let valid = call_579260.validator(path, query, header, formData, body)
  let scheme = call_579260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579260.url(scheme.get, call_579260.host, call_579260.base,
                         call_579260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579260, url, valid)

proc call*(call_579261: Call_GmailUsersMessagesDelete_579248; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersMessagesDelete
  ## Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the message to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579262 = newJObject()
  var query_579263 = newJObject()
  add(query_579263, "key", newJString(key))
  add(query_579263, "prettyPrint", newJBool(prettyPrint))
  add(query_579263, "oauth_token", newJString(oauthToken))
  add(path_579262, "id", newJString(id))
  add(query_579263, "alt", newJString(alt))
  add(query_579263, "userIp", newJString(userIp))
  add(query_579263, "quotaUser", newJString(quotaUser))
  add(path_579262, "userId", newJString(userId))
  add(query_579263, "fields", newJString(fields))
  result = call_579261.call(path_579262, query_579263, nil, nil, nil)

var gmailUsersMessagesDelete* = Call_GmailUsersMessagesDelete_579248(
    name: "gmailUsersMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}",
    validator: validate_GmailUsersMessagesDelete_579249, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesDelete_579250, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesModify_579264 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesModify_579266(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesModify_579265(path: JsonNode; query: JsonNode;
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
  var valid_579267 = path.getOrDefault("id")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "id", valid_579267
  var valid_579268 = path.getOrDefault("userId")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = newJString("me"))
  if valid_579268 != nil:
    section.add "userId", valid_579268
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
  var valid_579269 = query.getOrDefault("key")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "key", valid_579269
  var valid_579270 = query.getOrDefault("prettyPrint")
  valid_579270 = validateParameter(valid_579270, JBool, required = false,
                                 default = newJBool(true))
  if valid_579270 != nil:
    section.add "prettyPrint", valid_579270
  var valid_579271 = query.getOrDefault("oauth_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "oauth_token", valid_579271
  var valid_579272 = query.getOrDefault("alt")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("json"))
  if valid_579272 != nil:
    section.add "alt", valid_579272
  var valid_579273 = query.getOrDefault("userIp")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "userIp", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("fields")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "fields", valid_579275
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

proc call*(call_579277: Call_GmailUsersMessagesModify_579264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels on the specified message.
  ## 
  let valid = call_579277.validator(path, query, header, formData, body)
  let scheme = call_579277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579277.url(scheme.get, call_579277.host, call_579277.base,
                         call_579277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579277, url, valid)

proc call*(call_579278: Call_GmailUsersMessagesModify_579264; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersMessagesModify
  ## Modifies the labels on the specified message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the message to modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579279 = newJObject()
  var query_579280 = newJObject()
  var body_579281 = newJObject()
  add(query_579280, "key", newJString(key))
  add(query_579280, "prettyPrint", newJBool(prettyPrint))
  add(query_579280, "oauth_token", newJString(oauthToken))
  add(path_579279, "id", newJString(id))
  add(query_579280, "alt", newJString(alt))
  add(query_579280, "userIp", newJString(userIp))
  add(query_579280, "quotaUser", newJString(quotaUser))
  add(path_579279, "userId", newJString(userId))
  if body != nil:
    body_579281 = body
  add(query_579280, "fields", newJString(fields))
  result = call_579278.call(path_579279, query_579280, nil, nil, body_579281)

var gmailUsersMessagesModify* = Call_GmailUsersMessagesModify_579264(
    name: "gmailUsersMessagesModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/modify",
    validator: validate_GmailUsersMessagesModify_579265, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesModify_579266, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesTrash_579282 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesTrash_579284(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersMessagesTrash_579283(path: JsonNode; query: JsonNode;
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
  var valid_579285 = path.getOrDefault("id")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "id", valid_579285
  var valid_579286 = path.getOrDefault("userId")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = newJString("me"))
  if valid_579286 != nil:
    section.add "userId", valid_579286
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
  var valid_579287 = query.getOrDefault("key")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "key", valid_579287
  var valid_579288 = query.getOrDefault("prettyPrint")
  valid_579288 = validateParameter(valid_579288, JBool, required = false,
                                 default = newJBool(true))
  if valid_579288 != nil:
    section.add "prettyPrint", valid_579288
  var valid_579289 = query.getOrDefault("oauth_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "oauth_token", valid_579289
  var valid_579290 = query.getOrDefault("alt")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("json"))
  if valid_579290 != nil:
    section.add "alt", valid_579290
  var valid_579291 = query.getOrDefault("userIp")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "userIp", valid_579291
  var valid_579292 = query.getOrDefault("quotaUser")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "quotaUser", valid_579292
  var valid_579293 = query.getOrDefault("fields")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "fields", valid_579293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579294: Call_GmailUsersMessagesTrash_579282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified message to the trash.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_GmailUsersMessagesTrash_579282; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersMessagesTrash
  ## Moves the specified message to the trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the message to Trash.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579296 = newJObject()
  var query_579297 = newJObject()
  add(query_579297, "key", newJString(key))
  add(query_579297, "prettyPrint", newJBool(prettyPrint))
  add(query_579297, "oauth_token", newJString(oauthToken))
  add(path_579296, "id", newJString(id))
  add(query_579297, "alt", newJString(alt))
  add(query_579297, "userIp", newJString(userIp))
  add(query_579297, "quotaUser", newJString(quotaUser))
  add(path_579296, "userId", newJString(userId))
  add(query_579297, "fields", newJString(fields))
  result = call_579295.call(path_579296, query_579297, nil, nil, nil)

var gmailUsersMessagesTrash* = Call_GmailUsersMessagesTrash_579282(
    name: "gmailUsersMessagesTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/trash",
    validator: validate_GmailUsersMessagesTrash_579283, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesTrash_579284, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesUntrash_579298 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesUntrash_579300(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesUntrash_579299(path: JsonNode; query: JsonNode;
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
  var valid_579301 = path.getOrDefault("id")
  valid_579301 = validateParameter(valid_579301, JString, required = true,
                                 default = nil)
  if valid_579301 != nil:
    section.add "id", valid_579301
  var valid_579302 = path.getOrDefault("userId")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = newJString("me"))
  if valid_579302 != nil:
    section.add "userId", valid_579302
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
  var valid_579303 = query.getOrDefault("key")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "key", valid_579303
  var valid_579304 = query.getOrDefault("prettyPrint")
  valid_579304 = validateParameter(valid_579304, JBool, required = false,
                                 default = newJBool(true))
  if valid_579304 != nil:
    section.add "prettyPrint", valid_579304
  var valid_579305 = query.getOrDefault("oauth_token")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "oauth_token", valid_579305
  var valid_579306 = query.getOrDefault("alt")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = newJString("json"))
  if valid_579306 != nil:
    section.add "alt", valid_579306
  var valid_579307 = query.getOrDefault("userIp")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "userIp", valid_579307
  var valid_579308 = query.getOrDefault("quotaUser")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "quotaUser", valid_579308
  var valid_579309 = query.getOrDefault("fields")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "fields", valid_579309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579310: Call_GmailUsersMessagesUntrash_579298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified message from the trash.
  ## 
  let valid = call_579310.validator(path, query, header, formData, body)
  let scheme = call_579310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579310.url(scheme.get, call_579310.host, call_579310.base,
                         call_579310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579310, url, valid)

proc call*(call_579311: Call_GmailUsersMessagesUntrash_579298; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersMessagesUntrash
  ## Removes the specified message from the trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the message to remove from Trash.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579312 = newJObject()
  var query_579313 = newJObject()
  add(query_579313, "key", newJString(key))
  add(query_579313, "prettyPrint", newJBool(prettyPrint))
  add(query_579313, "oauth_token", newJString(oauthToken))
  add(path_579312, "id", newJString(id))
  add(query_579313, "alt", newJString(alt))
  add(query_579313, "userIp", newJString(userIp))
  add(query_579313, "quotaUser", newJString(quotaUser))
  add(path_579312, "userId", newJString(userId))
  add(query_579313, "fields", newJString(fields))
  result = call_579311.call(path_579312, query_579313, nil, nil, nil)

var gmailUsersMessagesUntrash* = Call_GmailUsersMessagesUntrash_579298(
    name: "gmailUsersMessagesUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/messages/{id}/untrash",
    validator: validate_GmailUsersMessagesUntrash_579299, base: "/gmail/v1/users",
    url: url_GmailUsersMessagesUntrash_579300, schemes: {Scheme.Https})
type
  Call_GmailUsersMessagesAttachmentsGet_579314 = ref object of OpenApiRestCall_578355
proc url_GmailUsersMessagesAttachmentsGet_579316(protocol: Scheme; host: string;
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

proc validate_GmailUsersMessagesAttachmentsGet_579315(path: JsonNode;
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
  var valid_579317 = path.getOrDefault("messageId")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "messageId", valid_579317
  var valid_579318 = path.getOrDefault("id")
  valid_579318 = validateParameter(valid_579318, JString, required = true,
                                 default = nil)
  if valid_579318 != nil:
    section.add "id", valid_579318
  var valid_579319 = path.getOrDefault("userId")
  valid_579319 = validateParameter(valid_579319, JString, required = true,
                                 default = newJString("me"))
  if valid_579319 != nil:
    section.add "userId", valid_579319
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
  var valid_579320 = query.getOrDefault("key")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "key", valid_579320
  var valid_579321 = query.getOrDefault("prettyPrint")
  valid_579321 = validateParameter(valid_579321, JBool, required = false,
                                 default = newJBool(true))
  if valid_579321 != nil:
    section.add "prettyPrint", valid_579321
  var valid_579322 = query.getOrDefault("oauth_token")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "oauth_token", valid_579322
  var valid_579323 = query.getOrDefault("alt")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = newJString("json"))
  if valid_579323 != nil:
    section.add "alt", valid_579323
  var valid_579324 = query.getOrDefault("userIp")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "userIp", valid_579324
  var valid_579325 = query.getOrDefault("quotaUser")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "quotaUser", valid_579325
  var valid_579326 = query.getOrDefault("fields")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "fields", valid_579326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579327: Call_GmailUsersMessagesAttachmentsGet_579314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified message attachment.
  ## 
  let valid = call_579327.validator(path, query, header, formData, body)
  let scheme = call_579327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579327.url(scheme.get, call_579327.host, call_579327.base,
                         call_579327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579327, url, valid)

proc call*(call_579328: Call_GmailUsersMessagesAttachmentsGet_579314;
          messageId: string; id: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersMessagesAttachmentsGet
  ## Gets the specified message attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   messageId: string (required)
  ##            : The ID of the message containing the attachment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the attachment.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579329 = newJObject()
  var query_579330 = newJObject()
  add(query_579330, "key", newJString(key))
  add(path_579329, "messageId", newJString(messageId))
  add(query_579330, "prettyPrint", newJBool(prettyPrint))
  add(query_579330, "oauth_token", newJString(oauthToken))
  add(path_579329, "id", newJString(id))
  add(query_579330, "alt", newJString(alt))
  add(query_579330, "userIp", newJString(userIp))
  add(query_579330, "quotaUser", newJString(quotaUser))
  add(path_579329, "userId", newJString(userId))
  add(query_579330, "fields", newJString(fields))
  result = call_579328.call(path_579329, query_579330, nil, nil, nil)

var gmailUsersMessagesAttachmentsGet* = Call_GmailUsersMessagesAttachmentsGet_579314(
    name: "gmailUsersMessagesAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/messages/{messageId}/attachments/{id}",
    validator: validate_GmailUsersMessagesAttachmentsGet_579315,
    base: "/gmail/v1/users", url: url_GmailUsersMessagesAttachmentsGet_579316,
    schemes: {Scheme.Https})
type
  Call_GmailUsersGetProfile_579331 = ref object of OpenApiRestCall_578355
proc url_GmailUsersGetProfile_579333(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersGetProfile_579332(path: JsonNode; query: JsonNode;
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
  var valid_579334 = path.getOrDefault("userId")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = newJString("me"))
  if valid_579334 != nil:
    section.add "userId", valid_579334
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
  var valid_579335 = query.getOrDefault("key")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "key", valid_579335
  var valid_579336 = query.getOrDefault("prettyPrint")
  valid_579336 = validateParameter(valid_579336, JBool, required = false,
                                 default = newJBool(true))
  if valid_579336 != nil:
    section.add "prettyPrint", valid_579336
  var valid_579337 = query.getOrDefault("oauth_token")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "oauth_token", valid_579337
  var valid_579338 = query.getOrDefault("alt")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = newJString("json"))
  if valid_579338 != nil:
    section.add "alt", valid_579338
  var valid_579339 = query.getOrDefault("userIp")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "userIp", valid_579339
  var valid_579340 = query.getOrDefault("quotaUser")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "quotaUser", valid_579340
  var valid_579341 = query.getOrDefault("fields")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "fields", valid_579341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579342: Call_GmailUsersGetProfile_579331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current user's Gmail profile.
  ## 
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_GmailUsersGetProfile_579331; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersGetProfile
  ## Gets the current user's Gmail profile.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "userIp", newJString(userIp))
  add(query_579345, "quotaUser", newJString(quotaUser))
  add(path_579344, "userId", newJString(userId))
  add(query_579345, "fields", newJString(fields))
  result = call_579343.call(path_579344, query_579345, nil, nil, nil)

var gmailUsersGetProfile* = Call_GmailUsersGetProfile_579331(
    name: "gmailUsersGetProfile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/profile",
    validator: validate_GmailUsersGetProfile_579332, base: "/gmail/v1/users",
    url: url_GmailUsersGetProfile_579333, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateAutoForwarding_579361 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsUpdateAutoForwarding_579363(protocol: Scheme;
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

proc validate_GmailUsersSettingsUpdateAutoForwarding_579362(path: JsonNode;
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
  var valid_579364 = path.getOrDefault("userId")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = newJString("me"))
  if valid_579364 != nil:
    section.add "userId", valid_579364
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
  var valid_579365 = query.getOrDefault("key")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "key", valid_579365
  var valid_579366 = query.getOrDefault("prettyPrint")
  valid_579366 = validateParameter(valid_579366, JBool, required = false,
                                 default = newJBool(true))
  if valid_579366 != nil:
    section.add "prettyPrint", valid_579366
  var valid_579367 = query.getOrDefault("oauth_token")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "oauth_token", valid_579367
  var valid_579368 = query.getOrDefault("alt")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = newJString("json"))
  if valid_579368 != nil:
    section.add "alt", valid_579368
  var valid_579369 = query.getOrDefault("userIp")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "userIp", valid_579369
  var valid_579370 = query.getOrDefault("quotaUser")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "quotaUser", valid_579370
  var valid_579371 = query.getOrDefault("fields")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "fields", valid_579371
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

proc call*(call_579373: Call_GmailUsersSettingsUpdateAutoForwarding_579361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579373.validator(path, query, header, formData, body)
  let scheme = call_579373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579373.url(scheme.get, call_579373.host, call_579373.base,
                         call_579373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579373, url, valid)

proc call*(call_579374: Call_GmailUsersSettingsUpdateAutoForwarding_579361;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsUpdateAutoForwarding
  ## Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579375 = newJObject()
  var query_579376 = newJObject()
  var body_579377 = newJObject()
  add(query_579376, "key", newJString(key))
  add(query_579376, "prettyPrint", newJBool(prettyPrint))
  add(query_579376, "oauth_token", newJString(oauthToken))
  add(query_579376, "alt", newJString(alt))
  add(query_579376, "userIp", newJString(userIp))
  add(query_579376, "quotaUser", newJString(quotaUser))
  add(path_579375, "userId", newJString(userId))
  if body != nil:
    body_579377 = body
  add(query_579376, "fields", newJString(fields))
  result = call_579374.call(path_579375, query_579376, nil, nil, body_579377)

var gmailUsersSettingsUpdateAutoForwarding* = Call_GmailUsersSettingsUpdateAutoForwarding_579361(
    name: "gmailUsersSettingsUpdateAutoForwarding", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsUpdateAutoForwarding_579362,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateAutoForwarding_579363,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetAutoForwarding_579346 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsGetAutoForwarding_579348(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetAutoForwarding_579347(path: JsonNode;
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
  var valid_579349 = path.getOrDefault("userId")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = newJString("me"))
  if valid_579349 != nil:
    section.add "userId", valid_579349
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
  var valid_579350 = query.getOrDefault("key")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "key", valid_579350
  var valid_579351 = query.getOrDefault("prettyPrint")
  valid_579351 = validateParameter(valid_579351, JBool, required = false,
                                 default = newJBool(true))
  if valid_579351 != nil:
    section.add "prettyPrint", valid_579351
  var valid_579352 = query.getOrDefault("oauth_token")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "oauth_token", valid_579352
  var valid_579353 = query.getOrDefault("alt")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = newJString("json"))
  if valid_579353 != nil:
    section.add "alt", valid_579353
  var valid_579354 = query.getOrDefault("userIp")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "userIp", valid_579354
  var valid_579355 = query.getOrDefault("quotaUser")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "quotaUser", valid_579355
  var valid_579356 = query.getOrDefault("fields")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "fields", valid_579356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579357: Call_GmailUsersSettingsGetAutoForwarding_579346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the auto-forwarding setting for the specified account.
  ## 
  let valid = call_579357.validator(path, query, header, formData, body)
  let scheme = call_579357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579357.url(scheme.get, call_579357.host, call_579357.base,
                         call_579357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579357, url, valid)

proc call*(call_579358: Call_GmailUsersSettingsGetAutoForwarding_579346;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsGetAutoForwarding
  ## Gets the auto-forwarding setting for the specified account.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579359 = newJObject()
  var query_579360 = newJObject()
  add(query_579360, "key", newJString(key))
  add(query_579360, "prettyPrint", newJBool(prettyPrint))
  add(query_579360, "oauth_token", newJString(oauthToken))
  add(query_579360, "alt", newJString(alt))
  add(query_579360, "userIp", newJString(userIp))
  add(query_579360, "quotaUser", newJString(quotaUser))
  add(path_579359, "userId", newJString(userId))
  add(query_579360, "fields", newJString(fields))
  result = call_579358.call(path_579359, query_579360, nil, nil, nil)

var gmailUsersSettingsGetAutoForwarding* = Call_GmailUsersSettingsGetAutoForwarding_579346(
    name: "gmailUsersSettingsGetAutoForwarding", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/autoForwarding",
    validator: validate_GmailUsersSettingsGetAutoForwarding_579347,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetAutoForwarding_579348,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesCreate_579393 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsDelegatesCreate_579395(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesCreate_579394(path: JsonNode;
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
  var valid_579396 = path.getOrDefault("userId")
  valid_579396 = validateParameter(valid_579396, JString, required = true,
                                 default = newJString("me"))
  if valid_579396 != nil:
    section.add "userId", valid_579396
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
  var valid_579397 = query.getOrDefault("key")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "key", valid_579397
  var valid_579398 = query.getOrDefault("prettyPrint")
  valid_579398 = validateParameter(valid_579398, JBool, required = false,
                                 default = newJBool(true))
  if valid_579398 != nil:
    section.add "prettyPrint", valid_579398
  var valid_579399 = query.getOrDefault("oauth_token")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "oauth_token", valid_579399
  var valid_579400 = query.getOrDefault("alt")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = newJString("json"))
  if valid_579400 != nil:
    section.add "alt", valid_579400
  var valid_579401 = query.getOrDefault("userIp")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "userIp", valid_579401
  var valid_579402 = query.getOrDefault("quotaUser")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "quotaUser", valid_579402
  var valid_579403 = query.getOrDefault("fields")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "fields", valid_579403
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

proc call*(call_579405: Call_GmailUsersSettingsDelegatesCreate_579393;
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
  let valid = call_579405.validator(path, query, header, formData, body)
  let scheme = call_579405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579405.url(scheme.get, call_579405.host, call_579405.base,
                         call_579405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579405, url, valid)

proc call*(call_579406: Call_GmailUsersSettingsDelegatesCreate_579393;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579407 = newJObject()
  var query_579408 = newJObject()
  var body_579409 = newJObject()
  add(query_579408, "key", newJString(key))
  add(query_579408, "prettyPrint", newJBool(prettyPrint))
  add(query_579408, "oauth_token", newJString(oauthToken))
  add(query_579408, "alt", newJString(alt))
  add(query_579408, "userIp", newJString(userIp))
  add(query_579408, "quotaUser", newJString(quotaUser))
  add(path_579407, "userId", newJString(userId))
  if body != nil:
    body_579409 = body
  add(query_579408, "fields", newJString(fields))
  result = call_579406.call(path_579407, query_579408, nil, nil, body_579409)

var gmailUsersSettingsDelegatesCreate* = Call_GmailUsersSettingsDelegatesCreate_579393(
    name: "gmailUsersSettingsDelegatesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesCreate_579394,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesCreate_579395,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesList_579378 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsDelegatesList_579380(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesList_579379(path: JsonNode;
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
  var valid_579381 = path.getOrDefault("userId")
  valid_579381 = validateParameter(valid_579381, JString, required = true,
                                 default = newJString("me"))
  if valid_579381 != nil:
    section.add "userId", valid_579381
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
  var valid_579382 = query.getOrDefault("key")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "key", valid_579382
  var valid_579383 = query.getOrDefault("prettyPrint")
  valid_579383 = validateParameter(valid_579383, JBool, required = false,
                                 default = newJBool(true))
  if valid_579383 != nil:
    section.add "prettyPrint", valid_579383
  var valid_579384 = query.getOrDefault("oauth_token")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "oauth_token", valid_579384
  var valid_579385 = query.getOrDefault("alt")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = newJString("json"))
  if valid_579385 != nil:
    section.add "alt", valid_579385
  var valid_579386 = query.getOrDefault("userIp")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "userIp", valid_579386
  var valid_579387 = query.getOrDefault("quotaUser")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "quotaUser", valid_579387
  var valid_579388 = query.getOrDefault("fields")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "fields", valid_579388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579389: Call_GmailUsersSettingsDelegatesList_579378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579389.validator(path, query, header, formData, body)
  let scheme = call_579389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579389.url(scheme.get, call_579389.host, call_579389.base,
                         call_579389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579389, url, valid)

proc call*(call_579390: Call_GmailUsersSettingsDelegatesList_579378;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsDelegatesList
  ## Lists the delegates for the specified account.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579391 = newJObject()
  var query_579392 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "userIp", newJString(userIp))
  add(query_579392, "quotaUser", newJString(quotaUser))
  add(path_579391, "userId", newJString(userId))
  add(query_579392, "fields", newJString(fields))
  result = call_579390.call(path_579391, query_579392, nil, nil, nil)

var gmailUsersSettingsDelegatesList* = Call_GmailUsersSettingsDelegatesList_579378(
    name: "gmailUsersSettingsDelegatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/delegates",
    validator: validate_GmailUsersSettingsDelegatesList_579379,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesList_579380,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesGet_579410 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsDelegatesGet_579412(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesGet_579411(path: JsonNode;
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
  var valid_579413 = path.getOrDefault("delegateEmail")
  valid_579413 = validateParameter(valid_579413, JString, required = true,
                                 default = nil)
  if valid_579413 != nil:
    section.add "delegateEmail", valid_579413
  var valid_579414 = path.getOrDefault("userId")
  valid_579414 = validateParameter(valid_579414, JString, required = true,
                                 default = newJString("me"))
  if valid_579414 != nil:
    section.add "userId", valid_579414
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
  var valid_579415 = query.getOrDefault("key")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "key", valid_579415
  var valid_579416 = query.getOrDefault("prettyPrint")
  valid_579416 = validateParameter(valid_579416, JBool, required = false,
                                 default = newJBool(true))
  if valid_579416 != nil:
    section.add "prettyPrint", valid_579416
  var valid_579417 = query.getOrDefault("oauth_token")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "oauth_token", valid_579417
  var valid_579418 = query.getOrDefault("alt")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = newJString("json"))
  if valid_579418 != nil:
    section.add "alt", valid_579418
  var valid_579419 = query.getOrDefault("userIp")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "userIp", valid_579419
  var valid_579420 = query.getOrDefault("quotaUser")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "quotaUser", valid_579420
  var valid_579421 = query.getOrDefault("fields")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "fields", valid_579421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579422: Call_GmailUsersSettingsDelegatesGet_579410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579422.validator(path, query, header, formData, body)
  let scheme = call_579422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579422.url(scheme.get, call_579422.host, call_579422.base,
                         call_579422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579422, url, valid)

proc call*(call_579423: Call_GmailUsersSettingsDelegatesGet_579410;
          delegateEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsDelegatesGet
  ## Gets the specified delegate.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   delegateEmail: string (required)
  ##                : The email address of the user whose delegate relationship is to be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579424 = newJObject()
  var query_579425 = newJObject()
  add(query_579425, "key", newJString(key))
  add(query_579425, "prettyPrint", newJBool(prettyPrint))
  add(query_579425, "oauth_token", newJString(oauthToken))
  add(path_579424, "delegateEmail", newJString(delegateEmail))
  add(query_579425, "alt", newJString(alt))
  add(query_579425, "userIp", newJString(userIp))
  add(query_579425, "quotaUser", newJString(quotaUser))
  add(path_579424, "userId", newJString(userId))
  add(query_579425, "fields", newJString(fields))
  result = call_579423.call(path_579424, query_579425, nil, nil, nil)

var gmailUsersSettingsDelegatesGet* = Call_GmailUsersSettingsDelegatesGet_579410(
    name: "gmailUsersSettingsDelegatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesGet_579411,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesGet_579412,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsDelegatesDelete_579426 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsDelegatesDelete_579428(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsDelegatesDelete_579427(path: JsonNode;
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
  var valid_579429 = path.getOrDefault("delegateEmail")
  valid_579429 = validateParameter(valid_579429, JString, required = true,
                                 default = nil)
  if valid_579429 != nil:
    section.add "delegateEmail", valid_579429
  var valid_579430 = path.getOrDefault("userId")
  valid_579430 = validateParameter(valid_579430, JString, required = true,
                                 default = newJString("me"))
  if valid_579430 != nil:
    section.add "userId", valid_579430
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
  var valid_579431 = query.getOrDefault("key")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "key", valid_579431
  var valid_579432 = query.getOrDefault("prettyPrint")
  valid_579432 = validateParameter(valid_579432, JBool, required = false,
                                 default = newJBool(true))
  if valid_579432 != nil:
    section.add "prettyPrint", valid_579432
  var valid_579433 = query.getOrDefault("oauth_token")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "oauth_token", valid_579433
  var valid_579434 = query.getOrDefault("alt")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = newJString("json"))
  if valid_579434 != nil:
    section.add "alt", valid_579434
  var valid_579435 = query.getOrDefault("userIp")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "userIp", valid_579435
  var valid_579436 = query.getOrDefault("quotaUser")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "quotaUser", valid_579436
  var valid_579437 = query.getOrDefault("fields")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "fields", valid_579437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579438: Call_GmailUsersSettingsDelegatesDelete_579426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579438.validator(path, query, header, formData, body)
  let scheme = call_579438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579438.url(scheme.get, call_579438.host, call_579438.base,
                         call_579438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579438, url, valid)

proc call*(call_579439: Call_GmailUsersSettingsDelegatesDelete_579426;
          delegateEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsDelegatesDelete
  ## Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.
  ## 
  ## Note that a delegate user must be referred to by their primary email address, and not an email alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   delegateEmail: string (required)
  ##                : The email address of the user to be removed as a delegate.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579440 = newJObject()
  var query_579441 = newJObject()
  add(query_579441, "key", newJString(key))
  add(query_579441, "prettyPrint", newJBool(prettyPrint))
  add(query_579441, "oauth_token", newJString(oauthToken))
  add(path_579440, "delegateEmail", newJString(delegateEmail))
  add(query_579441, "alt", newJString(alt))
  add(query_579441, "userIp", newJString(userIp))
  add(query_579441, "quotaUser", newJString(quotaUser))
  add(path_579440, "userId", newJString(userId))
  add(query_579441, "fields", newJString(fields))
  result = call_579439.call(path_579440, query_579441, nil, nil, nil)

var gmailUsersSettingsDelegatesDelete* = Call_GmailUsersSettingsDelegatesDelete_579426(
    name: "gmailUsersSettingsDelegatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/delegates/{delegateEmail}",
    validator: validate_GmailUsersSettingsDelegatesDelete_579427,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsDelegatesDelete_579428,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersCreate_579457 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsFiltersCreate_579459(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersCreate_579458(path: JsonNode;
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
  var valid_579460 = path.getOrDefault("userId")
  valid_579460 = validateParameter(valid_579460, JString, required = true,
                                 default = newJString("me"))
  if valid_579460 != nil:
    section.add "userId", valid_579460
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
  var valid_579461 = query.getOrDefault("key")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "key", valid_579461
  var valid_579462 = query.getOrDefault("prettyPrint")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(true))
  if valid_579462 != nil:
    section.add "prettyPrint", valid_579462
  var valid_579463 = query.getOrDefault("oauth_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "oauth_token", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("userIp")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "userIp", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("fields")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "fields", valid_579467
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

proc call*(call_579469: Call_GmailUsersSettingsFiltersCreate_579457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a filter.
  ## 
  let valid = call_579469.validator(path, query, header, formData, body)
  let scheme = call_579469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579469.url(scheme.get, call_579469.host, call_579469.base,
                         call_579469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579469, url, valid)

proc call*(call_579470: Call_GmailUsersSettingsFiltersCreate_579457;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsFiltersCreate
  ## Creates a filter.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579471 = newJObject()
  var query_579472 = newJObject()
  var body_579473 = newJObject()
  add(query_579472, "key", newJString(key))
  add(query_579472, "prettyPrint", newJBool(prettyPrint))
  add(query_579472, "oauth_token", newJString(oauthToken))
  add(query_579472, "alt", newJString(alt))
  add(query_579472, "userIp", newJString(userIp))
  add(query_579472, "quotaUser", newJString(quotaUser))
  add(path_579471, "userId", newJString(userId))
  if body != nil:
    body_579473 = body
  add(query_579472, "fields", newJString(fields))
  result = call_579470.call(path_579471, query_579472, nil, nil, body_579473)

var gmailUsersSettingsFiltersCreate* = Call_GmailUsersSettingsFiltersCreate_579457(
    name: "gmailUsersSettingsFiltersCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersCreate_579458,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersCreate_579459,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersList_579442 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsFiltersList_579444(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersList_579443(path: JsonNode; query: JsonNode;
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
  var valid_579445 = path.getOrDefault("userId")
  valid_579445 = validateParameter(valid_579445, JString, required = true,
                                 default = newJString("me"))
  if valid_579445 != nil:
    section.add "userId", valid_579445
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
  var valid_579446 = query.getOrDefault("key")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "key", valid_579446
  var valid_579447 = query.getOrDefault("prettyPrint")
  valid_579447 = validateParameter(valid_579447, JBool, required = false,
                                 default = newJBool(true))
  if valid_579447 != nil:
    section.add "prettyPrint", valid_579447
  var valid_579448 = query.getOrDefault("oauth_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "oauth_token", valid_579448
  var valid_579449 = query.getOrDefault("alt")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = newJString("json"))
  if valid_579449 != nil:
    section.add "alt", valid_579449
  var valid_579450 = query.getOrDefault("userIp")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "userIp", valid_579450
  var valid_579451 = query.getOrDefault("quotaUser")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "quotaUser", valid_579451
  var valid_579452 = query.getOrDefault("fields")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "fields", valid_579452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579453: Call_GmailUsersSettingsFiltersList_579442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the message filters of a Gmail user.
  ## 
  let valid = call_579453.validator(path, query, header, formData, body)
  let scheme = call_579453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579453.url(scheme.get, call_579453.host, call_579453.base,
                         call_579453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579453, url, valid)

proc call*(call_579454: Call_GmailUsersSettingsFiltersList_579442;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsFiltersList
  ## Lists the message filters of a Gmail user.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579455 = newJObject()
  var query_579456 = newJObject()
  add(query_579456, "key", newJString(key))
  add(query_579456, "prettyPrint", newJBool(prettyPrint))
  add(query_579456, "oauth_token", newJString(oauthToken))
  add(query_579456, "alt", newJString(alt))
  add(query_579456, "userIp", newJString(userIp))
  add(query_579456, "quotaUser", newJString(quotaUser))
  add(path_579455, "userId", newJString(userId))
  add(query_579456, "fields", newJString(fields))
  result = call_579454.call(path_579455, query_579456, nil, nil, nil)

var gmailUsersSettingsFiltersList* = Call_GmailUsersSettingsFiltersList_579442(
    name: "gmailUsersSettingsFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters",
    validator: validate_GmailUsersSettingsFiltersList_579443,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersList_579444,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersGet_579474 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsFiltersGet_579476(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersGet_579475(path: JsonNode; query: JsonNode;
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
  var valid_579477 = path.getOrDefault("id")
  valid_579477 = validateParameter(valid_579477, JString, required = true,
                                 default = nil)
  if valid_579477 != nil:
    section.add "id", valid_579477
  var valid_579478 = path.getOrDefault("userId")
  valid_579478 = validateParameter(valid_579478, JString, required = true,
                                 default = newJString("me"))
  if valid_579478 != nil:
    section.add "userId", valid_579478
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
  var valid_579479 = query.getOrDefault("key")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "key", valid_579479
  var valid_579480 = query.getOrDefault("prettyPrint")
  valid_579480 = validateParameter(valid_579480, JBool, required = false,
                                 default = newJBool(true))
  if valid_579480 != nil:
    section.add "prettyPrint", valid_579480
  var valid_579481 = query.getOrDefault("oauth_token")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "oauth_token", valid_579481
  var valid_579482 = query.getOrDefault("alt")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = newJString("json"))
  if valid_579482 != nil:
    section.add "alt", valid_579482
  var valid_579483 = query.getOrDefault("userIp")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "userIp", valid_579483
  var valid_579484 = query.getOrDefault("quotaUser")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "quotaUser", valid_579484
  var valid_579485 = query.getOrDefault("fields")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "fields", valid_579485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579486: Call_GmailUsersSettingsFiltersGet_579474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a filter.
  ## 
  let valid = call_579486.validator(path, query, header, formData, body)
  let scheme = call_579486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579486.url(scheme.get, call_579486.host, call_579486.base,
                         call_579486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579486, url, valid)

proc call*(call_579487: Call_GmailUsersSettingsFiltersGet_579474; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsFiltersGet
  ## Gets a filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the filter to be fetched.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579488 = newJObject()
  var query_579489 = newJObject()
  add(query_579489, "key", newJString(key))
  add(query_579489, "prettyPrint", newJBool(prettyPrint))
  add(query_579489, "oauth_token", newJString(oauthToken))
  add(path_579488, "id", newJString(id))
  add(query_579489, "alt", newJString(alt))
  add(query_579489, "userIp", newJString(userIp))
  add(query_579489, "quotaUser", newJString(quotaUser))
  add(path_579488, "userId", newJString(userId))
  add(query_579489, "fields", newJString(fields))
  result = call_579487.call(path_579488, query_579489, nil, nil, nil)

var gmailUsersSettingsFiltersGet* = Call_GmailUsersSettingsFiltersGet_579474(
    name: "gmailUsersSettingsFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersGet_579475,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersGet_579476,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsFiltersDelete_579490 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsFiltersDelete_579492(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsFiltersDelete_579491(path: JsonNode;
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
  var valid_579493 = path.getOrDefault("id")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "id", valid_579493
  var valid_579494 = path.getOrDefault("userId")
  valid_579494 = validateParameter(valid_579494, JString, required = true,
                                 default = newJString("me"))
  if valid_579494 != nil:
    section.add "userId", valid_579494
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
  var valid_579495 = query.getOrDefault("key")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "key", valid_579495
  var valid_579496 = query.getOrDefault("prettyPrint")
  valid_579496 = validateParameter(valid_579496, JBool, required = false,
                                 default = newJBool(true))
  if valid_579496 != nil:
    section.add "prettyPrint", valid_579496
  var valid_579497 = query.getOrDefault("oauth_token")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "oauth_token", valid_579497
  var valid_579498 = query.getOrDefault("alt")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = newJString("json"))
  if valid_579498 != nil:
    section.add "alt", valid_579498
  var valid_579499 = query.getOrDefault("userIp")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "userIp", valid_579499
  var valid_579500 = query.getOrDefault("quotaUser")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "quotaUser", valid_579500
  var valid_579501 = query.getOrDefault("fields")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "fields", valid_579501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579502: Call_GmailUsersSettingsFiltersDelete_579490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a filter.
  ## 
  let valid = call_579502.validator(path, query, header, formData, body)
  let scheme = call_579502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579502.url(scheme.get, call_579502.host, call_579502.base,
                         call_579502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579502, url, valid)

proc call*(call_579503: Call_GmailUsersSettingsFiltersDelete_579490; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsFiltersDelete
  ## Deletes a filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the filter to be deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579504 = newJObject()
  var query_579505 = newJObject()
  add(query_579505, "key", newJString(key))
  add(query_579505, "prettyPrint", newJBool(prettyPrint))
  add(query_579505, "oauth_token", newJString(oauthToken))
  add(path_579504, "id", newJString(id))
  add(query_579505, "alt", newJString(alt))
  add(query_579505, "userIp", newJString(userIp))
  add(query_579505, "quotaUser", newJString(quotaUser))
  add(path_579504, "userId", newJString(userId))
  add(query_579505, "fields", newJString(fields))
  result = call_579503.call(path_579504, query_579505, nil, nil, nil)

var gmailUsersSettingsFiltersDelete* = Call_GmailUsersSettingsFiltersDelete_579490(
    name: "gmailUsersSettingsFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/filters/{id}",
    validator: validate_GmailUsersSettingsFiltersDelete_579491,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsFiltersDelete_579492,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesCreate_579521 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsForwardingAddressesCreate_579523(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesCreate_579522(path: JsonNode;
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
  var valid_579524 = path.getOrDefault("userId")
  valid_579524 = validateParameter(valid_579524, JString, required = true,
                                 default = newJString("me"))
  if valid_579524 != nil:
    section.add "userId", valid_579524
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
  var valid_579525 = query.getOrDefault("key")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "key", valid_579525
  var valid_579526 = query.getOrDefault("prettyPrint")
  valid_579526 = validateParameter(valid_579526, JBool, required = false,
                                 default = newJBool(true))
  if valid_579526 != nil:
    section.add "prettyPrint", valid_579526
  var valid_579527 = query.getOrDefault("oauth_token")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "oauth_token", valid_579527
  var valid_579528 = query.getOrDefault("alt")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = newJString("json"))
  if valid_579528 != nil:
    section.add "alt", valid_579528
  var valid_579529 = query.getOrDefault("userIp")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "userIp", valid_579529
  var valid_579530 = query.getOrDefault("quotaUser")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "quotaUser", valid_579530
  var valid_579531 = query.getOrDefault("fields")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "fields", valid_579531
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

proc call*(call_579533: Call_GmailUsersSettingsForwardingAddressesCreate_579521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579533.validator(path, query, header, formData, body)
  let scheme = call_579533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579533.url(scheme.get, call_579533.host, call_579533.base,
                         call_579533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579533, url, valid)

proc call*(call_579534: Call_GmailUsersSettingsForwardingAddressesCreate_579521;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsForwardingAddressesCreate
  ## Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579535 = newJObject()
  var query_579536 = newJObject()
  var body_579537 = newJObject()
  add(query_579536, "key", newJString(key))
  add(query_579536, "prettyPrint", newJBool(prettyPrint))
  add(query_579536, "oauth_token", newJString(oauthToken))
  add(query_579536, "alt", newJString(alt))
  add(query_579536, "userIp", newJString(userIp))
  add(query_579536, "quotaUser", newJString(quotaUser))
  add(path_579535, "userId", newJString(userId))
  if body != nil:
    body_579537 = body
  add(query_579536, "fields", newJString(fields))
  result = call_579534.call(path_579535, query_579536, nil, nil, body_579537)

var gmailUsersSettingsForwardingAddressesCreate* = Call_GmailUsersSettingsForwardingAddressesCreate_579521(
    name: "gmailUsersSettingsForwardingAddressesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesCreate_579522,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesCreate_579523,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesList_579506 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsForwardingAddressesList_579508(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesList_579507(path: JsonNode;
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
  var valid_579509 = path.getOrDefault("userId")
  valid_579509 = validateParameter(valid_579509, JString, required = true,
                                 default = newJString("me"))
  if valid_579509 != nil:
    section.add "userId", valid_579509
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
  var valid_579510 = query.getOrDefault("key")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "key", valid_579510
  var valid_579511 = query.getOrDefault("prettyPrint")
  valid_579511 = validateParameter(valid_579511, JBool, required = false,
                                 default = newJBool(true))
  if valid_579511 != nil:
    section.add "prettyPrint", valid_579511
  var valid_579512 = query.getOrDefault("oauth_token")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "oauth_token", valid_579512
  var valid_579513 = query.getOrDefault("alt")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = newJString("json"))
  if valid_579513 != nil:
    section.add "alt", valid_579513
  var valid_579514 = query.getOrDefault("userIp")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "userIp", valid_579514
  var valid_579515 = query.getOrDefault("quotaUser")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "quotaUser", valid_579515
  var valid_579516 = query.getOrDefault("fields")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "fields", valid_579516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579517: Call_GmailUsersSettingsForwardingAddressesList_579506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the forwarding addresses for the specified account.
  ## 
  let valid = call_579517.validator(path, query, header, formData, body)
  let scheme = call_579517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579517.url(scheme.get, call_579517.host, call_579517.base,
                         call_579517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579517, url, valid)

proc call*(call_579518: Call_GmailUsersSettingsForwardingAddressesList_579506;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsForwardingAddressesList
  ## Lists the forwarding addresses for the specified account.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579519 = newJObject()
  var query_579520 = newJObject()
  add(query_579520, "key", newJString(key))
  add(query_579520, "prettyPrint", newJBool(prettyPrint))
  add(query_579520, "oauth_token", newJString(oauthToken))
  add(query_579520, "alt", newJString(alt))
  add(query_579520, "userIp", newJString(userIp))
  add(query_579520, "quotaUser", newJString(quotaUser))
  add(path_579519, "userId", newJString(userId))
  add(query_579520, "fields", newJString(fields))
  result = call_579518.call(path_579519, query_579520, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesList* = Call_GmailUsersSettingsForwardingAddressesList_579506(
    name: "gmailUsersSettingsForwardingAddressesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/forwardingAddresses",
    validator: validate_GmailUsersSettingsForwardingAddressesList_579507,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesList_579508,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesGet_579538 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsForwardingAddressesGet_579540(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesGet_579539(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified forwarding address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   forwardingEmail: JString (required)
  ##                  : The forwarding address to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579541 = path.getOrDefault("userId")
  valid_579541 = validateParameter(valid_579541, JString, required = true,
                                 default = newJString("me"))
  if valid_579541 != nil:
    section.add "userId", valid_579541
  var valid_579542 = path.getOrDefault("forwardingEmail")
  valid_579542 = validateParameter(valid_579542, JString, required = true,
                                 default = nil)
  if valid_579542 != nil:
    section.add "forwardingEmail", valid_579542
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
  var valid_579543 = query.getOrDefault("key")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "key", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  var valid_579546 = query.getOrDefault("alt")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = newJString("json"))
  if valid_579546 != nil:
    section.add "alt", valid_579546
  var valid_579547 = query.getOrDefault("userIp")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "userIp", valid_579547
  var valid_579548 = query.getOrDefault("quotaUser")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "quotaUser", valid_579548
  var valid_579549 = query.getOrDefault("fields")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "fields", valid_579549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579550: Call_GmailUsersSettingsForwardingAddressesGet_579538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified forwarding address.
  ## 
  let valid = call_579550.validator(path, query, header, formData, body)
  let scheme = call_579550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579550.url(scheme.get, call_579550.host, call_579550.base,
                         call_579550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579550, url, valid)

proc call*(call_579551: Call_GmailUsersSettingsForwardingAddressesGet_579538;
          forwardingEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsForwardingAddressesGet
  ## Gets the specified forwarding address.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   forwardingEmail: string (required)
  ##                  : The forwarding address to be retrieved.
  var path_579552 = newJObject()
  var query_579553 = newJObject()
  add(query_579553, "key", newJString(key))
  add(query_579553, "prettyPrint", newJBool(prettyPrint))
  add(query_579553, "oauth_token", newJString(oauthToken))
  add(query_579553, "alt", newJString(alt))
  add(query_579553, "userIp", newJString(userIp))
  add(query_579553, "quotaUser", newJString(quotaUser))
  add(path_579552, "userId", newJString(userId))
  add(query_579553, "fields", newJString(fields))
  add(path_579552, "forwardingEmail", newJString(forwardingEmail))
  result = call_579551.call(path_579552, query_579553, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesGet* = Call_GmailUsersSettingsForwardingAddressesGet_579538(
    name: "gmailUsersSettingsForwardingAddressesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesGet_579539,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesGet_579540,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsForwardingAddressesDelete_579554 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsForwardingAddressesDelete_579556(protocol: Scheme;
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

proc validate_GmailUsersSettingsForwardingAddressesDelete_579555(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   forwardingEmail: JString (required)
  ##                  : The forwarding address to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579557 = path.getOrDefault("userId")
  valid_579557 = validateParameter(valid_579557, JString, required = true,
                                 default = newJString("me"))
  if valid_579557 != nil:
    section.add "userId", valid_579557
  var valid_579558 = path.getOrDefault("forwardingEmail")
  valid_579558 = validateParameter(valid_579558, JString, required = true,
                                 default = nil)
  if valid_579558 != nil:
    section.add "forwardingEmail", valid_579558
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
  var valid_579559 = query.getOrDefault("key")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "key", valid_579559
  var valid_579560 = query.getOrDefault("prettyPrint")
  valid_579560 = validateParameter(valid_579560, JBool, required = false,
                                 default = newJBool(true))
  if valid_579560 != nil:
    section.add "prettyPrint", valid_579560
  var valid_579561 = query.getOrDefault("oauth_token")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "oauth_token", valid_579561
  var valid_579562 = query.getOrDefault("alt")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = newJString("json"))
  if valid_579562 != nil:
    section.add "alt", valid_579562
  var valid_579563 = query.getOrDefault("userIp")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "userIp", valid_579563
  var valid_579564 = query.getOrDefault("quotaUser")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "quotaUser", valid_579564
  var valid_579565 = query.getOrDefault("fields")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "fields", valid_579565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579566: Call_GmailUsersSettingsForwardingAddressesDelete_579554;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579566.validator(path, query, header, formData, body)
  let scheme = call_579566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579566.url(scheme.get, call_579566.host, call_579566.base,
                         call_579566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579566, url, valid)

proc call*(call_579567: Call_GmailUsersSettingsForwardingAddressesDelete_579554;
          forwardingEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsForwardingAddressesDelete
  ## Deletes the specified forwarding address and revokes any verification that may have been required.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   forwardingEmail: string (required)
  ##                  : The forwarding address to be deleted.
  var path_579568 = newJObject()
  var query_579569 = newJObject()
  add(query_579569, "key", newJString(key))
  add(query_579569, "prettyPrint", newJBool(prettyPrint))
  add(query_579569, "oauth_token", newJString(oauthToken))
  add(query_579569, "alt", newJString(alt))
  add(query_579569, "userIp", newJString(userIp))
  add(query_579569, "quotaUser", newJString(quotaUser))
  add(path_579568, "userId", newJString(userId))
  add(query_579569, "fields", newJString(fields))
  add(path_579568, "forwardingEmail", newJString(forwardingEmail))
  result = call_579567.call(path_579568, query_579569, nil, nil, nil)

var gmailUsersSettingsForwardingAddressesDelete* = Call_GmailUsersSettingsForwardingAddressesDelete_579554(
    name: "gmailUsersSettingsForwardingAddressesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{userId}/settings/forwardingAddresses/{forwardingEmail}",
    validator: validate_GmailUsersSettingsForwardingAddressesDelete_579555,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsForwardingAddressesDelete_579556,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateImap_579585 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsUpdateImap_579587(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateImap_579586(path: JsonNode; query: JsonNode;
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
  var valid_579588 = path.getOrDefault("userId")
  valid_579588 = validateParameter(valid_579588, JString, required = true,
                                 default = newJString("me"))
  if valid_579588 != nil:
    section.add "userId", valid_579588
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
  var valid_579589 = query.getOrDefault("key")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "key", valid_579589
  var valid_579590 = query.getOrDefault("prettyPrint")
  valid_579590 = validateParameter(valid_579590, JBool, required = false,
                                 default = newJBool(true))
  if valid_579590 != nil:
    section.add "prettyPrint", valid_579590
  var valid_579591 = query.getOrDefault("oauth_token")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "oauth_token", valid_579591
  var valid_579592 = query.getOrDefault("alt")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = newJString("json"))
  if valid_579592 != nil:
    section.add "alt", valid_579592
  var valid_579593 = query.getOrDefault("userIp")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "userIp", valid_579593
  var valid_579594 = query.getOrDefault("quotaUser")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "quotaUser", valid_579594
  var valid_579595 = query.getOrDefault("fields")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "fields", valid_579595
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

proc call*(call_579597: Call_GmailUsersSettingsUpdateImap_579585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates IMAP settings.
  ## 
  let valid = call_579597.validator(path, query, header, formData, body)
  let scheme = call_579597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579597.url(scheme.get, call_579597.host, call_579597.base,
                         call_579597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579597, url, valid)

proc call*(call_579598: Call_GmailUsersSettingsUpdateImap_579585; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsUpdateImap
  ## Updates IMAP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579599 = newJObject()
  var query_579600 = newJObject()
  var body_579601 = newJObject()
  add(query_579600, "key", newJString(key))
  add(query_579600, "prettyPrint", newJBool(prettyPrint))
  add(query_579600, "oauth_token", newJString(oauthToken))
  add(query_579600, "alt", newJString(alt))
  add(query_579600, "userIp", newJString(userIp))
  add(query_579600, "quotaUser", newJString(quotaUser))
  add(path_579599, "userId", newJString(userId))
  if body != nil:
    body_579601 = body
  add(query_579600, "fields", newJString(fields))
  result = call_579598.call(path_579599, query_579600, nil, nil, body_579601)

var gmailUsersSettingsUpdateImap* = Call_GmailUsersSettingsUpdateImap_579585(
    name: "gmailUsersSettingsUpdateImap", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsUpdateImap_579586,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateImap_579587,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetImap_579570 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsGetImap_579572(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetImap_579571(path: JsonNode; query: JsonNode;
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
  var valid_579573 = path.getOrDefault("userId")
  valid_579573 = validateParameter(valid_579573, JString, required = true,
                                 default = newJString("me"))
  if valid_579573 != nil:
    section.add "userId", valid_579573
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
  var valid_579574 = query.getOrDefault("key")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "key", valid_579574
  var valid_579575 = query.getOrDefault("prettyPrint")
  valid_579575 = validateParameter(valid_579575, JBool, required = false,
                                 default = newJBool(true))
  if valid_579575 != nil:
    section.add "prettyPrint", valid_579575
  var valid_579576 = query.getOrDefault("oauth_token")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "oauth_token", valid_579576
  var valid_579577 = query.getOrDefault("alt")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = newJString("json"))
  if valid_579577 != nil:
    section.add "alt", valid_579577
  var valid_579578 = query.getOrDefault("userIp")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "userIp", valid_579578
  var valid_579579 = query.getOrDefault("quotaUser")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "quotaUser", valid_579579
  var valid_579580 = query.getOrDefault("fields")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "fields", valid_579580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579581: Call_GmailUsersSettingsGetImap_579570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets IMAP settings.
  ## 
  let valid = call_579581.validator(path, query, header, formData, body)
  let scheme = call_579581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579581.url(scheme.get, call_579581.host, call_579581.base,
                         call_579581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579581, url, valid)

proc call*(call_579582: Call_GmailUsersSettingsGetImap_579570; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersSettingsGetImap
  ## Gets IMAP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579583 = newJObject()
  var query_579584 = newJObject()
  add(query_579584, "key", newJString(key))
  add(query_579584, "prettyPrint", newJBool(prettyPrint))
  add(query_579584, "oauth_token", newJString(oauthToken))
  add(query_579584, "alt", newJString(alt))
  add(query_579584, "userIp", newJString(userIp))
  add(query_579584, "quotaUser", newJString(quotaUser))
  add(path_579583, "userId", newJString(userId))
  add(query_579584, "fields", newJString(fields))
  result = call_579582.call(path_579583, query_579584, nil, nil, nil)

var gmailUsersSettingsGetImap* = Call_GmailUsersSettingsGetImap_579570(
    name: "gmailUsersSettingsGetImap", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/imap",
    validator: validate_GmailUsersSettingsGetImap_579571, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetImap_579572, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateLanguage_579617 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsUpdateLanguage_579619(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateLanguage_579618(path: JsonNode;
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
  var valid_579620 = path.getOrDefault("userId")
  valid_579620 = validateParameter(valid_579620, JString, required = true,
                                 default = newJString("me"))
  if valid_579620 != nil:
    section.add "userId", valid_579620
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
  var valid_579621 = query.getOrDefault("key")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "key", valid_579621
  var valid_579622 = query.getOrDefault("prettyPrint")
  valid_579622 = validateParameter(valid_579622, JBool, required = false,
                                 default = newJBool(true))
  if valid_579622 != nil:
    section.add "prettyPrint", valid_579622
  var valid_579623 = query.getOrDefault("oauth_token")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "oauth_token", valid_579623
  var valid_579624 = query.getOrDefault("alt")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = newJString("json"))
  if valid_579624 != nil:
    section.add "alt", valid_579624
  var valid_579625 = query.getOrDefault("userIp")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "userIp", valid_579625
  var valid_579626 = query.getOrDefault("quotaUser")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "quotaUser", valid_579626
  var valid_579627 = query.getOrDefault("fields")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "fields", valid_579627
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

proc call*(call_579629: Call_GmailUsersSettingsUpdateLanguage_579617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
  ## 
  let valid = call_579629.validator(path, query, header, formData, body)
  let scheme = call_579629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579629.url(scheme.get, call_579629.host, call_579629.base,
                         call_579629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579629, url, valid)

proc call*(call_579630: Call_GmailUsersSettingsUpdateLanguage_579617;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsUpdateLanguage
  ## Updates language settings.
  ## 
  ## If successful, the return object contains the displayLanguage that was saved for the user, which may differ from the value passed into the request. This is because the requested displayLanguage may not be directly supported by Gmail but have a close variant that is, and so the variant may be chosen and saved instead.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579631 = newJObject()
  var query_579632 = newJObject()
  var body_579633 = newJObject()
  add(query_579632, "key", newJString(key))
  add(query_579632, "prettyPrint", newJBool(prettyPrint))
  add(query_579632, "oauth_token", newJString(oauthToken))
  add(query_579632, "alt", newJString(alt))
  add(query_579632, "userIp", newJString(userIp))
  add(query_579632, "quotaUser", newJString(quotaUser))
  add(path_579631, "userId", newJString(userId))
  if body != nil:
    body_579633 = body
  add(query_579632, "fields", newJString(fields))
  result = call_579630.call(path_579631, query_579632, nil, nil, body_579633)

var gmailUsersSettingsUpdateLanguage* = Call_GmailUsersSettingsUpdateLanguage_579617(
    name: "gmailUsersSettingsUpdateLanguage", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsUpdateLanguage_579618,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateLanguage_579619,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetLanguage_579602 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsGetLanguage_579604(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetLanguage_579603(path: JsonNode; query: JsonNode;
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
  var valid_579605 = path.getOrDefault("userId")
  valid_579605 = validateParameter(valid_579605, JString, required = true,
                                 default = newJString("me"))
  if valid_579605 != nil:
    section.add "userId", valid_579605
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
  var valid_579606 = query.getOrDefault("key")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "key", valid_579606
  var valid_579607 = query.getOrDefault("prettyPrint")
  valid_579607 = validateParameter(valid_579607, JBool, required = false,
                                 default = newJBool(true))
  if valid_579607 != nil:
    section.add "prettyPrint", valid_579607
  var valid_579608 = query.getOrDefault("oauth_token")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "oauth_token", valid_579608
  var valid_579609 = query.getOrDefault("alt")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = newJString("json"))
  if valid_579609 != nil:
    section.add "alt", valid_579609
  var valid_579610 = query.getOrDefault("userIp")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "userIp", valid_579610
  var valid_579611 = query.getOrDefault("quotaUser")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = nil)
  if valid_579611 != nil:
    section.add "quotaUser", valid_579611
  var valid_579612 = query.getOrDefault("fields")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "fields", valid_579612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579613: Call_GmailUsersSettingsGetLanguage_579602; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets language settings.
  ## 
  let valid = call_579613.validator(path, query, header, formData, body)
  let scheme = call_579613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579613.url(scheme.get, call_579613.host, call_579613.base,
                         call_579613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579613, url, valid)

proc call*(call_579614: Call_GmailUsersSettingsGetLanguage_579602;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsGetLanguage
  ## Gets language settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579615 = newJObject()
  var query_579616 = newJObject()
  add(query_579616, "key", newJString(key))
  add(query_579616, "prettyPrint", newJBool(prettyPrint))
  add(query_579616, "oauth_token", newJString(oauthToken))
  add(query_579616, "alt", newJString(alt))
  add(query_579616, "userIp", newJString(userIp))
  add(query_579616, "quotaUser", newJString(quotaUser))
  add(path_579615, "userId", newJString(userId))
  add(query_579616, "fields", newJString(fields))
  result = call_579614.call(path_579615, query_579616, nil, nil, nil)

var gmailUsersSettingsGetLanguage* = Call_GmailUsersSettingsGetLanguage_579602(
    name: "gmailUsersSettingsGetLanguage", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/language",
    validator: validate_GmailUsersSettingsGetLanguage_579603,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetLanguage_579604,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdatePop_579649 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsUpdatePop_579651(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdatePop_579650(path: JsonNode; query: JsonNode;
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
  var valid_579652 = path.getOrDefault("userId")
  valid_579652 = validateParameter(valid_579652, JString, required = true,
                                 default = newJString("me"))
  if valid_579652 != nil:
    section.add "userId", valid_579652
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
  var valid_579653 = query.getOrDefault("key")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "key", valid_579653
  var valid_579654 = query.getOrDefault("prettyPrint")
  valid_579654 = validateParameter(valid_579654, JBool, required = false,
                                 default = newJBool(true))
  if valid_579654 != nil:
    section.add "prettyPrint", valid_579654
  var valid_579655 = query.getOrDefault("oauth_token")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "oauth_token", valid_579655
  var valid_579656 = query.getOrDefault("alt")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = newJString("json"))
  if valid_579656 != nil:
    section.add "alt", valid_579656
  var valid_579657 = query.getOrDefault("userIp")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "userIp", valid_579657
  var valid_579658 = query.getOrDefault("quotaUser")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = nil)
  if valid_579658 != nil:
    section.add "quotaUser", valid_579658
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579661: Call_GmailUsersSettingsUpdatePop_579649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates POP settings.
  ## 
  let valid = call_579661.validator(path, query, header, formData, body)
  let scheme = call_579661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579661.url(scheme.get, call_579661.host, call_579661.base,
                         call_579661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579661, url, valid)

proc call*(call_579662: Call_GmailUsersSettingsUpdatePop_579649; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsUpdatePop
  ## Updates POP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579663 = newJObject()
  var query_579664 = newJObject()
  var body_579665 = newJObject()
  add(query_579664, "key", newJString(key))
  add(query_579664, "prettyPrint", newJBool(prettyPrint))
  add(query_579664, "oauth_token", newJString(oauthToken))
  add(query_579664, "alt", newJString(alt))
  add(query_579664, "userIp", newJString(userIp))
  add(query_579664, "quotaUser", newJString(quotaUser))
  add(path_579663, "userId", newJString(userId))
  if body != nil:
    body_579665 = body
  add(query_579664, "fields", newJString(fields))
  result = call_579662.call(path_579663, query_579664, nil, nil, body_579665)

var gmailUsersSettingsUpdatePop* = Call_GmailUsersSettingsUpdatePop_579649(
    name: "gmailUsersSettingsUpdatePop", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsUpdatePop_579650,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdatePop_579651,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetPop_579634 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsGetPop_579636(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetPop_579635(path: JsonNode; query: JsonNode;
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
  var valid_579637 = path.getOrDefault("userId")
  valid_579637 = validateParameter(valid_579637, JString, required = true,
                                 default = newJString("me"))
  if valid_579637 != nil:
    section.add "userId", valid_579637
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
  var valid_579638 = query.getOrDefault("key")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "key", valid_579638
  var valid_579639 = query.getOrDefault("prettyPrint")
  valid_579639 = validateParameter(valid_579639, JBool, required = false,
                                 default = newJBool(true))
  if valid_579639 != nil:
    section.add "prettyPrint", valid_579639
  var valid_579640 = query.getOrDefault("oauth_token")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "oauth_token", valid_579640
  var valid_579641 = query.getOrDefault("alt")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = newJString("json"))
  if valid_579641 != nil:
    section.add "alt", valid_579641
  var valid_579642 = query.getOrDefault("userIp")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "userIp", valid_579642
  var valid_579643 = query.getOrDefault("quotaUser")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "quotaUser", valid_579643
  var valid_579644 = query.getOrDefault("fields")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "fields", valid_579644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579645: Call_GmailUsersSettingsGetPop_579634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets POP settings.
  ## 
  let valid = call_579645.validator(path, query, header, formData, body)
  let scheme = call_579645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579645.url(scheme.get, call_579645.host, call_579645.base,
                         call_579645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579645, url, valid)

proc call*(call_579646: Call_GmailUsersSettingsGetPop_579634; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersSettingsGetPop
  ## Gets POP settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579647 = newJObject()
  var query_579648 = newJObject()
  add(query_579648, "key", newJString(key))
  add(query_579648, "prettyPrint", newJBool(prettyPrint))
  add(query_579648, "oauth_token", newJString(oauthToken))
  add(query_579648, "alt", newJString(alt))
  add(query_579648, "userIp", newJString(userIp))
  add(query_579648, "quotaUser", newJString(quotaUser))
  add(path_579647, "userId", newJString(userId))
  add(query_579648, "fields", newJString(fields))
  result = call_579646.call(path_579647, query_579648, nil, nil, nil)

var gmailUsersSettingsGetPop* = Call_GmailUsersSettingsGetPop_579634(
    name: "gmailUsersSettingsGetPop", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/pop",
    validator: validate_GmailUsersSettingsGetPop_579635, base: "/gmail/v1/users",
    url: url_GmailUsersSettingsGetPop_579636, schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsCreate_579681 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsCreate_579683(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsCreate_579682(path: JsonNode;
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
  var valid_579684 = path.getOrDefault("userId")
  valid_579684 = validateParameter(valid_579684, JString, required = true,
                                 default = newJString("me"))
  if valid_579684 != nil:
    section.add "userId", valid_579684
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
  var valid_579685 = query.getOrDefault("key")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "key", valid_579685
  var valid_579686 = query.getOrDefault("prettyPrint")
  valid_579686 = validateParameter(valid_579686, JBool, required = false,
                                 default = newJBool(true))
  if valid_579686 != nil:
    section.add "prettyPrint", valid_579686
  var valid_579687 = query.getOrDefault("oauth_token")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "oauth_token", valid_579687
  var valid_579688 = query.getOrDefault("alt")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = newJString("json"))
  if valid_579688 != nil:
    section.add "alt", valid_579688
  var valid_579689 = query.getOrDefault("userIp")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "userIp", valid_579689
  var valid_579690 = query.getOrDefault("quotaUser")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "quotaUser", valid_579690
  var valid_579691 = query.getOrDefault("fields")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "fields", valid_579691
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

proc call*(call_579693: Call_GmailUsersSettingsSendAsCreate_579681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579693.validator(path, query, header, formData, body)
  let scheme = call_579693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579693.url(scheme.get, call_579693.host, call_579693.base,
                         call_579693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579693, url, valid)

proc call*(call_579694: Call_GmailUsersSettingsSendAsCreate_579681;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsCreate
  ## Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579695 = newJObject()
  var query_579696 = newJObject()
  var body_579697 = newJObject()
  add(query_579696, "key", newJString(key))
  add(query_579696, "prettyPrint", newJBool(prettyPrint))
  add(query_579696, "oauth_token", newJString(oauthToken))
  add(query_579696, "alt", newJString(alt))
  add(query_579696, "userIp", newJString(userIp))
  add(query_579696, "quotaUser", newJString(quotaUser))
  add(path_579695, "userId", newJString(userId))
  if body != nil:
    body_579697 = body
  add(query_579696, "fields", newJString(fields))
  result = call_579694.call(path_579695, query_579696, nil, nil, body_579697)

var gmailUsersSettingsSendAsCreate* = Call_GmailUsersSettingsSendAsCreate_579681(
    name: "gmailUsersSettingsSendAsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsCreate_579682,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsCreate_579683,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsList_579666 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsList_579668(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsList_579667(path: JsonNode; query: JsonNode;
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
  var valid_579669 = path.getOrDefault("userId")
  valid_579669 = validateParameter(valid_579669, JString, required = true,
                                 default = newJString("me"))
  if valid_579669 != nil:
    section.add "userId", valid_579669
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
  var valid_579670 = query.getOrDefault("key")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "key", valid_579670
  var valid_579671 = query.getOrDefault("prettyPrint")
  valid_579671 = validateParameter(valid_579671, JBool, required = false,
                                 default = newJBool(true))
  if valid_579671 != nil:
    section.add "prettyPrint", valid_579671
  var valid_579672 = query.getOrDefault("oauth_token")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "oauth_token", valid_579672
  var valid_579673 = query.getOrDefault("alt")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = newJString("json"))
  if valid_579673 != nil:
    section.add "alt", valid_579673
  var valid_579674 = query.getOrDefault("userIp")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "userIp", valid_579674
  var valid_579675 = query.getOrDefault("quotaUser")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "quotaUser", valid_579675
  var valid_579676 = query.getOrDefault("fields")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "fields", valid_579676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579677: Call_GmailUsersSettingsSendAsList_579666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
  ## 
  let valid = call_579677.validator(path, query, header, formData, body)
  let scheme = call_579677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579677.url(scheme.get, call_579677.host, call_579677.base,
                         call_579677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579677, url, valid)

proc call*(call_579678: Call_GmailUsersSettingsSendAsList_579666; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsList
  ## Lists the send-as aliases for the specified account. The result includes the primary send-as address associated with the account as well as any custom "from" aliases.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579679 = newJObject()
  var query_579680 = newJObject()
  add(query_579680, "key", newJString(key))
  add(query_579680, "prettyPrint", newJBool(prettyPrint))
  add(query_579680, "oauth_token", newJString(oauthToken))
  add(query_579680, "alt", newJString(alt))
  add(query_579680, "userIp", newJString(userIp))
  add(query_579680, "quotaUser", newJString(quotaUser))
  add(path_579679, "userId", newJString(userId))
  add(query_579680, "fields", newJString(fields))
  result = call_579678.call(path_579679, query_579680, nil, nil, nil)

var gmailUsersSettingsSendAsList* = Call_GmailUsersSettingsSendAsList_579666(
    name: "gmailUsersSettingsSendAsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs",
    validator: validate_GmailUsersSettingsSendAsList_579667,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsList_579668,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsUpdate_579714 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsUpdate_579716(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsUpdate_579715(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579717 = path.getOrDefault("userId")
  valid_579717 = validateParameter(valid_579717, JString, required = true,
                                 default = newJString("me"))
  if valid_579717 != nil:
    section.add "userId", valid_579717
  var valid_579718 = path.getOrDefault("sendAsEmail")
  valid_579718 = validateParameter(valid_579718, JString, required = true,
                                 default = nil)
  if valid_579718 != nil:
    section.add "sendAsEmail", valid_579718
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
  var valid_579719 = query.getOrDefault("key")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "key", valid_579719
  var valid_579720 = query.getOrDefault("prettyPrint")
  valid_579720 = validateParameter(valid_579720, JBool, required = false,
                                 default = newJBool(true))
  if valid_579720 != nil:
    section.add "prettyPrint", valid_579720
  var valid_579721 = query.getOrDefault("oauth_token")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "oauth_token", valid_579721
  var valid_579722 = query.getOrDefault("alt")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = newJString("json"))
  if valid_579722 != nil:
    section.add "alt", valid_579722
  var valid_579723 = query.getOrDefault("userIp")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "userIp", valid_579723
  var valid_579724 = query.getOrDefault("quotaUser")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "quotaUser", valid_579724
  var valid_579725 = query.getOrDefault("fields")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "fields", valid_579725
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

proc call*(call_579727: Call_GmailUsersSettingsSendAsUpdate_579714; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579727.validator(path, query, header, formData, body)
  let scheme = call_579727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579727.url(scheme.get, call_579727.host, call_579727.base,
                         call_579727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579727, url, valid)

proc call*(call_579728: Call_GmailUsersSettingsSendAsUpdate_579714;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsUpdate
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be updated.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579729 = newJObject()
  var query_579730 = newJObject()
  var body_579731 = newJObject()
  add(query_579730, "key", newJString(key))
  add(query_579730, "prettyPrint", newJBool(prettyPrint))
  add(query_579730, "oauth_token", newJString(oauthToken))
  add(query_579730, "alt", newJString(alt))
  add(query_579730, "userIp", newJString(userIp))
  add(query_579730, "quotaUser", newJString(quotaUser))
  add(path_579729, "userId", newJString(userId))
  add(path_579729, "sendAsEmail", newJString(sendAsEmail))
  if body != nil:
    body_579731 = body
  add(query_579730, "fields", newJString(fields))
  result = call_579728.call(path_579729, query_579730, nil, nil, body_579731)

var gmailUsersSettingsSendAsUpdate* = Call_GmailUsersSettingsSendAsUpdate_579714(
    name: "gmailUsersSettingsSendAsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsUpdate_579715,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsUpdate_579716,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsGet_579698 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsGet_579700(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsGet_579699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579701 = path.getOrDefault("userId")
  valid_579701 = validateParameter(valid_579701, JString, required = true,
                                 default = newJString("me"))
  if valid_579701 != nil:
    section.add "userId", valid_579701
  var valid_579702 = path.getOrDefault("sendAsEmail")
  valid_579702 = validateParameter(valid_579702, JString, required = true,
                                 default = nil)
  if valid_579702 != nil:
    section.add "sendAsEmail", valid_579702
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
  var valid_579703 = query.getOrDefault("key")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "key", valid_579703
  var valid_579704 = query.getOrDefault("prettyPrint")
  valid_579704 = validateParameter(valid_579704, JBool, required = false,
                                 default = newJBool(true))
  if valid_579704 != nil:
    section.add "prettyPrint", valid_579704
  var valid_579705 = query.getOrDefault("oauth_token")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "oauth_token", valid_579705
  var valid_579706 = query.getOrDefault("alt")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = newJString("json"))
  if valid_579706 != nil:
    section.add "alt", valid_579706
  var valid_579707 = query.getOrDefault("userIp")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "userIp", valid_579707
  var valid_579708 = query.getOrDefault("quotaUser")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "quotaUser", valid_579708
  var valid_579709 = query.getOrDefault("fields")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "fields", valid_579709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579710: Call_GmailUsersSettingsSendAsGet_579698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
  ## 
  let valid = call_579710.validator(path, query, header, formData, body)
  let scheme = call_579710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579710.url(scheme.get, call_579710.host, call_579710.base,
                         call_579710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579710, url, valid)

proc call*(call_579711: Call_GmailUsersSettingsSendAsGet_579698;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsGet
  ## Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579712 = newJObject()
  var query_579713 = newJObject()
  add(query_579713, "key", newJString(key))
  add(query_579713, "prettyPrint", newJBool(prettyPrint))
  add(query_579713, "oauth_token", newJString(oauthToken))
  add(query_579713, "alt", newJString(alt))
  add(query_579713, "userIp", newJString(userIp))
  add(query_579713, "quotaUser", newJString(quotaUser))
  add(path_579712, "userId", newJString(userId))
  add(path_579712, "sendAsEmail", newJString(sendAsEmail))
  add(query_579713, "fields", newJString(fields))
  result = call_579711.call(path_579712, query_579713, nil, nil, nil)

var gmailUsersSettingsSendAsGet* = Call_GmailUsersSettingsSendAsGet_579698(
    name: "gmailUsersSettingsSendAsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsGet_579699,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsGet_579700,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsPatch_579748 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsPatch_579750(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsPatch_579749(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579751 = path.getOrDefault("userId")
  valid_579751 = validateParameter(valid_579751, JString, required = true,
                                 default = newJString("me"))
  if valid_579751 != nil:
    section.add "userId", valid_579751
  var valid_579752 = path.getOrDefault("sendAsEmail")
  valid_579752 = validateParameter(valid_579752, JString, required = true,
                                 default = nil)
  if valid_579752 != nil:
    section.add "sendAsEmail", valid_579752
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
  var valid_579753 = query.getOrDefault("key")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "key", valid_579753
  var valid_579754 = query.getOrDefault("prettyPrint")
  valid_579754 = validateParameter(valid_579754, JBool, required = false,
                                 default = newJBool(true))
  if valid_579754 != nil:
    section.add "prettyPrint", valid_579754
  var valid_579755 = query.getOrDefault("oauth_token")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "oauth_token", valid_579755
  var valid_579756 = query.getOrDefault("alt")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = newJString("json"))
  if valid_579756 != nil:
    section.add "alt", valid_579756
  var valid_579757 = query.getOrDefault("userIp")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "userIp", valid_579757
  var valid_579758 = query.getOrDefault("quotaUser")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "quotaUser", valid_579758
  var valid_579759 = query.getOrDefault("fields")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = nil)
  if valid_579759 != nil:
    section.add "fields", valid_579759
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

proc call*(call_579761: Call_GmailUsersSettingsSendAsPatch_579748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
  ## 
  let valid = call_579761.validator(path, query, header, formData, body)
  let scheme = call_579761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579761.url(scheme.get, call_579761.host, call_579761.base,
                         call_579761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579761, url, valid)

proc call*(call_579762: Call_GmailUsersSettingsSendAsPatch_579748;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsPatch
  ## Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias.
  ## 
  ## Addresses other than the primary address for the account can only be updated by service account clients that have been delegated domain-wide authority. This method supports patch semantics.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be updated.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579763 = newJObject()
  var query_579764 = newJObject()
  var body_579765 = newJObject()
  add(query_579764, "key", newJString(key))
  add(query_579764, "prettyPrint", newJBool(prettyPrint))
  add(query_579764, "oauth_token", newJString(oauthToken))
  add(query_579764, "alt", newJString(alt))
  add(query_579764, "userIp", newJString(userIp))
  add(query_579764, "quotaUser", newJString(quotaUser))
  add(path_579763, "userId", newJString(userId))
  add(path_579763, "sendAsEmail", newJString(sendAsEmail))
  if body != nil:
    body_579765 = body
  add(query_579764, "fields", newJString(fields))
  result = call_579762.call(path_579763, query_579764, nil, nil, body_579765)

var gmailUsersSettingsSendAsPatch* = Call_GmailUsersSettingsSendAsPatch_579748(
    name: "gmailUsersSettingsSendAsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsPatch_579749,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsPatch_579750,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsDelete_579732 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsDelete_579734(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsDelete_579733(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579735 = path.getOrDefault("userId")
  valid_579735 = validateParameter(valid_579735, JString, required = true,
                                 default = newJString("me"))
  if valid_579735 != nil:
    section.add "userId", valid_579735
  var valid_579736 = path.getOrDefault("sendAsEmail")
  valid_579736 = validateParameter(valid_579736, JString, required = true,
                                 default = nil)
  if valid_579736 != nil:
    section.add "sendAsEmail", valid_579736
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
  var valid_579737 = query.getOrDefault("key")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "key", valid_579737
  var valid_579738 = query.getOrDefault("prettyPrint")
  valid_579738 = validateParameter(valid_579738, JBool, required = false,
                                 default = newJBool(true))
  if valid_579738 != nil:
    section.add "prettyPrint", valid_579738
  var valid_579739 = query.getOrDefault("oauth_token")
  valid_579739 = validateParameter(valid_579739, JString, required = false,
                                 default = nil)
  if valid_579739 != nil:
    section.add "oauth_token", valid_579739
  var valid_579740 = query.getOrDefault("alt")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = newJString("json"))
  if valid_579740 != nil:
    section.add "alt", valid_579740
  var valid_579741 = query.getOrDefault("userIp")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "userIp", valid_579741
  var valid_579742 = query.getOrDefault("quotaUser")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = nil)
  if valid_579742 != nil:
    section.add "quotaUser", valid_579742
  var valid_579743 = query.getOrDefault("fields")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = nil)
  if valid_579743 != nil:
    section.add "fields", valid_579743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579744: Call_GmailUsersSettingsSendAsDelete_579732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579744.validator(path, query, header, formData, body)
  let scheme = call_579744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579744.url(scheme.get, call_579744.host, call_579744.base,
                         call_579744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579744, url, valid)

proc call*(call_579745: Call_GmailUsersSettingsSendAsDelete_579732;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsDelete
  ## Deletes the specified send-as alias. Revokes any verification that may have been required for using it.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579746 = newJObject()
  var query_579747 = newJObject()
  add(query_579747, "key", newJString(key))
  add(query_579747, "prettyPrint", newJBool(prettyPrint))
  add(query_579747, "oauth_token", newJString(oauthToken))
  add(query_579747, "alt", newJString(alt))
  add(query_579747, "userIp", newJString(userIp))
  add(query_579747, "quotaUser", newJString(quotaUser))
  add(path_579746, "userId", newJString(userId))
  add(path_579746, "sendAsEmail", newJString(sendAsEmail))
  add(query_579747, "fields", newJString(fields))
  result = call_579745.call(path_579746, query_579747, nil, nil, nil)

var gmailUsersSettingsSendAsDelete* = Call_GmailUsersSettingsSendAsDelete_579732(
    name: "gmailUsersSettingsSendAsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/settings/sendAs/{sendAsEmail}",
    validator: validate_GmailUsersSettingsSendAsDelete_579733,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsDelete_579734,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoInsert_579782 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsSmimeInfoInsert_579784(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoInsert_579783(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579785 = path.getOrDefault("userId")
  valid_579785 = validateParameter(valid_579785, JString, required = true,
                                 default = newJString("me"))
  if valid_579785 != nil:
    section.add "userId", valid_579785
  var valid_579786 = path.getOrDefault("sendAsEmail")
  valid_579786 = validateParameter(valid_579786, JString, required = true,
                                 default = nil)
  if valid_579786 != nil:
    section.add "sendAsEmail", valid_579786
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
  var valid_579787 = query.getOrDefault("key")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "key", valid_579787
  var valid_579788 = query.getOrDefault("prettyPrint")
  valid_579788 = validateParameter(valid_579788, JBool, required = false,
                                 default = newJBool(true))
  if valid_579788 != nil:
    section.add "prettyPrint", valid_579788
  var valid_579789 = query.getOrDefault("oauth_token")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "oauth_token", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("userIp")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "userIp", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
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

proc call*(call_579795: Call_GmailUsersSettingsSendAsSmimeInfoInsert_579782;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
  ## 
  let valid = call_579795.validator(path, query, header, formData, body)
  let scheme = call_579795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579795.url(scheme.get, call_579795.host, call_579795.base,
                         call_579795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579795, url, valid)

proc call*(call_579796: Call_GmailUsersSettingsSendAsSmimeInfoInsert_579782;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoInsert
  ## Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579797 = newJObject()
  var query_579798 = newJObject()
  var body_579799 = newJObject()
  add(query_579798, "key", newJString(key))
  add(query_579798, "prettyPrint", newJBool(prettyPrint))
  add(query_579798, "oauth_token", newJString(oauthToken))
  add(query_579798, "alt", newJString(alt))
  add(query_579798, "userIp", newJString(userIp))
  add(query_579798, "quotaUser", newJString(quotaUser))
  add(path_579797, "userId", newJString(userId))
  add(path_579797, "sendAsEmail", newJString(sendAsEmail))
  if body != nil:
    body_579799 = body
  add(query_579798, "fields", newJString(fields))
  result = call_579796.call(path_579797, query_579798, nil, nil, body_579799)

var gmailUsersSettingsSendAsSmimeInfoInsert* = Call_GmailUsersSettingsSendAsSmimeInfoInsert_579782(
    name: "gmailUsersSettingsSendAsSmimeInfoInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoInsert_579783,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoInsert_579784,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoList_579766 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsSmimeInfoList_579768(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoList_579767(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579769 = path.getOrDefault("userId")
  valid_579769 = validateParameter(valid_579769, JString, required = true,
                                 default = newJString("me"))
  if valid_579769 != nil:
    section.add "userId", valid_579769
  var valid_579770 = path.getOrDefault("sendAsEmail")
  valid_579770 = validateParameter(valid_579770, JString, required = true,
                                 default = nil)
  if valid_579770 != nil:
    section.add "sendAsEmail", valid_579770
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
  var valid_579771 = query.getOrDefault("key")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "key", valid_579771
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("alt")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("json"))
  if valid_579774 != nil:
    section.add "alt", valid_579774
  var valid_579775 = query.getOrDefault("userIp")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "userIp", valid_579775
  var valid_579776 = query.getOrDefault("quotaUser")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "quotaUser", valid_579776
  var valid_579777 = query.getOrDefault("fields")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "fields", valid_579777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579778: Call_GmailUsersSettingsSendAsSmimeInfoList_579766;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists S/MIME configs for the specified send-as alias.
  ## 
  let valid = call_579778.validator(path, query, header, formData, body)
  let scheme = call_579778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579778.url(scheme.get, call_579778.host, call_579778.base,
                         call_579778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579778, url, valid)

proc call*(call_579779: Call_GmailUsersSettingsSendAsSmimeInfoList_579766;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoList
  ## Lists S/MIME configs for the specified send-as alias.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579780 = newJObject()
  var query_579781 = newJObject()
  add(query_579781, "key", newJString(key))
  add(query_579781, "prettyPrint", newJBool(prettyPrint))
  add(query_579781, "oauth_token", newJString(oauthToken))
  add(query_579781, "alt", newJString(alt))
  add(query_579781, "userIp", newJString(userIp))
  add(query_579781, "quotaUser", newJString(quotaUser))
  add(path_579780, "userId", newJString(userId))
  add(path_579780, "sendAsEmail", newJString(sendAsEmail))
  add(query_579781, "fields", newJString(fields))
  result = call_579779.call(path_579780, query_579781, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoList* = Call_GmailUsersSettingsSendAsSmimeInfoList_579766(
    name: "gmailUsersSettingsSendAsSmimeInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoList_579767,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoList_579768,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoGet_579800 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsSmimeInfoGet_579802(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoGet_579801(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579803 = path.getOrDefault("id")
  valid_579803 = validateParameter(valid_579803, JString, required = true,
                                 default = nil)
  if valid_579803 != nil:
    section.add "id", valid_579803
  var valid_579804 = path.getOrDefault("userId")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = newJString("me"))
  if valid_579804 != nil:
    section.add "userId", valid_579804
  var valid_579805 = path.getOrDefault("sendAsEmail")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "sendAsEmail", valid_579805
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
  var valid_579806 = query.getOrDefault("key")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "key", valid_579806
  var valid_579807 = query.getOrDefault("prettyPrint")
  valid_579807 = validateParameter(valid_579807, JBool, required = false,
                                 default = newJBool(true))
  if valid_579807 != nil:
    section.add "prettyPrint", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("alt")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = newJString("json"))
  if valid_579809 != nil:
    section.add "alt", valid_579809
  var valid_579810 = query.getOrDefault("userIp")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "userIp", valid_579810
  var valid_579811 = query.getOrDefault("quotaUser")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "quotaUser", valid_579811
  var valid_579812 = query.getOrDefault("fields")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "fields", valid_579812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579813: Call_GmailUsersSettingsSendAsSmimeInfoGet_579800;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_579813.validator(path, query, header, formData, body)
  let scheme = call_579813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579813.url(scheme.get, call_579813.host, call_579813.base,
                         call_579813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579813, url, valid)

proc call*(call_579814: Call_GmailUsersSettingsSendAsSmimeInfoGet_579800;
          id: string; sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoGet
  ## Gets the specified S/MIME config for the specified send-as alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579815 = newJObject()
  var query_579816 = newJObject()
  add(query_579816, "key", newJString(key))
  add(query_579816, "prettyPrint", newJBool(prettyPrint))
  add(query_579816, "oauth_token", newJString(oauthToken))
  add(path_579815, "id", newJString(id))
  add(query_579816, "alt", newJString(alt))
  add(query_579816, "userIp", newJString(userIp))
  add(query_579816, "quotaUser", newJString(quotaUser))
  add(path_579815, "userId", newJString(userId))
  add(path_579815, "sendAsEmail", newJString(sendAsEmail))
  add(query_579816, "fields", newJString(fields))
  result = call_579814.call(path_579815, query_579816, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoGet* = Call_GmailUsersSettingsSendAsSmimeInfoGet_579800(
    name: "gmailUsersSettingsSendAsSmimeInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoGet_579801,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoGet_579802,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoDelete_579817 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsSmimeInfoDelete_579819(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoDelete_579818(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579820 = path.getOrDefault("id")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "id", valid_579820
  var valid_579821 = path.getOrDefault("userId")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = newJString("me"))
  if valid_579821 != nil:
    section.add "userId", valid_579821
  var valid_579822 = path.getOrDefault("sendAsEmail")
  valid_579822 = validateParameter(valid_579822, JString, required = true,
                                 default = nil)
  if valid_579822 != nil:
    section.add "sendAsEmail", valid_579822
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
  var valid_579823 = query.getOrDefault("key")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "key", valid_579823
  var valid_579824 = query.getOrDefault("prettyPrint")
  valid_579824 = validateParameter(valid_579824, JBool, required = false,
                                 default = newJBool(true))
  if valid_579824 != nil:
    section.add "prettyPrint", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("alt")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = newJString("json"))
  if valid_579826 != nil:
    section.add "alt", valid_579826
  var valid_579827 = query.getOrDefault("userIp")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "userIp", valid_579827
  var valid_579828 = query.getOrDefault("quotaUser")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "quotaUser", valid_579828
  var valid_579829 = query.getOrDefault("fields")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "fields", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579830: Call_GmailUsersSettingsSendAsSmimeInfoDelete_579817;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ## 
  let valid = call_579830.validator(path, query, header, formData, body)
  let scheme = call_579830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579830.url(scheme.get, call_579830.host, call_579830.base,
                         call_579830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579830, url, valid)

proc call*(call_579831: Call_GmailUsersSettingsSendAsSmimeInfoDelete_579817;
          id: string; sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoDelete
  ## Deletes the specified S/MIME config for the specified send-as alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579832 = newJObject()
  var query_579833 = newJObject()
  add(query_579833, "key", newJString(key))
  add(query_579833, "prettyPrint", newJBool(prettyPrint))
  add(query_579833, "oauth_token", newJString(oauthToken))
  add(path_579832, "id", newJString(id))
  add(query_579833, "alt", newJString(alt))
  add(query_579833, "userIp", newJString(userIp))
  add(query_579833, "quotaUser", newJString(quotaUser))
  add(path_579832, "userId", newJString(userId))
  add(path_579832, "sendAsEmail", newJString(sendAsEmail))
  add(query_579833, "fields", newJString(fields))
  result = call_579831.call(path_579832, query_579833, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoDelete* = Call_GmailUsersSettingsSendAsSmimeInfoDelete_579817(
    name: "gmailUsersSettingsSendAsSmimeInfoDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoDelete_579818,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoDelete_579819,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_579834 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsSmimeInfoSetDefault_579836(protocol: Scheme;
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

proc validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_579835(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   userId: JString (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579837 = path.getOrDefault("id")
  valid_579837 = validateParameter(valid_579837, JString, required = true,
                                 default = nil)
  if valid_579837 != nil:
    section.add "id", valid_579837
  var valid_579838 = path.getOrDefault("userId")
  valid_579838 = validateParameter(valid_579838, JString, required = true,
                                 default = newJString("me"))
  if valid_579838 != nil:
    section.add "userId", valid_579838
  var valid_579839 = path.getOrDefault("sendAsEmail")
  valid_579839 = validateParameter(valid_579839, JString, required = true,
                                 default = nil)
  if valid_579839 != nil:
    section.add "sendAsEmail", valid_579839
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
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
  var valid_579842 = query.getOrDefault("oauth_token")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "oauth_token", valid_579842
  var valid_579843 = query.getOrDefault("alt")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = newJString("json"))
  if valid_579843 != nil:
    section.add "alt", valid_579843
  var valid_579844 = query.getOrDefault("userIp")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "userIp", valid_579844
  var valid_579845 = query.getOrDefault("quotaUser")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "quotaUser", valid_579845
  var valid_579846 = query.getOrDefault("fields")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "fields", valid_579846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579847: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_579834;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default S/MIME config for the specified send-as alias.
  ## 
  let valid = call_579847.validator(path, query, header, formData, body)
  let scheme = call_579847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579847.url(scheme.get, call_579847.host, call_579847.base,
                         call_579847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579847, url, valid)

proc call*(call_579848: Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_579834;
          id: string; sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsSmimeInfoSetDefault
  ## Sets the default S/MIME config for the specified send-as alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The immutable ID for the SmimeInfo.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The email address that appears in the "From:" header for mail sent using this alias.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579849 = newJObject()
  var query_579850 = newJObject()
  add(query_579850, "key", newJString(key))
  add(query_579850, "prettyPrint", newJBool(prettyPrint))
  add(query_579850, "oauth_token", newJString(oauthToken))
  add(path_579849, "id", newJString(id))
  add(query_579850, "alt", newJString(alt))
  add(query_579850, "userIp", newJString(userIp))
  add(query_579850, "quotaUser", newJString(quotaUser))
  add(path_579849, "userId", newJString(userId))
  add(path_579849, "sendAsEmail", newJString(sendAsEmail))
  add(query_579850, "fields", newJString(fields))
  result = call_579848.call(path_579849, query_579850, nil, nil, nil)

var gmailUsersSettingsSendAsSmimeInfoSetDefault* = Call_GmailUsersSettingsSendAsSmimeInfoSetDefault_579834(
    name: "gmailUsersSettingsSendAsSmimeInfoSetDefault",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}/setDefault",
    validator: validate_GmailUsersSettingsSendAsSmimeInfoSetDefault_579835,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsSmimeInfoSetDefault_579836,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsSendAsVerify_579851 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsSendAsVerify_579853(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsSendAsVerify_579852(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: JString (required)
  ##              : The send-as alias to be verified.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579854 = path.getOrDefault("userId")
  valid_579854 = validateParameter(valid_579854, JString, required = true,
                                 default = newJString("me"))
  if valid_579854 != nil:
    section.add "userId", valid_579854
  var valid_579855 = path.getOrDefault("sendAsEmail")
  valid_579855 = validateParameter(valid_579855, JString, required = true,
                                 default = nil)
  if valid_579855 != nil:
    section.add "sendAsEmail", valid_579855
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
  var valid_579856 = query.getOrDefault("key")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "key", valid_579856
  var valid_579857 = query.getOrDefault("prettyPrint")
  valid_579857 = validateParameter(valid_579857, JBool, required = false,
                                 default = newJBool(true))
  if valid_579857 != nil:
    section.add "prettyPrint", valid_579857
  var valid_579858 = query.getOrDefault("oauth_token")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "oauth_token", valid_579858
  var valid_579859 = query.getOrDefault("alt")
  valid_579859 = validateParameter(valid_579859, JString, required = false,
                                 default = newJString("json"))
  if valid_579859 != nil:
    section.add "alt", valid_579859
  var valid_579860 = query.getOrDefault("userIp")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = nil)
  if valid_579860 != nil:
    section.add "userIp", valid_579860
  var valid_579861 = query.getOrDefault("quotaUser")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = nil)
  if valid_579861 != nil:
    section.add "quotaUser", valid_579861
  var valid_579862 = query.getOrDefault("fields")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "fields", valid_579862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579863: Call_GmailUsersSettingsSendAsVerify_579851; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
  ## 
  let valid = call_579863.validator(path, query, header, formData, body)
  let scheme = call_579863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579863.url(scheme.get, call_579863.host, call_579863.base,
                         call_579863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579863, url, valid)

proc call*(call_579864: Call_GmailUsersSettingsSendAsVerify_579851;
          sendAsEmail: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsSendAsVerify
  ## Sends a verification email to the specified send-as alias address. The verification status must be pending.
  ## 
  ## This method is only available to service account clients that have been delegated domain-wide authority.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   sendAsEmail: string (required)
  ##              : The send-as alias to be verified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579865 = newJObject()
  var query_579866 = newJObject()
  add(query_579866, "key", newJString(key))
  add(query_579866, "prettyPrint", newJBool(prettyPrint))
  add(query_579866, "oauth_token", newJString(oauthToken))
  add(query_579866, "alt", newJString(alt))
  add(query_579866, "userIp", newJString(userIp))
  add(query_579866, "quotaUser", newJString(quotaUser))
  add(path_579865, "userId", newJString(userId))
  add(path_579865, "sendAsEmail", newJString(sendAsEmail))
  add(query_579866, "fields", newJString(fields))
  result = call_579864.call(path_579865, query_579866, nil, nil, nil)

var gmailUsersSettingsSendAsVerify* = Call_GmailUsersSettingsSendAsVerify_579851(
    name: "gmailUsersSettingsSendAsVerify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{userId}/settings/sendAs/{sendAsEmail}/verify",
    validator: validate_GmailUsersSettingsSendAsVerify_579852,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsSendAsVerify_579853,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsUpdateVacation_579882 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsUpdateVacation_579884(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsUpdateVacation_579883(path: JsonNode;
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
  var valid_579885 = path.getOrDefault("userId")
  valid_579885 = validateParameter(valid_579885, JString, required = true,
                                 default = newJString("me"))
  if valid_579885 != nil:
    section.add "userId", valid_579885
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
  var valid_579886 = query.getOrDefault("key")
  valid_579886 = validateParameter(valid_579886, JString, required = false,
                                 default = nil)
  if valid_579886 != nil:
    section.add "key", valid_579886
  var valid_579887 = query.getOrDefault("prettyPrint")
  valid_579887 = validateParameter(valid_579887, JBool, required = false,
                                 default = newJBool(true))
  if valid_579887 != nil:
    section.add "prettyPrint", valid_579887
  var valid_579888 = query.getOrDefault("oauth_token")
  valid_579888 = validateParameter(valid_579888, JString, required = false,
                                 default = nil)
  if valid_579888 != nil:
    section.add "oauth_token", valid_579888
  var valid_579889 = query.getOrDefault("alt")
  valid_579889 = validateParameter(valid_579889, JString, required = false,
                                 default = newJString("json"))
  if valid_579889 != nil:
    section.add "alt", valid_579889
  var valid_579890 = query.getOrDefault("userIp")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = nil)
  if valid_579890 != nil:
    section.add "userIp", valid_579890
  var valid_579891 = query.getOrDefault("quotaUser")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "quotaUser", valid_579891
  var valid_579892 = query.getOrDefault("fields")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = nil)
  if valid_579892 != nil:
    section.add "fields", valid_579892
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

proc call*(call_579894: Call_GmailUsersSettingsUpdateVacation_579882;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vacation responder settings.
  ## 
  let valid = call_579894.validator(path, query, header, formData, body)
  let scheme = call_579894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579894.url(scheme.get, call_579894.host, call_579894.base,
                         call_579894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579894, url, valid)

proc call*(call_579895: Call_GmailUsersSettingsUpdateVacation_579882;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersSettingsUpdateVacation
  ## Updates vacation responder settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579896 = newJObject()
  var query_579897 = newJObject()
  var body_579898 = newJObject()
  add(query_579897, "key", newJString(key))
  add(query_579897, "prettyPrint", newJBool(prettyPrint))
  add(query_579897, "oauth_token", newJString(oauthToken))
  add(query_579897, "alt", newJString(alt))
  add(query_579897, "userIp", newJString(userIp))
  add(query_579897, "quotaUser", newJString(quotaUser))
  add(path_579896, "userId", newJString(userId))
  if body != nil:
    body_579898 = body
  add(query_579897, "fields", newJString(fields))
  result = call_579895.call(path_579896, query_579897, nil, nil, body_579898)

var gmailUsersSettingsUpdateVacation* = Call_GmailUsersSettingsUpdateVacation_579882(
    name: "gmailUsersSettingsUpdateVacation", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsUpdateVacation_579883,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsUpdateVacation_579884,
    schemes: {Scheme.Https})
type
  Call_GmailUsersSettingsGetVacation_579867 = ref object of OpenApiRestCall_578355
proc url_GmailUsersSettingsGetVacation_579869(protocol: Scheme; host: string;
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

proc validate_GmailUsersSettingsGetVacation_579868(path: JsonNode; query: JsonNode;
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
  var valid_579870 = path.getOrDefault("userId")
  valid_579870 = validateParameter(valid_579870, JString, required = true,
                                 default = newJString("me"))
  if valid_579870 != nil:
    section.add "userId", valid_579870
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
  var valid_579871 = query.getOrDefault("key")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = nil)
  if valid_579871 != nil:
    section.add "key", valid_579871
  var valid_579872 = query.getOrDefault("prettyPrint")
  valid_579872 = validateParameter(valid_579872, JBool, required = false,
                                 default = newJBool(true))
  if valid_579872 != nil:
    section.add "prettyPrint", valid_579872
  var valid_579873 = query.getOrDefault("oauth_token")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = nil)
  if valid_579873 != nil:
    section.add "oauth_token", valid_579873
  var valid_579874 = query.getOrDefault("alt")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = newJString("json"))
  if valid_579874 != nil:
    section.add "alt", valid_579874
  var valid_579875 = query.getOrDefault("userIp")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "userIp", valid_579875
  var valid_579876 = query.getOrDefault("quotaUser")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "quotaUser", valid_579876
  var valid_579877 = query.getOrDefault("fields")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = nil)
  if valid_579877 != nil:
    section.add "fields", valid_579877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579878: Call_GmailUsersSettingsGetVacation_579867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets vacation responder settings.
  ## 
  let valid = call_579878.validator(path, query, header, formData, body)
  let scheme = call_579878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579878.url(scheme.get, call_579878.host, call_579878.base,
                         call_579878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579878, url, valid)

proc call*(call_579879: Call_GmailUsersSettingsGetVacation_579867;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersSettingsGetVacation
  ## Gets vacation responder settings.
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
  ##   userId: string (required)
  ##         : User's email address. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579880 = newJObject()
  var query_579881 = newJObject()
  add(query_579881, "key", newJString(key))
  add(query_579881, "prettyPrint", newJBool(prettyPrint))
  add(query_579881, "oauth_token", newJString(oauthToken))
  add(query_579881, "alt", newJString(alt))
  add(query_579881, "userIp", newJString(userIp))
  add(query_579881, "quotaUser", newJString(quotaUser))
  add(path_579880, "userId", newJString(userId))
  add(query_579881, "fields", newJString(fields))
  result = call_579879.call(path_579880, query_579881, nil, nil, nil)

var gmailUsersSettingsGetVacation* = Call_GmailUsersSettingsGetVacation_579867(
    name: "gmailUsersSettingsGetVacation", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/settings/vacation",
    validator: validate_GmailUsersSettingsGetVacation_579868,
    base: "/gmail/v1/users", url: url_GmailUsersSettingsGetVacation_579869,
    schemes: {Scheme.Https})
type
  Call_GmailUsersStop_579899 = ref object of OpenApiRestCall_578355
proc url_GmailUsersStop_579901(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersStop_579900(path: JsonNode; query: JsonNode;
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
  var valid_579902 = path.getOrDefault("userId")
  valid_579902 = validateParameter(valid_579902, JString, required = true,
                                 default = newJString("me"))
  if valid_579902 != nil:
    section.add "userId", valid_579902
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
  var valid_579903 = query.getOrDefault("key")
  valid_579903 = validateParameter(valid_579903, JString, required = false,
                                 default = nil)
  if valid_579903 != nil:
    section.add "key", valid_579903
  var valid_579904 = query.getOrDefault("prettyPrint")
  valid_579904 = validateParameter(valid_579904, JBool, required = false,
                                 default = newJBool(true))
  if valid_579904 != nil:
    section.add "prettyPrint", valid_579904
  var valid_579905 = query.getOrDefault("oauth_token")
  valid_579905 = validateParameter(valid_579905, JString, required = false,
                                 default = nil)
  if valid_579905 != nil:
    section.add "oauth_token", valid_579905
  var valid_579906 = query.getOrDefault("alt")
  valid_579906 = validateParameter(valid_579906, JString, required = false,
                                 default = newJString("json"))
  if valid_579906 != nil:
    section.add "alt", valid_579906
  var valid_579907 = query.getOrDefault("userIp")
  valid_579907 = validateParameter(valid_579907, JString, required = false,
                                 default = nil)
  if valid_579907 != nil:
    section.add "userIp", valid_579907
  var valid_579908 = query.getOrDefault("quotaUser")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "quotaUser", valid_579908
  var valid_579909 = query.getOrDefault("fields")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = nil)
  if valid_579909 != nil:
    section.add "fields", valid_579909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579910: Call_GmailUsersStop_579899; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop receiving push notifications for the given user mailbox.
  ## 
  let valid = call_579910.validator(path, query, header, formData, body)
  let scheme = call_579910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579910.url(scheme.get, call_579910.host, call_579910.base,
                         call_579910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579910, url, valid)

proc call*(call_579911: Call_GmailUsersStop_579899; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          fields: string = ""): Recallable =
  ## gmailUsersStop
  ## Stop receiving push notifications for the given user mailbox.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579912 = newJObject()
  var query_579913 = newJObject()
  add(query_579913, "key", newJString(key))
  add(query_579913, "prettyPrint", newJBool(prettyPrint))
  add(query_579913, "oauth_token", newJString(oauthToken))
  add(query_579913, "alt", newJString(alt))
  add(query_579913, "userIp", newJString(userIp))
  add(query_579913, "quotaUser", newJString(quotaUser))
  add(path_579912, "userId", newJString(userId))
  add(query_579913, "fields", newJString(fields))
  result = call_579911.call(path_579912, query_579913, nil, nil, nil)

var gmailUsersStop* = Call_GmailUsersStop_579899(name: "gmailUsersStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/stop",
    validator: validate_GmailUsersStop_579900, base: "/gmail/v1/users",
    url: url_GmailUsersStop_579901, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsList_579914 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsList_579916(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsList_579915(path: JsonNode; query: JsonNode;
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
  var valid_579917 = path.getOrDefault("userId")
  valid_579917 = validateParameter(valid_579917, JString, required = true,
                                 default = newJString("me"))
  if valid_579917 != nil:
    section.add "userId", valid_579917
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labelIds: JArray
  ##           : Only return threads with labels that match all of the specified label IDs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString
  ##    : Only return threads matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: JBool
  ##                   : Include threads from SPAM and TRASH in the results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token to retrieve a specific page of results in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of threads to return.
  section = newJObject()
  var valid_579918 = query.getOrDefault("key")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "key", valid_579918
  var valid_579919 = query.getOrDefault("labelIds")
  valid_579919 = validateParameter(valid_579919, JArray, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "labelIds", valid_579919
  var valid_579920 = query.getOrDefault("prettyPrint")
  valid_579920 = validateParameter(valid_579920, JBool, required = false,
                                 default = newJBool(true))
  if valid_579920 != nil:
    section.add "prettyPrint", valid_579920
  var valid_579921 = query.getOrDefault("oauth_token")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "oauth_token", valid_579921
  var valid_579922 = query.getOrDefault("q")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "q", valid_579922
  var valid_579923 = query.getOrDefault("alt")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = newJString("json"))
  if valid_579923 != nil:
    section.add "alt", valid_579923
  var valid_579924 = query.getOrDefault("userIp")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "userIp", valid_579924
  var valid_579925 = query.getOrDefault("includeSpamTrash")
  valid_579925 = validateParameter(valid_579925, JBool, required = false,
                                 default = newJBool(false))
  if valid_579925 != nil:
    section.add "includeSpamTrash", valid_579925
  var valid_579926 = query.getOrDefault("quotaUser")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "quotaUser", valid_579926
  var valid_579927 = query.getOrDefault("pageToken")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "pageToken", valid_579927
  var valid_579928 = query.getOrDefault("fields")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "fields", valid_579928
  var valid_579929 = query.getOrDefault("maxResults")
  valid_579929 = validateParameter(valid_579929, JInt, required = false,
                                 default = newJInt(100))
  if valid_579929 != nil:
    section.add "maxResults", valid_579929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579930: Call_GmailUsersThreadsList_579914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the threads in the user's mailbox.
  ## 
  let valid = call_579930.validator(path, query, header, formData, body)
  let scheme = call_579930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579930.url(scheme.get, call_579930.host, call_579930.base,
                         call_579930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579930, url, valid)

proc call*(call_579931: Call_GmailUsersThreadsList_579914; key: string = "";
          labelIds: JsonNode = nil; prettyPrint: bool = true; oauthToken: string = "";
          q: string = ""; alt: string = "json"; userIp: string = "";
          includeSpamTrash: bool = false; quotaUser: string = "";
          pageToken: string = ""; userId: string = "me"; fields: string = "";
          maxResults: int = 100): Recallable =
  ## gmailUsersThreadsList
  ## Lists the threads in the user's mailbox.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labelIds: JArray
  ##           : Only return threads with labels that match all of the specified label IDs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string
  ##    : Only return threads matching the specified query. Supports the same query format as the Gmail search box. For example, "from:someuser@example.com rfc822msgid: is:unread". Parameter cannot be used when accessing the api using the gmail.metadata scope.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   includeSpamTrash: bool
  ##                   : Include threads from SPAM and TRASH in the results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token to retrieve a specific page of results in the list.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of threads to return.
  var path_579932 = newJObject()
  var query_579933 = newJObject()
  add(query_579933, "key", newJString(key))
  if labelIds != nil:
    query_579933.add "labelIds", labelIds
  add(query_579933, "prettyPrint", newJBool(prettyPrint))
  add(query_579933, "oauth_token", newJString(oauthToken))
  add(query_579933, "q", newJString(q))
  add(query_579933, "alt", newJString(alt))
  add(query_579933, "userIp", newJString(userIp))
  add(query_579933, "includeSpamTrash", newJBool(includeSpamTrash))
  add(query_579933, "quotaUser", newJString(quotaUser))
  add(query_579933, "pageToken", newJString(pageToken))
  add(path_579932, "userId", newJString(userId))
  add(query_579933, "fields", newJString(fields))
  add(query_579933, "maxResults", newJInt(maxResults))
  result = call_579931.call(path_579932, query_579933, nil, nil, nil)

var gmailUsersThreadsList* = Call_GmailUsersThreadsList_579914(
    name: "gmailUsersThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads",
    validator: validate_GmailUsersThreadsList_579915, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsList_579916, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsGet_579934 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsGet_579936(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsGet_579935(path: JsonNode; query: JsonNode;
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
  var valid_579937 = path.getOrDefault("id")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "id", valid_579937
  var valid_579938 = path.getOrDefault("userId")
  valid_579938 = validateParameter(valid_579938, JString, required = true,
                                 default = newJString("me"))
  if valid_579938 != nil:
    section.add "userId", valid_579938
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   format: JString
  ##         : The format to return the messages in.
  section = newJObject()
  var valid_579939 = query.getOrDefault("key")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "key", valid_579939
  var valid_579940 = query.getOrDefault("prettyPrint")
  valid_579940 = validateParameter(valid_579940, JBool, required = false,
                                 default = newJBool(true))
  if valid_579940 != nil:
    section.add "prettyPrint", valid_579940
  var valid_579941 = query.getOrDefault("oauth_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "oauth_token", valid_579941
  var valid_579942 = query.getOrDefault("metadataHeaders")
  valid_579942 = validateParameter(valid_579942, JArray, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "metadataHeaders", valid_579942
  var valid_579943 = query.getOrDefault("alt")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("json"))
  if valid_579943 != nil:
    section.add "alt", valid_579943
  var valid_579944 = query.getOrDefault("userIp")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "userIp", valid_579944
  var valid_579945 = query.getOrDefault("quotaUser")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "quotaUser", valid_579945
  var valid_579946 = query.getOrDefault("fields")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "fields", valid_579946
  var valid_579947 = query.getOrDefault("format")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = newJString("full"))
  if valid_579947 != nil:
    section.add "format", valid_579947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579948: Call_GmailUsersThreadsGet_579934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified thread.
  ## 
  let valid = call_579948.validator(path, query, header, formData, body)
  let scheme = call_579948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579948.url(scheme.get, call_579948.host, call_579948.base,
                         call_579948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579948, url, valid)

proc call*(call_579949: Call_GmailUsersThreadsGet_579934; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          metadataHeaders: JsonNode = nil; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; userId: string = "me"; fields: string = "";
          format: string = "full"): Recallable =
  ## gmailUsersThreadsGet
  ## Gets the specified thread.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metadataHeaders: JArray
  ##                  : When given and format is METADATA, only include headers specified.
  ##   id: string (required)
  ##     : The ID of the thread to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   format: string
  ##         : The format to return the messages in.
  var path_579950 = newJObject()
  var query_579951 = newJObject()
  add(query_579951, "key", newJString(key))
  add(query_579951, "prettyPrint", newJBool(prettyPrint))
  add(query_579951, "oauth_token", newJString(oauthToken))
  if metadataHeaders != nil:
    query_579951.add "metadataHeaders", metadataHeaders
  add(path_579950, "id", newJString(id))
  add(query_579951, "alt", newJString(alt))
  add(query_579951, "userIp", newJString(userIp))
  add(query_579951, "quotaUser", newJString(quotaUser))
  add(path_579950, "userId", newJString(userId))
  add(query_579951, "fields", newJString(fields))
  add(query_579951, "format", newJString(format))
  result = call_579949.call(path_579950, query_579951, nil, nil, nil)

var gmailUsersThreadsGet* = Call_GmailUsersThreadsGet_579934(
    name: "gmailUsersThreadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsGet_579935, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsGet_579936, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsDelete_579952 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsDelete_579954(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsDelete_579953(path: JsonNode; query: JsonNode;
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
  var valid_579955 = path.getOrDefault("id")
  valid_579955 = validateParameter(valid_579955, JString, required = true,
                                 default = nil)
  if valid_579955 != nil:
    section.add "id", valid_579955
  var valid_579956 = path.getOrDefault("userId")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = newJString("me"))
  if valid_579956 != nil:
    section.add "userId", valid_579956
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
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("alt")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("json"))
  if valid_579960 != nil:
    section.add "alt", valid_579960
  var valid_579961 = query.getOrDefault("userIp")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "userIp", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579964: Call_GmailUsersThreadsDelete_579952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ## 
  let valid = call_579964.validator(path, query, header, formData, body)
  let scheme = call_579964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579964.url(scheme.get, call_579964.host, call_579964.base,
                         call_579964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579964, url, valid)

proc call*(call_579965: Call_GmailUsersThreadsDelete_579952; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersThreadsDelete
  ## Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : ID of the Thread to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579966 = newJObject()
  var query_579967 = newJObject()
  add(query_579967, "key", newJString(key))
  add(query_579967, "prettyPrint", newJBool(prettyPrint))
  add(query_579967, "oauth_token", newJString(oauthToken))
  add(path_579966, "id", newJString(id))
  add(query_579967, "alt", newJString(alt))
  add(query_579967, "userIp", newJString(userIp))
  add(query_579967, "quotaUser", newJString(quotaUser))
  add(path_579966, "userId", newJString(userId))
  add(query_579967, "fields", newJString(fields))
  result = call_579965.call(path_579966, query_579967, nil, nil, nil)

var gmailUsersThreadsDelete* = Call_GmailUsersThreadsDelete_579952(
    name: "gmailUsersThreadsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}",
    validator: validate_GmailUsersThreadsDelete_579953, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsDelete_579954, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsModify_579968 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsModify_579970(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsModify_579969(path: JsonNode; query: JsonNode;
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
  var valid_579971 = path.getOrDefault("id")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "id", valid_579971
  var valid_579972 = path.getOrDefault("userId")
  valid_579972 = validateParameter(valid_579972, JString, required = true,
                                 default = newJString("me"))
  if valid_579972 != nil:
    section.add "userId", valid_579972
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
  var valid_579973 = query.getOrDefault("key")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "key", valid_579973
  var valid_579974 = query.getOrDefault("prettyPrint")
  valid_579974 = validateParameter(valid_579974, JBool, required = false,
                                 default = newJBool(true))
  if valid_579974 != nil:
    section.add "prettyPrint", valid_579974
  var valid_579975 = query.getOrDefault("oauth_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "oauth_token", valid_579975
  var valid_579976 = query.getOrDefault("alt")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("json"))
  if valid_579976 != nil:
    section.add "alt", valid_579976
  var valid_579977 = query.getOrDefault("userIp")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "userIp", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
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

proc call*(call_579981: Call_GmailUsersThreadsModify_579968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_GmailUsersThreadsModify_579968; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersThreadsModify
  ## Modifies the labels applied to the thread. This applies to all messages in the thread.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the thread to modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579983 = newJObject()
  var query_579984 = newJObject()
  var body_579985 = newJObject()
  add(query_579984, "key", newJString(key))
  add(query_579984, "prettyPrint", newJBool(prettyPrint))
  add(query_579984, "oauth_token", newJString(oauthToken))
  add(path_579983, "id", newJString(id))
  add(query_579984, "alt", newJString(alt))
  add(query_579984, "userIp", newJString(userIp))
  add(query_579984, "quotaUser", newJString(quotaUser))
  add(path_579983, "userId", newJString(userId))
  if body != nil:
    body_579985 = body
  add(query_579984, "fields", newJString(fields))
  result = call_579982.call(path_579983, query_579984, nil, nil, body_579985)

var gmailUsersThreadsModify* = Call_GmailUsersThreadsModify_579968(
    name: "gmailUsersThreadsModify", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/modify",
    validator: validate_GmailUsersThreadsModify_579969, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsModify_579970, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsTrash_579986 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsTrash_579988(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersThreadsTrash_579987(path: JsonNode; query: JsonNode;
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
  var valid_579989 = path.getOrDefault("id")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "id", valid_579989
  var valid_579990 = path.getOrDefault("userId")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = newJString("me"))
  if valid_579990 != nil:
    section.add "userId", valid_579990
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
  if body != nil:
    result.add "body", body

proc call*(call_579998: Call_GmailUsersThreadsTrash_579986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified thread to the trash.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_GmailUsersThreadsTrash_579986; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersThreadsTrash
  ## Moves the specified thread to the trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the thread to Trash.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580000 = newJObject()
  var query_580001 = newJObject()
  add(query_580001, "key", newJString(key))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(path_580000, "id", newJString(id))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "userIp", newJString(userIp))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(path_580000, "userId", newJString(userId))
  add(query_580001, "fields", newJString(fields))
  result = call_579999.call(path_580000, query_580001, nil, nil, nil)

var gmailUsersThreadsTrash* = Call_GmailUsersThreadsTrash_579986(
    name: "gmailUsersThreadsTrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/trash",
    validator: validate_GmailUsersThreadsTrash_579987, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsTrash_579988, schemes: {Scheme.Https})
type
  Call_GmailUsersThreadsUntrash_580002 = ref object of OpenApiRestCall_578355
proc url_GmailUsersThreadsUntrash_580004(protocol: Scheme; host: string;
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

proc validate_GmailUsersThreadsUntrash_580003(path: JsonNode; query: JsonNode;
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
  var valid_580005 = path.getOrDefault("id")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "id", valid_580005
  var valid_580006 = path.getOrDefault("userId")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = newJString("me"))
  if valid_580006 != nil:
    section.add "userId", valid_580006
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
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("userIp")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "userIp", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580014: Call_GmailUsersThreadsUntrash_580002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the specified thread from the trash.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_GmailUsersThreadsUntrash_580002; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userId: string = "me"; fields: string = ""): Recallable =
  ## gmailUsersThreadsUntrash
  ## Removes the specified thread from the trash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the thread to remove from Trash.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  add(query_580017, "key", newJString(key))
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(path_580016, "id", newJString(id))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "userIp", newJString(userIp))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(path_580016, "userId", newJString(userId))
  add(query_580017, "fields", newJString(fields))
  result = call_580015.call(path_580016, query_580017, nil, nil, nil)

var gmailUsersThreadsUntrash* = Call_GmailUsersThreadsUntrash_580002(
    name: "gmailUsersThreadsUntrash", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{userId}/threads/{id}/untrash",
    validator: validate_GmailUsersThreadsUntrash_580003, base: "/gmail/v1/users",
    url: url_GmailUsersThreadsUntrash_580004, schemes: {Scheme.Https})
type
  Call_GmailUsersWatch_580018 = ref object of OpenApiRestCall_578355
proc url_GmailUsersWatch_580020(protocol: Scheme; host: string; base: string;
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

proc validate_GmailUsersWatch_580019(path: JsonNode; query: JsonNode;
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
  var valid_580021 = path.getOrDefault("userId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = newJString("me"))
  if valid_580021 != nil:
    section.add "userId", valid_580021
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
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
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

proc call*(call_580030: Call_GmailUsersWatch_580018; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set up or update a push notification watch on the given user mailbox.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_GmailUsersWatch_580018; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userId: string = "me";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gmailUsersWatch
  ## Set up or update a push notification watch on the given user mailbox.
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
  ##   userId: string (required)
  ##         : The user's email address. The special value me can be used to indicate the authenticated user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "userId", newJString(userId))
  if body != nil:
    body_580034 = body
  add(query_580033, "fields", newJString(fields))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var gmailUsersWatch* = Call_GmailUsersWatch_580018(name: "gmailUsersWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{userId}/watch",
    validator: validate_GmailUsersWatch_580019, base: "/gmail/v1/users",
    url: url_GmailUsersWatch_580020, schemes: {Scheme.Https})
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
