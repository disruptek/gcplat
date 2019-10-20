
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Blogger
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for access to the data within Blogger.
## 
## https://developers.google.com/blogger/docs/2.0/json/getting_started
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "blogger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGet_578609 = ref object of OpenApiRestCall_578339
proc url_BloggerBlogsGet_578611(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsGet_578610(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578737 = path.getOrDefault("blogId")
  valid_578737 = validateParameter(valid_578737, JString, required = true,
                                 default = nil)
  if valid_578737 != nil:
    section.add "blogId", valid_578737
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
  var valid_578738 = query.getOrDefault("key")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "key", valid_578738
  var valid_578752 = query.getOrDefault("prettyPrint")
  valid_578752 = validateParameter(valid_578752, JBool, required = false,
                                 default = newJBool(true))
  if valid_578752 != nil:
    section.add "prettyPrint", valid_578752
  var valid_578753 = query.getOrDefault("oauth_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "oauth_token", valid_578753
  var valid_578754 = query.getOrDefault("alt")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = newJString("json"))
  if valid_578754 != nil:
    section.add "alt", valid_578754
  var valid_578755 = query.getOrDefault("userIp")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "userIp", valid_578755
  var valid_578756 = query.getOrDefault("quotaUser")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "quotaUser", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578780: Call_BloggerBlogsGet_578609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by id.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_BloggerBlogsGet_578609; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerBlogsGet
  ## Gets one blog by id.
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
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578852 = newJObject()
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "userIp", newJString(userIp))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(path_578852, "blogId", newJString(blogId))
  add(query_578854, "fields", newJString(fields))
  result = call_578851.call(path_578852, query_578854, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_578609(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_578610, base: "/blogger/v2",
    url: url_BloggerBlogsGet_578611, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_578893 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesList_578895(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesList_578894(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves pages for a blog, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch pages from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578896 = path.getOrDefault("blogId")
  valid_578896 = validateParameter(valid_578896, JString, required = true,
                                 default = nil)
  if valid_578896 != nil:
    section.add "blogId", valid_578896
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
  ##   fetchBodies: JBool
  ##              : Whether to retrieve the Page bodies.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("prettyPrint")
  valid_578898 = validateParameter(valid_578898, JBool, required = false,
                                 default = newJBool(true))
  if valid_578898 != nil:
    section.add "prettyPrint", valid_578898
  var valid_578899 = query.getOrDefault("oauth_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "oauth_token", valid_578899
  var valid_578900 = query.getOrDefault("alt")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("json"))
  if valid_578900 != nil:
    section.add "alt", valid_578900
  var valid_578901 = query.getOrDefault("userIp")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "userIp", valid_578901
  var valid_578902 = query.getOrDefault("quotaUser")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "quotaUser", valid_578902
  var valid_578903 = query.getOrDefault("fetchBodies")
  valid_578903 = validateParameter(valid_578903, JBool, required = false, default = nil)
  if valid_578903 != nil:
    section.add "fetchBodies", valid_578903
  var valid_578904 = query.getOrDefault("fields")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "fields", valid_578904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578905: Call_BloggerPagesList_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves pages for a blog, possibly filtered.
  ## 
  let valid = call_578905.validator(path, query, header, formData, body)
  let scheme = call_578905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578905.url(scheme.get, call_578905.host, call_578905.base,
                         call_578905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578905, url, valid)

proc call*(call_578906: Call_BloggerPagesList_578893; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fetchBodies: bool = false; fields: string = ""): Recallable =
  ## bloggerPagesList
  ## Retrieves pages for a blog, possibly filtered.
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
  ##   blogId: string (required)
  ##         : ID of the blog to fetch pages from.
  ##   fetchBodies: bool
  ##              : Whether to retrieve the Page bodies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578907 = newJObject()
  var query_578908 = newJObject()
  add(query_578908, "key", newJString(key))
  add(query_578908, "prettyPrint", newJBool(prettyPrint))
  add(query_578908, "oauth_token", newJString(oauthToken))
  add(query_578908, "alt", newJString(alt))
  add(query_578908, "userIp", newJString(userIp))
  add(query_578908, "quotaUser", newJString(quotaUser))
  add(path_578907, "blogId", newJString(blogId))
  add(query_578908, "fetchBodies", newJBool(fetchBodies))
  add(query_578908, "fields", newJString(fields))
  result = call_578906.call(path_578907, query_578908, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_578893(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_578894,
    base: "/blogger/v2", url: url_BloggerPagesList_578895, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_578909 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesGet_578911(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesGet_578910(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog page by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog containing the page.
  ##   pageId: JString (required)
  ##         : The ID of the page to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578912 = path.getOrDefault("blogId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "blogId", valid_578912
  var valid_578913 = path.getOrDefault("pageId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "pageId", valid_578913
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
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("userIp")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "userIp", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578921: Call_BloggerPagesGet_578909; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by id.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_BloggerPagesGet_578909; blogId: string; pageId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerPagesGet
  ## Gets one blog page by id.
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
  ##   blogId: string (required)
  ##         : ID of the blog containing the page.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page to get.
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "userIp", newJString(userIp))
  add(query_578924, "quotaUser", newJString(quotaUser))
  add(path_578923, "blogId", newJString(blogId))
  add(query_578924, "fields", newJString(fields))
  add(path_578923, "pageId", newJString(pageId))
  result = call_578922.call(path_578923, query_578924, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_578909(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_578910,
    base: "/blogger/v2", url: url_BloggerPagesGet_578911, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_578925 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsList_578927(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsList_578926(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578928 = path.getOrDefault("blogId")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "blogId", valid_578928
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
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  section = newJObject()
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
  var valid_578930 = query.getOrDefault("prettyPrint")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "prettyPrint", valid_578930
  var valid_578931 = query.getOrDefault("oauth_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "oauth_token", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("userIp")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userIp", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("pageToken")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "pageToken", valid_578935
  var valid_578936 = query.getOrDefault("fetchBodies")
  valid_578936 = validateParameter(valid_578936, JBool, required = false, default = nil)
  if valid_578936 != nil:
    section.add "fetchBodies", valid_578936
  var valid_578937 = query.getOrDefault("fields")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "fields", valid_578937
  var valid_578938 = query.getOrDefault("startDate")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "startDate", valid_578938
  var valid_578939 = query.getOrDefault("maxResults")
  valid_578939 = validateParameter(valid_578939, JInt, required = false, default = nil)
  if valid_578939 != nil:
    section.add "maxResults", valid_578939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578940: Call_BloggerPostsList_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_578940.validator(path, query, header, formData, body)
  let scheme = call_578940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578940.url(scheme.get, call_578940.host, call_578940.base,
                         call_578940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578940, url, valid)

proc call*(call_578941: Call_BloggerPostsList_578925; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fetchBodies: bool = false; fields: string = "";
          startDate: string = ""; maxResults: int = 0): Recallable =
  ## bloggerPostsList
  ## Retrieves a list of posts, possibly filtered.
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
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  var path_578942 = newJObject()
  var query_578943 = newJObject()
  add(query_578943, "key", newJString(key))
  add(query_578943, "prettyPrint", newJBool(prettyPrint))
  add(query_578943, "oauth_token", newJString(oauthToken))
  add(query_578943, "alt", newJString(alt))
  add(query_578943, "userIp", newJString(userIp))
  add(query_578943, "quotaUser", newJString(quotaUser))
  add(query_578943, "pageToken", newJString(pageToken))
  add(path_578942, "blogId", newJString(blogId))
  add(query_578943, "fetchBodies", newJBool(fetchBodies))
  add(query_578943, "fields", newJString(fields))
  add(query_578943, "startDate", newJString(startDate))
  add(query_578943, "maxResults", newJInt(maxResults))
  result = call_578941.call(path_578942, query_578943, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_578925(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_578926,
    base: "/blogger/v2", url: url_BloggerPostsList_578927, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_578944 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsGet_578946(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsGet_578945(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a post by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the post
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch the post from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_578947 = path.getOrDefault("postId")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "postId", valid_578947
  var valid_578948 = path.getOrDefault("blogId")
  valid_578948 = validateParameter(valid_578948, JString, required = true,
                                 default = nil)
  if valid_578948 != nil:
    section.add "blogId", valid_578948
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
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("userIp")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "userIp", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_BloggerPostsGet_578944; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by id.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_BloggerPostsGet_578944; postId: string; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerPostsGet
  ## Get a post by id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the post
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(path_578958, "postId", newJString(postId))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "userIp", newJString(userIp))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(path_578958, "blogId", newJString(blogId))
  add(query_578959, "fields", newJString(fields))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_578944(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_578945,
    base: "/blogger/v2", url: url_BloggerPostsGet_578946, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_578960 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsList_578962(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsList_578961(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the comments for a blog, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch comments from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_578963 = path.getOrDefault("postId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "postId", valid_578963
  var valid_578964 = path.getOrDefault("blogId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "blogId", valid_578964
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
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  section = newJObject()
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("pageToken")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "pageToken", valid_578971
  var valid_578972 = query.getOrDefault("fetchBodies")
  valid_578972 = validateParameter(valid_578972, JBool, required = false, default = nil)
  if valid_578972 != nil:
    section.add "fetchBodies", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("startDate")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "startDate", valid_578974
  var valid_578975 = query.getOrDefault("maxResults")
  valid_578975 = validateParameter(valid_578975, JInt, required = false, default = nil)
  if valid_578975 != nil:
    section.add "maxResults", valid_578975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_BloggerCommentsList_578960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, possibly filtered.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_BloggerCommentsList_578960; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fetchBodies: bool = false;
          fields: string = ""; startDate: string = ""; maxResults: int = 0): Recallable =
  ## bloggerCommentsList
  ## Retrieves the comments for a blog, possibly filtered.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(path_578978, "postId", newJString(postId))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "userIp", newJString(userIp))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(query_578979, "pageToken", newJString(pageToken))
  add(path_578978, "blogId", newJString(blogId))
  add(query_578979, "fetchBodies", newJBool(fetchBodies))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "startDate", newJString(startDate))
  add(query_578979, "maxResults", newJInt(maxResults))
  result = call_578977.call(path_578978, query_578979, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_578960(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_578961, base: "/blogger/v2",
    url: url_BloggerCommentsList_578962, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_578980 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsGet_578982(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsGet_578981(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets one comment by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  ##   blogId: JString (required)
  ##         : ID of the blog to containing the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_578983 = path.getOrDefault("postId")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "postId", valid_578983
  var valid_578984 = path.getOrDefault("commentId")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "commentId", valid_578984
  var valid_578985 = path.getOrDefault("blogId")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "blogId", valid_578985
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
  var valid_578986 = query.getOrDefault("key")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "key", valid_578986
  var valid_578987 = query.getOrDefault("prettyPrint")
  valid_578987 = validateParameter(valid_578987, JBool, required = false,
                                 default = newJBool(true))
  if valid_578987 != nil:
    section.add "prettyPrint", valid_578987
  var valid_578988 = query.getOrDefault("oauth_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "oauth_token", valid_578988
  var valid_578989 = query.getOrDefault("alt")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = newJString("json"))
  if valid_578989 != nil:
    section.add "alt", valid_578989
  var valid_578990 = query.getOrDefault("userIp")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "userIp", valid_578990
  var valid_578991 = query.getOrDefault("quotaUser")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "quotaUser", valid_578991
  var valid_578992 = query.getOrDefault("fields")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "fields", valid_578992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578993: Call_BloggerCommentsGet_578980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by id.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_BloggerCommentsGet_578980; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerCommentsGet
  ## Gets one comment by id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to get.
  ##   blogId: string (required)
  ##         : ID of the blog to containing the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(path_578995, "postId", newJString(postId))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "userIp", newJString(userIp))
  add(query_578996, "quotaUser", newJString(quotaUser))
  add(path_578995, "commentId", newJString(commentId))
  add(path_578995, "blogId", newJString(blogId))
  add(query_578996, "fields", newJString(fields))
  result = call_578994.call(path_578995, query_578996, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_578980(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_578981, base: "/blogger/v2",
    url: url_BloggerCommentsGet_578982, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_578997 = ref object of OpenApiRestCall_578339
proc url_BloggerUsersGet_578999(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersGet_578998(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one user by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579000 = path.getOrDefault("userId")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "userId", valid_579000
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("userIp")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "userIp", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_BloggerUsersGet_578997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by id.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_BloggerUsersGet_578997; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerUsersGet
  ## Gets one user by id.
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
  ##         : The ID of the user to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "userId", newJString(userId))
  add(query_579011, "fields", newJString(fields))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_578997(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_578998, base: "/blogger/v2",
    url: url_BloggerUsersGet_578999, schemes: {Scheme.Https})
type
  Call_BloggerUsersBlogsList_579012 = ref object of OpenApiRestCall_578339
proc url_BloggerUsersBlogsList_579014(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersBlogsList_579013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579015 = path.getOrDefault("userId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "userId", valid_579015
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
  var valid_579016 = query.getOrDefault("key")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "key", valid_579016
  var valid_579017 = query.getOrDefault("prettyPrint")
  valid_579017 = validateParameter(valid_579017, JBool, required = false,
                                 default = newJBool(true))
  if valid_579017 != nil:
    section.add "prettyPrint", valid_579017
  var valid_579018 = query.getOrDefault("oauth_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "oauth_token", valid_579018
  var valid_579019 = query.getOrDefault("alt")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("json"))
  if valid_579019 != nil:
    section.add "alt", valid_579019
  var valid_579020 = query.getOrDefault("userIp")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "userIp", valid_579020
  var valid_579021 = query.getOrDefault("quotaUser")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "quotaUser", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579023: Call_BloggerUsersBlogsList_579012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_579023.validator(path, query, header, formData, body)
  let scheme = call_579023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579023.url(scheme.get, call_579023.host, call_579023.base,
                         call_579023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579023, url, valid)

proc call*(call_579024: Call_BloggerUsersBlogsList_579012; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerUsersBlogsList
  ## Retrieves a list of blogs, possibly filtered.
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
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579025 = newJObject()
  var query_579026 = newJObject()
  add(query_579026, "key", newJString(key))
  add(query_579026, "prettyPrint", newJBool(prettyPrint))
  add(query_579026, "oauth_token", newJString(oauthToken))
  add(query_579026, "alt", newJString(alt))
  add(query_579026, "userIp", newJString(userIp))
  add(query_579026, "quotaUser", newJString(quotaUser))
  add(path_579025, "userId", newJString(userId))
  add(query_579026, "fields", newJString(fields))
  result = call_579024.call(path_579025, query_579026, nil, nil, nil)

var bloggerUsersBlogsList* = Call_BloggerUsersBlogsList_579012(
    name: "bloggerUsersBlogsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerUsersBlogsList_579013, base: "/blogger/v2",
    url: url_BloggerUsersBlogsList_579014, schemes: {Scheme.Https})
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
