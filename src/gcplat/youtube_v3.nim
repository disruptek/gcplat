
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: YouTube Data
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Supports core YouTube features, such as uploading videos, creating and managing playlists, searching for content, and much more.
## 
## https://developers.google.com/youtube/v3
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtube"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeActivitiesInsert_593983 = ref object of OpenApiRestCall_593437
proc url_YoutubeActivitiesInsert_593985(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesInsert_593984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593986 = query.getOrDefault("fields")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "fields", valid_593986
  var valid_593987 = query.getOrDefault("quotaUser")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "quotaUser", valid_593987
  var valid_593988 = query.getOrDefault("alt")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = newJString("json"))
  if valid_593988 != nil:
    section.add "alt", valid_593988
  var valid_593989 = query.getOrDefault("oauth_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "oauth_token", valid_593989
  var valid_593990 = query.getOrDefault("userIp")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "userIp", valid_593990
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_593991 = query.getOrDefault("part")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "part", valid_593991
  var valid_593992 = query.getOrDefault("key")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "key", valid_593992
  var valid_593993 = query.getOrDefault("prettyPrint")
  valid_593993 = validateParameter(valid_593993, JBool, required = false,
                                 default = newJBool(true))
  if valid_593993 != nil:
    section.add "prettyPrint", valid_593993
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

proc call*(call_593995: Call_YoutubeActivitiesInsert_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_YoutubeActivitiesInsert_593983; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesInsert
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "fields", newJString(fields))
  add(query_593997, "quotaUser", newJString(quotaUser))
  add(query_593997, "alt", newJString(alt))
  add(query_593997, "oauth_token", newJString(oauthToken))
  add(query_593997, "userIp", newJString(userIp))
  add(query_593997, "part", newJString(part))
  add(query_593997, "key", newJString(key))
  if body != nil:
    body_593998 = body
  add(query_593997, "prettyPrint", newJBool(prettyPrint))
  result = call_593996.call(nil, query_593997, nil, nil, body_593998)

var youtubeActivitiesInsert* = Call_YoutubeActivitiesInsert_593983(
    name: "youtubeActivitiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesInsert_593984, base: "/youtube/v3",
    url: url_YoutubeActivitiesInsert_593985, schemes: {Scheme.Https})
type
  Call_YoutubeActivitiesList_593705 = ref object of OpenApiRestCall_593437
proc url_YoutubeActivitiesList_593707(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesList_593706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   home: JBool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593819 = query.getOrDefault("mine")
  valid_593819 = validateParameter(valid_593819, JBool, required = false, default = nil)
  if valid_593819 != nil:
    section.add "mine", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("publishedAfter")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "publishedAfter", valid_593821
  var valid_593822 = query.getOrDefault("quotaUser")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "quotaUser", valid_593822
  var valid_593823 = query.getOrDefault("pageToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "pageToken", valid_593823
  var valid_593837 = query.getOrDefault("alt")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = newJString("json"))
  if valid_593837 != nil:
    section.add "alt", valid_593837
  var valid_593838 = query.getOrDefault("home")
  valid_593838 = validateParameter(valid_593838, JBool, required = false, default = nil)
  if valid_593838 != nil:
    section.add "home", valid_593838
  var valid_593839 = query.getOrDefault("oauth_token")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "oauth_token", valid_593839
  var valid_593840 = query.getOrDefault("userIp")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "userIp", valid_593840
  var valid_593842 = query.getOrDefault("maxResults")
  valid_593842 = validateParameter(valid_593842, JInt, required = false,
                                 default = newJInt(5))
  if valid_593842 != nil:
    section.add "maxResults", valid_593842
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_593843 = query.getOrDefault("part")
  valid_593843 = validateParameter(valid_593843, JString, required = true,
                                 default = nil)
  if valid_593843 != nil:
    section.add "part", valid_593843
  var valid_593844 = query.getOrDefault("channelId")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "channelId", valid_593844
  var valid_593845 = query.getOrDefault("regionCode")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = nil)
  if valid_593845 != nil:
    section.add "regionCode", valid_593845
  var valid_593846 = query.getOrDefault("key")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "key", valid_593846
  var valid_593847 = query.getOrDefault("publishedBefore")
  valid_593847 = validateParameter(valid_593847, JString, required = false,
                                 default = nil)
  if valid_593847 != nil:
    section.add "publishedBefore", valid_593847
  var valid_593848 = query.getOrDefault("prettyPrint")
  valid_593848 = validateParameter(valid_593848, JBool, required = false,
                                 default = newJBool(true))
  if valid_593848 != nil:
    section.add "prettyPrint", valid_593848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593871: Call_YoutubeActivitiesList_593705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  let valid = call_593871.validator(path, query, header, formData, body)
  let scheme = call_593871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593871.url(scheme.get, call_593871.host, call_593871.base,
                         call_593871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593871, url, valid)

proc call*(call_593942: Call_YoutubeActivitiesList_593705; part: string;
          mine: bool = false; fields: string = ""; publishedAfter: string = "";
          quotaUser: string = ""; pageToken: string = ""; alt: string = "json";
          home: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; regionCode: string = "";
          key: string = ""; publishedBefore: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesList
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   home: bool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593943 = newJObject()
  add(query_593943, "mine", newJBool(mine))
  add(query_593943, "fields", newJString(fields))
  add(query_593943, "publishedAfter", newJString(publishedAfter))
  add(query_593943, "quotaUser", newJString(quotaUser))
  add(query_593943, "pageToken", newJString(pageToken))
  add(query_593943, "alt", newJString(alt))
  add(query_593943, "home", newJBool(home))
  add(query_593943, "oauth_token", newJString(oauthToken))
  add(query_593943, "userIp", newJString(userIp))
  add(query_593943, "maxResults", newJInt(maxResults))
  add(query_593943, "part", newJString(part))
  add(query_593943, "channelId", newJString(channelId))
  add(query_593943, "regionCode", newJString(regionCode))
  add(query_593943, "key", newJString(key))
  add(query_593943, "publishedBefore", newJString(publishedBefore))
  add(query_593943, "prettyPrint", newJBool(prettyPrint))
  result = call_593942.call(nil, query_593943, nil, nil, nil)

var youtubeActivitiesList* = Call_YoutubeActivitiesList_593705(
    name: "youtubeActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesList_593706, base: "/youtube/v3",
    url: url_YoutubeActivitiesList_593707, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsUpdate_594017 = ref object of OpenApiRestCall_593437
proc url_YoutubeCaptionsUpdate_594019(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsUpdate_594018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594020 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "onBehalfOfContentOwner", valid_594020
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("sync")
  valid_594023 = validateParameter(valid_594023, JBool, required = false, default = nil)
  if valid_594023 != nil:
    section.add "sync", valid_594023
  var valid_594024 = query.getOrDefault("alt")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = newJString("json"))
  if valid_594024 != nil:
    section.add "alt", valid_594024
  var valid_594025 = query.getOrDefault("oauth_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "oauth_token", valid_594025
  var valid_594026 = query.getOrDefault("userIp")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "userIp", valid_594026
  var valid_594027 = query.getOrDefault("onBehalfOf")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "onBehalfOf", valid_594027
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594028 = query.getOrDefault("part")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "part", valid_594028
  var valid_594029 = query.getOrDefault("key")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "key", valid_594029
  var valid_594030 = query.getOrDefault("prettyPrint")
  valid_594030 = validateParameter(valid_594030, JBool, required = false,
                                 default = newJBool(true))
  if valid_594030 != nil:
    section.add "prettyPrint", valid_594030
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

proc call*(call_594032: Call_YoutubeCaptionsUpdate_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_YoutubeCaptionsUpdate_594017; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsUpdate
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(query_594034, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594034, "fields", newJString(fields))
  add(query_594034, "quotaUser", newJString(quotaUser))
  add(query_594034, "sync", newJBool(sync))
  add(query_594034, "alt", newJString(alt))
  add(query_594034, "oauth_token", newJString(oauthToken))
  add(query_594034, "userIp", newJString(userIp))
  add(query_594034, "onBehalfOf", newJString(onBehalfOf))
  add(query_594034, "part", newJString(part))
  add(query_594034, "key", newJString(key))
  if body != nil:
    body_594035 = body
  add(query_594034, "prettyPrint", newJBool(prettyPrint))
  result = call_594033.call(nil, query_594034, nil, nil, body_594035)

var youtubeCaptionsUpdate* = Call_YoutubeCaptionsUpdate_594017(
    name: "youtubeCaptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsUpdate_594018, base: "/youtube/v3",
    url: url_YoutubeCaptionsUpdate_594019, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsInsert_594036 = ref object of OpenApiRestCall_593437
proc url_YoutubeCaptionsInsert_594038(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsInsert_594037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594039 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "onBehalfOfContentOwner", valid_594039
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("sync")
  valid_594042 = validateParameter(valid_594042, JBool, required = false, default = nil)
  if valid_594042 != nil:
    section.add "sync", valid_594042
  var valid_594043 = query.getOrDefault("alt")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("json"))
  if valid_594043 != nil:
    section.add "alt", valid_594043
  var valid_594044 = query.getOrDefault("oauth_token")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "oauth_token", valid_594044
  var valid_594045 = query.getOrDefault("userIp")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "userIp", valid_594045
  var valid_594046 = query.getOrDefault("onBehalfOf")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "onBehalfOf", valid_594046
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594047 = query.getOrDefault("part")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "part", valid_594047
  var valid_594048 = query.getOrDefault("key")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "key", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
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

proc call*(call_594051: Call_YoutubeCaptionsInsert_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a caption track.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_YoutubeCaptionsInsert_594036; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsInsert
  ## Uploads a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(query_594053, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(query_594053, "sync", newJBool(sync))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "userIp", newJString(userIp))
  add(query_594053, "onBehalfOf", newJString(onBehalfOf))
  add(query_594053, "part", newJString(part))
  add(query_594053, "key", newJString(key))
  if body != nil:
    body_594054 = body
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594052.call(nil, query_594053, nil, nil, body_594054)

var youtubeCaptionsInsert* = Call_YoutubeCaptionsInsert_594036(
    name: "youtubeCaptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsInsert_594037, base: "/youtube/v3",
    url: url_YoutubeCaptionsInsert_594038, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsList_593999 = ref object of OpenApiRestCall_593437
proc url_YoutubeCaptionsList_594001(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsList_594000(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594002 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "onBehalfOfContentOwner", valid_594002
  var valid_594003 = query.getOrDefault("fields")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "fields", valid_594003
  var valid_594004 = query.getOrDefault("quotaUser")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "quotaUser", valid_594004
  var valid_594005 = query.getOrDefault("id")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "id", valid_594005
  var valid_594006 = query.getOrDefault("alt")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("json"))
  if valid_594006 != nil:
    section.add "alt", valid_594006
  var valid_594007 = query.getOrDefault("oauth_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "oauth_token", valid_594007
  var valid_594008 = query.getOrDefault("userIp")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "userIp", valid_594008
  var valid_594009 = query.getOrDefault("onBehalfOf")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "onBehalfOf", valid_594009
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_594010 = query.getOrDefault("videoId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "videoId", valid_594010
  var valid_594011 = query.getOrDefault("part")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "part", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("prettyPrint")
  valid_594013 = validateParameter(valid_594013, JBool, required = false,
                                 default = newJBool(true))
  if valid_594013 != nil:
    section.add "prettyPrint", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_YoutubeCaptionsList_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_YoutubeCaptionsList_593999; videoId: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsList
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594016 = newJObject()
  add(query_594016, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "id", newJString(id))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "userIp", newJString(userIp))
  add(query_594016, "onBehalfOf", newJString(onBehalfOf))
  add(query_594016, "videoId", newJString(videoId))
  add(query_594016, "part", newJString(part))
  add(query_594016, "key", newJString(key))
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594015.call(nil, query_594016, nil, nil, nil)

var youtubeCaptionsList* = Call_YoutubeCaptionsList_593999(
    name: "youtubeCaptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsList_594000, base: "/youtube/v3",
    url: url_YoutubeCaptionsList_594001, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDelete_594055 = ref object of OpenApiRestCall_593437
proc url_YoutubeCaptionsDelete_594057(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsDelete_594056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specified caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594058 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "onBehalfOfContentOwner", valid_594058
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594061 = query.getOrDefault("id")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "id", valid_594061
  var valid_594062 = query.getOrDefault("alt")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("json"))
  if valid_594062 != nil:
    section.add "alt", valid_594062
  var valid_594063 = query.getOrDefault("oauth_token")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "oauth_token", valid_594063
  var valid_594064 = query.getOrDefault("userIp")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "userIp", valid_594064
  var valid_594065 = query.getOrDefault("onBehalfOf")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "onBehalfOf", valid_594065
  var valid_594066 = query.getOrDefault("key")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "key", valid_594066
  var valid_594067 = query.getOrDefault("prettyPrint")
  valid_594067 = validateParameter(valid_594067, JBool, required = false,
                                 default = newJBool(true))
  if valid_594067 != nil:
    section.add "prettyPrint", valid_594067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594068: Call_YoutubeCaptionsDelete_594055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified caption track.
  ## 
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_YoutubeCaptionsDelete_594055; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; onBehalfOf: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDelete
  ## Deletes a specified caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594070 = newJObject()
  add(query_594070, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "id", newJString(id))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "onBehalfOf", newJString(onBehalfOf))
  add(query_594070, "key", newJString(key))
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594069.call(nil, query_594070, nil, nil, nil)

var youtubeCaptionsDelete* = Call_YoutubeCaptionsDelete_594055(
    name: "youtubeCaptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsDelete_594056, base: "/youtube/v3",
    url: url_YoutubeCaptionsDelete_594057, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDownload_594071 = ref object of OpenApiRestCall_593437
proc url_YoutubeCaptionsDownload_594073(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/captions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubeCaptionsDownload_594072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594088 = path.getOrDefault("id")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "id", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: JString
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
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
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: JString
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594089 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "onBehalfOfContentOwner", valid_594089
  var valid_594090 = query.getOrDefault("tfmt")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("sbv"))
  if valid_594090 != nil:
    section.add "tfmt", valid_594090
  var valid_594091 = query.getOrDefault("fields")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "fields", valid_594091
  var valid_594092 = query.getOrDefault("quotaUser")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "quotaUser", valid_594092
  var valid_594093 = query.getOrDefault("alt")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = newJString("json"))
  if valid_594093 != nil:
    section.add "alt", valid_594093
  var valid_594094 = query.getOrDefault("oauth_token")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "oauth_token", valid_594094
  var valid_594095 = query.getOrDefault("userIp")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "userIp", valid_594095
  var valid_594096 = query.getOrDefault("onBehalfOf")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "onBehalfOf", valid_594096
  var valid_594097 = query.getOrDefault("tlang")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "tlang", valid_594097
  var valid_594098 = query.getOrDefault("key")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "key", valid_594098
  var valid_594099 = query.getOrDefault("prettyPrint")
  valid_594099 = validateParameter(valid_594099, JBool, required = false,
                                 default = newJBool(true))
  if valid_594099 != nil:
    section.add "prettyPrint", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_YoutubeCaptionsDownload_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_YoutubeCaptionsDownload_594071; id: string;
          onBehalfOfContentOwner: string = ""; tfmt: string = "sbv";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          tlang: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDownload
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: string
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
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
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: string
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(query_594103, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594103, "tfmt", newJString(tfmt))
  add(query_594103, "fields", newJString(fields))
  add(query_594103, "quotaUser", newJString(quotaUser))
  add(query_594103, "alt", newJString(alt))
  add(query_594103, "oauth_token", newJString(oauthToken))
  add(query_594103, "userIp", newJString(userIp))
  add(query_594103, "onBehalfOf", newJString(onBehalfOf))
  add(query_594103, "tlang", newJString(tlang))
  add(path_594102, "id", newJString(id))
  add(query_594103, "key", newJString(key))
  add(query_594103, "prettyPrint", newJBool(prettyPrint))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var youtubeCaptionsDownload* = Call_YoutubeCaptionsDownload_594071(
    name: "youtubeCaptionsDownload", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions/{id}",
    validator: validate_YoutubeCaptionsDownload_594072, base: "/youtube/v3",
    url: url_YoutubeCaptionsDownload_594073, schemes: {Scheme.Https})
type
  Call_YoutubeChannelBannersInsert_594104 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelBannersInsert_594106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelBannersInsert_594105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594107 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "onBehalfOfContentOwner", valid_594107
  var valid_594108 = query.getOrDefault("fields")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "fields", valid_594108
  var valid_594109 = query.getOrDefault("quotaUser")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "quotaUser", valid_594109
  var valid_594110 = query.getOrDefault("alt")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = newJString("json"))
  if valid_594110 != nil:
    section.add "alt", valid_594110
  var valid_594111 = query.getOrDefault("oauth_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "oauth_token", valid_594111
  var valid_594112 = query.getOrDefault("userIp")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "userIp", valid_594112
  var valid_594113 = query.getOrDefault("channelId")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "channelId", valid_594113
  var valid_594114 = query.getOrDefault("key")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "key", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
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

proc call*(call_594117: Call_YoutubeChannelBannersInsert_594104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_YoutubeChannelBannersInsert_594104;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; channelId: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeChannelBannersInsert
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(query_594119, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594119, "fields", newJString(fields))
  add(query_594119, "quotaUser", newJString(quotaUser))
  add(query_594119, "alt", newJString(alt))
  add(query_594119, "oauth_token", newJString(oauthToken))
  add(query_594119, "userIp", newJString(userIp))
  add(query_594119, "channelId", newJString(channelId))
  add(query_594119, "key", newJString(key))
  if body != nil:
    body_594120 = body
  add(query_594119, "prettyPrint", newJBool(prettyPrint))
  result = call_594118.call(nil, query_594119, nil, nil, body_594120)

var youtubeChannelBannersInsert* = Call_YoutubeChannelBannersInsert_594104(
    name: "youtubeChannelBannersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelBanners/insert",
    validator: validate_YoutubeChannelBannersInsert_594105, base: "/youtube/v3",
    url: url_YoutubeChannelBannersInsert_594106, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsUpdate_594140 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelSectionsUpdate_594142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsUpdate_594141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594143 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "onBehalfOfContentOwner", valid_594143
  var valid_594144 = query.getOrDefault("fields")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "fields", valid_594144
  var valid_594145 = query.getOrDefault("quotaUser")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "quotaUser", valid_594145
  var valid_594146 = query.getOrDefault("alt")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("json"))
  if valid_594146 != nil:
    section.add "alt", valid_594146
  var valid_594147 = query.getOrDefault("oauth_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "oauth_token", valid_594147
  var valid_594148 = query.getOrDefault("userIp")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "userIp", valid_594148
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594149 = query.getOrDefault("part")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "part", valid_594149
  var valid_594150 = query.getOrDefault("key")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "key", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
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

proc call*(call_594153: Call_YoutubeChannelSectionsUpdate_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a channelSection.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_YoutubeChannelSectionsUpdate_594140; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsUpdate
  ## Update a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594155 = newJObject()
  var body_594156 = newJObject()
  add(query_594155, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594155, "fields", newJString(fields))
  add(query_594155, "quotaUser", newJString(quotaUser))
  add(query_594155, "alt", newJString(alt))
  add(query_594155, "oauth_token", newJString(oauthToken))
  add(query_594155, "userIp", newJString(userIp))
  add(query_594155, "part", newJString(part))
  add(query_594155, "key", newJString(key))
  if body != nil:
    body_594156 = body
  add(query_594155, "prettyPrint", newJBool(prettyPrint))
  result = call_594154.call(nil, query_594155, nil, nil, body_594156)

var youtubeChannelSectionsUpdate* = Call_YoutubeChannelSectionsUpdate_594140(
    name: "youtubeChannelSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsUpdate_594141, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsUpdate_594142, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsInsert_594157 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelSectionsInsert_594159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsInsert_594158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594160 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "onBehalfOfContentOwner", valid_594160
  var valid_594161 = query.getOrDefault("fields")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "fields", valid_594161
  var valid_594162 = query.getOrDefault("quotaUser")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "quotaUser", valid_594162
  var valid_594163 = query.getOrDefault("alt")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = newJString("json"))
  if valid_594163 != nil:
    section.add "alt", valid_594163
  var valid_594164 = query.getOrDefault("oauth_token")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "oauth_token", valid_594164
  var valid_594165 = query.getOrDefault("userIp")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "userIp", valid_594165
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594166 = query.getOrDefault("part")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "part", valid_594166
  var valid_594167 = query.getOrDefault("key")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "key", valid_594167
  var valid_594168 = query.getOrDefault("prettyPrint")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(true))
  if valid_594168 != nil:
    section.add "prettyPrint", valid_594168
  var valid_594169 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594169
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

proc call*(call_594171: Call_YoutubeChannelSectionsInsert_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_YoutubeChannelSectionsInsert_594157; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeChannelSectionsInsert
  ## Adds a channelSection for the authenticated user's channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594173 = newJObject()
  var body_594174 = newJObject()
  add(query_594173, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594173, "fields", newJString(fields))
  add(query_594173, "quotaUser", newJString(quotaUser))
  add(query_594173, "alt", newJString(alt))
  add(query_594173, "oauth_token", newJString(oauthToken))
  add(query_594173, "userIp", newJString(userIp))
  add(query_594173, "part", newJString(part))
  add(query_594173, "key", newJString(key))
  if body != nil:
    body_594174 = body
  add(query_594173, "prettyPrint", newJBool(prettyPrint))
  add(query_594173, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594172.call(nil, query_594173, nil, nil, body_594174)

var youtubeChannelSectionsInsert* = Call_YoutubeChannelSectionsInsert_594157(
    name: "youtubeChannelSectionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsInsert_594158, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsInsert_594159, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsList_594121 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelSectionsList_594123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsList_594122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  section = newJObject()
  var valid_594124 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "onBehalfOfContentOwner", valid_594124
  var valid_594125 = query.getOrDefault("mine")
  valid_594125 = validateParameter(valid_594125, JBool, required = false, default = nil)
  if valid_594125 != nil:
    section.add "mine", valid_594125
  var valid_594126 = query.getOrDefault("fields")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "fields", valid_594126
  var valid_594127 = query.getOrDefault("quotaUser")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "quotaUser", valid_594127
  var valid_594128 = query.getOrDefault("id")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "id", valid_594128
  var valid_594129 = query.getOrDefault("alt")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("json"))
  if valid_594129 != nil:
    section.add "alt", valid_594129
  var valid_594130 = query.getOrDefault("oauth_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "oauth_token", valid_594130
  var valid_594131 = query.getOrDefault("userIp")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "userIp", valid_594131
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594132 = query.getOrDefault("part")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "part", valid_594132
  var valid_594133 = query.getOrDefault("channelId")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "channelId", valid_594133
  var valid_594134 = query.getOrDefault("key")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "key", valid_594134
  var valid_594135 = query.getOrDefault("prettyPrint")
  valid_594135 = validateParameter(valid_594135, JBool, required = false,
                                 default = newJBool(true))
  if valid_594135 != nil:
    section.add "prettyPrint", valid_594135
  var valid_594136 = query.getOrDefault("hl")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "hl", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_YoutubeChannelSectionsList_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_YoutubeChannelSectionsList_594121; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; channelId: string = "";
          key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelSectionsList
  ## Returns channelSection resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  var query_594139 = newJObject()
  add(query_594139, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594139, "mine", newJBool(mine))
  add(query_594139, "fields", newJString(fields))
  add(query_594139, "quotaUser", newJString(quotaUser))
  add(query_594139, "id", newJString(id))
  add(query_594139, "alt", newJString(alt))
  add(query_594139, "oauth_token", newJString(oauthToken))
  add(query_594139, "userIp", newJString(userIp))
  add(query_594139, "part", newJString(part))
  add(query_594139, "channelId", newJString(channelId))
  add(query_594139, "key", newJString(key))
  add(query_594139, "prettyPrint", newJBool(prettyPrint))
  add(query_594139, "hl", newJString(hl))
  result = call_594138.call(nil, query_594139, nil, nil, nil)

var youtubeChannelSectionsList* = Call_YoutubeChannelSectionsList_594121(
    name: "youtubeChannelSectionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsList_594122, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsList_594123, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsDelete_594175 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelSectionsDelete_594177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsDelete_594176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
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
  var valid_594178 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "onBehalfOfContentOwner", valid_594178
  var valid_594179 = query.getOrDefault("fields")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "fields", valid_594179
  var valid_594180 = query.getOrDefault("quotaUser")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "quotaUser", valid_594180
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594181 = query.getOrDefault("id")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "id", valid_594181
  var valid_594182 = query.getOrDefault("alt")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = newJString("json"))
  if valid_594182 != nil:
    section.add "alt", valid_594182
  var valid_594183 = query.getOrDefault("oauth_token")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "oauth_token", valid_594183
  var valid_594184 = query.getOrDefault("userIp")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "userIp", valid_594184
  var valid_594185 = query.getOrDefault("key")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "key", valid_594185
  var valid_594186 = query.getOrDefault("prettyPrint")
  valid_594186 = validateParameter(valid_594186, JBool, required = false,
                                 default = newJBool(true))
  if valid_594186 != nil:
    section.add "prettyPrint", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_YoutubeChannelSectionsDelete_594175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channelSection.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_YoutubeChannelSectionsDelete_594175; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsDelete
  ## Deletes a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
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
  var query_594189 = newJObject()
  add(query_594189, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594189, "fields", newJString(fields))
  add(query_594189, "quotaUser", newJString(quotaUser))
  add(query_594189, "id", newJString(id))
  add(query_594189, "alt", newJString(alt))
  add(query_594189, "oauth_token", newJString(oauthToken))
  add(query_594189, "userIp", newJString(userIp))
  add(query_594189, "key", newJString(key))
  add(query_594189, "prettyPrint", newJBool(prettyPrint))
  result = call_594188.call(nil, query_594189, nil, nil, nil)

var youtubeChannelSectionsDelete* = Call_YoutubeChannelSectionsDelete_594175(
    name: "youtubeChannelSectionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsDelete_594176, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsDelete_594177, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsUpdate_594214 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelsUpdate_594216(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelsUpdate_594215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594217 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "onBehalfOfContentOwner", valid_594217
  var valid_594218 = query.getOrDefault("fields")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "fields", valid_594218
  var valid_594219 = query.getOrDefault("quotaUser")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "quotaUser", valid_594219
  var valid_594220 = query.getOrDefault("alt")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = newJString("json"))
  if valid_594220 != nil:
    section.add "alt", valid_594220
  var valid_594221 = query.getOrDefault("oauth_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "oauth_token", valid_594221
  var valid_594222 = query.getOrDefault("userIp")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "userIp", valid_594222
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594223 = query.getOrDefault("part")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "part", valid_594223
  var valid_594224 = query.getOrDefault("key")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "key", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
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

proc call*(call_594227: Call_YoutubeChannelsUpdate_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_YoutubeChannelsUpdate_594214; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelsUpdate
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ##   onBehalfOfContentOwner: string
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594229 = newJObject()
  var body_594230 = newJObject()
  add(query_594229, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594229, "fields", newJString(fields))
  add(query_594229, "quotaUser", newJString(quotaUser))
  add(query_594229, "alt", newJString(alt))
  add(query_594229, "oauth_token", newJString(oauthToken))
  add(query_594229, "userIp", newJString(userIp))
  add(query_594229, "part", newJString(part))
  add(query_594229, "key", newJString(key))
  if body != nil:
    body_594230 = body
  add(query_594229, "prettyPrint", newJBool(prettyPrint))
  result = call_594228.call(nil, query_594229, nil, nil, body_594230)

var youtubeChannelsUpdate* = Call_YoutubeChannelsUpdate_594214(
    name: "youtubeChannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsUpdate_594215, base: "/youtube/v3",
    url: url_YoutubeChannelsUpdate_594216, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsList_594190 = ref object of OpenApiRestCall_593437
proc url_YoutubeChannelsList_594192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeChannelsList_594191(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: JString
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: JString
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: JBool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  section = newJObject()
  var valid_594193 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "onBehalfOfContentOwner", valid_594193
  var valid_594194 = query.getOrDefault("mine")
  valid_594194 = validateParameter(valid_594194, JBool, required = false, default = nil)
  if valid_594194 != nil:
    section.add "mine", valid_594194
  var valid_594195 = query.getOrDefault("fields")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "fields", valid_594195
  var valid_594196 = query.getOrDefault("pageToken")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "pageToken", valid_594196
  var valid_594197 = query.getOrDefault("quotaUser")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "quotaUser", valid_594197
  var valid_594198 = query.getOrDefault("id")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "id", valid_594198
  var valid_594199 = query.getOrDefault("alt")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = newJString("json"))
  if valid_594199 != nil:
    section.add "alt", valid_594199
  var valid_594200 = query.getOrDefault("mySubscribers")
  valid_594200 = validateParameter(valid_594200, JBool, required = false, default = nil)
  if valid_594200 != nil:
    section.add "mySubscribers", valid_594200
  var valid_594201 = query.getOrDefault("forUsername")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "forUsername", valid_594201
  var valid_594202 = query.getOrDefault("categoryId")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "categoryId", valid_594202
  var valid_594203 = query.getOrDefault("managedByMe")
  valid_594203 = validateParameter(valid_594203, JBool, required = false, default = nil)
  if valid_594203 != nil:
    section.add "managedByMe", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("userIp")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "userIp", valid_594205
  var valid_594206 = query.getOrDefault("maxResults")
  valid_594206 = validateParameter(valid_594206, JInt, required = false,
                                 default = newJInt(5))
  if valid_594206 != nil:
    section.add "maxResults", valid_594206
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594207 = query.getOrDefault("part")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "part", valid_594207
  var valid_594208 = query.getOrDefault("key")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "key", valid_594208
  var valid_594209 = query.getOrDefault("prettyPrint")
  valid_594209 = validateParameter(valid_594209, JBool, required = false,
                                 default = newJBool(true))
  if valid_594209 != nil:
    section.add "prettyPrint", valid_594209
  var valid_594210 = query.getOrDefault("hl")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "hl", valid_594210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594211: Call_YoutubeChannelsList_594190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  let valid = call_594211.validator(path, query, header, formData, body)
  let scheme = call_594211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594211.url(scheme.get, call_594211.host, call_594211.base,
                         call_594211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594211, url, valid)

proc call*(call_594212: Call_YoutubeChannelsList_594190; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; mySubscribers: bool = false; forUsername: string = "";
          categoryId: string = ""; managedByMe: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelsList
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: string
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: string
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: bool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  var query_594213 = newJObject()
  add(query_594213, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594213, "mine", newJBool(mine))
  add(query_594213, "fields", newJString(fields))
  add(query_594213, "pageToken", newJString(pageToken))
  add(query_594213, "quotaUser", newJString(quotaUser))
  add(query_594213, "id", newJString(id))
  add(query_594213, "alt", newJString(alt))
  add(query_594213, "mySubscribers", newJBool(mySubscribers))
  add(query_594213, "forUsername", newJString(forUsername))
  add(query_594213, "categoryId", newJString(categoryId))
  add(query_594213, "managedByMe", newJBool(managedByMe))
  add(query_594213, "oauth_token", newJString(oauthToken))
  add(query_594213, "userIp", newJString(userIp))
  add(query_594213, "maxResults", newJInt(maxResults))
  add(query_594213, "part", newJString(part))
  add(query_594213, "key", newJString(key))
  add(query_594213, "prettyPrint", newJBool(prettyPrint))
  add(query_594213, "hl", newJString(hl))
  result = call_594212.call(nil, query_594213, nil, nil, nil)

var youtubeChannelsList* = Call_YoutubeChannelsList_594190(
    name: "youtubeChannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsList_594191, base: "/youtube/v3",
    url: url_YoutubeChannelsList_594192, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsUpdate_594255 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentThreadsUpdate_594257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsUpdate_594256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the top-level comment in a comment thread.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594258 = query.getOrDefault("fields")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "fields", valid_594258
  var valid_594259 = query.getOrDefault("quotaUser")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "quotaUser", valid_594259
  var valid_594260 = query.getOrDefault("alt")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = newJString("json"))
  if valid_594260 != nil:
    section.add "alt", valid_594260
  var valid_594261 = query.getOrDefault("oauth_token")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "oauth_token", valid_594261
  var valid_594262 = query.getOrDefault("userIp")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "userIp", valid_594262
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594263 = query.getOrDefault("part")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "part", valid_594263
  var valid_594264 = query.getOrDefault("key")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "key", valid_594264
  var valid_594265 = query.getOrDefault("prettyPrint")
  valid_594265 = validateParameter(valid_594265, JBool, required = false,
                                 default = newJBool(true))
  if valid_594265 != nil:
    section.add "prettyPrint", valid_594265
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

proc call*(call_594267: Call_YoutubeCommentThreadsUpdate_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the top-level comment in a comment thread.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_YoutubeCommentThreadsUpdate_594255; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsUpdate
  ## Modifies the top-level comment in a comment thread.
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
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594269 = newJObject()
  var body_594270 = newJObject()
  add(query_594269, "fields", newJString(fields))
  add(query_594269, "quotaUser", newJString(quotaUser))
  add(query_594269, "alt", newJString(alt))
  add(query_594269, "oauth_token", newJString(oauthToken))
  add(query_594269, "userIp", newJString(userIp))
  add(query_594269, "part", newJString(part))
  add(query_594269, "key", newJString(key))
  if body != nil:
    body_594270 = body
  add(query_594269, "prettyPrint", newJBool(prettyPrint))
  result = call_594268.call(nil, query_594269, nil, nil, body_594270)

var youtubeCommentThreadsUpdate* = Call_YoutubeCommentThreadsUpdate_594255(
    name: "youtubeCommentThreadsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsUpdate_594256, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsUpdate_594257, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsInsert_594271 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentThreadsInsert_594273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsInsert_594272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594274 = query.getOrDefault("fields")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "fields", valid_594274
  var valid_594275 = query.getOrDefault("quotaUser")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "quotaUser", valid_594275
  var valid_594276 = query.getOrDefault("alt")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = newJString("json"))
  if valid_594276 != nil:
    section.add "alt", valid_594276
  var valid_594277 = query.getOrDefault("oauth_token")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "oauth_token", valid_594277
  var valid_594278 = query.getOrDefault("userIp")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "userIp", valid_594278
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594279 = query.getOrDefault("part")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "part", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("prettyPrint")
  valid_594281 = validateParameter(valid_594281, JBool, required = false,
                                 default = newJBool(true))
  if valid_594281 != nil:
    section.add "prettyPrint", valid_594281
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

proc call*(call_594283: Call_YoutubeCommentThreadsInsert_594271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_YoutubeCommentThreadsInsert_594271; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsInsert
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594285 = newJObject()
  var body_594286 = newJObject()
  add(query_594285, "fields", newJString(fields))
  add(query_594285, "quotaUser", newJString(quotaUser))
  add(query_594285, "alt", newJString(alt))
  add(query_594285, "oauth_token", newJString(oauthToken))
  add(query_594285, "userIp", newJString(userIp))
  add(query_594285, "part", newJString(part))
  add(query_594285, "key", newJString(key))
  if body != nil:
    body_594286 = body
  add(query_594285, "prettyPrint", newJBool(prettyPrint))
  result = call_594284.call(nil, query_594285, nil, nil, body_594286)

var youtubeCommentThreadsInsert* = Call_YoutubeCommentThreadsInsert_594271(
    name: "youtubeCommentThreadsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsInsert_594272, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsInsert_594273, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsList_594231 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentThreadsList_594233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsList_594232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   order: JString
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: JString
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: JString
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: JString
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_594234 = query.getOrDefault("textFormat")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("html"))
  if valid_594234 != nil:
    section.add "textFormat", valid_594234
  var valid_594235 = query.getOrDefault("fields")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "fields", valid_594235
  var valid_594236 = query.getOrDefault("pageToken")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "pageToken", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("id")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "id", valid_594238
  var valid_594239 = query.getOrDefault("alt")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = newJString("json"))
  if valid_594239 != nil:
    section.add "alt", valid_594239
  var valid_594240 = query.getOrDefault("order")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = newJString("relevance"))
  if valid_594240 != nil:
    section.add "order", valid_594240
  var valid_594241 = query.getOrDefault("oauth_token")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "oauth_token", valid_594241
  var valid_594242 = query.getOrDefault("userIp")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "userIp", valid_594242
  var valid_594243 = query.getOrDefault("videoId")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "videoId", valid_594243
  var valid_594244 = query.getOrDefault("maxResults")
  valid_594244 = validateParameter(valid_594244, JInt, required = false,
                                 default = newJInt(20))
  if valid_594244 != nil:
    section.add "maxResults", valid_594244
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594245 = query.getOrDefault("part")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "part", valid_594245
  var valid_594246 = query.getOrDefault("channelId")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "channelId", valid_594246
  var valid_594247 = query.getOrDefault("key")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "key", valid_594247
  var valid_594248 = query.getOrDefault("moderationStatus")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = newJString("published"))
  if valid_594248 != nil:
    section.add "moderationStatus", valid_594248
  var valid_594249 = query.getOrDefault("prettyPrint")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(true))
  if valid_594249 != nil:
    section.add "prettyPrint", valid_594249
  var valid_594250 = query.getOrDefault("allThreadsRelatedToChannelId")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "allThreadsRelatedToChannelId", valid_594250
  var valid_594251 = query.getOrDefault("searchTerms")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "searchTerms", valid_594251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594252: Call_YoutubeCommentThreadsList_594231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  let valid = call_594252.validator(path, query, header, formData, body)
  let scheme = call_594252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594252.url(scheme.get, call_594252.host, call_594252.base,
                         call_594252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594252, url, valid)

proc call*(call_594253: Call_YoutubeCommentThreadsList_594231; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          order: string = "relevance"; oauthToken: string = ""; userIp: string = "";
          videoId: string = ""; maxResults: int = 20; channelId: string = "";
          key: string = ""; moderationStatus: string = "published";
          prettyPrint: bool = true; allThreadsRelatedToChannelId: string = "";
          searchTerms: string = ""): Recallable =
  ## youtubeCommentThreadsList
  ## Returns a list of comment threads that match the API request parameters.
  ##   textFormat: string
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   order: string
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: string
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: string
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: string
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  var query_594254 = newJObject()
  add(query_594254, "textFormat", newJString(textFormat))
  add(query_594254, "fields", newJString(fields))
  add(query_594254, "pageToken", newJString(pageToken))
  add(query_594254, "quotaUser", newJString(quotaUser))
  add(query_594254, "id", newJString(id))
  add(query_594254, "alt", newJString(alt))
  add(query_594254, "order", newJString(order))
  add(query_594254, "oauth_token", newJString(oauthToken))
  add(query_594254, "userIp", newJString(userIp))
  add(query_594254, "videoId", newJString(videoId))
  add(query_594254, "maxResults", newJInt(maxResults))
  add(query_594254, "part", newJString(part))
  add(query_594254, "channelId", newJString(channelId))
  add(query_594254, "key", newJString(key))
  add(query_594254, "moderationStatus", newJString(moderationStatus))
  add(query_594254, "prettyPrint", newJBool(prettyPrint))
  add(query_594254, "allThreadsRelatedToChannelId",
      newJString(allThreadsRelatedToChannelId))
  add(query_594254, "searchTerms", newJString(searchTerms))
  result = call_594253.call(nil, query_594254, nil, nil, nil)

var youtubeCommentThreadsList* = Call_YoutubeCommentThreadsList_594231(
    name: "youtubeCommentThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsList_594232, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsList_594233, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsUpdate_594306 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsUpdate_594308(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsUpdate_594307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a comment.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594309 = query.getOrDefault("fields")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "fields", valid_594309
  var valid_594310 = query.getOrDefault("quotaUser")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "quotaUser", valid_594310
  var valid_594311 = query.getOrDefault("alt")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = newJString("json"))
  if valid_594311 != nil:
    section.add "alt", valid_594311
  var valid_594312 = query.getOrDefault("oauth_token")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "oauth_token", valid_594312
  var valid_594313 = query.getOrDefault("userIp")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "userIp", valid_594313
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594314 = query.getOrDefault("part")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "part", valid_594314
  var valid_594315 = query.getOrDefault("key")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "key", valid_594315
  var valid_594316 = query.getOrDefault("prettyPrint")
  valid_594316 = validateParameter(valid_594316, JBool, required = false,
                                 default = newJBool(true))
  if valid_594316 != nil:
    section.add "prettyPrint", valid_594316
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

proc call*(call_594318: Call_YoutubeCommentsUpdate_594306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a comment.
  ## 
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_YoutubeCommentsUpdate_594306; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsUpdate
  ## Modifies a comment.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594320 = newJObject()
  var body_594321 = newJObject()
  add(query_594320, "fields", newJString(fields))
  add(query_594320, "quotaUser", newJString(quotaUser))
  add(query_594320, "alt", newJString(alt))
  add(query_594320, "oauth_token", newJString(oauthToken))
  add(query_594320, "userIp", newJString(userIp))
  add(query_594320, "part", newJString(part))
  add(query_594320, "key", newJString(key))
  if body != nil:
    body_594321 = body
  add(query_594320, "prettyPrint", newJBool(prettyPrint))
  result = call_594319.call(nil, query_594320, nil, nil, body_594321)

var youtubeCommentsUpdate* = Call_YoutubeCommentsUpdate_594306(
    name: "youtubeCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsUpdate_594307, base: "/youtube/v3",
    url: url_YoutubeCommentsUpdate_594308, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsInsert_594322 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsInsert_594324(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsInsert_594323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594325 = query.getOrDefault("fields")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "fields", valid_594325
  var valid_594326 = query.getOrDefault("quotaUser")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "quotaUser", valid_594326
  var valid_594327 = query.getOrDefault("alt")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = newJString("json"))
  if valid_594327 != nil:
    section.add "alt", valid_594327
  var valid_594328 = query.getOrDefault("oauth_token")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "oauth_token", valid_594328
  var valid_594329 = query.getOrDefault("userIp")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "userIp", valid_594329
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594330 = query.getOrDefault("part")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "part", valid_594330
  var valid_594331 = query.getOrDefault("key")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "key", valid_594331
  var valid_594332 = query.getOrDefault("prettyPrint")
  valid_594332 = validateParameter(valid_594332, JBool, required = false,
                                 default = newJBool(true))
  if valid_594332 != nil:
    section.add "prettyPrint", valid_594332
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

proc call*(call_594334: Call_YoutubeCommentsInsert_594322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_YoutubeCommentsInsert_594322; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsInsert
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594336 = newJObject()
  var body_594337 = newJObject()
  add(query_594336, "fields", newJString(fields))
  add(query_594336, "quotaUser", newJString(quotaUser))
  add(query_594336, "alt", newJString(alt))
  add(query_594336, "oauth_token", newJString(oauthToken))
  add(query_594336, "userIp", newJString(userIp))
  add(query_594336, "part", newJString(part))
  add(query_594336, "key", newJString(key))
  if body != nil:
    body_594337 = body
  add(query_594336, "prettyPrint", newJBool(prettyPrint))
  result = call_594335.call(nil, query_594336, nil, nil, body_594337)

var youtubeCommentsInsert* = Call_YoutubeCommentsInsert_594322(
    name: "youtubeCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsInsert_594323, base: "/youtube/v3",
    url: url_YoutubeCommentsInsert_594324, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsList_594287 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsList_594289(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsList_594288(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of comments that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: JString
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594290 = query.getOrDefault("textFormat")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = newJString("html"))
  if valid_594290 != nil:
    section.add "textFormat", valid_594290
  var valid_594291 = query.getOrDefault("fields")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "fields", valid_594291
  var valid_594292 = query.getOrDefault("pageToken")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "pageToken", valid_594292
  var valid_594293 = query.getOrDefault("quotaUser")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "quotaUser", valid_594293
  var valid_594294 = query.getOrDefault("id")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "id", valid_594294
  var valid_594295 = query.getOrDefault("alt")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = newJString("json"))
  if valid_594295 != nil:
    section.add "alt", valid_594295
  var valid_594296 = query.getOrDefault("oauth_token")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "oauth_token", valid_594296
  var valid_594297 = query.getOrDefault("userIp")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "userIp", valid_594297
  var valid_594298 = query.getOrDefault("maxResults")
  valid_594298 = validateParameter(valid_594298, JInt, required = false,
                                 default = newJInt(20))
  if valid_594298 != nil:
    section.add "maxResults", valid_594298
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594299 = query.getOrDefault("part")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "part", valid_594299
  var valid_594300 = query.getOrDefault("parentId")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "parentId", valid_594300
  var valid_594301 = query.getOrDefault("key")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "key", valid_594301
  var valid_594302 = query.getOrDefault("prettyPrint")
  valid_594302 = validateParameter(valid_594302, JBool, required = false,
                                 default = newJBool(true))
  if valid_594302 != nil:
    section.add "prettyPrint", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_YoutubeCommentsList_594287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comments that match the API request parameters.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_YoutubeCommentsList_594287; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 20;
          parentId: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsList
  ## Returns a list of comments that match the API request parameters.
  ##   textFormat: string
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: string
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594305 = newJObject()
  add(query_594305, "textFormat", newJString(textFormat))
  add(query_594305, "fields", newJString(fields))
  add(query_594305, "pageToken", newJString(pageToken))
  add(query_594305, "quotaUser", newJString(quotaUser))
  add(query_594305, "id", newJString(id))
  add(query_594305, "alt", newJString(alt))
  add(query_594305, "oauth_token", newJString(oauthToken))
  add(query_594305, "userIp", newJString(userIp))
  add(query_594305, "maxResults", newJInt(maxResults))
  add(query_594305, "part", newJString(part))
  add(query_594305, "parentId", newJString(parentId))
  add(query_594305, "key", newJString(key))
  add(query_594305, "prettyPrint", newJBool(prettyPrint))
  result = call_594304.call(nil, query_594305, nil, nil, nil)

var youtubeCommentsList* = Call_YoutubeCommentsList_594287(
    name: "youtubeCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsList_594288, base: "/youtube/v3",
    url: url_YoutubeCommentsList_594289, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsDelete_594338 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsDelete_594340(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsDelete_594339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a comment.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
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
  var valid_594341 = query.getOrDefault("fields")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "fields", valid_594341
  var valid_594342 = query.getOrDefault("quotaUser")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "quotaUser", valid_594342
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594343 = query.getOrDefault("id")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "id", valid_594343
  var valid_594344 = query.getOrDefault("alt")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = newJString("json"))
  if valid_594344 != nil:
    section.add "alt", valid_594344
  var valid_594345 = query.getOrDefault("oauth_token")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "oauth_token", valid_594345
  var valid_594346 = query.getOrDefault("userIp")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "userIp", valid_594346
  var valid_594347 = query.getOrDefault("key")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "key", valid_594347
  var valid_594348 = query.getOrDefault("prettyPrint")
  valid_594348 = validateParameter(valid_594348, JBool, required = false,
                                 default = newJBool(true))
  if valid_594348 != nil:
    section.add "prettyPrint", valid_594348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594349: Call_YoutubeCommentsDelete_594338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_YoutubeCommentsDelete_594338; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsDelete
  ## Deletes a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
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
  var query_594351 = newJObject()
  add(query_594351, "fields", newJString(fields))
  add(query_594351, "quotaUser", newJString(quotaUser))
  add(query_594351, "id", newJString(id))
  add(query_594351, "alt", newJString(alt))
  add(query_594351, "oauth_token", newJString(oauthToken))
  add(query_594351, "userIp", newJString(userIp))
  add(query_594351, "key", newJString(key))
  add(query_594351, "prettyPrint", newJBool(prettyPrint))
  result = call_594350.call(nil, query_594351, nil, nil, nil)

var youtubeCommentsDelete* = Call_YoutubeCommentsDelete_594338(
    name: "youtubeCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsDelete_594339, base: "/youtube/v3",
    url: url_YoutubeCommentsDelete_594340, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsMarkAsSpam_594352 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsMarkAsSpam_594354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsMarkAsSpam_594353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
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
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
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
  var valid_594355 = query.getOrDefault("fields")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "fields", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594357 = query.getOrDefault("id")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "id", valid_594357
  var valid_594358 = query.getOrDefault("alt")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = newJString("json"))
  if valid_594358 != nil:
    section.add "alt", valid_594358
  var valid_594359 = query.getOrDefault("oauth_token")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "oauth_token", valid_594359
  var valid_594360 = query.getOrDefault("userIp")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "userIp", valid_594360
  var valid_594361 = query.getOrDefault("key")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "key", valid_594361
  var valid_594362 = query.getOrDefault("prettyPrint")
  valid_594362 = validateParameter(valid_594362, JBool, required = false,
                                 default = newJBool(true))
  if valid_594362 != nil:
    section.add "prettyPrint", valid_594362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594363: Call_YoutubeCommentsMarkAsSpam_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_YoutubeCommentsMarkAsSpam_594352; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsMarkAsSpam
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
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
  var query_594365 = newJObject()
  add(query_594365, "fields", newJString(fields))
  add(query_594365, "quotaUser", newJString(quotaUser))
  add(query_594365, "id", newJString(id))
  add(query_594365, "alt", newJString(alt))
  add(query_594365, "oauth_token", newJString(oauthToken))
  add(query_594365, "userIp", newJString(userIp))
  add(query_594365, "key", newJString(key))
  add(query_594365, "prettyPrint", newJBool(prettyPrint))
  result = call_594364.call(nil, query_594365, nil, nil, nil)

var youtubeCommentsMarkAsSpam* = Call_YoutubeCommentsMarkAsSpam_594352(
    name: "youtubeCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/markAsSpam",
    validator: validate_YoutubeCommentsMarkAsSpam_594353, base: "/youtube/v3",
    url: url_YoutubeCommentsMarkAsSpam_594354, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsSetModerationStatus_594366 = ref object of OpenApiRestCall_593437
proc url_YoutubeCommentsSetModerationStatus_594368(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeCommentsSetModerationStatus_594367(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
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
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   banAuthor: JBool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594369 = query.getOrDefault("fields")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "fields", valid_594369
  var valid_594370 = query.getOrDefault("quotaUser")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "quotaUser", valid_594370
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594371 = query.getOrDefault("id")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "id", valid_594371
  var valid_594372 = query.getOrDefault("alt")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = newJString("json"))
  if valid_594372 != nil:
    section.add "alt", valid_594372
  var valid_594373 = query.getOrDefault("banAuthor")
  valid_594373 = validateParameter(valid_594373, JBool, required = false,
                                 default = newJBool(false))
  if valid_594373 != nil:
    section.add "banAuthor", valid_594373
  var valid_594374 = query.getOrDefault("oauth_token")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "oauth_token", valid_594374
  var valid_594375 = query.getOrDefault("userIp")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "userIp", valid_594375
  var valid_594376 = query.getOrDefault("key")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "key", valid_594376
  var valid_594377 = query.getOrDefault("moderationStatus")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = newJString("heldForReview"))
  if valid_594377 != nil:
    section.add "moderationStatus", valid_594377
  var valid_594378 = query.getOrDefault("prettyPrint")
  valid_594378 = validateParameter(valid_594378, JBool, required = false,
                                 default = newJBool(true))
  if valid_594378 != nil:
    section.add "prettyPrint", valid_594378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594379: Call_YoutubeCommentsSetModerationStatus_594366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_YoutubeCommentsSetModerationStatus_594366; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          banAuthor: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; moderationStatus: string = "heldForReview";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsSetModerationStatus
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: string
  ##      : Data format for the response.
  ##   banAuthor: bool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594381 = newJObject()
  add(query_594381, "fields", newJString(fields))
  add(query_594381, "quotaUser", newJString(quotaUser))
  add(query_594381, "id", newJString(id))
  add(query_594381, "alt", newJString(alt))
  add(query_594381, "banAuthor", newJBool(banAuthor))
  add(query_594381, "oauth_token", newJString(oauthToken))
  add(query_594381, "userIp", newJString(userIp))
  add(query_594381, "key", newJString(key))
  add(query_594381, "moderationStatus", newJString(moderationStatus))
  add(query_594381, "prettyPrint", newJBool(prettyPrint))
  result = call_594380.call(nil, query_594381, nil, nil, nil)

var youtubeCommentsSetModerationStatus* = Call_YoutubeCommentsSetModerationStatus_594366(
    name: "youtubeCommentsSetModerationStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/setModerationStatus",
    validator: validate_YoutubeCommentsSetModerationStatus_594367,
    base: "/youtube/v3", url: url_YoutubeCommentsSetModerationStatus_594368,
    schemes: {Scheme.Https})
type
  Call_YoutubeGuideCategoriesList_594382 = ref object of OpenApiRestCall_593437
proc url_YoutubeGuideCategoriesList_594384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeGuideCategoriesList_594383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube channels.
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
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  section = newJObject()
  var valid_594385 = query.getOrDefault("fields")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "fields", valid_594385
  var valid_594386 = query.getOrDefault("quotaUser")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "quotaUser", valid_594386
  var valid_594387 = query.getOrDefault("id")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "id", valid_594387
  var valid_594388 = query.getOrDefault("alt")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = newJString("json"))
  if valid_594388 != nil:
    section.add "alt", valid_594388
  var valid_594389 = query.getOrDefault("oauth_token")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "oauth_token", valid_594389
  var valid_594390 = query.getOrDefault("userIp")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "userIp", valid_594390
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594391 = query.getOrDefault("part")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "part", valid_594391
  var valid_594392 = query.getOrDefault("regionCode")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "regionCode", valid_594392
  var valid_594393 = query.getOrDefault("key")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "key", valid_594393
  var valid_594394 = query.getOrDefault("prettyPrint")
  valid_594394 = validateParameter(valid_594394, JBool, required = false,
                                 default = newJBool(true))
  if valid_594394 != nil:
    section.add "prettyPrint", valid_594394
  var valid_594395 = query.getOrDefault("hl")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = newJString("en-US"))
  if valid_594395 != nil:
    section.add "hl", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_YoutubeGuideCategoriesList_594382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_YoutubeGuideCategoriesList_594382; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en-US"): Recallable =
  ## youtubeGuideCategoriesList
  ## Returns a list of categories that can be associated with YouTube channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  var query_594398 = newJObject()
  add(query_594398, "fields", newJString(fields))
  add(query_594398, "quotaUser", newJString(quotaUser))
  add(query_594398, "id", newJString(id))
  add(query_594398, "alt", newJString(alt))
  add(query_594398, "oauth_token", newJString(oauthToken))
  add(query_594398, "userIp", newJString(userIp))
  add(query_594398, "part", newJString(part))
  add(query_594398, "regionCode", newJString(regionCode))
  add(query_594398, "key", newJString(key))
  add(query_594398, "prettyPrint", newJBool(prettyPrint))
  add(query_594398, "hl", newJString(hl))
  result = call_594397.call(nil, query_594398, nil, nil, nil)

var youtubeGuideCategoriesList* = Call_YoutubeGuideCategoriesList_594382(
    name: "youtubeGuideCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/guideCategories",
    validator: validate_YoutubeGuideCategoriesList_594383, base: "/youtube/v3",
    url: url_YoutubeGuideCategoriesList_594384, schemes: {Scheme.Https})
type
  Call_YoutubeI18nLanguagesList_594399 = ref object of OpenApiRestCall_593437
proc url_YoutubeI18nLanguagesList_594401(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeI18nLanguagesList_594400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of application languages that the YouTube website supports.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594407 = query.getOrDefault("part")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "part", valid_594407
  var valid_594408 = query.getOrDefault("key")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "key", valid_594408
  var valid_594409 = query.getOrDefault("prettyPrint")
  valid_594409 = validateParameter(valid_594409, JBool, required = false,
                                 default = newJBool(true))
  if valid_594409 != nil:
    section.add "prettyPrint", valid_594409
  var valid_594410 = query.getOrDefault("hl")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = newJString("en_US"))
  if valid_594410 != nil:
    section.add "hl", valid_594410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594411: Call_YoutubeI18nLanguagesList_594399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  let valid = call_594411.validator(path, query, header, formData, body)
  let scheme = call_594411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594411.url(scheme.get, call_594411.host, call_594411.base,
                         call_594411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594411, url, valid)

proc call*(call_594412: Call_YoutubeI18nLanguagesList_594399; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nLanguagesList
  ## Returns a list of application languages that the YouTube website supports.
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
  ##   part: string (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_594413 = newJObject()
  add(query_594413, "fields", newJString(fields))
  add(query_594413, "quotaUser", newJString(quotaUser))
  add(query_594413, "alt", newJString(alt))
  add(query_594413, "oauth_token", newJString(oauthToken))
  add(query_594413, "userIp", newJString(userIp))
  add(query_594413, "part", newJString(part))
  add(query_594413, "key", newJString(key))
  add(query_594413, "prettyPrint", newJBool(prettyPrint))
  add(query_594413, "hl", newJString(hl))
  result = call_594412.call(nil, query_594413, nil, nil, nil)

var youtubeI18nLanguagesList* = Call_YoutubeI18nLanguagesList_594399(
    name: "youtubeI18nLanguagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nLanguages",
    validator: validate_YoutubeI18nLanguagesList_594400, base: "/youtube/v3",
    url: url_YoutubeI18nLanguagesList_594401, schemes: {Scheme.Https})
type
  Call_YoutubeI18nRegionsList_594414 = ref object of OpenApiRestCall_593437
proc url_YoutubeI18nRegionsList_594416(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeI18nRegionsList_594415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of content regions that the YouTube website supports.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594422 = query.getOrDefault("part")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "part", valid_594422
  var valid_594423 = query.getOrDefault("key")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "key", valid_594423
  var valid_594424 = query.getOrDefault("prettyPrint")
  valid_594424 = validateParameter(valid_594424, JBool, required = false,
                                 default = newJBool(true))
  if valid_594424 != nil:
    section.add "prettyPrint", valid_594424
  var valid_594425 = query.getOrDefault("hl")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = newJString("en_US"))
  if valid_594425 != nil:
    section.add "hl", valid_594425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594426: Call_YoutubeI18nRegionsList_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  let valid = call_594426.validator(path, query, header, formData, body)
  let scheme = call_594426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594426.url(scheme.get, call_594426.host, call_594426.base,
                         call_594426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594426, url, valid)

proc call*(call_594427: Call_YoutubeI18nRegionsList_594414; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nRegionsList
  ## Returns a list of content regions that the YouTube website supports.
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
  ##   part: string (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_594428 = newJObject()
  add(query_594428, "fields", newJString(fields))
  add(query_594428, "quotaUser", newJString(quotaUser))
  add(query_594428, "alt", newJString(alt))
  add(query_594428, "oauth_token", newJString(oauthToken))
  add(query_594428, "userIp", newJString(userIp))
  add(query_594428, "part", newJString(part))
  add(query_594428, "key", newJString(key))
  add(query_594428, "prettyPrint", newJBool(prettyPrint))
  add(query_594428, "hl", newJString(hl))
  result = call_594427.call(nil, query_594428, nil, nil, nil)

var youtubeI18nRegionsList* = Call_YoutubeI18nRegionsList_594414(
    name: "youtubeI18nRegionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nRegions",
    validator: validate_YoutubeI18nRegionsList_594415, base: "/youtube/v3",
    url: url_YoutubeI18nRegionsList_594416, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsUpdate_594451 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsUpdate_594453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsUpdate_594452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594454 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "onBehalfOfContentOwner", valid_594454
  var valid_594455 = query.getOrDefault("fields")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "fields", valid_594455
  var valid_594456 = query.getOrDefault("quotaUser")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "quotaUser", valid_594456
  var valid_594457 = query.getOrDefault("alt")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = newJString("json"))
  if valid_594457 != nil:
    section.add "alt", valid_594457
  var valid_594458 = query.getOrDefault("oauth_token")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "oauth_token", valid_594458
  var valid_594459 = query.getOrDefault("userIp")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "userIp", valid_594459
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594460 = query.getOrDefault("part")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "part", valid_594460
  var valid_594461 = query.getOrDefault("key")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "key", valid_594461
  var valid_594462 = query.getOrDefault("prettyPrint")
  valid_594462 = validateParameter(valid_594462, JBool, required = false,
                                 default = newJBool(true))
  if valid_594462 != nil:
    section.add "prettyPrint", valid_594462
  var valid_594463 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = nil)
  if valid_594463 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594463
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

proc call*(call_594465: Call_YoutubeLiveBroadcastsUpdate_594451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  let valid = call_594465.validator(path, query, header, formData, body)
  let scheme = call_594465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594465.url(scheme.get, call_594465.host, call_594465.base,
                         call_594465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594465, url, valid)

proc call*(call_594466: Call_YoutubeLiveBroadcastsUpdate_594451; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsUpdate
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594467 = newJObject()
  var body_594468 = newJObject()
  add(query_594467, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594467, "fields", newJString(fields))
  add(query_594467, "quotaUser", newJString(quotaUser))
  add(query_594467, "alt", newJString(alt))
  add(query_594467, "oauth_token", newJString(oauthToken))
  add(query_594467, "userIp", newJString(userIp))
  add(query_594467, "part", newJString(part))
  add(query_594467, "key", newJString(key))
  if body != nil:
    body_594468 = body
  add(query_594467, "prettyPrint", newJBool(prettyPrint))
  add(query_594467, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594466.call(nil, query_594467, nil, nil, body_594468)

var youtubeLiveBroadcastsUpdate* = Call_YoutubeLiveBroadcastsUpdate_594451(
    name: "youtubeLiveBroadcastsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsUpdate_594452, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsUpdate_594453, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsInsert_594469 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsInsert_594471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsInsert_594470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594472 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "onBehalfOfContentOwner", valid_594472
  var valid_594473 = query.getOrDefault("fields")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "fields", valid_594473
  var valid_594474 = query.getOrDefault("quotaUser")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "quotaUser", valid_594474
  var valid_594475 = query.getOrDefault("alt")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = newJString("json"))
  if valid_594475 != nil:
    section.add "alt", valid_594475
  var valid_594476 = query.getOrDefault("oauth_token")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "oauth_token", valid_594476
  var valid_594477 = query.getOrDefault("userIp")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "userIp", valid_594477
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594478 = query.getOrDefault("part")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "part", valid_594478
  var valid_594479 = query.getOrDefault("key")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "key", valid_594479
  var valid_594480 = query.getOrDefault("prettyPrint")
  valid_594480 = validateParameter(valid_594480, JBool, required = false,
                                 default = newJBool(true))
  if valid_594480 != nil:
    section.add "prettyPrint", valid_594480
  var valid_594481 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594481
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

proc call*(call_594483: Call_YoutubeLiveBroadcastsInsert_594469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a broadcast.
  ## 
  let valid = call_594483.validator(path, query, header, formData, body)
  let scheme = call_594483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594483.url(scheme.get, call_594483.host, call_594483.base,
                         call_594483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594483, url, valid)

proc call*(call_594484: Call_YoutubeLiveBroadcastsInsert_594469; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsInsert
  ## Creates a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594485 = newJObject()
  var body_594486 = newJObject()
  add(query_594485, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594485, "fields", newJString(fields))
  add(query_594485, "quotaUser", newJString(quotaUser))
  add(query_594485, "alt", newJString(alt))
  add(query_594485, "oauth_token", newJString(oauthToken))
  add(query_594485, "userIp", newJString(userIp))
  add(query_594485, "part", newJString(part))
  add(query_594485, "key", newJString(key))
  if body != nil:
    body_594486 = body
  add(query_594485, "prettyPrint", newJBool(prettyPrint))
  add(query_594485, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594484.call(nil, query_594485, nil, nil, body_594486)

var youtubeLiveBroadcastsInsert* = Call_YoutubeLiveBroadcastsInsert_594469(
    name: "youtubeLiveBroadcastsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsInsert_594470, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsInsert_594471, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsList_594429 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsList_594431(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsList_594430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   broadcastType: JString
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594432 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "onBehalfOfContentOwner", valid_594432
  var valid_594433 = query.getOrDefault("mine")
  valid_594433 = validateParameter(valid_594433, JBool, required = false, default = nil)
  if valid_594433 != nil:
    section.add "mine", valid_594433
  var valid_594434 = query.getOrDefault("fields")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "fields", valid_594434
  var valid_594435 = query.getOrDefault("pageToken")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "pageToken", valid_594435
  var valid_594436 = query.getOrDefault("quotaUser")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "quotaUser", valid_594436
  var valid_594437 = query.getOrDefault("id")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "id", valid_594437
  var valid_594438 = query.getOrDefault("alt")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = newJString("json"))
  if valid_594438 != nil:
    section.add "alt", valid_594438
  var valid_594439 = query.getOrDefault("broadcastType")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = newJString("event"))
  if valid_594439 != nil:
    section.add "broadcastType", valid_594439
  var valid_594440 = query.getOrDefault("oauth_token")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "oauth_token", valid_594440
  var valid_594441 = query.getOrDefault("userIp")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "userIp", valid_594441
  var valid_594442 = query.getOrDefault("maxResults")
  valid_594442 = validateParameter(valid_594442, JInt, required = false,
                                 default = newJInt(5))
  if valid_594442 != nil:
    section.add "maxResults", valid_594442
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594443 = query.getOrDefault("part")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "part", valid_594443
  var valid_594444 = query.getOrDefault("key")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "key", valid_594444
  var valid_594445 = query.getOrDefault("broadcastStatus")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = newJString("active"))
  if valid_594445 != nil:
    section.add "broadcastStatus", valid_594445
  var valid_594446 = query.getOrDefault("prettyPrint")
  valid_594446 = validateParameter(valid_594446, JBool, required = false,
                                 default = newJBool(true))
  if valid_594446 != nil:
    section.add "prettyPrint", valid_594446
  var valid_594447 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594448: Call_YoutubeLiveBroadcastsList_594429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  let valid = call_594448.validator(path, query, header, formData, body)
  let scheme = call_594448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594448.url(scheme.get, call_594448.host, call_594448.base,
                         call_594448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594448, url, valid)

proc call*(call_594449: Call_YoutubeLiveBroadcastsList_594429; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; broadcastType: string = "event";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          key: string = ""; broadcastStatus: string = "active";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsList
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   broadcastType: string
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594450 = newJObject()
  add(query_594450, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594450, "mine", newJBool(mine))
  add(query_594450, "fields", newJString(fields))
  add(query_594450, "pageToken", newJString(pageToken))
  add(query_594450, "quotaUser", newJString(quotaUser))
  add(query_594450, "id", newJString(id))
  add(query_594450, "alt", newJString(alt))
  add(query_594450, "broadcastType", newJString(broadcastType))
  add(query_594450, "oauth_token", newJString(oauthToken))
  add(query_594450, "userIp", newJString(userIp))
  add(query_594450, "maxResults", newJInt(maxResults))
  add(query_594450, "part", newJString(part))
  add(query_594450, "key", newJString(key))
  add(query_594450, "broadcastStatus", newJString(broadcastStatus))
  add(query_594450, "prettyPrint", newJBool(prettyPrint))
  add(query_594450, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594449.call(nil, query_594450, nil, nil, nil)

var youtubeLiveBroadcastsList* = Call_YoutubeLiveBroadcastsList_594429(
    name: "youtubeLiveBroadcastsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsList_594430, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsList_594431, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsDelete_594487 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsDelete_594489(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsDelete_594488(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594490 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "onBehalfOfContentOwner", valid_594490
  var valid_594491 = query.getOrDefault("fields")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "fields", valid_594491
  var valid_594492 = query.getOrDefault("quotaUser")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "quotaUser", valid_594492
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594493 = query.getOrDefault("id")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "id", valid_594493
  var valid_594494 = query.getOrDefault("alt")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = newJString("json"))
  if valid_594494 != nil:
    section.add "alt", valid_594494
  var valid_594495 = query.getOrDefault("oauth_token")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "oauth_token", valid_594495
  var valid_594496 = query.getOrDefault("userIp")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "userIp", valid_594496
  var valid_594497 = query.getOrDefault("key")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "key", valid_594497
  var valid_594498 = query.getOrDefault("prettyPrint")
  valid_594498 = validateParameter(valid_594498, JBool, required = false,
                                 default = newJBool(true))
  if valid_594498 != nil:
    section.add "prettyPrint", valid_594498
  var valid_594499 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594500: Call_YoutubeLiveBroadcastsDelete_594487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a broadcast.
  ## 
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_YoutubeLiveBroadcastsDelete_594487; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsDelete
  ## Deletes a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594502 = newJObject()
  add(query_594502, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594502, "fields", newJString(fields))
  add(query_594502, "quotaUser", newJString(quotaUser))
  add(query_594502, "id", newJString(id))
  add(query_594502, "alt", newJString(alt))
  add(query_594502, "oauth_token", newJString(oauthToken))
  add(query_594502, "userIp", newJString(userIp))
  add(query_594502, "key", newJString(key))
  add(query_594502, "prettyPrint", newJBool(prettyPrint))
  add(query_594502, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594501.call(nil, query_594502, nil, nil, nil)

var youtubeLiveBroadcastsDelete* = Call_YoutubeLiveBroadcastsDelete_594487(
    name: "youtubeLiveBroadcastsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsDelete_594488, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsDelete_594489, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsBind_594503 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsBind_594505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsBind_594504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: JString
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594506 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "onBehalfOfContentOwner", valid_594506
  var valid_594507 = query.getOrDefault("fields")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "fields", valid_594507
  var valid_594508 = query.getOrDefault("quotaUser")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "quotaUser", valid_594508
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594509 = query.getOrDefault("id")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "id", valid_594509
  var valid_594510 = query.getOrDefault("alt")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = newJString("json"))
  if valid_594510 != nil:
    section.add "alt", valid_594510
  var valid_594511 = query.getOrDefault("oauth_token")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = nil)
  if valid_594511 != nil:
    section.add "oauth_token", valid_594511
  var valid_594512 = query.getOrDefault("userIp")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = nil)
  if valid_594512 != nil:
    section.add "userIp", valid_594512
  var valid_594513 = query.getOrDefault("part")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "part", valid_594513
  var valid_594514 = query.getOrDefault("key")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "key", valid_594514
  var valid_594515 = query.getOrDefault("streamId")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "streamId", valid_594515
  var valid_594516 = query.getOrDefault("prettyPrint")
  valid_594516 = validateParameter(valid_594516, JBool, required = false,
                                 default = newJBool(true))
  if valid_594516 != nil:
    section.add "prettyPrint", valid_594516
  var valid_594517 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594518: Call_YoutubeLiveBroadcastsBind_594503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_YoutubeLiveBroadcastsBind_594503; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; streamId: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsBind
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: string
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594520 = newJObject()
  add(query_594520, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594520, "fields", newJString(fields))
  add(query_594520, "quotaUser", newJString(quotaUser))
  add(query_594520, "id", newJString(id))
  add(query_594520, "alt", newJString(alt))
  add(query_594520, "oauth_token", newJString(oauthToken))
  add(query_594520, "userIp", newJString(userIp))
  add(query_594520, "part", newJString(part))
  add(query_594520, "key", newJString(key))
  add(query_594520, "streamId", newJString(streamId))
  add(query_594520, "prettyPrint", newJBool(prettyPrint))
  add(query_594520, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594519.call(nil, query_594520, nil, nil, nil)

var youtubeLiveBroadcastsBind* = Call_YoutubeLiveBroadcastsBind_594503(
    name: "youtubeLiveBroadcastsBind", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/bind",
    validator: validate_YoutubeLiveBroadcastsBind_594504, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsBind_594505, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsControl_594521 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsControl_594523(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsControl_594522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: JString
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: JString
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: JBool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  section = newJObject()
  var valid_594524 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "onBehalfOfContentOwner", valid_594524
  var valid_594525 = query.getOrDefault("offsetTimeMs")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "offsetTimeMs", valid_594525
  var valid_594526 = query.getOrDefault("fields")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "fields", valid_594526
  var valid_594527 = query.getOrDefault("quotaUser")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "quotaUser", valid_594527
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594528 = query.getOrDefault("id")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "id", valid_594528
  var valid_594529 = query.getOrDefault("alt")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = newJString("json"))
  if valid_594529 != nil:
    section.add "alt", valid_594529
  var valid_594530 = query.getOrDefault("oauth_token")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "oauth_token", valid_594530
  var valid_594531 = query.getOrDefault("userIp")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "userIp", valid_594531
  var valid_594532 = query.getOrDefault("part")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "part", valid_594532
  var valid_594533 = query.getOrDefault("walltime")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "walltime", valid_594533
  var valid_594534 = query.getOrDefault("key")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = nil)
  if valid_594534 != nil:
    section.add "key", valid_594534
  var valid_594535 = query.getOrDefault("prettyPrint")
  valid_594535 = validateParameter(valid_594535, JBool, required = false,
                                 default = newJBool(true))
  if valid_594535 != nil:
    section.add "prettyPrint", valid_594535
  var valid_594536 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594536 = validateParameter(valid_594536, JString, required = false,
                                 default = nil)
  if valid_594536 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594536
  var valid_594537 = query.getOrDefault("displaySlate")
  valid_594537 = validateParameter(valid_594537, JBool, required = false, default = nil)
  if valid_594537 != nil:
    section.add "displaySlate", valid_594537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594538: Call_YoutubeLiveBroadcastsControl_594521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  let valid = call_594538.validator(path, query, header, formData, body)
  let scheme = call_594538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594538.url(scheme.get, call_594538.host, call_594538.base,
                         call_594538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594538, url, valid)

proc call*(call_594539: Call_YoutubeLiveBroadcastsControl_594521; id: string;
          part: string; onBehalfOfContentOwner: string = "";
          offsetTimeMs: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          walltime: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; displaySlate: bool = false): Recallable =
  ## youtubeLiveBroadcastsControl
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: string
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: string
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: bool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  var query_594540 = newJObject()
  add(query_594540, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594540, "offsetTimeMs", newJString(offsetTimeMs))
  add(query_594540, "fields", newJString(fields))
  add(query_594540, "quotaUser", newJString(quotaUser))
  add(query_594540, "id", newJString(id))
  add(query_594540, "alt", newJString(alt))
  add(query_594540, "oauth_token", newJString(oauthToken))
  add(query_594540, "userIp", newJString(userIp))
  add(query_594540, "part", newJString(part))
  add(query_594540, "walltime", newJString(walltime))
  add(query_594540, "key", newJString(key))
  add(query_594540, "prettyPrint", newJBool(prettyPrint))
  add(query_594540, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_594540, "displaySlate", newJBool(displaySlate))
  result = call_594539.call(nil, query_594540, nil, nil, nil)

var youtubeLiveBroadcastsControl* = Call_YoutubeLiveBroadcastsControl_594521(
    name: "youtubeLiveBroadcastsControl", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/control",
    validator: validate_YoutubeLiveBroadcastsControl_594522, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsControl_594523, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsTransition_594541 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveBroadcastsTransition_594543(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsTransition_594542(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594544 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "onBehalfOfContentOwner", valid_594544
  var valid_594545 = query.getOrDefault("fields")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "fields", valid_594545
  var valid_594546 = query.getOrDefault("quotaUser")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "quotaUser", valid_594546
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594547 = query.getOrDefault("id")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "id", valid_594547
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
  var valid_594551 = query.getOrDefault("part")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "part", valid_594551
  var valid_594552 = query.getOrDefault("key")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "key", valid_594552
  var valid_594553 = query.getOrDefault("broadcastStatus")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = newJString("complete"))
  if valid_594553 != nil:
    section.add "broadcastStatus", valid_594553
  var valid_594554 = query.getOrDefault("prettyPrint")
  valid_594554 = validateParameter(valid_594554, JBool, required = false,
                                 default = newJBool(true))
  if valid_594554 != nil:
    section.add "prettyPrint", valid_594554
  var valid_594555 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_YoutubeLiveBroadcastsTransition_594541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_YoutubeLiveBroadcastsTransition_594541; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; broadcastStatus: string = "complete";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsTransition
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594558 = newJObject()
  add(query_594558, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594558, "fields", newJString(fields))
  add(query_594558, "quotaUser", newJString(quotaUser))
  add(query_594558, "id", newJString(id))
  add(query_594558, "alt", newJString(alt))
  add(query_594558, "oauth_token", newJString(oauthToken))
  add(query_594558, "userIp", newJString(userIp))
  add(query_594558, "part", newJString(part))
  add(query_594558, "key", newJString(key))
  add(query_594558, "broadcastStatus", newJString(broadcastStatus))
  add(query_594558, "prettyPrint", newJBool(prettyPrint))
  add(query_594558, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594557.call(nil, query_594558, nil, nil, nil)

var youtubeLiveBroadcastsTransition* = Call_YoutubeLiveBroadcastsTransition_594541(
    name: "youtubeLiveBroadcastsTransition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/transition",
    validator: validate_YoutubeLiveBroadcastsTransition_594542,
    base: "/youtube/v3", url: url_YoutubeLiveBroadcastsTransition_594543,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansInsert_594559 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatBansInsert_594561(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansInsert_594560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new ban to the chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594567 = query.getOrDefault("part")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "part", valid_594567
  var valid_594568 = query.getOrDefault("key")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "key", valid_594568
  var valid_594569 = query.getOrDefault("prettyPrint")
  valid_594569 = validateParameter(valid_594569, JBool, required = false,
                                 default = newJBool(true))
  if valid_594569 != nil:
    section.add "prettyPrint", valid_594569
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

proc call*(call_594571: Call_YoutubeLiveChatBansInsert_594559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new ban to the chat.
  ## 
  let valid = call_594571.validator(path, query, header, formData, body)
  let scheme = call_594571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594571.url(scheme.get, call_594571.host, call_594571.base,
                         call_594571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594571, url, valid)

proc call*(call_594572: Call_YoutubeLiveChatBansInsert_594559; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansInsert
  ## Adds a new ban to the chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594573 = newJObject()
  var body_594574 = newJObject()
  add(query_594573, "fields", newJString(fields))
  add(query_594573, "quotaUser", newJString(quotaUser))
  add(query_594573, "alt", newJString(alt))
  add(query_594573, "oauth_token", newJString(oauthToken))
  add(query_594573, "userIp", newJString(userIp))
  add(query_594573, "part", newJString(part))
  add(query_594573, "key", newJString(key))
  if body != nil:
    body_594574 = body
  add(query_594573, "prettyPrint", newJBool(prettyPrint))
  result = call_594572.call(nil, query_594573, nil, nil, body_594574)

var youtubeLiveChatBansInsert* = Call_YoutubeLiveChatBansInsert_594559(
    name: "youtubeLiveChatBansInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansInsert_594560, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansInsert_594561, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansDelete_594575 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatBansDelete_594577(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansDelete_594576(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat ban.
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
  ##   id: JString (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
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
  var valid_594578 = query.getOrDefault("fields")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "fields", valid_594578
  var valid_594579 = query.getOrDefault("quotaUser")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "quotaUser", valid_594579
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594580 = query.getOrDefault("id")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "id", valid_594580
  var valid_594581 = query.getOrDefault("alt")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = newJString("json"))
  if valid_594581 != nil:
    section.add "alt", valid_594581
  var valid_594582 = query.getOrDefault("oauth_token")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "oauth_token", valid_594582
  var valid_594583 = query.getOrDefault("userIp")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "userIp", valid_594583
  var valid_594584 = query.getOrDefault("key")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "key", valid_594584
  var valid_594585 = query.getOrDefault("prettyPrint")
  valid_594585 = validateParameter(valid_594585, JBool, required = false,
                                 default = newJBool(true))
  if valid_594585 != nil:
    section.add "prettyPrint", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594586: Call_YoutubeLiveChatBansDelete_594575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a chat ban.
  ## 
  let valid = call_594586.validator(path, query, header, formData, body)
  let scheme = call_594586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594586.url(scheme.get, call_594586.host, call_594586.base,
                         call_594586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594586, url, valid)

proc call*(call_594587: Call_YoutubeLiveChatBansDelete_594575; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansDelete
  ## Removes a chat ban.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
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
  var query_594588 = newJObject()
  add(query_594588, "fields", newJString(fields))
  add(query_594588, "quotaUser", newJString(quotaUser))
  add(query_594588, "id", newJString(id))
  add(query_594588, "alt", newJString(alt))
  add(query_594588, "oauth_token", newJString(oauthToken))
  add(query_594588, "userIp", newJString(userIp))
  add(query_594588, "key", newJString(key))
  add(query_594588, "prettyPrint", newJBool(prettyPrint))
  result = call_594587.call(nil, query_594588, nil, nil, nil)

var youtubeLiveChatBansDelete* = Call_YoutubeLiveChatBansDelete_594575(
    name: "youtubeLiveChatBansDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansDelete_594576, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansDelete_594577, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesInsert_594608 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatMessagesInsert_594610(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesInsert_594609(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a message to a live chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594611 = query.getOrDefault("fields")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "fields", valid_594611
  var valid_594612 = query.getOrDefault("quotaUser")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = nil)
  if valid_594612 != nil:
    section.add "quotaUser", valid_594612
  var valid_594613 = query.getOrDefault("alt")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = newJString("json"))
  if valid_594613 != nil:
    section.add "alt", valid_594613
  var valid_594614 = query.getOrDefault("oauth_token")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "oauth_token", valid_594614
  var valid_594615 = query.getOrDefault("userIp")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "userIp", valid_594615
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594616 = query.getOrDefault("part")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "part", valid_594616
  var valid_594617 = query.getOrDefault("key")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "key", valid_594617
  var valid_594618 = query.getOrDefault("prettyPrint")
  valid_594618 = validateParameter(valid_594618, JBool, required = false,
                                 default = newJBool(true))
  if valid_594618 != nil:
    section.add "prettyPrint", valid_594618
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

proc call*(call_594620: Call_YoutubeLiveChatMessagesInsert_594608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to a live chat.
  ## 
  let valid = call_594620.validator(path, query, header, formData, body)
  let scheme = call_594620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594620.url(scheme.get, call_594620.host, call_594620.base,
                         call_594620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594620, url, valid)

proc call*(call_594621: Call_YoutubeLiveChatMessagesInsert_594608; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesInsert
  ## Adds a message to a live chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594622 = newJObject()
  var body_594623 = newJObject()
  add(query_594622, "fields", newJString(fields))
  add(query_594622, "quotaUser", newJString(quotaUser))
  add(query_594622, "alt", newJString(alt))
  add(query_594622, "oauth_token", newJString(oauthToken))
  add(query_594622, "userIp", newJString(userIp))
  add(query_594622, "part", newJString(part))
  add(query_594622, "key", newJString(key))
  if body != nil:
    body_594623 = body
  add(query_594622, "prettyPrint", newJBool(prettyPrint))
  result = call_594621.call(nil, query_594622, nil, nil, body_594623)

var youtubeLiveChatMessagesInsert* = Call_YoutubeLiveChatMessagesInsert_594608(
    name: "youtubeLiveChatMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesInsert_594609, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesInsert_594610, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesList_594589 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatMessagesList_594591(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesList_594590(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists live chat messages for a specific chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: JInt
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_594592 = query.getOrDefault("fields")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "fields", valid_594592
  var valid_594593 = query.getOrDefault("pageToken")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "pageToken", valid_594593
  var valid_594594 = query.getOrDefault("quotaUser")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = nil)
  if valid_594594 != nil:
    section.add "quotaUser", valid_594594
  var valid_594595 = query.getOrDefault("alt")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = newJString("json"))
  if valid_594595 != nil:
    section.add "alt", valid_594595
  var valid_594596 = query.getOrDefault("oauth_token")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "oauth_token", valid_594596
  var valid_594597 = query.getOrDefault("userIp")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "userIp", valid_594597
  var valid_594598 = query.getOrDefault("maxResults")
  valid_594598 = validateParameter(valid_594598, JInt, required = false,
                                 default = newJInt(500))
  if valid_594598 != nil:
    section.add "maxResults", valid_594598
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594599 = query.getOrDefault("part")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "part", valid_594599
  var valid_594600 = query.getOrDefault("key")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "key", valid_594600
  var valid_594601 = query.getOrDefault("liveChatId")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "liveChatId", valid_594601
  var valid_594602 = query.getOrDefault("profileImageSize")
  valid_594602 = validateParameter(valid_594602, JInt, required = false, default = nil)
  if valid_594602 != nil:
    section.add "profileImageSize", valid_594602
  var valid_594603 = query.getOrDefault("prettyPrint")
  valid_594603 = validateParameter(valid_594603, JBool, required = false,
                                 default = newJBool(true))
  if valid_594603 != nil:
    section.add "prettyPrint", valid_594603
  var valid_594604 = query.getOrDefault("hl")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "hl", valid_594604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594605: Call_YoutubeLiveChatMessagesList_594589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists live chat messages for a specific chat.
  ## 
  let valid = call_594605.validator(path, query, header, formData, body)
  let scheme = call_594605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594605.url(scheme.get, call_594605.host, call_594605.base,
                         call_594605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594605, url, valid)

proc call*(call_594606: Call_YoutubeLiveChatMessagesList_594589; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          profileImageSize: int = 0; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeLiveChatMessagesList
  ## Lists live chat messages for a specific chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: int
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_594607 = newJObject()
  add(query_594607, "fields", newJString(fields))
  add(query_594607, "pageToken", newJString(pageToken))
  add(query_594607, "quotaUser", newJString(quotaUser))
  add(query_594607, "alt", newJString(alt))
  add(query_594607, "oauth_token", newJString(oauthToken))
  add(query_594607, "userIp", newJString(userIp))
  add(query_594607, "maxResults", newJInt(maxResults))
  add(query_594607, "part", newJString(part))
  add(query_594607, "key", newJString(key))
  add(query_594607, "liveChatId", newJString(liveChatId))
  add(query_594607, "profileImageSize", newJInt(profileImageSize))
  add(query_594607, "prettyPrint", newJBool(prettyPrint))
  add(query_594607, "hl", newJString(hl))
  result = call_594606.call(nil, query_594607, nil, nil, nil)

var youtubeLiveChatMessagesList* = Call_YoutubeLiveChatMessagesList_594589(
    name: "youtubeLiveChatMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesList_594590, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesList_594591, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesDelete_594624 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatMessagesDelete_594626(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesDelete_594625(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a chat message.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
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
  var valid_594627 = query.getOrDefault("fields")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "fields", valid_594627
  var valid_594628 = query.getOrDefault("quotaUser")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "quotaUser", valid_594628
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594629 = query.getOrDefault("id")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "id", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("oauth_token")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "oauth_token", valid_594631
  var valid_594632 = query.getOrDefault("userIp")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "userIp", valid_594632
  var valid_594633 = query.getOrDefault("key")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "key", valid_594633
  var valid_594634 = query.getOrDefault("prettyPrint")
  valid_594634 = validateParameter(valid_594634, JBool, required = false,
                                 default = newJBool(true))
  if valid_594634 != nil:
    section.add "prettyPrint", valid_594634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594635: Call_YoutubeLiveChatMessagesDelete_594624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a chat message.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_YoutubeLiveChatMessagesDelete_594624; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesDelete
  ## Deletes a chat message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
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
  var query_594637 = newJObject()
  add(query_594637, "fields", newJString(fields))
  add(query_594637, "quotaUser", newJString(quotaUser))
  add(query_594637, "id", newJString(id))
  add(query_594637, "alt", newJString(alt))
  add(query_594637, "oauth_token", newJString(oauthToken))
  add(query_594637, "userIp", newJString(userIp))
  add(query_594637, "key", newJString(key))
  add(query_594637, "prettyPrint", newJBool(prettyPrint))
  result = call_594636.call(nil, query_594637, nil, nil, nil)

var youtubeLiveChatMessagesDelete* = Call_YoutubeLiveChatMessagesDelete_594624(
    name: "youtubeLiveChatMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesDelete_594625, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesDelete_594626, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsInsert_594655 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatModeratorsInsert_594657(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsInsert_594656(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new moderator for the chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594658 = query.getOrDefault("fields")
  valid_594658 = validateParameter(valid_594658, JString, required = false,
                                 default = nil)
  if valid_594658 != nil:
    section.add "fields", valid_594658
  var valid_594659 = query.getOrDefault("quotaUser")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "quotaUser", valid_594659
  var valid_594660 = query.getOrDefault("alt")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = newJString("json"))
  if valid_594660 != nil:
    section.add "alt", valid_594660
  var valid_594661 = query.getOrDefault("oauth_token")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "oauth_token", valid_594661
  var valid_594662 = query.getOrDefault("userIp")
  valid_594662 = validateParameter(valid_594662, JString, required = false,
                                 default = nil)
  if valid_594662 != nil:
    section.add "userIp", valid_594662
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594663 = query.getOrDefault("part")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "part", valid_594663
  var valid_594664 = query.getOrDefault("key")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "key", valid_594664
  var valid_594665 = query.getOrDefault("prettyPrint")
  valid_594665 = validateParameter(valid_594665, JBool, required = false,
                                 default = newJBool(true))
  if valid_594665 != nil:
    section.add "prettyPrint", valid_594665
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

proc call*(call_594667: Call_YoutubeLiveChatModeratorsInsert_594655;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new moderator for the chat.
  ## 
  let valid = call_594667.validator(path, query, header, formData, body)
  let scheme = call_594667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594667.url(scheme.get, call_594667.host, call_594667.base,
                         call_594667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594667, url, valid)

proc call*(call_594668: Call_YoutubeLiveChatModeratorsInsert_594655; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsInsert
  ## Adds a new moderator for the chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594669 = newJObject()
  var body_594670 = newJObject()
  add(query_594669, "fields", newJString(fields))
  add(query_594669, "quotaUser", newJString(quotaUser))
  add(query_594669, "alt", newJString(alt))
  add(query_594669, "oauth_token", newJString(oauthToken))
  add(query_594669, "userIp", newJString(userIp))
  add(query_594669, "part", newJString(part))
  add(query_594669, "key", newJString(key))
  if body != nil:
    body_594670 = body
  add(query_594669, "prettyPrint", newJBool(prettyPrint))
  result = call_594668.call(nil, query_594669, nil, nil, body_594670)

var youtubeLiveChatModeratorsInsert* = Call_YoutubeLiveChatModeratorsInsert_594655(
    name: "youtubeLiveChatModeratorsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsInsert_594656,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsInsert_594657,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsList_594638 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatModeratorsList_594640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsList_594639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists moderators for a live chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594641 = query.getOrDefault("fields")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "fields", valid_594641
  var valid_594642 = query.getOrDefault("pageToken")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = nil)
  if valid_594642 != nil:
    section.add "pageToken", valid_594642
  var valid_594643 = query.getOrDefault("quotaUser")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "quotaUser", valid_594643
  var valid_594644 = query.getOrDefault("alt")
  valid_594644 = validateParameter(valid_594644, JString, required = false,
                                 default = newJString("json"))
  if valid_594644 != nil:
    section.add "alt", valid_594644
  var valid_594645 = query.getOrDefault("oauth_token")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = nil)
  if valid_594645 != nil:
    section.add "oauth_token", valid_594645
  var valid_594646 = query.getOrDefault("userIp")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "userIp", valid_594646
  var valid_594647 = query.getOrDefault("maxResults")
  valid_594647 = validateParameter(valid_594647, JInt, required = false,
                                 default = newJInt(5))
  if valid_594647 != nil:
    section.add "maxResults", valid_594647
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594648 = query.getOrDefault("part")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "part", valid_594648
  var valid_594649 = query.getOrDefault("key")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = nil)
  if valid_594649 != nil:
    section.add "key", valid_594649
  var valid_594650 = query.getOrDefault("liveChatId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "liveChatId", valid_594650
  var valid_594651 = query.getOrDefault("prettyPrint")
  valid_594651 = validateParameter(valid_594651, JBool, required = false,
                                 default = newJBool(true))
  if valid_594651 != nil:
    section.add "prettyPrint", valid_594651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594652: Call_YoutubeLiveChatModeratorsList_594638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists moderators for a live chat.
  ## 
  let valid = call_594652.validator(path, query, header, formData, body)
  let scheme = call_594652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594652.url(scheme.get, call_594652.host, call_594652.base,
                         call_594652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594652, url, valid)

proc call*(call_594653: Call_YoutubeLiveChatModeratorsList_594638; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsList
  ## Lists moderators for a live chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594654 = newJObject()
  add(query_594654, "fields", newJString(fields))
  add(query_594654, "pageToken", newJString(pageToken))
  add(query_594654, "quotaUser", newJString(quotaUser))
  add(query_594654, "alt", newJString(alt))
  add(query_594654, "oauth_token", newJString(oauthToken))
  add(query_594654, "userIp", newJString(userIp))
  add(query_594654, "maxResults", newJInt(maxResults))
  add(query_594654, "part", newJString(part))
  add(query_594654, "key", newJString(key))
  add(query_594654, "liveChatId", newJString(liveChatId))
  add(query_594654, "prettyPrint", newJBool(prettyPrint))
  result = call_594653.call(nil, query_594654, nil, nil, nil)

var youtubeLiveChatModeratorsList* = Call_YoutubeLiveChatModeratorsList_594638(
    name: "youtubeLiveChatModeratorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsList_594639, base: "/youtube/v3",
    url: url_YoutubeLiveChatModeratorsList_594640, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsDelete_594671 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveChatModeratorsDelete_594673(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsDelete_594672(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat moderator.
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
  ##   id: JString (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
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
  var valid_594674 = query.getOrDefault("fields")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "fields", valid_594674
  var valid_594675 = query.getOrDefault("quotaUser")
  valid_594675 = validateParameter(valid_594675, JString, required = false,
                                 default = nil)
  if valid_594675 != nil:
    section.add "quotaUser", valid_594675
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594676 = query.getOrDefault("id")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "id", valid_594676
  var valid_594677 = query.getOrDefault("alt")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = newJString("json"))
  if valid_594677 != nil:
    section.add "alt", valid_594677
  var valid_594678 = query.getOrDefault("oauth_token")
  valid_594678 = validateParameter(valid_594678, JString, required = false,
                                 default = nil)
  if valid_594678 != nil:
    section.add "oauth_token", valid_594678
  var valid_594679 = query.getOrDefault("userIp")
  valid_594679 = validateParameter(valid_594679, JString, required = false,
                                 default = nil)
  if valid_594679 != nil:
    section.add "userIp", valid_594679
  var valid_594680 = query.getOrDefault("key")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = nil)
  if valid_594680 != nil:
    section.add "key", valid_594680
  var valid_594681 = query.getOrDefault("prettyPrint")
  valid_594681 = validateParameter(valid_594681, JBool, required = false,
                                 default = newJBool(true))
  if valid_594681 != nil:
    section.add "prettyPrint", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_YoutubeLiveChatModeratorsDelete_594671;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a chat moderator.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_YoutubeLiveChatModeratorsDelete_594671; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsDelete
  ## Removes a chat moderator.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
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
  var query_594684 = newJObject()
  add(query_594684, "fields", newJString(fields))
  add(query_594684, "quotaUser", newJString(quotaUser))
  add(query_594684, "id", newJString(id))
  add(query_594684, "alt", newJString(alt))
  add(query_594684, "oauth_token", newJString(oauthToken))
  add(query_594684, "userIp", newJString(userIp))
  add(query_594684, "key", newJString(key))
  add(query_594684, "prettyPrint", newJBool(prettyPrint))
  result = call_594683.call(nil, query_594684, nil, nil, nil)

var youtubeLiveChatModeratorsDelete* = Call_YoutubeLiveChatModeratorsDelete_594671(
    name: "youtubeLiveChatModeratorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsDelete_594672,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsDelete_594673,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsUpdate_594705 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveStreamsUpdate_594707(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsUpdate_594706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594708 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "onBehalfOfContentOwner", valid_594708
  var valid_594709 = query.getOrDefault("fields")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "fields", valid_594709
  var valid_594710 = query.getOrDefault("quotaUser")
  valid_594710 = validateParameter(valid_594710, JString, required = false,
                                 default = nil)
  if valid_594710 != nil:
    section.add "quotaUser", valid_594710
  var valid_594711 = query.getOrDefault("alt")
  valid_594711 = validateParameter(valid_594711, JString, required = false,
                                 default = newJString("json"))
  if valid_594711 != nil:
    section.add "alt", valid_594711
  var valid_594712 = query.getOrDefault("oauth_token")
  valid_594712 = validateParameter(valid_594712, JString, required = false,
                                 default = nil)
  if valid_594712 != nil:
    section.add "oauth_token", valid_594712
  var valid_594713 = query.getOrDefault("userIp")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "userIp", valid_594713
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594714 = query.getOrDefault("part")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "part", valid_594714
  var valid_594715 = query.getOrDefault("key")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = nil)
  if valid_594715 != nil:
    section.add "key", valid_594715
  var valid_594716 = query.getOrDefault("prettyPrint")
  valid_594716 = validateParameter(valid_594716, JBool, required = false,
                                 default = newJBool(true))
  if valid_594716 != nil:
    section.add "prettyPrint", valid_594716
  var valid_594717 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594717 = validateParameter(valid_594717, JString, required = false,
                                 default = nil)
  if valid_594717 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594717
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

proc call*(call_594719: Call_YoutubeLiveStreamsUpdate_594705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  let valid = call_594719.validator(path, query, header, formData, body)
  let scheme = call_594719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594719.url(scheme.get, call_594719.host, call_594719.base,
                         call_594719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594719, url, valid)

proc call*(call_594720: Call_YoutubeLiveStreamsUpdate_594705; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsUpdate
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594721 = newJObject()
  var body_594722 = newJObject()
  add(query_594721, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594721, "fields", newJString(fields))
  add(query_594721, "quotaUser", newJString(quotaUser))
  add(query_594721, "alt", newJString(alt))
  add(query_594721, "oauth_token", newJString(oauthToken))
  add(query_594721, "userIp", newJString(userIp))
  add(query_594721, "part", newJString(part))
  add(query_594721, "key", newJString(key))
  if body != nil:
    body_594722 = body
  add(query_594721, "prettyPrint", newJBool(prettyPrint))
  add(query_594721, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594720.call(nil, query_594721, nil, nil, body_594722)

var youtubeLiveStreamsUpdate* = Call_YoutubeLiveStreamsUpdate_594705(
    name: "youtubeLiveStreamsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsUpdate_594706, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsUpdate_594707, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsInsert_594723 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveStreamsInsert_594725(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsInsert_594724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594726 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594726 = validateParameter(valid_594726, JString, required = false,
                                 default = nil)
  if valid_594726 != nil:
    section.add "onBehalfOfContentOwner", valid_594726
  var valid_594727 = query.getOrDefault("fields")
  valid_594727 = validateParameter(valid_594727, JString, required = false,
                                 default = nil)
  if valid_594727 != nil:
    section.add "fields", valid_594727
  var valid_594728 = query.getOrDefault("quotaUser")
  valid_594728 = validateParameter(valid_594728, JString, required = false,
                                 default = nil)
  if valid_594728 != nil:
    section.add "quotaUser", valid_594728
  var valid_594729 = query.getOrDefault("alt")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = newJString("json"))
  if valid_594729 != nil:
    section.add "alt", valid_594729
  var valid_594730 = query.getOrDefault("oauth_token")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = nil)
  if valid_594730 != nil:
    section.add "oauth_token", valid_594730
  var valid_594731 = query.getOrDefault("userIp")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "userIp", valid_594731
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594732 = query.getOrDefault("part")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "part", valid_594732
  var valid_594733 = query.getOrDefault("key")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "key", valid_594733
  var valid_594734 = query.getOrDefault("prettyPrint")
  valid_594734 = validateParameter(valid_594734, JBool, required = false,
                                 default = newJBool(true))
  if valid_594734 != nil:
    section.add "prettyPrint", valid_594734
  var valid_594735 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594735
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

proc call*(call_594737: Call_YoutubeLiveStreamsInsert_594723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  let valid = call_594737.validator(path, query, header, formData, body)
  let scheme = call_594737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594737.url(scheme.get, call_594737.host, call_594737.base,
                         call_594737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594737, url, valid)

proc call*(call_594738: Call_YoutubeLiveStreamsInsert_594723; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsInsert
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594739 = newJObject()
  var body_594740 = newJObject()
  add(query_594739, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594739, "fields", newJString(fields))
  add(query_594739, "quotaUser", newJString(quotaUser))
  add(query_594739, "alt", newJString(alt))
  add(query_594739, "oauth_token", newJString(oauthToken))
  add(query_594739, "userIp", newJString(userIp))
  add(query_594739, "part", newJString(part))
  add(query_594739, "key", newJString(key))
  if body != nil:
    body_594740 = body
  add(query_594739, "prettyPrint", newJBool(prettyPrint))
  add(query_594739, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594738.call(nil, query_594739, nil, nil, body_594740)

var youtubeLiveStreamsInsert* = Call_YoutubeLiveStreamsInsert_594723(
    name: "youtubeLiveStreamsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsInsert_594724, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsInsert_594725, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsList_594685 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveStreamsList_594687(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsList_594686(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594688 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "onBehalfOfContentOwner", valid_594688
  var valid_594689 = query.getOrDefault("mine")
  valid_594689 = validateParameter(valid_594689, JBool, required = false, default = nil)
  if valid_594689 != nil:
    section.add "mine", valid_594689
  var valid_594690 = query.getOrDefault("fields")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "fields", valid_594690
  var valid_594691 = query.getOrDefault("pageToken")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "pageToken", valid_594691
  var valid_594692 = query.getOrDefault("quotaUser")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "quotaUser", valid_594692
  var valid_594693 = query.getOrDefault("id")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = nil)
  if valid_594693 != nil:
    section.add "id", valid_594693
  var valid_594694 = query.getOrDefault("alt")
  valid_594694 = validateParameter(valid_594694, JString, required = false,
                                 default = newJString("json"))
  if valid_594694 != nil:
    section.add "alt", valid_594694
  var valid_594695 = query.getOrDefault("oauth_token")
  valid_594695 = validateParameter(valid_594695, JString, required = false,
                                 default = nil)
  if valid_594695 != nil:
    section.add "oauth_token", valid_594695
  var valid_594696 = query.getOrDefault("userIp")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "userIp", valid_594696
  var valid_594697 = query.getOrDefault("maxResults")
  valid_594697 = validateParameter(valid_594697, JInt, required = false,
                                 default = newJInt(5))
  if valid_594697 != nil:
    section.add "maxResults", valid_594697
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594698 = query.getOrDefault("part")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "part", valid_594698
  var valid_594699 = query.getOrDefault("key")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "key", valid_594699
  var valid_594700 = query.getOrDefault("prettyPrint")
  valid_594700 = validateParameter(valid_594700, JBool, required = false,
                                 default = newJBool(true))
  if valid_594700 != nil:
    section.add "prettyPrint", valid_594700
  var valid_594701 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = nil)
  if valid_594701 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594702: Call_YoutubeLiveStreamsList_594685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  let valid = call_594702.validator(path, query, header, formData, body)
  let scheme = call_594702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594702.url(scheme.get, call_594702.host, call_594702.base,
                         call_594702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594702, url, valid)

proc call*(call_594703: Call_YoutubeLiveStreamsList_594685; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsList
  ## Returns a list of video streams that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594704 = newJObject()
  add(query_594704, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594704, "mine", newJBool(mine))
  add(query_594704, "fields", newJString(fields))
  add(query_594704, "pageToken", newJString(pageToken))
  add(query_594704, "quotaUser", newJString(quotaUser))
  add(query_594704, "id", newJString(id))
  add(query_594704, "alt", newJString(alt))
  add(query_594704, "oauth_token", newJString(oauthToken))
  add(query_594704, "userIp", newJString(userIp))
  add(query_594704, "maxResults", newJInt(maxResults))
  add(query_594704, "part", newJString(part))
  add(query_594704, "key", newJString(key))
  add(query_594704, "prettyPrint", newJBool(prettyPrint))
  add(query_594704, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594703.call(nil, query_594704, nil, nil, nil)

var youtubeLiveStreamsList* = Call_YoutubeLiveStreamsList_594685(
    name: "youtubeLiveStreamsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsList_594686, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsList_594687, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsDelete_594741 = ref object of OpenApiRestCall_593437
proc url_YoutubeLiveStreamsDelete_594743(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsDelete_594742(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a video stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594744 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "onBehalfOfContentOwner", valid_594744
  var valid_594745 = query.getOrDefault("fields")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = nil)
  if valid_594745 != nil:
    section.add "fields", valid_594745
  var valid_594746 = query.getOrDefault("quotaUser")
  valid_594746 = validateParameter(valid_594746, JString, required = false,
                                 default = nil)
  if valid_594746 != nil:
    section.add "quotaUser", valid_594746
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594747 = query.getOrDefault("id")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "id", valid_594747
  var valid_594748 = query.getOrDefault("alt")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = newJString("json"))
  if valid_594748 != nil:
    section.add "alt", valid_594748
  var valid_594749 = query.getOrDefault("oauth_token")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "oauth_token", valid_594749
  var valid_594750 = query.getOrDefault("userIp")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = nil)
  if valid_594750 != nil:
    section.add "userIp", valid_594750
  var valid_594751 = query.getOrDefault("key")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "key", valid_594751
  var valid_594752 = query.getOrDefault("prettyPrint")
  valid_594752 = validateParameter(valid_594752, JBool, required = false,
                                 default = newJBool(true))
  if valid_594752 != nil:
    section.add "prettyPrint", valid_594752
  var valid_594753 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594754: Call_YoutubeLiveStreamsDelete_594741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a video stream.
  ## 
  let valid = call_594754.validator(path, query, header, formData, body)
  let scheme = call_594754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594754.url(scheme.get, call_594754.host, call_594754.base,
                         call_594754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594754, url, valid)

proc call*(call_594755: Call_YoutubeLiveStreamsDelete_594741; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsDelete
  ## Deletes a video stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594756 = newJObject()
  add(query_594756, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594756, "fields", newJString(fields))
  add(query_594756, "quotaUser", newJString(quotaUser))
  add(query_594756, "id", newJString(id))
  add(query_594756, "alt", newJString(alt))
  add(query_594756, "oauth_token", newJString(oauthToken))
  add(query_594756, "userIp", newJString(userIp))
  add(query_594756, "key", newJString(key))
  add(query_594756, "prettyPrint", newJBool(prettyPrint))
  add(query_594756, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594755.call(nil, query_594756, nil, nil, nil)

var youtubeLiveStreamsDelete* = Call_YoutubeLiveStreamsDelete_594741(
    name: "youtubeLiveStreamsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsDelete_594742, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsDelete_594743, schemes: {Scheme.Https})
type
  Call_YoutubeMembersList_594757 = ref object of OpenApiRestCall_593437
proc url_YoutubeMembersList_594759(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeMembersList_594758(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists members for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   mode: JString
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: JString
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594760 = query.getOrDefault("fields")
  valid_594760 = validateParameter(valid_594760, JString, required = false,
                                 default = nil)
  if valid_594760 != nil:
    section.add "fields", valid_594760
  var valid_594761 = query.getOrDefault("pageToken")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "pageToken", valid_594761
  var valid_594762 = query.getOrDefault("quotaUser")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "quotaUser", valid_594762
  var valid_594763 = query.getOrDefault("alt")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = newJString("json"))
  if valid_594763 != nil:
    section.add "alt", valid_594763
  var valid_594764 = query.getOrDefault("oauth_token")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "oauth_token", valid_594764
  var valid_594765 = query.getOrDefault("mode")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = newJString("all_current"))
  if valid_594765 != nil:
    section.add "mode", valid_594765
  var valid_594766 = query.getOrDefault("userIp")
  valid_594766 = validateParameter(valid_594766, JString, required = false,
                                 default = nil)
  if valid_594766 != nil:
    section.add "userIp", valid_594766
  var valid_594767 = query.getOrDefault("hasAccessToLevel")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "hasAccessToLevel", valid_594767
  var valid_594768 = query.getOrDefault("maxResults")
  valid_594768 = validateParameter(valid_594768, JInt, required = false,
                                 default = newJInt(5))
  if valid_594768 != nil:
    section.add "maxResults", valid_594768
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594769 = query.getOrDefault("part")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "part", valid_594769
  var valid_594770 = query.getOrDefault("key")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "key", valid_594770
  var valid_594771 = query.getOrDefault("prettyPrint")
  valid_594771 = validateParameter(valid_594771, JBool, required = false,
                                 default = newJBool(true))
  if valid_594771 != nil:
    section.add "prettyPrint", valid_594771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594772: Call_YoutubeMembersList_594757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists members for a channel.
  ## 
  let valid = call_594772.validator(path, query, header, formData, body)
  let scheme = call_594772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594772.url(scheme.get, call_594772.host, call_594772.base,
                         call_594772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594772, url, valid)

proc call*(call_594773: Call_YoutubeMembersList_594757; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; mode: string = "all_current";
          userIp: string = ""; hasAccessToLevel: string = ""; maxResults: int = 5;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeMembersList
  ## Lists members for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mode: string
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: string
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594774 = newJObject()
  add(query_594774, "fields", newJString(fields))
  add(query_594774, "pageToken", newJString(pageToken))
  add(query_594774, "quotaUser", newJString(quotaUser))
  add(query_594774, "alt", newJString(alt))
  add(query_594774, "oauth_token", newJString(oauthToken))
  add(query_594774, "mode", newJString(mode))
  add(query_594774, "userIp", newJString(userIp))
  add(query_594774, "hasAccessToLevel", newJString(hasAccessToLevel))
  add(query_594774, "maxResults", newJInt(maxResults))
  add(query_594774, "part", newJString(part))
  add(query_594774, "key", newJString(key))
  add(query_594774, "prettyPrint", newJBool(prettyPrint))
  result = call_594773.call(nil, query_594774, nil, nil, nil)

var youtubeMembersList* = Call_YoutubeMembersList_594757(
    name: "youtubeMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/members",
    validator: validate_YoutubeMembersList_594758, base: "/youtube/v3",
    url: url_YoutubeMembersList_594759, schemes: {Scheme.Https})
type
  Call_YoutubeMembershipsLevelsList_594775 = ref object of OpenApiRestCall_593437
proc url_YoutubeMembershipsLevelsList_594777(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeMembershipsLevelsList_594776(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pricing levels for a channel.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594778 = query.getOrDefault("fields")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "fields", valid_594778
  var valid_594779 = query.getOrDefault("quotaUser")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = nil)
  if valid_594779 != nil:
    section.add "quotaUser", valid_594779
  var valid_594780 = query.getOrDefault("alt")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = newJString("json"))
  if valid_594780 != nil:
    section.add "alt", valid_594780
  var valid_594781 = query.getOrDefault("oauth_token")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "oauth_token", valid_594781
  var valid_594782 = query.getOrDefault("userIp")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "userIp", valid_594782
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594783 = query.getOrDefault("part")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "part", valid_594783
  var valid_594784 = query.getOrDefault("key")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "key", valid_594784
  var valid_594785 = query.getOrDefault("prettyPrint")
  valid_594785 = validateParameter(valid_594785, JBool, required = false,
                                 default = newJBool(true))
  if valid_594785 != nil:
    section.add "prettyPrint", valid_594785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594786: Call_YoutubeMembershipsLevelsList_594775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pricing levels for a channel.
  ## 
  let valid = call_594786.validator(path, query, header, formData, body)
  let scheme = call_594786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594786.url(scheme.get, call_594786.host, call_594786.base,
                         call_594786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594786, url, valid)

proc call*(call_594787: Call_YoutubeMembershipsLevelsList_594775; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeMembershipsLevelsList
  ## Lists pricing levels for a channel.
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
  ##   part: string (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594788 = newJObject()
  add(query_594788, "fields", newJString(fields))
  add(query_594788, "quotaUser", newJString(quotaUser))
  add(query_594788, "alt", newJString(alt))
  add(query_594788, "oauth_token", newJString(oauthToken))
  add(query_594788, "userIp", newJString(userIp))
  add(query_594788, "part", newJString(part))
  add(query_594788, "key", newJString(key))
  add(query_594788, "prettyPrint", newJBool(prettyPrint))
  result = call_594787.call(nil, query_594788, nil, nil, nil)

var youtubeMembershipsLevelsList* = Call_YoutubeMembershipsLevelsList_594775(
    name: "youtubeMembershipsLevelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/membershipsLevels",
    validator: validate_YoutubeMembershipsLevelsList_594776, base: "/youtube/v3",
    url: url_YoutubeMembershipsLevelsList_594777, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsUpdate_594809 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistItemsUpdate_594811(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsUpdate_594810(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594812 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = nil)
  if valid_594812 != nil:
    section.add "onBehalfOfContentOwner", valid_594812
  var valid_594813 = query.getOrDefault("fields")
  valid_594813 = validateParameter(valid_594813, JString, required = false,
                                 default = nil)
  if valid_594813 != nil:
    section.add "fields", valid_594813
  var valid_594814 = query.getOrDefault("quotaUser")
  valid_594814 = validateParameter(valid_594814, JString, required = false,
                                 default = nil)
  if valid_594814 != nil:
    section.add "quotaUser", valid_594814
  var valid_594815 = query.getOrDefault("alt")
  valid_594815 = validateParameter(valid_594815, JString, required = false,
                                 default = newJString("json"))
  if valid_594815 != nil:
    section.add "alt", valid_594815
  var valid_594816 = query.getOrDefault("oauth_token")
  valid_594816 = validateParameter(valid_594816, JString, required = false,
                                 default = nil)
  if valid_594816 != nil:
    section.add "oauth_token", valid_594816
  var valid_594817 = query.getOrDefault("userIp")
  valid_594817 = validateParameter(valid_594817, JString, required = false,
                                 default = nil)
  if valid_594817 != nil:
    section.add "userIp", valid_594817
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594818 = query.getOrDefault("part")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "part", valid_594818
  var valid_594819 = query.getOrDefault("key")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "key", valid_594819
  var valid_594820 = query.getOrDefault("prettyPrint")
  valid_594820 = validateParameter(valid_594820, JBool, required = false,
                                 default = newJBool(true))
  if valid_594820 != nil:
    section.add "prettyPrint", valid_594820
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

proc call*(call_594822: Call_YoutubePlaylistItemsUpdate_594809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  let valid = call_594822.validator(path, query, header, formData, body)
  let scheme = call_594822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594822.url(scheme.get, call_594822.host, call_594822.base,
                         call_594822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594822, url, valid)

proc call*(call_594823: Call_YoutubePlaylistItemsUpdate_594809; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsUpdate
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594824 = newJObject()
  var body_594825 = newJObject()
  add(query_594824, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594824, "fields", newJString(fields))
  add(query_594824, "quotaUser", newJString(quotaUser))
  add(query_594824, "alt", newJString(alt))
  add(query_594824, "oauth_token", newJString(oauthToken))
  add(query_594824, "userIp", newJString(userIp))
  add(query_594824, "part", newJString(part))
  add(query_594824, "key", newJString(key))
  if body != nil:
    body_594825 = body
  add(query_594824, "prettyPrint", newJBool(prettyPrint))
  result = call_594823.call(nil, query_594824, nil, nil, body_594825)

var youtubePlaylistItemsUpdate* = Call_YoutubePlaylistItemsUpdate_594809(
    name: "youtubePlaylistItemsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsUpdate_594810, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsUpdate_594811, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsInsert_594826 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistItemsInsert_594828(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsInsert_594827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a resource to a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594829 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594829 = validateParameter(valid_594829, JString, required = false,
                                 default = nil)
  if valid_594829 != nil:
    section.add "onBehalfOfContentOwner", valid_594829
  var valid_594830 = query.getOrDefault("fields")
  valid_594830 = validateParameter(valid_594830, JString, required = false,
                                 default = nil)
  if valid_594830 != nil:
    section.add "fields", valid_594830
  var valid_594831 = query.getOrDefault("quotaUser")
  valid_594831 = validateParameter(valid_594831, JString, required = false,
                                 default = nil)
  if valid_594831 != nil:
    section.add "quotaUser", valid_594831
  var valid_594832 = query.getOrDefault("alt")
  valid_594832 = validateParameter(valid_594832, JString, required = false,
                                 default = newJString("json"))
  if valid_594832 != nil:
    section.add "alt", valid_594832
  var valid_594833 = query.getOrDefault("oauth_token")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = nil)
  if valid_594833 != nil:
    section.add "oauth_token", valid_594833
  var valid_594834 = query.getOrDefault("userIp")
  valid_594834 = validateParameter(valid_594834, JString, required = false,
                                 default = nil)
  if valid_594834 != nil:
    section.add "userIp", valid_594834
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594835 = query.getOrDefault("part")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "part", valid_594835
  var valid_594836 = query.getOrDefault("key")
  valid_594836 = validateParameter(valid_594836, JString, required = false,
                                 default = nil)
  if valid_594836 != nil:
    section.add "key", valid_594836
  var valid_594837 = query.getOrDefault("prettyPrint")
  valid_594837 = validateParameter(valid_594837, JBool, required = false,
                                 default = newJBool(true))
  if valid_594837 != nil:
    section.add "prettyPrint", valid_594837
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

proc call*(call_594839: Call_YoutubePlaylistItemsInsert_594826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a resource to a playlist.
  ## 
  let valid = call_594839.validator(path, query, header, formData, body)
  let scheme = call_594839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594839.url(scheme.get, call_594839.host, call_594839.base,
                         call_594839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594839, url, valid)

proc call*(call_594840: Call_YoutubePlaylistItemsInsert_594826; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsInsert
  ## Adds a resource to a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594841 = newJObject()
  var body_594842 = newJObject()
  add(query_594841, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594841, "fields", newJString(fields))
  add(query_594841, "quotaUser", newJString(quotaUser))
  add(query_594841, "alt", newJString(alt))
  add(query_594841, "oauth_token", newJString(oauthToken))
  add(query_594841, "userIp", newJString(userIp))
  add(query_594841, "part", newJString(part))
  add(query_594841, "key", newJString(key))
  if body != nil:
    body_594842 = body
  add(query_594841, "prettyPrint", newJBool(prettyPrint))
  result = call_594840.call(nil, query_594841, nil, nil, body_594842)

var youtubePlaylistItemsInsert* = Call_YoutubePlaylistItemsInsert_594826(
    name: "youtubePlaylistItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsInsert_594827, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsInsert_594828, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsList_594789 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistItemsList_594791(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsList_594790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: JString
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594792 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594792 = validateParameter(valid_594792, JString, required = false,
                                 default = nil)
  if valid_594792 != nil:
    section.add "onBehalfOfContentOwner", valid_594792
  var valid_594793 = query.getOrDefault("playlistId")
  valid_594793 = validateParameter(valid_594793, JString, required = false,
                                 default = nil)
  if valid_594793 != nil:
    section.add "playlistId", valid_594793
  var valid_594794 = query.getOrDefault("fields")
  valid_594794 = validateParameter(valid_594794, JString, required = false,
                                 default = nil)
  if valid_594794 != nil:
    section.add "fields", valid_594794
  var valid_594795 = query.getOrDefault("pageToken")
  valid_594795 = validateParameter(valid_594795, JString, required = false,
                                 default = nil)
  if valid_594795 != nil:
    section.add "pageToken", valid_594795
  var valid_594796 = query.getOrDefault("quotaUser")
  valid_594796 = validateParameter(valid_594796, JString, required = false,
                                 default = nil)
  if valid_594796 != nil:
    section.add "quotaUser", valid_594796
  var valid_594797 = query.getOrDefault("id")
  valid_594797 = validateParameter(valid_594797, JString, required = false,
                                 default = nil)
  if valid_594797 != nil:
    section.add "id", valid_594797
  var valid_594798 = query.getOrDefault("alt")
  valid_594798 = validateParameter(valid_594798, JString, required = false,
                                 default = newJString("json"))
  if valid_594798 != nil:
    section.add "alt", valid_594798
  var valid_594799 = query.getOrDefault("oauth_token")
  valid_594799 = validateParameter(valid_594799, JString, required = false,
                                 default = nil)
  if valid_594799 != nil:
    section.add "oauth_token", valid_594799
  var valid_594800 = query.getOrDefault("userIp")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "userIp", valid_594800
  var valid_594801 = query.getOrDefault("videoId")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = nil)
  if valid_594801 != nil:
    section.add "videoId", valid_594801
  var valid_594802 = query.getOrDefault("maxResults")
  valid_594802 = validateParameter(valid_594802, JInt, required = false,
                                 default = newJInt(5))
  if valid_594802 != nil:
    section.add "maxResults", valid_594802
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594803 = query.getOrDefault("part")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "part", valid_594803
  var valid_594804 = query.getOrDefault("key")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "key", valid_594804
  var valid_594805 = query.getOrDefault("prettyPrint")
  valid_594805 = validateParameter(valid_594805, JBool, required = false,
                                 default = newJBool(true))
  if valid_594805 != nil:
    section.add "prettyPrint", valid_594805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594806: Call_YoutubePlaylistItemsList_594789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  let valid = call_594806.validator(path, query, header, formData, body)
  let scheme = call_594806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594806.url(scheme.get, call_594806.host, call_594806.base,
                         call_594806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594806, url, valid)

proc call*(call_594807: Call_YoutubePlaylistItemsList_594789; part: string;
          onBehalfOfContentOwner: string = ""; playlistId: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          id: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; videoId: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsList
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: string
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594808 = newJObject()
  add(query_594808, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594808, "playlistId", newJString(playlistId))
  add(query_594808, "fields", newJString(fields))
  add(query_594808, "pageToken", newJString(pageToken))
  add(query_594808, "quotaUser", newJString(quotaUser))
  add(query_594808, "id", newJString(id))
  add(query_594808, "alt", newJString(alt))
  add(query_594808, "oauth_token", newJString(oauthToken))
  add(query_594808, "userIp", newJString(userIp))
  add(query_594808, "videoId", newJString(videoId))
  add(query_594808, "maxResults", newJInt(maxResults))
  add(query_594808, "part", newJString(part))
  add(query_594808, "key", newJString(key))
  add(query_594808, "prettyPrint", newJBool(prettyPrint))
  result = call_594807.call(nil, query_594808, nil, nil, nil)

var youtubePlaylistItemsList* = Call_YoutubePlaylistItemsList_594789(
    name: "youtubePlaylistItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsList_594790, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsList_594791, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsDelete_594843 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistItemsDelete_594845(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsDelete_594844(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
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
  var valid_594846 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594846 = validateParameter(valid_594846, JString, required = false,
                                 default = nil)
  if valid_594846 != nil:
    section.add "onBehalfOfContentOwner", valid_594846
  var valid_594847 = query.getOrDefault("fields")
  valid_594847 = validateParameter(valid_594847, JString, required = false,
                                 default = nil)
  if valid_594847 != nil:
    section.add "fields", valid_594847
  var valid_594848 = query.getOrDefault("quotaUser")
  valid_594848 = validateParameter(valid_594848, JString, required = false,
                                 default = nil)
  if valid_594848 != nil:
    section.add "quotaUser", valid_594848
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594849 = query.getOrDefault("id")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "id", valid_594849
  var valid_594850 = query.getOrDefault("alt")
  valid_594850 = validateParameter(valid_594850, JString, required = false,
                                 default = newJString("json"))
  if valid_594850 != nil:
    section.add "alt", valid_594850
  var valid_594851 = query.getOrDefault("oauth_token")
  valid_594851 = validateParameter(valid_594851, JString, required = false,
                                 default = nil)
  if valid_594851 != nil:
    section.add "oauth_token", valid_594851
  var valid_594852 = query.getOrDefault("userIp")
  valid_594852 = validateParameter(valid_594852, JString, required = false,
                                 default = nil)
  if valid_594852 != nil:
    section.add "userIp", valid_594852
  var valid_594853 = query.getOrDefault("key")
  valid_594853 = validateParameter(valid_594853, JString, required = false,
                                 default = nil)
  if valid_594853 != nil:
    section.add "key", valid_594853
  var valid_594854 = query.getOrDefault("prettyPrint")
  valid_594854 = validateParameter(valid_594854, JBool, required = false,
                                 default = newJBool(true))
  if valid_594854 != nil:
    section.add "prettyPrint", valid_594854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594855: Call_YoutubePlaylistItemsDelete_594843; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist item.
  ## 
  let valid = call_594855.validator(path, query, header, formData, body)
  let scheme = call_594855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594855.url(scheme.get, call_594855.host, call_594855.base,
                         call_594855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594855, url, valid)

proc call*(call_594856: Call_YoutubePlaylistItemsDelete_594843; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsDelete
  ## Deletes a playlist item.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
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
  var query_594857 = newJObject()
  add(query_594857, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594857, "fields", newJString(fields))
  add(query_594857, "quotaUser", newJString(quotaUser))
  add(query_594857, "id", newJString(id))
  add(query_594857, "alt", newJString(alt))
  add(query_594857, "oauth_token", newJString(oauthToken))
  add(query_594857, "userIp", newJString(userIp))
  add(query_594857, "key", newJString(key))
  add(query_594857, "prettyPrint", newJBool(prettyPrint))
  result = call_594856.call(nil, query_594857, nil, nil, nil)

var youtubePlaylistItemsDelete* = Call_YoutubePlaylistItemsDelete_594843(
    name: "youtubePlaylistItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsDelete_594844, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsDelete_594845, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsUpdate_594880 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistsUpdate_594882(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsUpdate_594881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594883 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594883 = validateParameter(valid_594883, JString, required = false,
                                 default = nil)
  if valid_594883 != nil:
    section.add "onBehalfOfContentOwner", valid_594883
  var valid_594884 = query.getOrDefault("fields")
  valid_594884 = validateParameter(valid_594884, JString, required = false,
                                 default = nil)
  if valid_594884 != nil:
    section.add "fields", valid_594884
  var valid_594885 = query.getOrDefault("quotaUser")
  valid_594885 = validateParameter(valid_594885, JString, required = false,
                                 default = nil)
  if valid_594885 != nil:
    section.add "quotaUser", valid_594885
  var valid_594886 = query.getOrDefault("alt")
  valid_594886 = validateParameter(valid_594886, JString, required = false,
                                 default = newJString("json"))
  if valid_594886 != nil:
    section.add "alt", valid_594886
  var valid_594887 = query.getOrDefault("oauth_token")
  valid_594887 = validateParameter(valid_594887, JString, required = false,
                                 default = nil)
  if valid_594887 != nil:
    section.add "oauth_token", valid_594887
  var valid_594888 = query.getOrDefault("userIp")
  valid_594888 = validateParameter(valid_594888, JString, required = false,
                                 default = nil)
  if valid_594888 != nil:
    section.add "userIp", valid_594888
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594889 = query.getOrDefault("part")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "part", valid_594889
  var valid_594890 = query.getOrDefault("key")
  valid_594890 = validateParameter(valid_594890, JString, required = false,
                                 default = nil)
  if valid_594890 != nil:
    section.add "key", valid_594890
  var valid_594891 = query.getOrDefault("prettyPrint")
  valid_594891 = validateParameter(valid_594891, JBool, required = false,
                                 default = newJBool(true))
  if valid_594891 != nil:
    section.add "prettyPrint", valid_594891
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

proc call*(call_594893: Call_YoutubePlaylistsUpdate_594880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  let valid = call_594893.validator(path, query, header, formData, body)
  let scheme = call_594893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594893.url(scheme.get, call_594893.host, call_594893.base,
                         call_594893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594893, url, valid)

proc call*(call_594894: Call_YoutubePlaylistsUpdate_594880; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsUpdate
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594895 = newJObject()
  var body_594896 = newJObject()
  add(query_594895, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594895, "fields", newJString(fields))
  add(query_594895, "quotaUser", newJString(quotaUser))
  add(query_594895, "alt", newJString(alt))
  add(query_594895, "oauth_token", newJString(oauthToken))
  add(query_594895, "userIp", newJString(userIp))
  add(query_594895, "part", newJString(part))
  add(query_594895, "key", newJString(key))
  if body != nil:
    body_594896 = body
  add(query_594895, "prettyPrint", newJBool(prettyPrint))
  result = call_594894.call(nil, query_594895, nil, nil, body_594896)

var youtubePlaylistsUpdate* = Call_YoutubePlaylistsUpdate_594880(
    name: "youtubePlaylistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsUpdate_594881, base: "/youtube/v3",
    url: url_YoutubePlaylistsUpdate_594882, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsInsert_594897 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistsInsert_594899(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsInsert_594898(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_594900 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594900 = validateParameter(valid_594900, JString, required = false,
                                 default = nil)
  if valid_594900 != nil:
    section.add "onBehalfOfContentOwner", valid_594900
  var valid_594901 = query.getOrDefault("fields")
  valid_594901 = validateParameter(valid_594901, JString, required = false,
                                 default = nil)
  if valid_594901 != nil:
    section.add "fields", valid_594901
  var valid_594902 = query.getOrDefault("quotaUser")
  valid_594902 = validateParameter(valid_594902, JString, required = false,
                                 default = nil)
  if valid_594902 != nil:
    section.add "quotaUser", valid_594902
  var valid_594903 = query.getOrDefault("alt")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = newJString("json"))
  if valid_594903 != nil:
    section.add "alt", valid_594903
  var valid_594904 = query.getOrDefault("oauth_token")
  valid_594904 = validateParameter(valid_594904, JString, required = false,
                                 default = nil)
  if valid_594904 != nil:
    section.add "oauth_token", valid_594904
  var valid_594905 = query.getOrDefault("userIp")
  valid_594905 = validateParameter(valid_594905, JString, required = false,
                                 default = nil)
  if valid_594905 != nil:
    section.add "userIp", valid_594905
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594906 = query.getOrDefault("part")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "part", valid_594906
  var valid_594907 = query.getOrDefault("key")
  valid_594907 = validateParameter(valid_594907, JString, required = false,
                                 default = nil)
  if valid_594907 != nil:
    section.add "key", valid_594907
  var valid_594908 = query.getOrDefault("prettyPrint")
  valid_594908 = validateParameter(valid_594908, JBool, required = false,
                                 default = newJBool(true))
  if valid_594908 != nil:
    section.add "prettyPrint", valid_594908
  var valid_594909 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = nil)
  if valid_594909 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594909
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

proc call*(call_594911: Call_YoutubePlaylistsInsert_594897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a playlist.
  ## 
  let valid = call_594911.validator(path, query, header, formData, body)
  let scheme = call_594911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594911.url(scheme.get, call_594911.host, call_594911.base,
                         call_594911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594911, url, valid)

proc call*(call_594912: Call_YoutubePlaylistsInsert_594897; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubePlaylistsInsert
  ## Creates a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_594913 = newJObject()
  var body_594914 = newJObject()
  add(query_594913, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594913, "fields", newJString(fields))
  add(query_594913, "quotaUser", newJString(quotaUser))
  add(query_594913, "alt", newJString(alt))
  add(query_594913, "oauth_token", newJString(oauthToken))
  add(query_594913, "userIp", newJString(userIp))
  add(query_594913, "part", newJString(part))
  add(query_594913, "key", newJString(key))
  if body != nil:
    body_594914 = body
  add(query_594913, "prettyPrint", newJBool(prettyPrint))
  add(query_594913, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_594912.call(nil, query_594913, nil, nil, body_594914)

var youtubePlaylistsInsert* = Call_YoutubePlaylistsInsert_594897(
    name: "youtubePlaylistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsInsert_594898, base: "/youtube/v3",
    url: url_YoutubePlaylistsInsert_594899, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsList_594858 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistsList_594860(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsList_594859(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: JString
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  section = newJObject()
  var valid_594861 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594861 = validateParameter(valid_594861, JString, required = false,
                                 default = nil)
  if valid_594861 != nil:
    section.add "onBehalfOfContentOwner", valid_594861
  var valid_594862 = query.getOrDefault("mine")
  valid_594862 = validateParameter(valid_594862, JBool, required = false, default = nil)
  if valid_594862 != nil:
    section.add "mine", valid_594862
  var valid_594863 = query.getOrDefault("fields")
  valid_594863 = validateParameter(valid_594863, JString, required = false,
                                 default = nil)
  if valid_594863 != nil:
    section.add "fields", valid_594863
  var valid_594864 = query.getOrDefault("pageToken")
  valid_594864 = validateParameter(valid_594864, JString, required = false,
                                 default = nil)
  if valid_594864 != nil:
    section.add "pageToken", valid_594864
  var valid_594865 = query.getOrDefault("quotaUser")
  valid_594865 = validateParameter(valid_594865, JString, required = false,
                                 default = nil)
  if valid_594865 != nil:
    section.add "quotaUser", valid_594865
  var valid_594866 = query.getOrDefault("id")
  valid_594866 = validateParameter(valid_594866, JString, required = false,
                                 default = nil)
  if valid_594866 != nil:
    section.add "id", valid_594866
  var valid_594867 = query.getOrDefault("alt")
  valid_594867 = validateParameter(valid_594867, JString, required = false,
                                 default = newJString("json"))
  if valid_594867 != nil:
    section.add "alt", valid_594867
  var valid_594868 = query.getOrDefault("oauth_token")
  valid_594868 = validateParameter(valid_594868, JString, required = false,
                                 default = nil)
  if valid_594868 != nil:
    section.add "oauth_token", valid_594868
  var valid_594869 = query.getOrDefault("userIp")
  valid_594869 = validateParameter(valid_594869, JString, required = false,
                                 default = nil)
  if valid_594869 != nil:
    section.add "userIp", valid_594869
  var valid_594870 = query.getOrDefault("maxResults")
  valid_594870 = validateParameter(valid_594870, JInt, required = false,
                                 default = newJInt(5))
  if valid_594870 != nil:
    section.add "maxResults", valid_594870
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594871 = query.getOrDefault("part")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "part", valid_594871
  var valid_594872 = query.getOrDefault("channelId")
  valid_594872 = validateParameter(valid_594872, JString, required = false,
                                 default = nil)
  if valid_594872 != nil:
    section.add "channelId", valid_594872
  var valid_594873 = query.getOrDefault("key")
  valid_594873 = validateParameter(valid_594873, JString, required = false,
                                 default = nil)
  if valid_594873 != nil:
    section.add "key", valid_594873
  var valid_594874 = query.getOrDefault("prettyPrint")
  valid_594874 = validateParameter(valid_594874, JBool, required = false,
                                 default = newJBool(true))
  if valid_594874 != nil:
    section.add "prettyPrint", valid_594874
  var valid_594875 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_594875 = validateParameter(valid_594875, JString, required = false,
                                 default = nil)
  if valid_594875 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_594875
  var valid_594876 = query.getOrDefault("hl")
  valid_594876 = validateParameter(valid_594876, JString, required = false,
                                 default = nil)
  if valid_594876 != nil:
    section.add "hl", valid_594876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594877: Call_YoutubePlaylistsList_594858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  let valid = call_594877.validator(path, query, header, formData, body)
  let scheme = call_594877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594877.url(scheme.get, call_594877.host, call_594877.base,
                         call_594877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594877, url, valid)

proc call*(call_594878: Call_YoutubePlaylistsList_594858; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; key: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = "";
          hl: string = ""): Recallable =
  ## youtubePlaylistsList
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: string
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  var query_594879 = newJObject()
  add(query_594879, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594879, "mine", newJBool(mine))
  add(query_594879, "fields", newJString(fields))
  add(query_594879, "pageToken", newJString(pageToken))
  add(query_594879, "quotaUser", newJString(quotaUser))
  add(query_594879, "id", newJString(id))
  add(query_594879, "alt", newJString(alt))
  add(query_594879, "oauth_token", newJString(oauthToken))
  add(query_594879, "userIp", newJString(userIp))
  add(query_594879, "maxResults", newJInt(maxResults))
  add(query_594879, "part", newJString(part))
  add(query_594879, "channelId", newJString(channelId))
  add(query_594879, "key", newJString(key))
  add(query_594879, "prettyPrint", newJBool(prettyPrint))
  add(query_594879, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_594879, "hl", newJString(hl))
  result = call_594878.call(nil, query_594879, nil, nil, nil)

var youtubePlaylistsList* = Call_YoutubePlaylistsList_594858(
    name: "youtubePlaylistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsList_594859, base: "/youtube/v3",
    url: url_YoutubePlaylistsList_594860, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsDelete_594915 = ref object of OpenApiRestCall_593437
proc url_YoutubePlaylistsDelete_594917(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsDelete_594916(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
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
  var valid_594918 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = nil)
  if valid_594918 != nil:
    section.add "onBehalfOfContentOwner", valid_594918
  var valid_594919 = query.getOrDefault("fields")
  valid_594919 = validateParameter(valid_594919, JString, required = false,
                                 default = nil)
  if valid_594919 != nil:
    section.add "fields", valid_594919
  var valid_594920 = query.getOrDefault("quotaUser")
  valid_594920 = validateParameter(valid_594920, JString, required = false,
                                 default = nil)
  if valid_594920 != nil:
    section.add "quotaUser", valid_594920
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_594921 = query.getOrDefault("id")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "id", valid_594921
  var valid_594922 = query.getOrDefault("alt")
  valid_594922 = validateParameter(valid_594922, JString, required = false,
                                 default = newJString("json"))
  if valid_594922 != nil:
    section.add "alt", valid_594922
  var valid_594923 = query.getOrDefault("oauth_token")
  valid_594923 = validateParameter(valid_594923, JString, required = false,
                                 default = nil)
  if valid_594923 != nil:
    section.add "oauth_token", valid_594923
  var valid_594924 = query.getOrDefault("userIp")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "userIp", valid_594924
  var valid_594925 = query.getOrDefault("key")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = nil)
  if valid_594925 != nil:
    section.add "key", valid_594925
  var valid_594926 = query.getOrDefault("prettyPrint")
  valid_594926 = validateParameter(valid_594926, JBool, required = false,
                                 default = newJBool(true))
  if valid_594926 != nil:
    section.add "prettyPrint", valid_594926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594927: Call_YoutubePlaylistsDelete_594915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist.
  ## 
  let valid = call_594927.validator(path, query, header, formData, body)
  let scheme = call_594927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594927.url(scheme.get, call_594927.host, call_594927.base,
                         call_594927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594927, url, valid)

proc call*(call_594928: Call_YoutubePlaylistsDelete_594915; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsDelete
  ## Deletes a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
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
  var query_594929 = newJObject()
  add(query_594929, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594929, "fields", newJString(fields))
  add(query_594929, "quotaUser", newJString(quotaUser))
  add(query_594929, "id", newJString(id))
  add(query_594929, "alt", newJString(alt))
  add(query_594929, "oauth_token", newJString(oauthToken))
  add(query_594929, "userIp", newJString(userIp))
  add(query_594929, "key", newJString(key))
  add(query_594929, "prettyPrint", newJBool(prettyPrint))
  result = call_594928.call(nil, query_594929, nil, nil, nil)

var youtubePlaylistsDelete* = Call_YoutubePlaylistsDelete_594915(
    name: "youtubePlaylistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsDelete_594916, base: "/youtube/v3",
    url: url_YoutubePlaylistsDelete_594917, schemes: {Scheme.Https})
type
  Call_YoutubeSearchList_594930 = ref object of OpenApiRestCall_593437
proc url_YoutubeSearchList_594932(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSearchList_594931(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: JString
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: JString
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: JString
  ##      : Data format for the response.
  ##   forContentOwner: JBool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: JBool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: JString
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: JString
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: JString
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: JString
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: JString
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locationRadius: JString
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: JBool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: JString
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: JString
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: JString
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: JString
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: JString
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: JString
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: JString
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: JString
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: JString
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: JString
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: JString
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  section = newJObject()
  var valid_594933 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594933 = validateParameter(valid_594933, JString, required = false,
                                 default = nil)
  if valid_594933 != nil:
    section.add "onBehalfOfContentOwner", valid_594933
  var valid_594934 = query.getOrDefault("safeSearch")
  valid_594934 = validateParameter(valid_594934, JString, required = false,
                                 default = newJString("moderate"))
  if valid_594934 != nil:
    section.add "safeSearch", valid_594934
  var valid_594935 = query.getOrDefault("fields")
  valid_594935 = validateParameter(valid_594935, JString, required = false,
                                 default = nil)
  if valid_594935 != nil:
    section.add "fields", valid_594935
  var valid_594936 = query.getOrDefault("publishedAfter")
  valid_594936 = validateParameter(valid_594936, JString, required = false,
                                 default = nil)
  if valid_594936 != nil:
    section.add "publishedAfter", valid_594936
  var valid_594937 = query.getOrDefault("quotaUser")
  valid_594937 = validateParameter(valid_594937, JString, required = false,
                                 default = nil)
  if valid_594937 != nil:
    section.add "quotaUser", valid_594937
  var valid_594938 = query.getOrDefault("pageToken")
  valid_594938 = validateParameter(valid_594938, JString, required = false,
                                 default = nil)
  if valid_594938 != nil:
    section.add "pageToken", valid_594938
  var valid_594939 = query.getOrDefault("relevanceLanguage")
  valid_594939 = validateParameter(valid_594939, JString, required = false,
                                 default = nil)
  if valid_594939 != nil:
    section.add "relevanceLanguage", valid_594939
  var valid_594940 = query.getOrDefault("alt")
  valid_594940 = validateParameter(valid_594940, JString, required = false,
                                 default = newJString("json"))
  if valid_594940 != nil:
    section.add "alt", valid_594940
  var valid_594941 = query.getOrDefault("forContentOwner")
  valid_594941 = validateParameter(valid_594941, JBool, required = false, default = nil)
  if valid_594941 != nil:
    section.add "forContentOwner", valid_594941
  var valid_594942 = query.getOrDefault("forMine")
  valid_594942 = validateParameter(valid_594942, JBool, required = false, default = nil)
  if valid_594942 != nil:
    section.add "forMine", valid_594942
  var valid_594943 = query.getOrDefault("videoCaption")
  valid_594943 = validateParameter(valid_594943, JString, required = false,
                                 default = newJString("any"))
  if valid_594943 != nil:
    section.add "videoCaption", valid_594943
  var valid_594944 = query.getOrDefault("videoDefinition")
  valid_594944 = validateParameter(valid_594944, JString, required = false,
                                 default = newJString("any"))
  if valid_594944 != nil:
    section.add "videoDefinition", valid_594944
  var valid_594945 = query.getOrDefault("topicId")
  valid_594945 = validateParameter(valid_594945, JString, required = false,
                                 default = nil)
  if valid_594945 != nil:
    section.add "topicId", valid_594945
  var valid_594946 = query.getOrDefault("type")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = newJString("video,channel,playlist"))
  if valid_594946 != nil:
    section.add "type", valid_594946
  var valid_594947 = query.getOrDefault("order")
  valid_594947 = validateParameter(valid_594947, JString, required = false,
                                 default = newJString("relevance"))
  if valid_594947 != nil:
    section.add "order", valid_594947
  var valid_594948 = query.getOrDefault("videoDuration")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = newJString("any"))
  if valid_594948 != nil:
    section.add "videoDuration", valid_594948
  var valid_594949 = query.getOrDefault("oauth_token")
  valid_594949 = validateParameter(valid_594949, JString, required = false,
                                 default = nil)
  if valid_594949 != nil:
    section.add "oauth_token", valid_594949
  var valid_594950 = query.getOrDefault("locationRadius")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "locationRadius", valid_594950
  var valid_594951 = query.getOrDefault("forDeveloper")
  valid_594951 = validateParameter(valid_594951, JBool, required = false, default = nil)
  if valid_594951 != nil:
    section.add "forDeveloper", valid_594951
  var valid_594952 = query.getOrDefault("userIp")
  valid_594952 = validateParameter(valid_594952, JString, required = false,
                                 default = nil)
  if valid_594952 != nil:
    section.add "userIp", valid_594952
  var valid_594953 = query.getOrDefault("videoType")
  valid_594953 = validateParameter(valid_594953, JString, required = false,
                                 default = newJString("any"))
  if valid_594953 != nil:
    section.add "videoType", valid_594953
  var valid_594954 = query.getOrDefault("eventType")
  valid_594954 = validateParameter(valid_594954, JString, required = false,
                                 default = newJString("completed"))
  if valid_594954 != nil:
    section.add "eventType", valid_594954
  var valid_594955 = query.getOrDefault("location")
  valid_594955 = validateParameter(valid_594955, JString, required = false,
                                 default = nil)
  if valid_594955 != nil:
    section.add "location", valid_594955
  var valid_594956 = query.getOrDefault("maxResults")
  valid_594956 = validateParameter(valid_594956, JInt, required = false,
                                 default = newJInt(5))
  if valid_594956 != nil:
    section.add "maxResults", valid_594956
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594957 = query.getOrDefault("part")
  valid_594957 = validateParameter(valid_594957, JString, required = true,
                                 default = nil)
  if valid_594957 != nil:
    section.add "part", valid_594957
  var valid_594958 = query.getOrDefault("q")
  valid_594958 = validateParameter(valid_594958, JString, required = false,
                                 default = nil)
  if valid_594958 != nil:
    section.add "q", valid_594958
  var valid_594959 = query.getOrDefault("channelId")
  valid_594959 = validateParameter(valid_594959, JString, required = false,
                                 default = nil)
  if valid_594959 != nil:
    section.add "channelId", valid_594959
  var valid_594960 = query.getOrDefault("regionCode")
  valid_594960 = validateParameter(valid_594960, JString, required = false,
                                 default = nil)
  if valid_594960 != nil:
    section.add "regionCode", valid_594960
  var valid_594961 = query.getOrDefault("key")
  valid_594961 = validateParameter(valid_594961, JString, required = false,
                                 default = nil)
  if valid_594961 != nil:
    section.add "key", valid_594961
  var valid_594962 = query.getOrDefault("relatedToVideoId")
  valid_594962 = validateParameter(valid_594962, JString, required = false,
                                 default = nil)
  if valid_594962 != nil:
    section.add "relatedToVideoId", valid_594962
  var valid_594963 = query.getOrDefault("videoDimension")
  valid_594963 = validateParameter(valid_594963, JString, required = false,
                                 default = newJString("2d"))
  if valid_594963 != nil:
    section.add "videoDimension", valid_594963
  var valid_594964 = query.getOrDefault("videoLicense")
  valid_594964 = validateParameter(valid_594964, JString, required = false,
                                 default = newJString("any"))
  if valid_594964 != nil:
    section.add "videoLicense", valid_594964
  var valid_594965 = query.getOrDefault("videoSyndicated")
  valid_594965 = validateParameter(valid_594965, JString, required = false,
                                 default = newJString("any"))
  if valid_594965 != nil:
    section.add "videoSyndicated", valid_594965
  var valid_594966 = query.getOrDefault("publishedBefore")
  valid_594966 = validateParameter(valid_594966, JString, required = false,
                                 default = nil)
  if valid_594966 != nil:
    section.add "publishedBefore", valid_594966
  var valid_594967 = query.getOrDefault("channelType")
  valid_594967 = validateParameter(valid_594967, JString, required = false,
                                 default = newJString("any"))
  if valid_594967 != nil:
    section.add "channelType", valid_594967
  var valid_594968 = query.getOrDefault("prettyPrint")
  valid_594968 = validateParameter(valid_594968, JBool, required = false,
                                 default = newJBool(true))
  if valid_594968 != nil:
    section.add "prettyPrint", valid_594968
  var valid_594969 = query.getOrDefault("videoEmbeddable")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = newJString("any"))
  if valid_594969 != nil:
    section.add "videoEmbeddable", valid_594969
  var valid_594970 = query.getOrDefault("videoCategoryId")
  valid_594970 = validateParameter(valid_594970, JString, required = false,
                                 default = nil)
  if valid_594970 != nil:
    section.add "videoCategoryId", valid_594970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594971: Call_YoutubeSearchList_594930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  let valid = call_594971.validator(path, query, header, formData, body)
  let scheme = call_594971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594971.url(scheme.get, call_594971.host, call_594971.base,
                         call_594971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594971, url, valid)

proc call*(call_594972: Call_YoutubeSearchList_594930; part: string;
          onBehalfOfContentOwner: string = ""; safeSearch: string = "moderate";
          fields: string = ""; publishedAfter: string = ""; quotaUser: string = "";
          pageToken: string = ""; relevanceLanguage: string = ""; alt: string = "json";
          forContentOwner: bool = false; forMine: bool = false;
          videoCaption: string = "any"; videoDefinition: string = "any";
          topicId: string = ""; `type`: string = "video,channel,playlist";
          order: string = "relevance"; videoDuration: string = "any";
          oauthToken: string = ""; locationRadius: string = "";
          forDeveloper: bool = false; userIp: string = ""; videoType: string = "any";
          eventType: string = "completed"; location: string = ""; maxResults: int = 5;
          q: string = ""; channelId: string = ""; regionCode: string = ""; key: string = "";
          relatedToVideoId: string = ""; videoDimension: string = "2d";
          videoLicense: string = "any"; videoSyndicated: string = "any";
          publishedBefore: string = ""; channelType: string = "any";
          prettyPrint: bool = true; videoEmbeddable: string = "any";
          videoCategoryId: string = ""): Recallable =
  ## youtubeSearchList
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: string
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: string
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: string
  ##      : Data format for the response.
  ##   forContentOwner: bool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: bool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: string
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: string
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: string
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: string
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: string
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locationRadius: string
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: bool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: string
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: string
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: string
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: string
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: string
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: string
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: string
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: string
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: string
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: string
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: string
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  var query_594973 = newJObject()
  add(query_594973, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594973, "safeSearch", newJString(safeSearch))
  add(query_594973, "fields", newJString(fields))
  add(query_594973, "publishedAfter", newJString(publishedAfter))
  add(query_594973, "quotaUser", newJString(quotaUser))
  add(query_594973, "pageToken", newJString(pageToken))
  add(query_594973, "relevanceLanguage", newJString(relevanceLanguage))
  add(query_594973, "alt", newJString(alt))
  add(query_594973, "forContentOwner", newJBool(forContentOwner))
  add(query_594973, "forMine", newJBool(forMine))
  add(query_594973, "videoCaption", newJString(videoCaption))
  add(query_594973, "videoDefinition", newJString(videoDefinition))
  add(query_594973, "topicId", newJString(topicId))
  add(query_594973, "type", newJString(`type`))
  add(query_594973, "order", newJString(order))
  add(query_594973, "videoDuration", newJString(videoDuration))
  add(query_594973, "oauth_token", newJString(oauthToken))
  add(query_594973, "locationRadius", newJString(locationRadius))
  add(query_594973, "forDeveloper", newJBool(forDeveloper))
  add(query_594973, "userIp", newJString(userIp))
  add(query_594973, "videoType", newJString(videoType))
  add(query_594973, "eventType", newJString(eventType))
  add(query_594973, "location", newJString(location))
  add(query_594973, "maxResults", newJInt(maxResults))
  add(query_594973, "part", newJString(part))
  add(query_594973, "q", newJString(q))
  add(query_594973, "channelId", newJString(channelId))
  add(query_594973, "regionCode", newJString(regionCode))
  add(query_594973, "key", newJString(key))
  add(query_594973, "relatedToVideoId", newJString(relatedToVideoId))
  add(query_594973, "videoDimension", newJString(videoDimension))
  add(query_594973, "videoLicense", newJString(videoLicense))
  add(query_594973, "videoSyndicated", newJString(videoSyndicated))
  add(query_594973, "publishedBefore", newJString(publishedBefore))
  add(query_594973, "channelType", newJString(channelType))
  add(query_594973, "prettyPrint", newJBool(prettyPrint))
  add(query_594973, "videoEmbeddable", newJString(videoEmbeddable))
  add(query_594973, "videoCategoryId", newJString(videoCategoryId))
  result = call_594972.call(nil, query_594973, nil, nil, nil)

var youtubeSearchList* = Call_YoutubeSearchList_594930(name: "youtubeSearchList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/search",
    validator: validate_YoutubeSearchList_594931, base: "/youtube/v3",
    url: url_YoutubeSearchList_594932, schemes: {Scheme.Https})
type
  Call_YoutubeSponsorsList_594974 = ref object of OpenApiRestCall_593437
proc url_YoutubeSponsorsList_594976(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSponsorsList_594975(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists sponsors for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter parameter specifies which channel sponsors to return.
  section = newJObject()
  var valid_594977 = query.getOrDefault("fields")
  valid_594977 = validateParameter(valid_594977, JString, required = false,
                                 default = nil)
  if valid_594977 != nil:
    section.add "fields", valid_594977
  var valid_594978 = query.getOrDefault("pageToken")
  valid_594978 = validateParameter(valid_594978, JString, required = false,
                                 default = nil)
  if valid_594978 != nil:
    section.add "pageToken", valid_594978
  var valid_594979 = query.getOrDefault("quotaUser")
  valid_594979 = validateParameter(valid_594979, JString, required = false,
                                 default = nil)
  if valid_594979 != nil:
    section.add "quotaUser", valid_594979
  var valid_594980 = query.getOrDefault("alt")
  valid_594980 = validateParameter(valid_594980, JString, required = false,
                                 default = newJString("json"))
  if valid_594980 != nil:
    section.add "alt", valid_594980
  var valid_594981 = query.getOrDefault("oauth_token")
  valid_594981 = validateParameter(valid_594981, JString, required = false,
                                 default = nil)
  if valid_594981 != nil:
    section.add "oauth_token", valid_594981
  var valid_594982 = query.getOrDefault("userIp")
  valid_594982 = validateParameter(valid_594982, JString, required = false,
                                 default = nil)
  if valid_594982 != nil:
    section.add "userIp", valid_594982
  var valid_594983 = query.getOrDefault("maxResults")
  valid_594983 = validateParameter(valid_594983, JInt, required = false,
                                 default = newJInt(5))
  if valid_594983 != nil:
    section.add "maxResults", valid_594983
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_594984 = query.getOrDefault("part")
  valid_594984 = validateParameter(valid_594984, JString, required = true,
                                 default = nil)
  if valid_594984 != nil:
    section.add "part", valid_594984
  var valid_594985 = query.getOrDefault("key")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "key", valid_594985
  var valid_594986 = query.getOrDefault("prettyPrint")
  valid_594986 = validateParameter(valid_594986, JBool, required = false,
                                 default = newJBool(true))
  if valid_594986 != nil:
    section.add "prettyPrint", valid_594986
  var valid_594987 = query.getOrDefault("filter")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = newJString("newest"))
  if valid_594987 != nil:
    section.add "filter", valid_594987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594988: Call_YoutubeSponsorsList_594974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sponsors for a channel.
  ## 
  let valid = call_594988.validator(path, query, header, formData, body)
  let scheme = call_594988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594988.url(scheme.get, call_594988.host, call_594988.base,
                         call_594988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594988, url, valid)

proc call*(call_594989: Call_YoutubeSponsorsList_594974; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          filter: string = "newest"): Recallable =
  ## youtubeSponsorsList
  ## Lists sponsors for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter parameter specifies which channel sponsors to return.
  var query_594990 = newJObject()
  add(query_594990, "fields", newJString(fields))
  add(query_594990, "pageToken", newJString(pageToken))
  add(query_594990, "quotaUser", newJString(quotaUser))
  add(query_594990, "alt", newJString(alt))
  add(query_594990, "oauth_token", newJString(oauthToken))
  add(query_594990, "userIp", newJString(userIp))
  add(query_594990, "maxResults", newJInt(maxResults))
  add(query_594990, "part", newJString(part))
  add(query_594990, "key", newJString(key))
  add(query_594990, "prettyPrint", newJBool(prettyPrint))
  add(query_594990, "filter", newJString(filter))
  result = call_594989.call(nil, query_594990, nil, nil, nil)

var youtubeSponsorsList* = Call_YoutubeSponsorsList_594974(
    name: "youtubeSponsorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sponsors",
    validator: validate_YoutubeSponsorsList_594975, base: "/youtube/v3",
    url: url_YoutubeSponsorsList_594976, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsInsert_595016 = ref object of OpenApiRestCall_593437
proc url_YoutubeSubscriptionsInsert_595018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsInsert_595017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a subscription for the authenticated user's channel.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595019 = query.getOrDefault("fields")
  valid_595019 = validateParameter(valid_595019, JString, required = false,
                                 default = nil)
  if valid_595019 != nil:
    section.add "fields", valid_595019
  var valid_595020 = query.getOrDefault("quotaUser")
  valid_595020 = validateParameter(valid_595020, JString, required = false,
                                 default = nil)
  if valid_595020 != nil:
    section.add "quotaUser", valid_595020
  var valid_595021 = query.getOrDefault("alt")
  valid_595021 = validateParameter(valid_595021, JString, required = false,
                                 default = newJString("json"))
  if valid_595021 != nil:
    section.add "alt", valid_595021
  var valid_595022 = query.getOrDefault("oauth_token")
  valid_595022 = validateParameter(valid_595022, JString, required = false,
                                 default = nil)
  if valid_595022 != nil:
    section.add "oauth_token", valid_595022
  var valid_595023 = query.getOrDefault("userIp")
  valid_595023 = validateParameter(valid_595023, JString, required = false,
                                 default = nil)
  if valid_595023 != nil:
    section.add "userIp", valid_595023
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595024 = query.getOrDefault("part")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "part", valid_595024
  var valid_595025 = query.getOrDefault("key")
  valid_595025 = validateParameter(valid_595025, JString, required = false,
                                 default = nil)
  if valid_595025 != nil:
    section.add "key", valid_595025
  var valid_595026 = query.getOrDefault("prettyPrint")
  valid_595026 = validateParameter(valid_595026, JBool, required = false,
                                 default = newJBool(true))
  if valid_595026 != nil:
    section.add "prettyPrint", valid_595026
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

proc call*(call_595028: Call_YoutubeSubscriptionsInsert_595016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  let valid = call_595028.validator(path, query, header, formData, body)
  let scheme = call_595028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595028.url(scheme.get, call_595028.host, call_595028.base,
                         call_595028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595028, url, valid)

proc call*(call_595029: Call_YoutubeSubscriptionsInsert_595016; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsInsert
  ## Adds a subscription for the authenticated user's channel.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595030 = newJObject()
  var body_595031 = newJObject()
  add(query_595030, "fields", newJString(fields))
  add(query_595030, "quotaUser", newJString(quotaUser))
  add(query_595030, "alt", newJString(alt))
  add(query_595030, "oauth_token", newJString(oauthToken))
  add(query_595030, "userIp", newJString(userIp))
  add(query_595030, "part", newJString(part))
  add(query_595030, "key", newJString(key))
  if body != nil:
    body_595031 = body
  add(query_595030, "prettyPrint", newJBool(prettyPrint))
  result = call_595029.call(nil, query_595030, nil, nil, body_595031)

var youtubeSubscriptionsInsert* = Call_YoutubeSubscriptionsInsert_595016(
    name: "youtubeSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsInsert_595017, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsInsert_595018, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsList_594991 = ref object of OpenApiRestCall_593437
proc url_YoutubeSubscriptionsList_594993(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsList_594992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns subscription resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: JString
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: JBool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  section = newJObject()
  var valid_594994 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594994 = validateParameter(valid_594994, JString, required = false,
                                 default = nil)
  if valid_594994 != nil:
    section.add "onBehalfOfContentOwner", valid_594994
  var valid_594995 = query.getOrDefault("mine")
  valid_594995 = validateParameter(valid_594995, JBool, required = false, default = nil)
  if valid_594995 != nil:
    section.add "mine", valid_594995
  var valid_594996 = query.getOrDefault("forChannelId")
  valid_594996 = validateParameter(valid_594996, JString, required = false,
                                 default = nil)
  if valid_594996 != nil:
    section.add "forChannelId", valid_594996
  var valid_594997 = query.getOrDefault("fields")
  valid_594997 = validateParameter(valid_594997, JString, required = false,
                                 default = nil)
  if valid_594997 != nil:
    section.add "fields", valid_594997
  var valid_594998 = query.getOrDefault("pageToken")
  valid_594998 = validateParameter(valid_594998, JString, required = false,
                                 default = nil)
  if valid_594998 != nil:
    section.add "pageToken", valid_594998
  var valid_594999 = query.getOrDefault("quotaUser")
  valid_594999 = validateParameter(valid_594999, JString, required = false,
                                 default = nil)
  if valid_594999 != nil:
    section.add "quotaUser", valid_594999
  var valid_595000 = query.getOrDefault("id")
  valid_595000 = validateParameter(valid_595000, JString, required = false,
                                 default = nil)
  if valid_595000 != nil:
    section.add "id", valid_595000
  var valid_595001 = query.getOrDefault("alt")
  valid_595001 = validateParameter(valid_595001, JString, required = false,
                                 default = newJString("json"))
  if valid_595001 != nil:
    section.add "alt", valid_595001
  var valid_595002 = query.getOrDefault("mySubscribers")
  valid_595002 = validateParameter(valid_595002, JBool, required = false, default = nil)
  if valid_595002 != nil:
    section.add "mySubscribers", valid_595002
  var valid_595003 = query.getOrDefault("order")
  valid_595003 = validateParameter(valid_595003, JString, required = false,
                                 default = newJString("relevance"))
  if valid_595003 != nil:
    section.add "order", valid_595003
  var valid_595004 = query.getOrDefault("oauth_token")
  valid_595004 = validateParameter(valid_595004, JString, required = false,
                                 default = nil)
  if valid_595004 != nil:
    section.add "oauth_token", valid_595004
  var valid_595005 = query.getOrDefault("userIp")
  valid_595005 = validateParameter(valid_595005, JString, required = false,
                                 default = nil)
  if valid_595005 != nil:
    section.add "userIp", valid_595005
  var valid_595006 = query.getOrDefault("maxResults")
  valid_595006 = validateParameter(valid_595006, JInt, required = false,
                                 default = newJInt(5))
  if valid_595006 != nil:
    section.add "maxResults", valid_595006
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595007 = query.getOrDefault("part")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "part", valid_595007
  var valid_595008 = query.getOrDefault("channelId")
  valid_595008 = validateParameter(valid_595008, JString, required = false,
                                 default = nil)
  if valid_595008 != nil:
    section.add "channelId", valid_595008
  var valid_595009 = query.getOrDefault("key")
  valid_595009 = validateParameter(valid_595009, JString, required = false,
                                 default = nil)
  if valid_595009 != nil:
    section.add "key", valid_595009
  var valid_595010 = query.getOrDefault("prettyPrint")
  valid_595010 = validateParameter(valid_595010, JBool, required = false,
                                 default = newJBool(true))
  if valid_595010 != nil:
    section.add "prettyPrint", valid_595010
  var valid_595011 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_595011 = validateParameter(valid_595011, JString, required = false,
                                 default = nil)
  if valid_595011 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_595011
  var valid_595012 = query.getOrDefault("myRecentSubscribers")
  valid_595012 = validateParameter(valid_595012, JBool, required = false, default = nil)
  if valid_595012 != nil:
    section.add "myRecentSubscribers", valid_595012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595013: Call_YoutubeSubscriptionsList_594991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns subscription resources that match the API request criteria.
  ## 
  let valid = call_595013.validator(path, query, header, formData, body)
  let scheme = call_595013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595013.url(scheme.get, call_595013.host, call_595013.base,
                         call_595013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595013, url, valid)

proc call*(call_595014: Call_YoutubeSubscriptionsList_594991; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false;
          forChannelId: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          mySubscribers: bool = false; order: string = "relevance";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          channelId: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = "";
          myRecentSubscribers: bool = false): Recallable =
  ## youtubeSubscriptionsList
  ## Returns subscription resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: string
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: bool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  var query_595015 = newJObject()
  add(query_595015, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595015, "mine", newJBool(mine))
  add(query_595015, "forChannelId", newJString(forChannelId))
  add(query_595015, "fields", newJString(fields))
  add(query_595015, "pageToken", newJString(pageToken))
  add(query_595015, "quotaUser", newJString(quotaUser))
  add(query_595015, "id", newJString(id))
  add(query_595015, "alt", newJString(alt))
  add(query_595015, "mySubscribers", newJBool(mySubscribers))
  add(query_595015, "order", newJString(order))
  add(query_595015, "oauth_token", newJString(oauthToken))
  add(query_595015, "userIp", newJString(userIp))
  add(query_595015, "maxResults", newJInt(maxResults))
  add(query_595015, "part", newJString(part))
  add(query_595015, "channelId", newJString(channelId))
  add(query_595015, "key", newJString(key))
  add(query_595015, "prettyPrint", newJBool(prettyPrint))
  add(query_595015, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_595015, "myRecentSubscribers", newJBool(myRecentSubscribers))
  result = call_595014.call(nil, query_595015, nil, nil, nil)

var youtubeSubscriptionsList* = Call_YoutubeSubscriptionsList_594991(
    name: "youtubeSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsList_594992, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsList_594993, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsDelete_595032 = ref object of OpenApiRestCall_593437
proc url_YoutubeSubscriptionsDelete_595034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsDelete_595033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
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
  var valid_595035 = query.getOrDefault("fields")
  valid_595035 = validateParameter(valid_595035, JString, required = false,
                                 default = nil)
  if valid_595035 != nil:
    section.add "fields", valid_595035
  var valid_595036 = query.getOrDefault("quotaUser")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "quotaUser", valid_595036
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_595037 = query.getOrDefault("id")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "id", valid_595037
  var valid_595038 = query.getOrDefault("alt")
  valid_595038 = validateParameter(valid_595038, JString, required = false,
                                 default = newJString("json"))
  if valid_595038 != nil:
    section.add "alt", valid_595038
  var valid_595039 = query.getOrDefault("oauth_token")
  valid_595039 = validateParameter(valid_595039, JString, required = false,
                                 default = nil)
  if valid_595039 != nil:
    section.add "oauth_token", valid_595039
  var valid_595040 = query.getOrDefault("userIp")
  valid_595040 = validateParameter(valid_595040, JString, required = false,
                                 default = nil)
  if valid_595040 != nil:
    section.add "userIp", valid_595040
  var valid_595041 = query.getOrDefault("key")
  valid_595041 = validateParameter(valid_595041, JString, required = false,
                                 default = nil)
  if valid_595041 != nil:
    section.add "key", valid_595041
  var valid_595042 = query.getOrDefault("prettyPrint")
  valid_595042 = validateParameter(valid_595042, JBool, required = false,
                                 default = newJBool(true))
  if valid_595042 != nil:
    section.add "prettyPrint", valid_595042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595043: Call_YoutubeSubscriptionsDelete_595032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_595043.validator(path, query, header, formData, body)
  let scheme = call_595043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595043.url(scheme.get, call_595043.host, call_595043.base,
                         call_595043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595043, url, valid)

proc call*(call_595044: Call_YoutubeSubscriptionsDelete_595032; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsDelete
  ## Deletes a subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
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
  var query_595045 = newJObject()
  add(query_595045, "fields", newJString(fields))
  add(query_595045, "quotaUser", newJString(quotaUser))
  add(query_595045, "id", newJString(id))
  add(query_595045, "alt", newJString(alt))
  add(query_595045, "oauth_token", newJString(oauthToken))
  add(query_595045, "userIp", newJString(userIp))
  add(query_595045, "key", newJString(key))
  add(query_595045, "prettyPrint", newJBool(prettyPrint))
  result = call_595044.call(nil, query_595045, nil, nil, nil)

var youtubeSubscriptionsDelete* = Call_YoutubeSubscriptionsDelete_595032(
    name: "youtubeSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsDelete_595033, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsDelete_595034, schemes: {Scheme.Https})
type
  Call_YoutubeSuperChatEventsList_595046 = ref object of OpenApiRestCall_593437
proc url_YoutubeSuperChatEventsList_595048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeSuperChatEventsList_595047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Super Chat events for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_595049 = query.getOrDefault("fields")
  valid_595049 = validateParameter(valid_595049, JString, required = false,
                                 default = nil)
  if valid_595049 != nil:
    section.add "fields", valid_595049
  var valid_595050 = query.getOrDefault("pageToken")
  valid_595050 = validateParameter(valid_595050, JString, required = false,
                                 default = nil)
  if valid_595050 != nil:
    section.add "pageToken", valid_595050
  var valid_595051 = query.getOrDefault("quotaUser")
  valid_595051 = validateParameter(valid_595051, JString, required = false,
                                 default = nil)
  if valid_595051 != nil:
    section.add "quotaUser", valid_595051
  var valid_595052 = query.getOrDefault("alt")
  valid_595052 = validateParameter(valid_595052, JString, required = false,
                                 default = newJString("json"))
  if valid_595052 != nil:
    section.add "alt", valid_595052
  var valid_595053 = query.getOrDefault("oauth_token")
  valid_595053 = validateParameter(valid_595053, JString, required = false,
                                 default = nil)
  if valid_595053 != nil:
    section.add "oauth_token", valid_595053
  var valid_595054 = query.getOrDefault("userIp")
  valid_595054 = validateParameter(valid_595054, JString, required = false,
                                 default = nil)
  if valid_595054 != nil:
    section.add "userIp", valid_595054
  var valid_595055 = query.getOrDefault("maxResults")
  valid_595055 = validateParameter(valid_595055, JInt, required = false,
                                 default = newJInt(5))
  if valid_595055 != nil:
    section.add "maxResults", valid_595055
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595056 = query.getOrDefault("part")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "part", valid_595056
  var valid_595057 = query.getOrDefault("key")
  valid_595057 = validateParameter(valid_595057, JString, required = false,
                                 default = nil)
  if valid_595057 != nil:
    section.add "key", valid_595057
  var valid_595058 = query.getOrDefault("prettyPrint")
  valid_595058 = validateParameter(valid_595058, JBool, required = false,
                                 default = newJBool(true))
  if valid_595058 != nil:
    section.add "prettyPrint", valid_595058
  var valid_595059 = query.getOrDefault("hl")
  valid_595059 = validateParameter(valid_595059, JString, required = false,
                                 default = nil)
  if valid_595059 != nil:
    section.add "hl", valid_595059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595060: Call_YoutubeSuperChatEventsList_595046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Super Chat events for a channel.
  ## 
  let valid = call_595060.validator(path, query, header, formData, body)
  let scheme = call_595060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595060.url(scheme.get, call_595060.host, call_595060.base,
                         call_595060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595060, url, valid)

proc call*(call_595061: Call_YoutubeSuperChatEventsList_595046; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeSuperChatEventsList
  ## Lists Super Chat events for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_595062 = newJObject()
  add(query_595062, "fields", newJString(fields))
  add(query_595062, "pageToken", newJString(pageToken))
  add(query_595062, "quotaUser", newJString(quotaUser))
  add(query_595062, "alt", newJString(alt))
  add(query_595062, "oauth_token", newJString(oauthToken))
  add(query_595062, "userIp", newJString(userIp))
  add(query_595062, "maxResults", newJInt(maxResults))
  add(query_595062, "part", newJString(part))
  add(query_595062, "key", newJString(key))
  add(query_595062, "prettyPrint", newJBool(prettyPrint))
  add(query_595062, "hl", newJString(hl))
  result = call_595061.call(nil, query_595062, nil, nil, nil)

var youtubeSuperChatEventsList* = Call_YoutubeSuperChatEventsList_595046(
    name: "youtubeSuperChatEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/superChatEvents",
    validator: validate_YoutubeSuperChatEventsList_595047, base: "/youtube/v3",
    url: url_YoutubeSuperChatEventsList_595048, schemes: {Scheme.Https})
type
  Call_YoutubeThumbnailsSet_595063 = ref object of OpenApiRestCall_593437
proc url_YoutubeThumbnailsSet_595065(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeThumbnailsSet_595064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595066 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595066 = validateParameter(valid_595066, JString, required = false,
                                 default = nil)
  if valid_595066 != nil:
    section.add "onBehalfOfContentOwner", valid_595066
  var valid_595067 = query.getOrDefault("fields")
  valid_595067 = validateParameter(valid_595067, JString, required = false,
                                 default = nil)
  if valid_595067 != nil:
    section.add "fields", valid_595067
  var valid_595068 = query.getOrDefault("quotaUser")
  valid_595068 = validateParameter(valid_595068, JString, required = false,
                                 default = nil)
  if valid_595068 != nil:
    section.add "quotaUser", valid_595068
  var valid_595069 = query.getOrDefault("alt")
  valid_595069 = validateParameter(valid_595069, JString, required = false,
                                 default = newJString("json"))
  if valid_595069 != nil:
    section.add "alt", valid_595069
  var valid_595070 = query.getOrDefault("oauth_token")
  valid_595070 = validateParameter(valid_595070, JString, required = false,
                                 default = nil)
  if valid_595070 != nil:
    section.add "oauth_token", valid_595070
  var valid_595071 = query.getOrDefault("userIp")
  valid_595071 = validateParameter(valid_595071, JString, required = false,
                                 default = nil)
  if valid_595071 != nil:
    section.add "userIp", valid_595071
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_595072 = query.getOrDefault("videoId")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "videoId", valid_595072
  var valid_595073 = query.getOrDefault("key")
  valid_595073 = validateParameter(valid_595073, JString, required = false,
                                 default = nil)
  if valid_595073 != nil:
    section.add "key", valid_595073
  var valid_595074 = query.getOrDefault("prettyPrint")
  valid_595074 = validateParameter(valid_595074, JBool, required = false,
                                 default = newJBool(true))
  if valid_595074 != nil:
    section.add "prettyPrint", valid_595074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595075: Call_YoutubeThumbnailsSet_595063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  let valid = call_595075.validator(path, query, header, formData, body)
  let scheme = call_595075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595075.url(scheme.get, call_595075.host, call_595075.base,
                         call_595075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595075, url, valid)

proc call*(call_595076: Call_YoutubeThumbnailsSet_595063; videoId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeThumbnailsSet
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   videoId: string (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595077 = newJObject()
  add(query_595077, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595077, "fields", newJString(fields))
  add(query_595077, "quotaUser", newJString(quotaUser))
  add(query_595077, "alt", newJString(alt))
  add(query_595077, "oauth_token", newJString(oauthToken))
  add(query_595077, "userIp", newJString(userIp))
  add(query_595077, "videoId", newJString(videoId))
  add(query_595077, "key", newJString(key))
  add(query_595077, "prettyPrint", newJBool(prettyPrint))
  result = call_595076.call(nil, query_595077, nil, nil, nil)

var youtubeThumbnailsSet* = Call_YoutubeThumbnailsSet_595063(
    name: "youtubeThumbnailsSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/thumbnails/set",
    validator: validate_YoutubeThumbnailsSet_595064, base: "/youtube/v3",
    url: url_YoutubeThumbnailsSet_595065, schemes: {Scheme.Https})
type
  Call_YoutubeVideoAbuseReportReasonsList_595078 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideoAbuseReportReasonsList_595080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideoAbuseReportReasonsList_595079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_595081 = query.getOrDefault("fields")
  valid_595081 = validateParameter(valid_595081, JString, required = false,
                                 default = nil)
  if valid_595081 != nil:
    section.add "fields", valid_595081
  var valid_595082 = query.getOrDefault("quotaUser")
  valid_595082 = validateParameter(valid_595082, JString, required = false,
                                 default = nil)
  if valid_595082 != nil:
    section.add "quotaUser", valid_595082
  var valid_595083 = query.getOrDefault("alt")
  valid_595083 = validateParameter(valid_595083, JString, required = false,
                                 default = newJString("json"))
  if valid_595083 != nil:
    section.add "alt", valid_595083
  var valid_595084 = query.getOrDefault("oauth_token")
  valid_595084 = validateParameter(valid_595084, JString, required = false,
                                 default = nil)
  if valid_595084 != nil:
    section.add "oauth_token", valid_595084
  var valid_595085 = query.getOrDefault("userIp")
  valid_595085 = validateParameter(valid_595085, JString, required = false,
                                 default = nil)
  if valid_595085 != nil:
    section.add "userIp", valid_595085
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595086 = query.getOrDefault("part")
  valid_595086 = validateParameter(valid_595086, JString, required = true,
                                 default = nil)
  if valid_595086 != nil:
    section.add "part", valid_595086
  var valid_595087 = query.getOrDefault("key")
  valid_595087 = validateParameter(valid_595087, JString, required = false,
                                 default = nil)
  if valid_595087 != nil:
    section.add "key", valid_595087
  var valid_595088 = query.getOrDefault("prettyPrint")
  valid_595088 = validateParameter(valid_595088, JBool, required = false,
                                 default = newJBool(true))
  if valid_595088 != nil:
    section.add "prettyPrint", valid_595088
  var valid_595089 = query.getOrDefault("hl")
  valid_595089 = validateParameter(valid_595089, JString, required = false,
                                 default = newJString("en_US"))
  if valid_595089 != nil:
    section.add "hl", valid_595089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595090: Call_YoutubeVideoAbuseReportReasonsList_595078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  let valid = call_595090.validator(path, query, header, formData, body)
  let scheme = call_595090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595090.url(scheme.get, call_595090.host, call_595090.base,
                         call_595090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595090, url, valid)

proc call*(call_595091: Call_YoutubeVideoAbuseReportReasonsList_595078;
          part: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeVideoAbuseReportReasonsList
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
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
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_595092 = newJObject()
  add(query_595092, "fields", newJString(fields))
  add(query_595092, "quotaUser", newJString(quotaUser))
  add(query_595092, "alt", newJString(alt))
  add(query_595092, "oauth_token", newJString(oauthToken))
  add(query_595092, "userIp", newJString(userIp))
  add(query_595092, "part", newJString(part))
  add(query_595092, "key", newJString(key))
  add(query_595092, "prettyPrint", newJBool(prettyPrint))
  add(query_595092, "hl", newJString(hl))
  result = call_595091.call(nil, query_595092, nil, nil, nil)

var youtubeVideoAbuseReportReasonsList* = Call_YoutubeVideoAbuseReportReasonsList_595078(
    name: "youtubeVideoAbuseReportReasonsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoAbuseReportReasons",
    validator: validate_YoutubeVideoAbuseReportReasonsList_595079,
    base: "/youtube/v3", url: url_YoutubeVideoAbuseReportReasonsList_595080,
    schemes: {Scheme.Https})
type
  Call_YoutubeVideoCategoriesList_595093 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideoCategoriesList_595095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideoCategoriesList_595094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube videos.
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
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_595096 = query.getOrDefault("fields")
  valid_595096 = validateParameter(valid_595096, JString, required = false,
                                 default = nil)
  if valid_595096 != nil:
    section.add "fields", valid_595096
  var valid_595097 = query.getOrDefault("quotaUser")
  valid_595097 = validateParameter(valid_595097, JString, required = false,
                                 default = nil)
  if valid_595097 != nil:
    section.add "quotaUser", valid_595097
  var valid_595098 = query.getOrDefault("id")
  valid_595098 = validateParameter(valid_595098, JString, required = false,
                                 default = nil)
  if valid_595098 != nil:
    section.add "id", valid_595098
  var valid_595099 = query.getOrDefault("alt")
  valid_595099 = validateParameter(valid_595099, JString, required = false,
                                 default = newJString("json"))
  if valid_595099 != nil:
    section.add "alt", valid_595099
  var valid_595100 = query.getOrDefault("oauth_token")
  valid_595100 = validateParameter(valid_595100, JString, required = false,
                                 default = nil)
  if valid_595100 != nil:
    section.add "oauth_token", valid_595100
  var valid_595101 = query.getOrDefault("userIp")
  valid_595101 = validateParameter(valid_595101, JString, required = false,
                                 default = nil)
  if valid_595101 != nil:
    section.add "userIp", valid_595101
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595102 = query.getOrDefault("part")
  valid_595102 = validateParameter(valid_595102, JString, required = true,
                                 default = nil)
  if valid_595102 != nil:
    section.add "part", valid_595102
  var valid_595103 = query.getOrDefault("regionCode")
  valid_595103 = validateParameter(valid_595103, JString, required = false,
                                 default = nil)
  if valid_595103 != nil:
    section.add "regionCode", valid_595103
  var valid_595104 = query.getOrDefault("key")
  valid_595104 = validateParameter(valid_595104, JString, required = false,
                                 default = nil)
  if valid_595104 != nil:
    section.add "key", valid_595104
  var valid_595105 = query.getOrDefault("prettyPrint")
  valid_595105 = validateParameter(valid_595105, JBool, required = false,
                                 default = newJBool(true))
  if valid_595105 != nil:
    section.add "prettyPrint", valid_595105
  var valid_595106 = query.getOrDefault("hl")
  valid_595106 = validateParameter(valid_595106, JString, required = false,
                                 default = newJString("en_US"))
  if valid_595106 != nil:
    section.add "hl", valid_595106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595107: Call_YoutubeVideoCategoriesList_595093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  let valid = call_595107.validator(path, query, header, formData, body)
  let scheme = call_595107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595107.url(scheme.get, call_595107.host, call_595107.base,
                         call_595107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595107, url, valid)

proc call*(call_595108: Call_YoutubeVideoCategoriesList_595093; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en_US"): Recallable =
  ## youtubeVideoCategoriesList
  ## Returns a list of categories that can be associated with YouTube videos.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_595109 = newJObject()
  add(query_595109, "fields", newJString(fields))
  add(query_595109, "quotaUser", newJString(quotaUser))
  add(query_595109, "id", newJString(id))
  add(query_595109, "alt", newJString(alt))
  add(query_595109, "oauth_token", newJString(oauthToken))
  add(query_595109, "userIp", newJString(userIp))
  add(query_595109, "part", newJString(part))
  add(query_595109, "regionCode", newJString(regionCode))
  add(query_595109, "key", newJString(key))
  add(query_595109, "prettyPrint", newJBool(prettyPrint))
  add(query_595109, "hl", newJString(hl))
  result = call_595108.call(nil, query_595109, nil, nil, nil)

var youtubeVideoCategoriesList* = Call_YoutubeVideoCategoriesList_595093(
    name: "youtubeVideoCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoCategories",
    validator: validate_YoutubeVideoCategoriesList_595094, base: "/youtube/v3",
    url: url_YoutubeVideoCategoriesList_595095, schemes: {Scheme.Https})
type
  Call_YoutubeVideosUpdate_595136 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosUpdate_595138(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosUpdate_595137(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595139 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595139 = validateParameter(valid_595139, JString, required = false,
                                 default = nil)
  if valid_595139 != nil:
    section.add "onBehalfOfContentOwner", valid_595139
  var valid_595140 = query.getOrDefault("fields")
  valid_595140 = validateParameter(valid_595140, JString, required = false,
                                 default = nil)
  if valid_595140 != nil:
    section.add "fields", valid_595140
  var valid_595141 = query.getOrDefault("quotaUser")
  valid_595141 = validateParameter(valid_595141, JString, required = false,
                                 default = nil)
  if valid_595141 != nil:
    section.add "quotaUser", valid_595141
  var valid_595142 = query.getOrDefault("alt")
  valid_595142 = validateParameter(valid_595142, JString, required = false,
                                 default = newJString("json"))
  if valid_595142 != nil:
    section.add "alt", valid_595142
  var valid_595143 = query.getOrDefault("oauth_token")
  valid_595143 = validateParameter(valid_595143, JString, required = false,
                                 default = nil)
  if valid_595143 != nil:
    section.add "oauth_token", valid_595143
  var valid_595144 = query.getOrDefault("userIp")
  valid_595144 = validateParameter(valid_595144, JString, required = false,
                                 default = nil)
  if valid_595144 != nil:
    section.add "userIp", valid_595144
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595145 = query.getOrDefault("part")
  valid_595145 = validateParameter(valid_595145, JString, required = true,
                                 default = nil)
  if valid_595145 != nil:
    section.add "part", valid_595145
  var valid_595146 = query.getOrDefault("key")
  valid_595146 = validateParameter(valid_595146, JString, required = false,
                                 default = nil)
  if valid_595146 != nil:
    section.add "key", valid_595146
  var valid_595147 = query.getOrDefault("prettyPrint")
  valid_595147 = validateParameter(valid_595147, JBool, required = false,
                                 default = newJBool(true))
  if valid_595147 != nil:
    section.add "prettyPrint", valid_595147
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

proc call*(call_595149: Call_YoutubeVideosUpdate_595136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video's metadata.
  ## 
  let valid = call_595149.validator(path, query, header, formData, body)
  let scheme = call_595149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595149.url(scheme.get, call_595149.host, call_595149.base,
                         call_595149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595149, url, valid)

proc call*(call_595150: Call_YoutubeVideosUpdate_595136; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosUpdate
  ## Updates a video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595151 = newJObject()
  var body_595152 = newJObject()
  add(query_595151, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595151, "fields", newJString(fields))
  add(query_595151, "quotaUser", newJString(quotaUser))
  add(query_595151, "alt", newJString(alt))
  add(query_595151, "oauth_token", newJString(oauthToken))
  add(query_595151, "userIp", newJString(userIp))
  add(query_595151, "part", newJString(part))
  add(query_595151, "key", newJString(key))
  if body != nil:
    body_595152 = body
  add(query_595151, "prettyPrint", newJBool(prettyPrint))
  result = call_595150.call(nil, query_595151, nil, nil, body_595152)

var youtubeVideosUpdate* = Call_YoutubeVideosUpdate_595136(
    name: "youtubeVideosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosUpdate_595137, base: "/youtube/v3",
    url: url_YoutubeVideosUpdate_595138, schemes: {Scheme.Https})
type
  Call_YoutubeVideosInsert_595153 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosInsert_595155(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosInsert_595154(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: JBool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   autoLevels: JBool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: JBool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  section = newJObject()
  var valid_595156 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595156 = validateParameter(valid_595156, JString, required = false,
                                 default = nil)
  if valid_595156 != nil:
    section.add "onBehalfOfContentOwner", valid_595156
  var valid_595157 = query.getOrDefault("fields")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = nil)
  if valid_595157 != nil:
    section.add "fields", valid_595157
  var valid_595158 = query.getOrDefault("notifySubscribers")
  valid_595158 = validateParameter(valid_595158, JBool, required = false,
                                 default = newJBool(true))
  if valid_595158 != nil:
    section.add "notifySubscribers", valid_595158
  var valid_595159 = query.getOrDefault("quotaUser")
  valid_595159 = validateParameter(valid_595159, JString, required = false,
                                 default = nil)
  if valid_595159 != nil:
    section.add "quotaUser", valid_595159
  var valid_595160 = query.getOrDefault("alt")
  valid_595160 = validateParameter(valid_595160, JString, required = false,
                                 default = newJString("json"))
  if valid_595160 != nil:
    section.add "alt", valid_595160
  var valid_595161 = query.getOrDefault("autoLevels")
  valid_595161 = validateParameter(valid_595161, JBool, required = false, default = nil)
  if valid_595161 != nil:
    section.add "autoLevels", valid_595161
  var valid_595162 = query.getOrDefault("oauth_token")
  valid_595162 = validateParameter(valid_595162, JString, required = false,
                                 default = nil)
  if valid_595162 != nil:
    section.add "oauth_token", valid_595162
  var valid_595163 = query.getOrDefault("userIp")
  valid_595163 = validateParameter(valid_595163, JString, required = false,
                                 default = nil)
  if valid_595163 != nil:
    section.add "userIp", valid_595163
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595164 = query.getOrDefault("part")
  valid_595164 = validateParameter(valid_595164, JString, required = true,
                                 default = nil)
  if valid_595164 != nil:
    section.add "part", valid_595164
  var valid_595165 = query.getOrDefault("key")
  valid_595165 = validateParameter(valid_595165, JString, required = false,
                                 default = nil)
  if valid_595165 != nil:
    section.add "key", valid_595165
  var valid_595166 = query.getOrDefault("prettyPrint")
  valid_595166 = validateParameter(valid_595166, JBool, required = false,
                                 default = newJBool(true))
  if valid_595166 != nil:
    section.add "prettyPrint", valid_595166
  var valid_595167 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_595167 = validateParameter(valid_595167, JString, required = false,
                                 default = nil)
  if valid_595167 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_595167
  var valid_595168 = query.getOrDefault("stabilize")
  valid_595168 = validateParameter(valid_595168, JBool, required = false, default = nil)
  if valid_595168 != nil:
    section.add "stabilize", valid_595168
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

proc call*(call_595170: Call_YoutubeVideosInsert_595153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  let valid = call_595170.validator(path, query, header, formData, body)
  let scheme = call_595170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595170.url(scheme.get, call_595170.host, call_595170.base,
                         call_595170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595170, url, valid)

proc call*(call_595171: Call_YoutubeVideosInsert_595153; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          notifySubscribers: bool = true; quotaUser: string = ""; alt: string = "json";
          autoLevels: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; stabilize: bool = false): Recallable =
  ## youtubeVideosInsert
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: bool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   autoLevels: bool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: bool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  var query_595172 = newJObject()
  var body_595173 = newJObject()
  add(query_595172, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595172, "fields", newJString(fields))
  add(query_595172, "notifySubscribers", newJBool(notifySubscribers))
  add(query_595172, "quotaUser", newJString(quotaUser))
  add(query_595172, "alt", newJString(alt))
  add(query_595172, "autoLevels", newJBool(autoLevels))
  add(query_595172, "oauth_token", newJString(oauthToken))
  add(query_595172, "userIp", newJString(userIp))
  add(query_595172, "part", newJString(part))
  add(query_595172, "key", newJString(key))
  if body != nil:
    body_595173 = body
  add(query_595172, "prettyPrint", newJBool(prettyPrint))
  add(query_595172, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_595172, "stabilize", newJBool(stabilize))
  result = call_595171.call(nil, query_595172, nil, nil, body_595173)

var youtubeVideosInsert* = Call_YoutubeVideosInsert_595153(
    name: "youtubeVideosInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosInsert_595154, base: "/youtube/v3",
    url: url_YoutubeVideosInsert_595155, schemes: {Scheme.Https})
type
  Call_YoutubeVideosList_595110 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosList_595112(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosList_595111(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of videos that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: JString
  ##         : DEPRECATED
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: JInt
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxWidth: JInt
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: JString
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: JString
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  section = newJObject()
  var valid_595113 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595113 = validateParameter(valid_595113, JString, required = false,
                                 default = nil)
  if valid_595113 != nil:
    section.add "onBehalfOfContentOwner", valid_595113
  var valid_595114 = query.getOrDefault("locale")
  valid_595114 = validateParameter(valid_595114, JString, required = false,
                                 default = nil)
  if valid_595114 != nil:
    section.add "locale", valid_595114
  var valid_595115 = query.getOrDefault("fields")
  valid_595115 = validateParameter(valid_595115, JString, required = false,
                                 default = nil)
  if valid_595115 != nil:
    section.add "fields", valid_595115
  var valid_595116 = query.getOrDefault("pageToken")
  valid_595116 = validateParameter(valid_595116, JString, required = false,
                                 default = nil)
  if valid_595116 != nil:
    section.add "pageToken", valid_595116
  var valid_595117 = query.getOrDefault("quotaUser")
  valid_595117 = validateParameter(valid_595117, JString, required = false,
                                 default = nil)
  if valid_595117 != nil:
    section.add "quotaUser", valid_595117
  var valid_595118 = query.getOrDefault("maxHeight")
  valid_595118 = validateParameter(valid_595118, JInt, required = false, default = nil)
  if valid_595118 != nil:
    section.add "maxHeight", valid_595118
  var valid_595119 = query.getOrDefault("id")
  valid_595119 = validateParameter(valid_595119, JString, required = false,
                                 default = nil)
  if valid_595119 != nil:
    section.add "id", valid_595119
  var valid_595120 = query.getOrDefault("alt")
  valid_595120 = validateParameter(valid_595120, JString, required = false,
                                 default = newJString("json"))
  if valid_595120 != nil:
    section.add "alt", valid_595120
  var valid_595121 = query.getOrDefault("maxWidth")
  valid_595121 = validateParameter(valid_595121, JInt, required = false, default = nil)
  if valid_595121 != nil:
    section.add "maxWidth", valid_595121
  var valid_595122 = query.getOrDefault("myRating")
  valid_595122 = validateParameter(valid_595122, JString, required = false,
                                 default = newJString("dislike"))
  if valid_595122 != nil:
    section.add "myRating", valid_595122
  var valid_595123 = query.getOrDefault("chart")
  valid_595123 = validateParameter(valid_595123, JString, required = false,
                                 default = newJString("mostPopular"))
  if valid_595123 != nil:
    section.add "chart", valid_595123
  var valid_595124 = query.getOrDefault("oauth_token")
  valid_595124 = validateParameter(valid_595124, JString, required = false,
                                 default = nil)
  if valid_595124 != nil:
    section.add "oauth_token", valid_595124
  var valid_595125 = query.getOrDefault("userIp")
  valid_595125 = validateParameter(valid_595125, JString, required = false,
                                 default = nil)
  if valid_595125 != nil:
    section.add "userIp", valid_595125
  var valid_595126 = query.getOrDefault("maxResults")
  valid_595126 = validateParameter(valid_595126, JInt, required = false,
                                 default = newJInt(5))
  if valid_595126 != nil:
    section.add "maxResults", valid_595126
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_595127 = query.getOrDefault("part")
  valid_595127 = validateParameter(valid_595127, JString, required = true,
                                 default = nil)
  if valid_595127 != nil:
    section.add "part", valid_595127
  var valid_595128 = query.getOrDefault("regionCode")
  valid_595128 = validateParameter(valid_595128, JString, required = false,
                                 default = nil)
  if valid_595128 != nil:
    section.add "regionCode", valid_595128
  var valid_595129 = query.getOrDefault("key")
  valid_595129 = validateParameter(valid_595129, JString, required = false,
                                 default = nil)
  if valid_595129 != nil:
    section.add "key", valid_595129
  var valid_595130 = query.getOrDefault("prettyPrint")
  valid_595130 = validateParameter(valid_595130, JBool, required = false,
                                 default = newJBool(true))
  if valid_595130 != nil:
    section.add "prettyPrint", valid_595130
  var valid_595131 = query.getOrDefault("hl")
  valid_595131 = validateParameter(valid_595131, JString, required = false,
                                 default = nil)
  if valid_595131 != nil:
    section.add "hl", valid_595131
  var valid_595132 = query.getOrDefault("videoCategoryId")
  valid_595132 = validateParameter(valid_595132, JString, required = false,
                                 default = newJString("0"))
  if valid_595132 != nil:
    section.add "videoCategoryId", valid_595132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595133: Call_YoutubeVideosList_595110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of videos that match the API request parameters.
  ## 
  let valid = call_595133.validator(path, query, header, formData, body)
  let scheme = call_595133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595133.url(scheme.get, call_595133.host, call_595133.base,
                         call_595133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595133, url, valid)

proc call*(call_595134: Call_YoutubeVideosList_595110; part: string;
          onBehalfOfContentOwner: string = ""; locale: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; maxHeight: int = 0;
          id: string = ""; alt: string = "json"; maxWidth: int = 0;
          myRating: string = "dislike"; chart: string = "mostPopular";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = ""; videoCategoryId: string = "0"): Recallable =
  ## youtubeVideosList
  ## Returns a list of videos that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: string
  ##         : DEPRECATED
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: int
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxWidth: int
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: string
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: string
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  var query_595135 = newJObject()
  add(query_595135, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595135, "locale", newJString(locale))
  add(query_595135, "fields", newJString(fields))
  add(query_595135, "pageToken", newJString(pageToken))
  add(query_595135, "quotaUser", newJString(quotaUser))
  add(query_595135, "maxHeight", newJInt(maxHeight))
  add(query_595135, "id", newJString(id))
  add(query_595135, "alt", newJString(alt))
  add(query_595135, "maxWidth", newJInt(maxWidth))
  add(query_595135, "myRating", newJString(myRating))
  add(query_595135, "chart", newJString(chart))
  add(query_595135, "oauth_token", newJString(oauthToken))
  add(query_595135, "userIp", newJString(userIp))
  add(query_595135, "maxResults", newJInt(maxResults))
  add(query_595135, "part", newJString(part))
  add(query_595135, "regionCode", newJString(regionCode))
  add(query_595135, "key", newJString(key))
  add(query_595135, "prettyPrint", newJBool(prettyPrint))
  add(query_595135, "hl", newJString(hl))
  add(query_595135, "videoCategoryId", newJString(videoCategoryId))
  result = call_595134.call(nil, query_595135, nil, nil, nil)

var youtubeVideosList* = Call_YoutubeVideosList_595110(name: "youtubeVideosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosList_595111, base: "/youtube/v3",
    url: url_YoutubeVideosList_595112, schemes: {Scheme.Https})
type
  Call_YoutubeVideosDelete_595174 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosDelete_595176(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosDelete_595175(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a YouTube video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
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
  var valid_595177 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595177 = validateParameter(valid_595177, JString, required = false,
                                 default = nil)
  if valid_595177 != nil:
    section.add "onBehalfOfContentOwner", valid_595177
  var valid_595178 = query.getOrDefault("fields")
  valid_595178 = validateParameter(valid_595178, JString, required = false,
                                 default = nil)
  if valid_595178 != nil:
    section.add "fields", valid_595178
  var valid_595179 = query.getOrDefault("quotaUser")
  valid_595179 = validateParameter(valid_595179, JString, required = false,
                                 default = nil)
  if valid_595179 != nil:
    section.add "quotaUser", valid_595179
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_595180 = query.getOrDefault("id")
  valid_595180 = validateParameter(valid_595180, JString, required = true,
                                 default = nil)
  if valid_595180 != nil:
    section.add "id", valid_595180
  var valid_595181 = query.getOrDefault("alt")
  valid_595181 = validateParameter(valid_595181, JString, required = false,
                                 default = newJString("json"))
  if valid_595181 != nil:
    section.add "alt", valid_595181
  var valid_595182 = query.getOrDefault("oauth_token")
  valid_595182 = validateParameter(valid_595182, JString, required = false,
                                 default = nil)
  if valid_595182 != nil:
    section.add "oauth_token", valid_595182
  var valid_595183 = query.getOrDefault("userIp")
  valid_595183 = validateParameter(valid_595183, JString, required = false,
                                 default = nil)
  if valid_595183 != nil:
    section.add "userIp", valid_595183
  var valid_595184 = query.getOrDefault("key")
  valid_595184 = validateParameter(valid_595184, JString, required = false,
                                 default = nil)
  if valid_595184 != nil:
    section.add "key", valid_595184
  var valid_595185 = query.getOrDefault("prettyPrint")
  valid_595185 = validateParameter(valid_595185, JBool, required = false,
                                 default = newJBool(true))
  if valid_595185 != nil:
    section.add "prettyPrint", valid_595185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595186: Call_YoutubeVideosDelete_595174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a YouTube video.
  ## 
  let valid = call_595186.validator(path, query, header, formData, body)
  let scheme = call_595186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595186.url(scheme.get, call_595186.host, call_595186.base,
                         call_595186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595186, url, valid)

proc call*(call_595187: Call_YoutubeVideosDelete_595174; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosDelete
  ## Deletes a YouTube video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
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
  var query_595188 = newJObject()
  add(query_595188, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595188, "fields", newJString(fields))
  add(query_595188, "quotaUser", newJString(quotaUser))
  add(query_595188, "id", newJString(id))
  add(query_595188, "alt", newJString(alt))
  add(query_595188, "oauth_token", newJString(oauthToken))
  add(query_595188, "userIp", newJString(userIp))
  add(query_595188, "key", newJString(key))
  add(query_595188, "prettyPrint", newJBool(prettyPrint))
  result = call_595187.call(nil, query_595188, nil, nil, nil)

var youtubeVideosDelete* = Call_YoutubeVideosDelete_595174(
    name: "youtubeVideosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosDelete_595175, base: "/youtube/v3",
    url: url_YoutubeVideosDelete_595176, schemes: {Scheme.Https})
type
  Call_YoutubeVideosGetRating_595189 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosGetRating_595191(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosGetRating_595190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
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
  var valid_595192 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595192 = validateParameter(valid_595192, JString, required = false,
                                 default = nil)
  if valid_595192 != nil:
    section.add "onBehalfOfContentOwner", valid_595192
  var valid_595193 = query.getOrDefault("fields")
  valid_595193 = validateParameter(valid_595193, JString, required = false,
                                 default = nil)
  if valid_595193 != nil:
    section.add "fields", valid_595193
  var valid_595194 = query.getOrDefault("quotaUser")
  valid_595194 = validateParameter(valid_595194, JString, required = false,
                                 default = nil)
  if valid_595194 != nil:
    section.add "quotaUser", valid_595194
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_595195 = query.getOrDefault("id")
  valid_595195 = validateParameter(valid_595195, JString, required = true,
                                 default = nil)
  if valid_595195 != nil:
    section.add "id", valid_595195
  var valid_595196 = query.getOrDefault("alt")
  valid_595196 = validateParameter(valid_595196, JString, required = false,
                                 default = newJString("json"))
  if valid_595196 != nil:
    section.add "alt", valid_595196
  var valid_595197 = query.getOrDefault("oauth_token")
  valid_595197 = validateParameter(valid_595197, JString, required = false,
                                 default = nil)
  if valid_595197 != nil:
    section.add "oauth_token", valid_595197
  var valid_595198 = query.getOrDefault("userIp")
  valid_595198 = validateParameter(valid_595198, JString, required = false,
                                 default = nil)
  if valid_595198 != nil:
    section.add "userIp", valid_595198
  var valid_595199 = query.getOrDefault("key")
  valid_595199 = validateParameter(valid_595199, JString, required = false,
                                 default = nil)
  if valid_595199 != nil:
    section.add "key", valid_595199
  var valid_595200 = query.getOrDefault("prettyPrint")
  valid_595200 = validateParameter(valid_595200, JBool, required = false,
                                 default = newJBool(true))
  if valid_595200 != nil:
    section.add "prettyPrint", valid_595200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595201: Call_YoutubeVideosGetRating_595189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  let valid = call_595201.validator(path, query, header, formData, body)
  let scheme = call_595201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595201.url(scheme.get, call_595201.host, call_595201.base,
                         call_595201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595201, url, valid)

proc call*(call_595202: Call_YoutubeVideosGetRating_595189; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosGetRating
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
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
  var query_595203 = newJObject()
  add(query_595203, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595203, "fields", newJString(fields))
  add(query_595203, "quotaUser", newJString(quotaUser))
  add(query_595203, "id", newJString(id))
  add(query_595203, "alt", newJString(alt))
  add(query_595203, "oauth_token", newJString(oauthToken))
  add(query_595203, "userIp", newJString(userIp))
  add(query_595203, "key", newJString(key))
  add(query_595203, "prettyPrint", newJBool(prettyPrint))
  result = call_595202.call(nil, query_595203, nil, nil, nil)

var youtubeVideosGetRating* = Call_YoutubeVideosGetRating_595189(
    name: "youtubeVideosGetRating", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videos/getRating",
    validator: validate_YoutubeVideosGetRating_595190, base: "/youtube/v3",
    url: url_YoutubeVideosGetRating_595191, schemes: {Scheme.Https})
type
  Call_YoutubeVideosRate_595204 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosRate_595206(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosRate_595205(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Add a like or dislike rating to a video or remove a rating from a video.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rating: JString (required)
  ##         : Specifies the rating to record.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595207 = query.getOrDefault("fields")
  valid_595207 = validateParameter(valid_595207, JString, required = false,
                                 default = nil)
  if valid_595207 != nil:
    section.add "fields", valid_595207
  var valid_595208 = query.getOrDefault("quotaUser")
  valid_595208 = validateParameter(valid_595208, JString, required = false,
                                 default = nil)
  if valid_595208 != nil:
    section.add "quotaUser", valid_595208
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_595209 = query.getOrDefault("id")
  valid_595209 = validateParameter(valid_595209, JString, required = true,
                                 default = nil)
  if valid_595209 != nil:
    section.add "id", valid_595209
  var valid_595210 = query.getOrDefault("alt")
  valid_595210 = validateParameter(valid_595210, JString, required = false,
                                 default = newJString("json"))
  if valid_595210 != nil:
    section.add "alt", valid_595210
  var valid_595211 = query.getOrDefault("rating")
  valid_595211 = validateParameter(valid_595211, JString, required = true,
                                 default = newJString("dislike"))
  if valid_595211 != nil:
    section.add "rating", valid_595211
  var valid_595212 = query.getOrDefault("oauth_token")
  valid_595212 = validateParameter(valid_595212, JString, required = false,
                                 default = nil)
  if valid_595212 != nil:
    section.add "oauth_token", valid_595212
  var valid_595213 = query.getOrDefault("userIp")
  valid_595213 = validateParameter(valid_595213, JString, required = false,
                                 default = nil)
  if valid_595213 != nil:
    section.add "userIp", valid_595213
  var valid_595214 = query.getOrDefault("key")
  valid_595214 = validateParameter(valid_595214, JString, required = false,
                                 default = nil)
  if valid_595214 != nil:
    section.add "key", valid_595214
  var valid_595215 = query.getOrDefault("prettyPrint")
  valid_595215 = validateParameter(valid_595215, JBool, required = false,
                                 default = newJBool(true))
  if valid_595215 != nil:
    section.add "prettyPrint", valid_595215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595216: Call_YoutubeVideosRate_595204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  let valid = call_595216.validator(path, query, header, formData, body)
  let scheme = call_595216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595216.url(scheme.get, call_595216.host, call_595216.base,
                         call_595216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595216, url, valid)

proc call*(call_595217: Call_YoutubeVideosRate_595204; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          rating: string = "dislike"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosRate
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: string
  ##      : Data format for the response.
  ##   rating: string (required)
  ##         : Specifies the rating to record.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595218 = newJObject()
  add(query_595218, "fields", newJString(fields))
  add(query_595218, "quotaUser", newJString(quotaUser))
  add(query_595218, "id", newJString(id))
  add(query_595218, "alt", newJString(alt))
  add(query_595218, "rating", newJString(rating))
  add(query_595218, "oauth_token", newJString(oauthToken))
  add(query_595218, "userIp", newJString(userIp))
  add(query_595218, "key", newJString(key))
  add(query_595218, "prettyPrint", newJBool(prettyPrint))
  result = call_595217.call(nil, query_595218, nil, nil, nil)

var youtubeVideosRate* = Call_YoutubeVideosRate_595204(name: "youtubeVideosRate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/videos/rate",
    validator: validate_YoutubeVideosRate_595205, base: "/youtube/v3",
    url: url_YoutubeVideosRate_595206, schemes: {Scheme.Https})
type
  Call_YoutubeVideosReportAbuse_595219 = ref object of OpenApiRestCall_593437
proc url_YoutubeVideosReportAbuse_595221(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeVideosReportAbuse_595220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report abuse for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  var valid_595222 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595222 = validateParameter(valid_595222, JString, required = false,
                                 default = nil)
  if valid_595222 != nil:
    section.add "onBehalfOfContentOwner", valid_595222
  var valid_595223 = query.getOrDefault("fields")
  valid_595223 = validateParameter(valid_595223, JString, required = false,
                                 default = nil)
  if valid_595223 != nil:
    section.add "fields", valid_595223
  var valid_595224 = query.getOrDefault("quotaUser")
  valid_595224 = validateParameter(valid_595224, JString, required = false,
                                 default = nil)
  if valid_595224 != nil:
    section.add "quotaUser", valid_595224
  var valid_595225 = query.getOrDefault("alt")
  valid_595225 = validateParameter(valid_595225, JString, required = false,
                                 default = newJString("json"))
  if valid_595225 != nil:
    section.add "alt", valid_595225
  var valid_595226 = query.getOrDefault("oauth_token")
  valid_595226 = validateParameter(valid_595226, JString, required = false,
                                 default = nil)
  if valid_595226 != nil:
    section.add "oauth_token", valid_595226
  var valid_595227 = query.getOrDefault("userIp")
  valid_595227 = validateParameter(valid_595227, JString, required = false,
                                 default = nil)
  if valid_595227 != nil:
    section.add "userIp", valid_595227
  var valid_595228 = query.getOrDefault("key")
  valid_595228 = validateParameter(valid_595228, JString, required = false,
                                 default = nil)
  if valid_595228 != nil:
    section.add "key", valid_595228
  var valid_595229 = query.getOrDefault("prettyPrint")
  valid_595229 = validateParameter(valid_595229, JBool, required = false,
                                 default = newJBool(true))
  if valid_595229 != nil:
    section.add "prettyPrint", valid_595229
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

proc call*(call_595231: Call_YoutubeVideosReportAbuse_595219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report abuse for a video.
  ## 
  let valid = call_595231.validator(path, query, header, formData, body)
  let scheme = call_595231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595231.url(scheme.get, call_595231.host, call_595231.base,
                         call_595231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595231, url, valid)

proc call*(call_595232: Call_YoutubeVideosReportAbuse_595219;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosReportAbuse
  ## Report abuse for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  var query_595233 = newJObject()
  var body_595234 = newJObject()
  add(query_595233, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595233, "fields", newJString(fields))
  add(query_595233, "quotaUser", newJString(quotaUser))
  add(query_595233, "alt", newJString(alt))
  add(query_595233, "oauth_token", newJString(oauthToken))
  add(query_595233, "userIp", newJString(userIp))
  add(query_595233, "key", newJString(key))
  if body != nil:
    body_595234 = body
  add(query_595233, "prettyPrint", newJBool(prettyPrint))
  result = call_595232.call(nil, query_595233, nil, nil, body_595234)

var youtubeVideosReportAbuse* = Call_YoutubeVideosReportAbuse_595219(
    name: "youtubeVideosReportAbuse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos/reportAbuse",
    validator: validate_YoutubeVideosReportAbuse_595220, base: "/youtube/v3",
    url: url_YoutubeVideosReportAbuse_595221, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksSet_595235 = ref object of OpenApiRestCall_593437
proc url_YoutubeWatermarksSet_595237(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksSet_595236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595238 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595238 = validateParameter(valid_595238, JString, required = false,
                                 default = nil)
  if valid_595238 != nil:
    section.add "onBehalfOfContentOwner", valid_595238
  var valid_595239 = query.getOrDefault("fields")
  valid_595239 = validateParameter(valid_595239, JString, required = false,
                                 default = nil)
  if valid_595239 != nil:
    section.add "fields", valid_595239
  var valid_595240 = query.getOrDefault("quotaUser")
  valid_595240 = validateParameter(valid_595240, JString, required = false,
                                 default = nil)
  if valid_595240 != nil:
    section.add "quotaUser", valid_595240
  var valid_595241 = query.getOrDefault("alt")
  valid_595241 = validateParameter(valid_595241, JString, required = false,
                                 default = newJString("json"))
  if valid_595241 != nil:
    section.add "alt", valid_595241
  var valid_595242 = query.getOrDefault("oauth_token")
  valid_595242 = validateParameter(valid_595242, JString, required = false,
                                 default = nil)
  if valid_595242 != nil:
    section.add "oauth_token", valid_595242
  var valid_595243 = query.getOrDefault("userIp")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = nil)
  if valid_595243 != nil:
    section.add "userIp", valid_595243
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_595244 = query.getOrDefault("channelId")
  valid_595244 = validateParameter(valid_595244, JString, required = true,
                                 default = nil)
  if valid_595244 != nil:
    section.add "channelId", valid_595244
  var valid_595245 = query.getOrDefault("key")
  valid_595245 = validateParameter(valid_595245, JString, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "key", valid_595245
  var valid_595246 = query.getOrDefault("prettyPrint")
  valid_595246 = validateParameter(valid_595246, JBool, required = false,
                                 default = newJBool(true))
  if valid_595246 != nil:
    section.add "prettyPrint", valid_595246
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

proc call*(call_595248: Call_YoutubeWatermarksSet_595235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  let valid = call_595248.validator(path, query, header, formData, body)
  let scheme = call_595248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595248.url(scheme.get, call_595248.host, call_595248.base,
                         call_595248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595248, url, valid)

proc call*(call_595249: Call_YoutubeWatermarksSet_595235; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksSet
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595250 = newJObject()
  var body_595251 = newJObject()
  add(query_595250, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595250, "fields", newJString(fields))
  add(query_595250, "quotaUser", newJString(quotaUser))
  add(query_595250, "alt", newJString(alt))
  add(query_595250, "oauth_token", newJString(oauthToken))
  add(query_595250, "userIp", newJString(userIp))
  add(query_595250, "channelId", newJString(channelId))
  add(query_595250, "key", newJString(key))
  if body != nil:
    body_595251 = body
  add(query_595250, "prettyPrint", newJBool(prettyPrint))
  result = call_595249.call(nil, query_595250, nil, nil, body_595251)

var youtubeWatermarksSet* = Call_YoutubeWatermarksSet_595235(
    name: "youtubeWatermarksSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/set",
    validator: validate_YoutubeWatermarksSet_595236, base: "/youtube/v3",
    url: url_YoutubeWatermarksSet_595237, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksUnset_595252 = ref object of OpenApiRestCall_593437
proc url_YoutubeWatermarksUnset_595254(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksUnset_595253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channel's watermark image.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595255 = query.getOrDefault("onBehalfOfContentOwner")
  valid_595255 = validateParameter(valid_595255, JString, required = false,
                                 default = nil)
  if valid_595255 != nil:
    section.add "onBehalfOfContentOwner", valid_595255
  var valid_595256 = query.getOrDefault("fields")
  valid_595256 = validateParameter(valid_595256, JString, required = false,
                                 default = nil)
  if valid_595256 != nil:
    section.add "fields", valid_595256
  var valid_595257 = query.getOrDefault("quotaUser")
  valid_595257 = validateParameter(valid_595257, JString, required = false,
                                 default = nil)
  if valid_595257 != nil:
    section.add "quotaUser", valid_595257
  var valid_595258 = query.getOrDefault("alt")
  valid_595258 = validateParameter(valid_595258, JString, required = false,
                                 default = newJString("json"))
  if valid_595258 != nil:
    section.add "alt", valid_595258
  var valid_595259 = query.getOrDefault("oauth_token")
  valid_595259 = validateParameter(valid_595259, JString, required = false,
                                 default = nil)
  if valid_595259 != nil:
    section.add "oauth_token", valid_595259
  var valid_595260 = query.getOrDefault("userIp")
  valid_595260 = validateParameter(valid_595260, JString, required = false,
                                 default = nil)
  if valid_595260 != nil:
    section.add "userIp", valid_595260
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_595261 = query.getOrDefault("channelId")
  valid_595261 = validateParameter(valid_595261, JString, required = true,
                                 default = nil)
  if valid_595261 != nil:
    section.add "channelId", valid_595261
  var valid_595262 = query.getOrDefault("key")
  valid_595262 = validateParameter(valid_595262, JString, required = false,
                                 default = nil)
  if valid_595262 != nil:
    section.add "key", valid_595262
  var valid_595263 = query.getOrDefault("prettyPrint")
  valid_595263 = validateParameter(valid_595263, JBool, required = false,
                                 default = newJBool(true))
  if valid_595263 != nil:
    section.add "prettyPrint", valid_595263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595264: Call_YoutubeWatermarksUnset_595252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channel's watermark image.
  ## 
  let valid = call_595264.validator(path, query, header, formData, body)
  let scheme = call_595264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595264.url(scheme.get, call_595264.host, call_595264.base,
                         call_595264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595264, url, valid)

proc call*(call_595265: Call_YoutubeWatermarksUnset_595252; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksUnset
  ## Deletes a channel's watermark image.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_595266 = newJObject()
  add(query_595266, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_595266, "fields", newJString(fields))
  add(query_595266, "quotaUser", newJString(quotaUser))
  add(query_595266, "alt", newJString(alt))
  add(query_595266, "oauth_token", newJString(oauthToken))
  add(query_595266, "userIp", newJString(userIp))
  add(query_595266, "channelId", newJString(channelId))
  add(query_595266, "key", newJString(key))
  add(query_595266, "prettyPrint", newJBool(prettyPrint))
  result = call_595265.call(nil, query_595266, nil, nil, nil)

var youtubeWatermarksUnset* = Call_YoutubeWatermarksUnset_595252(
    name: "youtubeWatermarksUnset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/unset",
    validator: validate_YoutubeWatermarksUnset_595253, base: "/youtube/v3",
    url: url_YoutubeWatermarksUnset_595254, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
